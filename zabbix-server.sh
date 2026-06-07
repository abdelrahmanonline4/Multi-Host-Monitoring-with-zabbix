#!/bin/bash

set -e

############################
# Variables
############################

ROOT_PASS="Zabbix@2025Strong"
ZABBIX_DB="zabbix"
ZABBIX_USER="zabbix"
ZABBIX_PASS="Zabbix_DB_Pass@123"

CONFIG="/etc/zabbix/zabbix_server.conf"

############################
# Update System
############################

dnf update -y

############################
# SELinux
############################

setenforce 0 || true

sed -i 's/^SELINUX=.*/SELINUX=disabled/' \
/etc/selinux/config

############################
# Hostname
############################

hostnamectl set-hostname zbx01

############################
# Timezone
############################

timedatectl set-timezone Africa/Cairo

############################
# Zabbix Repository
############################

rpm -Uvh \
https://repo.zabbix.com/zabbix/7.0/rhel/9/x86_64/zabbix-release-latest.el9.noarch.rpm

dnf clean all

dnf makecache

############################
# Install Packages
############################

dnf install -y \
mariadb-server \
zabbix-server-mysql \
zabbix-web-mysql \
zabbix-apache-conf \
zabbix-sql-scripts \
zabbix-agent2

############################
# MariaDB
############################

systemctl enable mariadb
systemctl start mariadb

############################
# Secure MariaDB
############################

mysql -u root <<EOF
ALTER USER 'root'@'localhost'
IDENTIFIED BY '${ROOT_PASS}';

DELETE FROM mysql.user
WHERE User='';

DROP DATABASE IF EXISTS test;

DELETE FROM mysql.db
WHERE Db='test'
OR Db='test\\_%';

FLUSH PRIVILEGES;
EOF

############################
# Create Zabbix DB
############################

mysql -uroot -p${ROOT_PASS} <<EOF
CREATE DATABASE ${ZABBIX_DB}
CHARACTER SET utf8mb4
COLLATE utf8mb4_bin;

CREATE USER '${ZABBIX_USER}'@'localhost'
IDENTIFIED BY '${ZABBIX_PASS}';

GRANT ALL PRIVILEGES
ON ${ZABBIX_DB}.*
TO '${ZABBIX_USER}'@'localhost';

FLUSH PRIVILEGES;
EOF

############################
# Enable Import
############################

mysql -uroot -p${ROOT_PASS} -e "
SET GLOBAL log_bin_trust_function_creators = 1;
"

############################
# Import Schema
############################

zcat \
/usr/share/zabbix-sql-scripts/mysql/server.sql.gz \
| mysql \
-u${ZABBIX_USER} \
-p${ZABBIX_PASS} \
${ZABBIX_DB}

############################
# Disable Import Mode
############################

mysql -uroot -p${ROOT_PASS} -e "
SET GLOBAL log_bin_trust_function_creators = 0;
"

############################
# Backup Config
############################

cp ${CONFIG} ${CONFIG}.backup

############################
# Configure Zabbix Server
############################

sed -i \
"s/^# DBPassword=.*/DBPassword=${ZABBIX_PASS}/" \
${CONFIG}

grep -q "^DBPassword=" ${CONFIG} || \
echo "DBPassword=${ZABBIX_PASS}" >> ${CONFIG}

############################
# Firewall
############################

systemctl enable firewalld
systemctl start firewalld

firewall-cmd --permanent \
--add-port=10051/tcp

firewall-cmd --permanent \
--add-service=http

firewall-cmd --reload

############################
# Services
############################

systemctl enable zabbix-server
systemctl enable zabbix-agent2
systemctl enable httpd

systemctl restart zabbix-server
systemctl restart zabbix-agent2
systemctl restart httpd

############################
# Status
############################

echo ""
echo "===================================="
echo "Zabbix Installation Completed"
echo "===================================="
echo "URL:"
echo "http://192.168.56.10/zabbix"
echo ""
echo "User : Admin"
echo "Pass : zabbix"
echo ""
echo "DB User : ${ZABBIX_USER}"
echo "DB Name : ${ZABBIX_DB}"
echo "===================================="
