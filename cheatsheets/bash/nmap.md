# Nmap commands with scripting engine

## Run the most popular scripts
nmap -v -sC 192.168.1.1 

## Run all the scripts within a category
nmap -v --script discovery 192.168.1.1

### You can even combine two categories if needed:
nmap -v --script default,safe 192.168.1.1

## Exclude a category
nmap --script "not vuln" 192.168.1.1

## Run Nmap scripts with a wildcard *
### Nmap also allows you to run scripts using wildcards, meaning you can target multiple scripts that finish or end up with any pattern. For example, if you want to run all the scripts that begin with 'ftp', you could simply use this syntax:

nmap --script "ftp-\*" 192.168.1.1

### The same goes for SSH:
nmap --script "ssh-\*" 192.168.1.1

## Run a single Nmap script
### This is the perfect solution when you already know which script is going to be used. For example, if we want to run the http-brute script to perform brute force password auditing against http basic, digest and ntlm authentication, we'll use:

nmap --script="http-brute" 192.168.122.1

## Run your own scripts
### As we said before, NSE has the ability to let you write your own scripts, and run those scripts locally in your operating system. For this purpose, you can use this syntax:

nmap --script =/your-scripts 192.168.122.1

### Just make sure you replace the path /your-scripts with the local path where your scripts are stored.



