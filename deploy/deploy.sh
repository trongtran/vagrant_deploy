#!/bin/sh

#setup mysql root password
echo mysql-server mysql-server/root_password select "vagrant" | debconf-set-selections
echo mysql-server mysql-server/root_password_again select "vagrant" | debconf-set-selections

#list of software to preinstall on you box
apt-get update
apt-get install -y mysql-server apache2 php5 libapache2-mod-php5 php5-mysql vim git

#configure git
git config --global user.name "Pawel"
git config --global user.email "pawel@4mation.com.au"
git config --global credential.helper cache

#create webroot for the vhost on the vagrant box
#this will be automatically symlinked to the directory where you setup project locally
mkdir /vagrant/web
echo "<?php phpinfo(); ?>" > /vagrant/web/index.php

#setup vhost
VHOST=$(cat <<EOF
<VirtualHost *:80>
  DocumentRoot "/vagrant/web"
  ServerName localhost
  <Directory "/vagrant/web">
    AllowOverride All
  </Directory>
</VirtualHost>
EOF
)
echo "ServerName localhost" > /etc/apache2/httpd.conf
echo "${VHOST}" > /etc/apache2/sites-enabled/000-default
sudo a2enmod rewrite
service apache2 restart

#remove mysql test db and anonymous user and setup a new db and user
mysql -u root -p"vagrant" -e ";DROP DATABASE test;DROP USER ''@'localhost';CREATE DATABASE dbname;GRANT ALL ON db.* TO dbuser IDENTIFIED BY 'password';"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
service mysql restart
apt-get clean
