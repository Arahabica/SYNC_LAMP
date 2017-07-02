#!/bin/bash

###############
# CentOS LAMP
#
# CentOS6
# PHP5.6
# MySQL Client 5.7

# update
sudo yum -y update
sudo yum -y upgrade -y

# PHP5.6
# ref) http://qiita.com/pakiln/items/645e8a97cde46b59f9f8
sudo rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
sudo yum -y install --enablerepo=remi --enablerepo=remi-php56 php php-opcache php-devel php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-pecl-xhprof
# Apache 2.2
sudo yum -y install httpd httpd-devel httpd-tools  httpd-manual
sudo chkconfig httpd on

# MySQL Client 5.7 (Not include MySQL Server)
# ref) http://qiita.com/tachitechi/items/b59278a16f636651410f
sudo yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
sudo yum -y install yum-utils
sudo yum-config-manager --enable mysql57-community-dmr
sudo yum -y install mysql

# HTTP => RDS
sudo setsebool -P httpd_can_network_connect 1

# Confirm Version (Optional)
cat /etc/redhat-release
  # CentOS release 6.9 (Final)
httpd -v
  # Server version: Apache/2.2.15 (Unix)
  # Server built:   Mar 22 2017 06:52:55
php -v
  # PHP 5.6.30 (cli) (built: Jan 19 2017 08:09:42)
  # Copyright (c) 1997-2016 The PHP Group
  # Zend Engine v2.6.0, Copyright (c) 1998-2016 Zend Technologies
  #     with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2016, by Zend Technologies
  #     with Xdebug v2.5.5, Copyright (c) 2002-2017, by Derick Rethans
mysql --version
  # mysql  Ver 14.14 Distrib 5.7.18, for Linux (x86_64) using  EditLine wrapper

# Confirm Working (Optional)
echo "apache is work" | sudo tee /var/www/html/index.html > /dev/null
echo "<?php phpinfo();" | sudo tee /var/www/html/phpinfo.php > /dev/null
