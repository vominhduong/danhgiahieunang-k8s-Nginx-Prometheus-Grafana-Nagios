#!/bin/bash
set -e

echo "=== Step 1: Update repositories and upgrade packages ==="
sudo apt update && sudo apt upgrade -y

echo "=== Step 2: Install required dependencies ==="
sudo apt install -y build-essential apache2 php openssl perl make php-gd libgd-dev libapache2-mod-php libperl-dev libssl-dev daemon wget apache2-utils unzip

echo "=== Step 3: Create Nagios user and group ==="
sudo useradd -m -s /bin/bash nagios || true
sudo groupadd nagcmd || true
sudo usermod -aG nagcmd nagios
sudo usermod -aG nagcmd www-data

echo "=== Step 4: Download and extract Nagios Core ==="
cd /tmp
wget -q https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.5.tar.gz
tar -zxvf nagios-4.4.5.tar.gz
cd nagios-4.4.5/

echo "=== Step 5: Compile Nagios ==="
sudo ./configure --with-nagios-group=nagios --with-command-group=nagcmd --with-httpd_conf=/etc/apache2/sites-enabled/
sudo make all
sudo make install
sudo make install-init
sudo make install-commandmode
sudo make install-config
sudo make install-daemoninit
sudo make install-webconf

echo "=== Step 6: Create Nagios web user (nagiosadmin) ==="
sudo htpasswd -cb /usr/local/nagios/etc/htpasswd.users nagiosadmin admin123

echo "=== Step 7: Enable CGI module and restart Apache ==="
sudo a2enmod cgi
sudo systemctl restart apache2

echo "=== Step 8: Update contact email ==="
sudo sed -i -E 's/^( *email[[:space:]]+).*/\1admin@example.com ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******/' /usr/local/nagios/etc/objects/contacts.cfg

echo "=== Step 9: Download and install Nagios plugins ==="
cd /tmp
wget -q https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz
tar -zxvf nagios-plugins-2.3.3.tar.gz
cd nagios-plugins-2.3.3/
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios
sudo make
sudo make install

echo "=== Step 10: Verify Nagios configuration ==="
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

echo "=== Step 11: Enable and start Nagios service ==="
sudo systemctl enable nagios
sudo systemctl start nagios
sudo systemctl status nagios --no-pager

echo "✅ Nagios Core installation completed successfully!"
echo "Access Nagios Web UI at: http://<your-server-ip>/nagios/"
echo "Login with username: nagiosadmin / password: admin123"




