# Bash error checking


## exit script if trying to use an uninitialized variable
set -o nounset 


## exit the script if any statement returns a non-true return value
set -o errexit 

### Exit script if trying to use an uninitialized variable

Using an uninitialized variable in Bash can lead to unexpected behavior and errors. To prevent this, you can use the set -o nounset option, also known as set -u. This option causes the shell to exit with an error message if you try to use an undefined variable.



```
#!/bin/bash

set -o nounset

echo "The value of foo is: $foo"
```



### Exit the script if any statement returns a non-true return value

In Bash, any command or statement can return a status code indicating success or failure. By default, the shell does not exit if a command fails, which can lead to unexpected behavior. To make the shell exit immediately if any command fails, you can use the set -o errexit option, also known as set -e.

#!/bin/bash

set -o errexit

ls /nonexistent/directory
echo "This line will not be executed"



## Exit the script if any pipeline command fails

In addition to the set -o errexit option, you can also use the set -o pipefail option to make the shell exit if any command in a pipeline fails. This can be useful when you want to ensure that the entire pipeline succeeds or fails as a whole.

Example:

#!/bin/bash

set -o errexit
set -o pipefail

echo "foo" | grep "bar" | sed "s/o/a/g"
echo "This line will not be executed"

If you run this script, the grep command will fail because the string "foo" does not contain the substring "bar", and the shell will exit immediately with an error message.



### Check if a command or file exists

To check if a command or file exists before using it, you can use the command -v or type command.

Example:

#!/bin/bash

if ! command -v git &> /dev/null
then
    echo "Git is not installed"
    exit 1
fi

if ! type -P jq &> /dev/null
then
    echo "jq is not installed"
    exit 1
fi

echo "All required commands are installed"


If you run this script without Git or jq installed, you will get an error message indicating which command is missing.




