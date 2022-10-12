Bash Error Output
Bash provides I/O redirection. There are 3 standard files: STDIN (standard input) with descriptor 0, STDOUT (standard output) with descriptor 1, and STDERR (standard error) with descriptor 2.

If you want to redirect your messages to STDERR, you can use >&2 symbol. This symbol is abbreviation of 1>&2 symbol which means, that everything in STDOUT will go to STDERR.

So, if you want to put the message “Cannot delete directory” in STDERR, you can do it this way:

echo Cannot delete directory >&2
Even more, you might to create your own function for error messages:

recho() { echo "$*" >&2 ; }
recho "Cannot delete directory" > /dev/null
Output: Cannot delete the directory

On the first line, we define recho function (error echo). This function will print all its arguments ($*) to STDERR (>&2).

On the second line, we try to use the function. To prove, that output will be written to STDERR, we will redirect STDIN to nowhere (/dev/null). So, if you see some output, it should be in STDERR.




https://linuxcent.com/bash-error-output/