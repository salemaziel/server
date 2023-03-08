#!/usr/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

umask 077

echo " ** Installing libsasl, postfix & mailutils ** "
pacman -S libsasl postfix mailutils

echo " ** Configuring postfix ** "
echo " 

# STARTING: SALEM'S CONFIGURATIONS BELOW 
relayhost = [smtp.mailgun.org]:2525 
smtp_tls_security_level = encrypt 
smtp_sasl_auth_enable = yes 
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd 
smtp_sasl_security_options = noanonymous " >> /etc/postfix/main.cf 


touch /etc/postfix/sasl_passwd

read -p "[.] Would you like to use a custom domain to send mail from? (Default answer = No, use mg.calegix.net [y/N]: " "use_custom_domain"

if  [[ ("$use_custom_domain" == "y" || "$use_custom_domain" == "Y") ]]; then
     current_domain =""
     while [[ $current_domain == "" ]]; do
          read -p "Enter the domain this mailgun setup is for (ex. mg.mydomain.com): " "current_domain"
       done
       while [[ $smtp_pw == "" ]]; do
          read -p "Enter the SMTP password: "
 "smtp_pw"
        done
             echo -e  "[smtp.mailgun.org]:2525 postmaster@($current_domain):($smtp_pw) >> /etc/postfix/sasl_passwd
else
     echo -e "[smtp.mailgun.org]:2525 postmaster@mg.calegix.net:8632c5589fb7cf45096c674dd0719452-
7bce17e5-cf70b556 " >> 
/etc/postfix/sasl_passwd
fi

postmap /etc/postfix/sasl_passwd

ls -l /etc/postfix/sasl_passwd*

chmod 400 /etc/postfix/sasl_passwd.db
chmod 400 /etc/postfix/sasl_passwd

systemctl restart postfix

echo 'Test passed.' | mail -s SMTP-Through-Mailgun-Email mymainemail0501@gmail.com

journalctl -xe


echo 'Test passed.' | mail -s Test-
SMTP-Through-Mailgun-Email nathanielj@patriotcomputer.men

journalctl -xe ;

done
