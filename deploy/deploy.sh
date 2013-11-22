#!/bin/sh

#setup mysql root password
echo mysql-server mysql-server/root_password select "vagrant" | debconf-set-selections
echo mysql-server mysql-server/root_password_again select "vagrant" | debconf-set-selections

#list of software to preinstall on you box
apt-get update
apt-get install -y mysql-server apache2 php5 libapache2-mod-php5 php5-mysql vim git

#configure git
git config --global user.name "Your Name"
git config --global user.email "you@email.com"
git config --global credential.helper cache
#add alias for pretty git log tree
echo "alias gitlog=\"git log --graph --all --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%cr)%C(reset) %C(white)%s%C(reset) %C(bold white)— %cn%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit --date=relative\"" >> ~/.bashrc
#display current branch name in commang line
cat << 'EOF' >> ~/.bashrc
c_cyan=`tput setaf 6`
c_red=`tput setaf 1`
c_green=`tput setaf 2`
c_sgr0=`tput sgr0`

parse_git_branch ()
{
  if git rev-parse --git-dir >/dev/null 2>&1
  then
          gitver=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')
  else
          return 0
  fi
  echo -e $gitver
}

branch_color ()
{
        if git rev-parse --git-dir >/dev/null 2>&1
        then
                color=""
                if git diff --quiet 2>/dev/null >&2
                then
                        color="${c_green}"
                else
                        color=${c_red}
                fi
        else
                return 0
        fi
        echo -ne $color
}
PS1='\u@\h:\[$(tput sgr0)$(tput setaf 5)\]\w\[$(tput sgr0)$(tput setaf 2)\] $(__git_ps1 "[%s]") \[$(tput sgr0)\]$ '
EOF

#setup vim syntax highlighting
echo -e "syntax on\ncolorscheme desert" | cat >> ~/.vimrc

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
