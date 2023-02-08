
screen
tips on using 'screen'

    Show

# apt install screen

linked screens¶

screen can be used to link two or more users so that basically you have multiple keyboards and multiple consoles but both people see exactly the same thing. cool! this is great for working on installs together or training.
with one user¶

> screen -x

This will join the latest screen session run by the same user.
with two users¶

user1 does this:

> screen -S pizza                   
^a: addacl root
^a: multiuser on

That is ‘Control A followed by Colon.’

user2 does this:

> sudo screen -r user1/pizza

if user2 does not have sudo access, user1 can change the permissions on their tty.
pretty screen¶

codetitle. ~/.screenrc

startup_message off
multiuser on
hardstatus alwayslastline
hardstatus string '%{gk}[ %{G}%H %{g}][%= %{wk}%?%-Lw%?%{=b kR}(%{W}%n*%f %t%?(%u)%?%{=b kR})%{= kw}%?%+Lw%?%?%= %{g}][%{Y}%l%{g}]%{=b C}[ %m/%d %c ]%{W}'

