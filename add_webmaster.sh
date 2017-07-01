#!/bin/bash


# set Webmaster password
PASS1=WEBMASTER_PASSWORD

# Add Webmaster User and He can change /var/www directory.
sudo useradd webmaster
sudo usermod --password $(echo $PASS1 | openssl passwd -1 -stdin)  webmaster
# Allow ssh password
sudo sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sudo service sshd restart

# Set centos user and root user's umask 002
umask 002
C="umask 002" && F=/root/.bashrc && sudo grep "$C" $F > /dev/null || echo "$C" | sudo tee -a $F > /dev/null


sudo chown webmaster:webmaster /var/www
sudo chmod 775 /var/www
sudo chmod g+s /var/www
sudo chown -R webmaster:webmaster /var/www
sudo chmod -R 775 /var/www
sudo chmod -R g+s  /var/www