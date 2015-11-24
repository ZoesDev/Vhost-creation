### About
The script is used to create vhosts on Apache web server. It is designed for use on Debian/Ubunut servers but may work on Redhat based servers too. 
when the script runs, it will ask for the desired url, relative web root, and does it need SSL or not. The script uses name based SSL so you many need to change Apache config to use it. by adding


    <IfModule mod_ssl.c>
        # If you add NameVirtualHost *:443 here, you will also have to change
        # the VirtualHost statement in /etc/apache2/sites-available/default-ssl
        # to <VirtualHost *:443>
        # Server Name Indication for SSL named virtual hosts is currently not
        # supported by MSIE on Windows XP.
        Listen 443
        NameVirtualHost *:443
    </IfModule>
    <IfModule mod_gnutls.c>
       Listen 443
       NameVirtualHost *:443
    </IfModule>


at /etc/apache2/ports.conf


### Install

1. Just git clone to your directory you want it
2. open up the vhosts.sh 
	- Change hosts_path to correct location normally at /etc/hosts
	- Change vhosts_path to where the vhosts are normally located on your server. defualt is normally fine
	- Change skeletion paths if you move them
	- Change web_root="/var/www" to where you want the websites to sit.
3. Open vhost.skeleton.conf and change ServerAdmin to the correct Email
4. open sslvhost.skeleton.conf 
	- change ServerAdmin to the correct Email
	- change SSL file locations to the correct locations

	
        SSLCertificateFile     /path/to/ssl/crt
        SSLCertificateKeyFile  /path/to/ssl/key
        SSLCertificateChainFile /path/to/ssl/ca.pem
        
5. Give the script the ability to excute by doing chmod +x vhosts.sh

### Usage
To use the script. Just run  ``` sudo vhosts.sh ``` and follow the directions
