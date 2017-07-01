#!/bin/bash


# Check IPS variable
if [ -z ${IPS} ]; then
  echo "Please set IPS variable";
  echo "Run this script like below code.";
  echo "";
  echo "> IPS=SLAVE_IP1,SLAVE_IP2 bash sync_master.sh";
  exit 1;
fi

# Install lsyncd
sudo yum -y install --enablerepo=epel lsyncd
sudo chkconfig lsyncd on

# Setting lsyncd
LSYNCD_SETTING_PATH=/etc/lsyncd.conf
sudo tee $LSYNCD_SETTING_PATH <<EOF >/dev/null
settings{
        insist = true,
        statusFile = "/tmp/lsyncd.stat",
        logfile = "/var/log/lsyncd/lsyncd.log",
        statusInterval = 1,
}

targets = {
  "rsync@SLAVE_PRIVATE_IP:/var/www/"
}
for _, target in ipairs( targets )
do
  sync {
    default.rsync,
     source = "/var/www/",
     target = target,
     rsync = {
       archive = true,
       _extra = { "--omit-dir-times" }
     }
  }
end
EOF

IFS_BAK=$IFS
IFS=","
for IP in ${IPS}
do
  sudo sed -E "s/((\".+)SLAVE_PRIVATE_IP([^\"]+\"))/\1,\2${IP}\3/g" ${LSYNCD_SETTING_PATH} | sudo tee ${LSYNCD_SETTING_PATH}.tmp > /dev/null
  sudo mv ${LSYNCD_SETTING_PATH}.tmp ${LSYNCD_SETTING_PATH}
done
sudo sed -E 's/((".+)SLAVE_PRIVATE_IP([^\"]+\")),//g' ${LSYNCD_SETTING_PATH} | sudo tee ${LSYNCD_SETTING_PATH}.tmp > /dev/null
sudo mv ${LSYNCD_SETTING_PATH}.tmp ${LSYNCD_SETTING_PATH}
IFS=$IFS_BAK

# Create Key
if ! sudo test -f /root/.ssh/id_rsa; then
  sudo ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
fi
echo ""
echo "Public key is below."
echo ""
sudo cat /root/.ssh/id_rsa.pub

# Add known_hosts
IFS_BAK=$IFS
IFS=","
for IP in ${IPS}
do
  sudo ssh-keygen -R ${IP}
  sudo ssh-keyscan -H ${IP} | sudo tee -a /root/.ssh/known_hosts > /dev/null
done
IFS=$IFS_BAK