#!/bin/bash

#the puropse of this script is to create vhosts on the server for all websites.
#This is done to make it simple to create the same settings for all sites using this server/servers
#created by Rob 10-24-2014

# permissions
if [ "$(whoami)" != "root" ]; then
        echo "Root privileges are required to run this, try running with sudo..."
        exit 2
fi

current_directory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
hosts_path="/etc/hosts"
vhosts_path="/etc/apache2/sites-available/"
sslvhost_skeleton_path="$current_directory/sslvhost.skeleton.conf"
vhost_skeleton_path="$current_directory/vhost.skeleton.conf"
web_root="/var/www/"

# prompt for options
        read -p "Please enter the desired URL: " site_url
        read -p "Please enter the site path relative to the web root: $web_root_path" relative_doc_root
                read -p "Does the site need SSL $sslyes {y|n}" sslanswer
# construct absolute path
absolute_doc_root=$web_root$relative_doc_root

# create directory if it doesn't exists
if [ ! -d "$absolute_doc_root" ]; then

        # create directory
        `mkdir -p "$absolute_doc_root/httpdocs"`

        # create index file
        indexfile="$absolute_doc_root/httpdocs/index.html"
        `touch "$indexfile"`
        echo "<html><head></head><body>Welcome!</body></html>" >> "$indexfile"
        #set permissions
        `chmod -R 775 "$absolute_doc_root/"`
       `chown -R rob:www-data "$absolute_doc_root/"`
        echo "Created directory $absolute_doc_root/"
fi

# Update Vhost
vhost=`cat "$vhost_skeleton_path"`
vhost=${vhost//@site_url@/$site_url}
vhost=${vhost//@site_docroot@/$absolute_doc_root}

`touch $vhosts_path$site_url`
echo "$vhost" > "$vhosts_path$site_url"

#Check to see if site needs SSL or not

if [[ $sslanswer = y ]] ; then
        sslvhost=`cat "$sslvhost_skeleton_path"`
        sslvhost=${sslvhost//@site_url@/$site_url}
        sslvhost=${sslvhost//@site_docroot@/$absolute_doc_root}
        `touch $vhosts_path$site_url-ssl`
        echo "$sslvhost" > "$vhosts_path$site_url-ssl"
        echo `a2ensite $site_url-ssl`
fi

echo "Updated vhosts in Apache config"

# Restart Apache2
echo "Enabling site in Apache..."
echo `a2ensite $site_url`

echo "Restarting Apache..."
echo `/etc/init.d/apache2 restart`

echo "Process complete, check out the new site at http://$site_url"

exit 0

