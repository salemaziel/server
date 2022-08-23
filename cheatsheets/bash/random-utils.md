## Date Manipulations
# Use strings to perform date manipulations
FUTURE_DATE=`date --date="+10 days"`         # Fri May 24 16:13:53 EST 2013
FUTURE_DATE=`date --date="+10 days ­1 month"` # Wed Apr 24 16:14:48 EST 2013

# Similar to php's date() function, you can change the output of the bash date
TIME=`date +%T`       # 16:16:08
DATE=`date +%Y-%m-%d` # 2013-05-14
YEAR=`date +%Y`       # 2013

# Use both of these tips together
FUTURE_DATE=`date --date="+10 days -1 month" +%Y-%m-%d\ %T` # 2013­04­24 16:18




###################################


## Using colours in your console output
# Predefined Colours
black='\E[30m'
red='\E[1;31m'
green='\E[1;32m'
yellow='\E[1;33m'
blue='\E[1;34m'
magenta='\E[1;35m'
cyan='\E[1;36m'
white='\E[1;37m'

# Color­echo. Argument $1 = message, Argument $2 = color
# This function works in the same way at `echo` but it prints the line out in a colour you specify.
function cecho ()
{
    local default_msg="No message passed."
    message=${1:-$default_msg} # Defaults to default message.
    color=${2:-""} # Defaults to nothing, if not specified
    echo -e "$color$message"
    tput sgr0 # reset
    return
}

# Example usage:
cecho "Script has completed successfully" $green
cecho "Warning, you are about to do something stupid" $yellow
cecho "Error: Dave's not here man." $red


###################################



## Ask a question to the user
# Function to do when the user answers yes:
function userSaidYes ()
{
    echo "You answered yes :)"
}

# Function to do when the user answers no:
function userSaidNo ()
{
    echo "You answered no :("
}

# Question Logic
while true; do
    read -p "Are you sure you want to do a release? " yn
    case $yn in
        [Yy]* ) userSaidYes; break;;
        [Nn]* ) userSaidNo; break;;
        * ) echo "Please answer yes or no.";;
    esac
done


###################################



## Check if a directory exists
DIR="/path/to/some/dir"
if [ -d "$DIR" ]
then
    echo "$DIR exists!"
else
    echo "$DIR does not exist!"
fi



###################################



## Check if the last command ran successfully
if [ "$?" == 0 ]
then
    echo "Last command ran successfully"
else
    echo "Last command failed with exit code: $?"
fi


###################################



## Get the head revision of an SVN repository
SVN_INFO=`svn info /path/to/svn/repo`
REVISION=`expr match "$SVN_INFO" '.*Revision: \([0-9]*\).*'`

if [[ $REVISION =~ ^-?[0-9]+$ ]]
then
    echo "Revision is $REVISION"
else
    echo "Could not get revision!"
fi


###################################


## Other random bits
# Exit your script
exit

# Exit your script with an exit code
exit 33 # any number you want

# Get the Server Name
SERVER=`uname -n`

# Get the username of the account executing the script
USER=`whoami`

# Get the filename of a path
FILE=`basename "/path/to/some/file/awesome.txt"` # returns: awesome.txt

# Get the dir name of a path
DIR=`dirname "/path/to/some/file/awesome.txt"` # returns: /path/to/some/file



