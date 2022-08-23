#!/usr/bin/env bash
set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

KASM_VERSION="1.11.0"
KASM_INSTALL_BASE="/opt/kasm/${KASM_VERSION}"
OFFLINE_INSTALL="false"
PULL_IMAGES="false"
PURGE_IMAGES="false"
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
KASM_RELEASE="$(realpath $SCRIPT_PATH)"
ARCH=$(uname -m)
DISK_SPACE=50000000000
DEFAULT_PROXY_LISTENING_PORT='443'
ARGS=("$@")

# Functions
function gather_vars() {
  ARCH=$(uname -m)
  CURRENT_VERSION=$(readlink -f /opt/kasm/current | awk -F'/' '{print $4}')
  DB_PASSWORD=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.database.password' /opt/kasm/${CURRENT_VERSION}/conf/app/api.app.config.yaml)
  MANAGER_TOKEN=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.manager.token' /opt/kasm/${CURRENT_VERSION}/conf/app/agent.app.config.yaml)
  SERVER_ID=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.agent.server_id' /opt/kasm/${CURRENT_VERSION}/conf/app/agent.app.config.yaml)
  PUBLIC_HOSTNAME=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.agent.public_hostname' /opt/kasm/${CURRENT_VERSION}/conf/app/agent.app.config.yaml)
  MANAGER_ID=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.manager.manager_id' /opt/kasm/${CURRENT_VERSION}/conf/app/api.app.config.yaml)
  SERVER_HOSTNAME=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.server.server_hostname' /opt/kasm/${CURRENT_VERSION}/conf/app/api.app.config.yaml)
  REDIS_PASSWORD=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.redis.redis_password' /opt/kasm/${CURRENT_VERSION}/conf/app/api.app.config.yaml)
  DATABASE_HOSTNAME=$(${SCRIPT_PATH}/bin/utils/yq_${ARCH} '.database.host' /opt/kasm/${CURRENT_VERSION}/conf/app/api.app.config.yaml)
}

function stop_kasm() {
  /opt/kasm/bin/stop
}

function start_kasm() {
  /opt/kasm/bin/start
}

function backup_db() {
  mkdir -p /opt/kasm/backups/
  # Hotfix in case we have old paths for dumping DB
  sed -i 's/tmp/backup/g' /opt/kasm/${CURRENT_VERSION}/bin/utils/db_backup
  # Run backup
  bash /opt/kasm/${CURRENT_VERSION}/bin/utils/db_backup -f /opt/kasm/backups/kasm_db_backup.tar -p /opt/kasm/${CURRENT_VERSION}/
  if [ ! -f "/opt/kasm/backups/kasm_db_backup.tar" ]; then
    echo "Error backing up database, please follow the instructions at https://kasmweb.com/docs/latest/upgrade/single_server_upgrade.html to manually upgrade your installation"
    start_kasm
    exit 1
  fi
}

function clean_install() {
  echo "Installing Kasm Workspaces ${KASM_VERSION}"
  if [ ! -z "${SERVICE_IMAGE_TARFILE}" ]; then
    OPTS="-s ${SERVICE_IMAGE_TARFILE} -I"
  else
    OPTS="-I"
  fi
  bash ${SCRIPT_PATH}/install.sh -e -H -D ${OPTS} -Q ${DB_PASSWORD} -M ${MANAGER_TOKEN} -L ${DEFAULT_PROXY_LISTENING_PORT}
}

function db_install() {
  echo "Installing Kasm Workspaces ${KASM_VERSION}"
  if [ ! -z "${SERVICE_IMAGE_TARFILE}" ]; then
    OPTS="-s ${SERVICE_IMAGE_TARFILE} -I"
  else
    OPTS="-I"
  fi
  bash ${SCRIPT_PATH}/install.sh -e -H -D ${OPTS} -S db -Q ${DB_PASSWORD} -R ${REDIS_PASSWORD} -L ${DEFAULT_PROXY_LISTENING_PORT}
}

function agent_install() {
  echo "Installing Kasm Workspaces ${KASM_VERSION}"
  if [ ! -z "${SERVICE_IMAGE_TARFILE}" ]; then
    OPTS="-s ${SERVICE_IMAGE_TARFILE} -I"
  else
    OPTS="-I"
  fi
  bash ${SCRIPT_PATH}/install.sh -e -H ${OPTS} -S agent -D -p ${PUBLIC_HOSTNAME} -m ${SERVER_HOSTNAME} -M ${MANAGER_TOKEN} -L ${DEFAULT_PROXY_LISTENING_PORT}
}

function app_install() {
  echo "Installing Kasm Workspaces ${KASM_VERSION}"
  if [ ! -z "${SERVICE_IMAGE_TARFILE}" ]; then
    OPTS="-s ${SERVICE_IMAGE_TARFILE} -I"
  else
    OPTS="-I"
  fi
  bash ${SCRIPT_PATH}/install.sh -e -H ${OPTS} -S app -D -q ${DATABASE_HOSTNAME} -Q ${DB_PASSWORD} -R ${REDIS_PASSWORD} -L ${DEFAULT_PROXY_LISTENING_PORT}
}

function modify_configs() {
  ${SCRIPT_PATH}/bin/utils/yq_${ARCH} -i '.agent.server_id = "'${SERVER_ID}'"' /opt/kasm/${KASM_VERSION}/conf/app/agent.app.config.yaml
  ${SCRIPT_PATH}/bin/utils/yq_${ARCH} -i '.agent.public_hostname = "'${PUBLIC_HOSTNAME}'"' /opt/kasm/${KASM_VERSION}/conf/app/agent.app.config.yaml
  ${SCRIPT_PATH}/bin/utils/yq_${ARCH} -i '.manager.manager_id = "'${MANAGER_ID}'"' /opt/kasm/${KASM_VERSION}/conf/app/api.app.config.yaml
  ${SCRIPT_PATH}/bin/utils/yq_${ARCH} -i '.server.server_hostname = "'${SERVER_HOSTNAME}'"' /opt/kasm/${KASM_VERSION}/conf/app/api.app.config.yaml
}

function copy_nginx() {
  if [ $(ls -A /opt/kasm/${CURRENT_VERSION}/conf/nginx/containers.d/) ]; then
    cp /opt/kasm/${CURRENT_VERSION}/conf/nginx/containers.d/* /opt/kasm/${KASM_VERSION}/conf/nginx/containers.d/
  fi
}

function restore_db() {
  /opt/kasm/${KASM_VERSION}/bin/utils/db_restore -a -f /opt/kasm/backups/kasm_db_backup.tar -p  /opt/kasm/${KASM_VERSION}
  /opt/kasm/${KASM_VERSION}/bin/utils/db_upgrade -p /opt/kasm/${KASM_VERSION}
}

function pull_images() {
  CLEAN_ARCH=$(uname -p | sed 's/aarch64/arm64/g' | sed 's/x86_64/amd64/g')
  if [ "${PURGE_IMAGES}" == "true" ] && [ "${PULL_IMAGES}" == "true" ]; then
    if [ -z "${ROLE}" ]; then
      echo "Purging old images from system"
      sudo docker exec kasm_db psql -U kasmapp -d kasm -t  -c "SELECT name FROM images;" | xargs -L 1 sudo docker rmi || :
    fi
    if [ "${ROLE}" == "db" ] || [ -z "${ROLE}" ]; then
      sudo docker exec kasm_db psql -U kasmapp -d kasm -t  -c "DELETE FROM images;"
    fi
  elif [ "${PURGE_IMAGES}" == "false" ] && [ "${PULL_IMAGES}" == "true" ]; then
    if [ "${ROLE}" == "db" ] || [ -z "${ROLE}" ]; then
      sudo docker exec kasm_db psql -U kasmapp -d kasm -t  -c "UPDATE images set enabled = 'false';"
    fi
  fi
  if [ ! -z "${WORKSPACE_IMAGE_TARFILE}" ]; then
    echo "Adding offline Workspaces images"
    tar xf ${WORKSPACE_IMAGE_TARFILE} --strip-components=1 -C /opt/kasm/${KASM_VERSION}/conf/database/seed_data/ workspace_images/default_images_${CLEAN_ARCH}.yaml
  fi
  if ([ ! -z "${WORKSPACE_IMAGE_TARFILE}" ] || [ "${PULL_IMAGES}" == "true" ]) && ([ -z "${ROLE}" ] || [ "${ROLE}" == "db" ]); then
    /opt/kasm/${KASM_VERSION}/bin/utils/db_init -s /opt/kasm/${KASM_VERSION}/conf/database/seed_data/default_images_${CLEAN_ARCH}.yaml
    start_kasm
  fi
  if [ ! -z "${WORKSPACE_IMAGE_TARFILE}" ] && ([ -z "${ROLE}" ] || [ "${ROLE}" == "agent" ]); then
    echo "Extracting offline Workspace images"
    tar xf "${WORKSPACE_IMAGE_TARFILE}" -C "${KASM_RELEASE}"
    # install all kasm infrastructure images
    while IFS="" read -r image || [ -n "$image" ]; do
      echo "Loading image: $image"
      IMAGE_FILENAME=$(echo $image | sed -r 's#[:/]#_#g')
      docker load --input ${KASM_RELEASE}/workspace_images/${IMAGE_FILENAME}.tar
    done < ${KASM_RELEASE}/workspace_images/images.txt
  elif [ "${PULL_IMAGES}" == "true" ] && ([ -z "${ROLE}" ] || [ "${ROLE}" == "agent" ]); then
    if [ $(sudo docker exec kasm_db psql -U kasmapp -d kasm -t  -c "SELECT name FROM images WHERE enabled = true;"| sed '/^ *$/ d'| wc -l) -ne 0 ]; then
      echo "Pulling default Workspaces Images"
      sudo docker exec kasm_db psql -U kasmapp -d kasm -t  -c "SELECT name FROM images WHERE enabled = true;" | xargs -L 1 sudo  docker pull
    fi
  fi
}

function display_help() {
  CMD='\033[0;31m'
  NC='\033[0m'
  echo "Kasm Upgrader ${KASM_VERSION}" 
  echo "Usage IE:"
  echo "${0} --upgrade-images --role all"
  echo    ""
  echo    "Flag                       Description"
  echo    "------------------------------------------------------------------------------------"
  echo -e "| ${CMD}-h|--help${NC}                | Display this help menu                                |"
  echo -e "| ${CMD}-L|--proxy-port${NC}          | Default Proxy Listening Port                          |"
  echo -e "| ${CMD}-I|--no-images${NC}           | Don't seed or pull default Workspaces Images          |"
  echo -e "| ${CMD}-U|--upgrade-images${NC}      | Upgrade Images to current set purging previous images |"
  echo -e "| ${CMD}-K|--add-images${NC}          | Ingest the latest images keeping old images in place  |"
  echo -e "| ${CMD}-w|--offline-workspaces${NC}  | Path to the tar.gz workspace images offline installer |"
  echo -e "| ${CMD}-s|--offline-service${NC}     | Path to the tar.gz service images offline installer   |"
  echo -e "| ${CMD}-S|--role${NC}                | Role to Upgrade: [app|db|agent]                       |"
  echo    "------------------------------------------------------------------------------------"
}


function check_role() {
if [ "${ROLE}" != "agent" ]  &&  [ "${ROLE}" !=  "app" ] &&  [ "${ROLE}" != "db" ];
then
    echo "Invalid Role Defined"
    display_help
    exit 1
fi
}

# Command line opts
for index in "${!ARGS[@]}"; do
  case ${ARGS[index]} in
    -L|--proxy-port)
        DEFAULT_PROXY_LISTENING_PORT="${ARGS[index+1]}"
        echo "Setting Default Listening Port as ${DEFAULT_PROXY_LISTENING_PORT}"
        ;;
    -S|--role)
        ROLE="${ARGS[index+1]}"
        check_role
        echo "Setting Role as ${ROLE}"
        ;;
    -h|--help)
      display_help
      exit 0
      ;;
    -I|--no-images)
      PULL_IMAGES="false"
      ;;
    -U|--upgrade-images)
      PURGE_IMAGES="true"
      PULL_IMAGES="true"
      ;;
    -K|--add-images)
      PURGE_IMAGES="false"
      PULL_IMAGES="true"
      ;;
    -w|--offline-workspaces)
        WORKSPACE_IMAGE_TARFILE="${ARGS[index+1]}"
        OFFLINE_INSTALL="true"

        if [ ! -f "$WORKSPACE_IMAGE_TARFILE" ]; then
            echo "FATAL: Workspace image tarfile does not exist: ${WORKSPACE_IMAGE_TARFILE}"
            exit 1
        fi

        echo "Setting workspace image tarfile to ${WORKSPACE_IMAGE_TARFILE}"
        ;;
    -s|--offline-service)
        SERVICE_IMAGE_TARFILE="${ARGS[index+1]}"
        OFFLINE_INSTALL="true"
        PULL_IMAGES="false"

        if [ ! -f "$SERVICE_IMAGE_TARFILE" ]; then
          echo "FATAL: Service image tarfile does not exist: ${SERVICE_IMAGE_TARFILE}"
          exit 1
        fi

        echo "Setting service image tarfile to ${SERVICE_IMAGE_TARFILE}"
        ;;
    -*|--*)
        echo "Unknown option ${ARG}"
        display_help
        exit 1
        ;;
  esac
done

# Check to ensure docker has enough disk space
DOCKER_DIR=$(docker info | awk -F': ' '/Docker Root Dir/ {print $2}')
BYTES=$(df --output=avail -B 1 "${DOCKER_DIR}" | tail -n 1)
if [ "${BYTES}" -lt "${DISK_SPACE}" ] && [ "${PULL_IMAGES}" == "true" ]; then
  echo "Not enough disk space for the upgrade - Please free up disk space or use -I to not preseed images"
  exit -1
fi

# Perform upgrade
if [ -z "${ROLE}" ]; then
  gather_vars
  stop_kasm
  backup_db
  clean_install
  modify_configs
  copy_nginx
  restore_db
  start_kasm
  pull_images
  start_kasm
elif [ "${ROLE}" == "db" ]; then
  gather_vars
  stop_kasm
  backup_db
  db_install
  restore_db
  start_kasm
  pull_images
  start_kasm
elif [ "${ROLE}" == "agent" ]; then
  gather_vars
  stop_kasm
  agent_install
  modify_configs
  copy_nginx
  start_kasm
  pull_images
  start_kasm
elif [ "${ROLE}" == "app" ]; then
  gather_vars
  stop_kasm
  app_install
  modify_configs
  start_kasm
fi

printf "\n\n"
echo "Upgrade from ${CURRENT_VERSION} to ${KASM_VERSION} Complete"
