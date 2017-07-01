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
sudo yum install --enablerepo=epel lsyncd
sudo chkconfig lsyncd on

# Setting lsyncd
LSYNCD_SETTING_PATH=/etc/lsyncd.conf
cat > $LSYNCD_SETTING_PATH << EOF
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
  sed -E "s/((\".+)SLAVE_PRIVATE_IP([^\"]+\"))/\1,\2${IP}\3/g" ${LSYNCD_SETTING_PATH} > ${LSYNCD_SETTING_PATH}.tmp
  mv ${LSYNCD_SETTING_PATH}.tmp ${LSYNCD_SETTING_PATH}
done
sed -E 's/((".+)SLAVE_PRIVATE_IP([^\"]+\")),//g' ${LSYNCD_SETTING_PATH} > ${LSYNCD_SETTING_PATH}.tmp
mv ${LSYNCD_SETTING_PATH}.tmp ${LSYNCD_SETTING_PATH}
IFS=$IFS_BAK

# Create Key
sudo ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
echo ""
echo "Public key is below."
echo ""
sudo cat /root/.ssh/id_rsa.pub