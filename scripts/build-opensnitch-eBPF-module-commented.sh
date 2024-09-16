#!/bin/sh
# This script is used to build the eBPF modules for the opensnitch project.

# Print out the dependencies needed to compile the eBPF modules.
echo """
  Dependencies needed to compile the eBPF modules:
  sudo apt install -y wget flex bison ca-certificates wget python3 rsync bc libssl-dev clang llvm libelf-dev libzip-dev git libpcap-dev
  ---
"""

# Get the kernel version. If a version is passed as an argument, use that instead.
kernel_version=$(uname -r | cut -d. -f1,2)
if [ ! -z $1 ]; then
    kernel_version=$1
fi

# Define the kernel sources file name.
kernel_sources="v${kernel_version}.tar.gz"

# If the kernel sources file already exists, delete it.
if [ -f "${kernel_sources}" ]; then
    echo -n "[i] Deleting previous kernel sources ${kernel_sources}: "
    rm -f ${kernel_sources} && echo "OK" || echo "ERROR"
fi

# Download the kernel sources.
echo "[+] Downloading kernel sources:"
wget -nv --show-progress https://github.com/torvalds/linux/archive/${kernel_sources} 1>/dev/null
echo

# If the kernel sources directory already exists, delete it.
if [ -d "linux-${kernel_version}/" ]; then
    echo -n "[i] Deleting previous kernel sources dir linux-${kernel_version}/: "
    rm -rf linux-${kernel_version}/ && echo "OK" || echo "ERROR"
fi

# Uncompress the kernel sources.
echo -n "[+] Uncompressing kernel sources: "
tar -xf v${kernel_version}.tar.gz && echo "OK" || echo "ERROR"

# If the architecture is arm or arm64, patch the kernel sources.
if [ "${ARCH}" == "arm" -o "${ARCH}" == "arm64" ]; then
    echo "[+] Patching kernel sources"
    patch linux-${kernel_version}/arch/arm/include/asm/unified.h < ebpf_prog/arm-clang-asm-fix.patch
fi

# Prepare the kernel sources.
echo -n "[+] Preparing kernel sources... (1-2 minutes): "
echo -n "."
cd linux-${kernel_version} && yes "" | make oldconfig 1>/dev/null
echo -n "."
make prepare 1>/dev/null
echo -n "."
make headers_install 1>/dev/null
echo " DONE"
cd ../

# If no architecture is specified, default to x86.
if [ -z $ARCH ]; then
    ARCH=x86
fi

# Compile the eBPF modules.
echo "[+] Compiling eBPF modules..."
cd ebpf_prog && make KERNEL_DIR=../linux-${kernel_version} KERNEL_HEADERS=../linux-${kernel_version} ARCH=${ARCH} >/dev/null

# If the modules directory does not exist, create it.
if [ ! -d modules/ ]; then
    mkdir modules/
fi

# Move the compiled modules to the modules directory.
mv opensnitch*o modules/
cd ../

# Remove debug info from the compiled modules.
llvm-strip -g ebpf_prog/modules/opensnitch*.o 

# Check if the opensnitch.o module was compiled and is valid.
if [ -f ebpf_prog/modules/opensnitch.o ]; then
    echo
    if objdump -h ebpf_prog/modules/opensnitch.o | grep "kprobe/tcp_v4_connect"; then
        ls ebpf_prog/modules/*.o
        echo -e "\n * eBPF modules compiled. Now you can copy the *.o files to /etc/opensnitchd/ and restart the daemon\n"
    else
        echo -e "\n [WARN] opensnitch.o module not valid\n"
        exit 1
    fi
else
    echo -e "\n [WARN] opensnitch.o module not compiled\n"
    exit 1
fi
