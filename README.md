Vagrant
=======

##WHY VAGRANT
Vagrant provides easy to configure, reproducible, and portable work environments built on top of industry-standard technology and controlled by a single consistent workflow to help maximize the productivity and flexibility of you and your team.

##HOW VAGRANT BENEFITS YOU
If you're a developer, Vagrant will isolate dependencies and their configuration within a single disposable, consistent environment, without sacrificing any of the tools you're used to working with (editors, browsers, debuggers, etc.). Once you or someone else creates a single Vagrantfile, you just need to vagrant up and everything is installed and configured for you to work. Other members of your team create their development environments from the same configuration, so whether you're working on Linux, Mac OS X, or Windows, all your team members are running code in the same environment, against the same dependencies, all configured the same way. Say goodbye to "works on my machine" bugs.

For more info go to vagrantup.com 


#Setup

To use the script simply download the attached file, extract it and setup vagrant by doing the following: 

##1
```pearl
sudo apt-get install vagrant
```
 
##2
```
vagrant box add precise32 \
    http://files.vagrantup.com/precise32.box
```
 
##3 
Navigate to the directory where you want to set up your project
 
##4 
```
cp path/to/vagrantarchive/* . -R
```

##5
```
vagrant up
```


Now you can access you box by going to: `http://192.168.100.101`
If you want to make the box available on your local network instead of just your local machine follow this tutorial.
If you need another IP address i.e. for a second box, simply edit "Vagrantfile" located in your project directory for that box prior running `vagrant up` (step 5). 

You can start adding files to the directory where you setup your project `./web/`, the files will be automatically added to the webroot of your vagrant box

