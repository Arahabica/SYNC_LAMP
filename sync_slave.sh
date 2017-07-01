
# Check IP and KEY variable
if ([ -z ${IP} ]  || [ -z ${KEY} ]); then
  echo "Please set IPS variable";
  echo "Run this script like below code.";
  echo "";
  echo "> IP=MASTER_IP KEY=YOUR_MASTER_PUBLIC_KEY bash sync_slave.sh";
  exit 1;
fi

# Add rsync user
sudo useradd rsync
sudo usermod -G webmaster rsync
sudo mkdir /home/rsync/.ssh
sudo echo ${KEY} > /home/rsync/.ssh/authorized_keys
sudo chown sync /home/rsync/.ssh
sudo chown -R rsync /home/rsync/.ssh
sudo chmod 600 /home/rsync/.ssh/authorized_keys
sudo chmod 700 /home/rsync/.ssh

# Install xinetd
sudo  yum install xinetd
sudo /etc/init.d/xinetd start
sudo chkconfig xinetd on

# /etc/xinetd.d/rsync
sudo cat > /etc/xinetd.d/rsync << EOF
# default: off
# description: The rsync server is a good addition to an ftp server, as it \
#       allows crc checksumming etc.
service rsync
{
        disable = no
        flags           = IPv6
        socket_type     = stream
        wait            = no
        user            = root
        server          = /usr/bin/rsync
        server_args     = --daemon --config=/etc/rsyncd.conf
        log_on_failure  += USERID
}
EOF

# /etc/rsyncd.conf
sudo cat > /etc/rsyncd.conf << EOF
# /etc/rsyncd.conf
uid = root
gid = root
read only = no
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid

[sync]
path = /var/www/
hosts allow = localhost ${IP}
hosts deny = *
read only = false
exclude = .svn
EOF