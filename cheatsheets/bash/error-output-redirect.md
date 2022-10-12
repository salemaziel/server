Bash Error Output Redirect
Each open file gets assigned a file descriptor. The file descriptors for STDIN is 0, for STDOUT is 1 nad STDERR is 2.

If you want to redirect just STDERR (standard error output) to file, ju do:

cmd_name 2> /file
If you want o redirect STDOUT to other files, and STDERR to other files, just do:

cmd_name >/stdout_file 2>/stderr_file
If you want to merge both (STDERR, STDOUT) into one file, you can do:

cmd_name >/file_4_both 2>&1
For the same effect, you can also use this syntax:

cmd_name &> /file_4_both
Even more, it is very useful to use the tee command. By definition, tee read from standard input and write to standard output and files, in same time.

In next example, we merge STDOUT and STDERR of “find /” command together. Then, we pass it to STDIN of tee command. Tee command is executed with -a parameter, that means append to an existing file (if exists):

find / 2>&1 | tee -a /home/tee.output
ll /home
Output: (lines omitted) -rw-r–r–. 1 root root 2.2M Jun 10 13:16 tee.output

The child process inherits open file descriptors. If you want to prevent file descriptors from being inherited, close it. For example:

<&-
This close stddin descriptor.



https://linuxcent.com/bash-error-output-redirect/