# Bash error checking


## exit script if trying to use an uninitialized variable
set -o nounset 


## exit the script if any statement returns a non-true return value
set -o errexit 

