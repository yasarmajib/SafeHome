#!bin/bash

#Update RaspberryPi
echo "Updating Repositories"
sudo apt-get update -q -y
echo "Updating System"
sudo apt-get upgrade -q -y
#=============================
#Download Git
#echo "Downloading Git"
#sudo apt-get install git -q -y
#=============================
#Install OpenHAB
#echo "Installing OpenHAB"
#sudo apt-get install openhab2 -q -y
#=============================
#Insatll DHCP Server
echo "Installing DHCP Server"
sudo apt-get install isc-dhcp-server -q -y
#Install DNS Server
echo "Installing DNS Server"
sudo apt-get install bind9 bind9utils dnsutils -q -y
#Install Apache2 Server
echo "Installing Apache Server"
sudo apt-get install apache2 -q -y

#Adding New Interface and assign new IP Address
echo "Configuring Network"
sudo echo "auto eth0" >> /etc/network/interfaces
sudo echo "iface eth0 inet dhcp" >> /etc/network/interfaces
sudo echo "auto eth1" >> /etc/network/interfaces
sudo echo "iface eth1 inet static" >> /etc/network/interfaces
sudo echo "address 192.168.94.253" >> /etc/network/interfaces
sudo echo "netmask 255.255.255.0" >> /etc/network/interfaces

#Enable IPv4 Forwarding
echo "Enable  Forwarding"
sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

#Restart networking service
echo "Restarting Networking Services"
sudo service networking restart

#DHCP Configurations
echo "Configuring DHCP"
sudo echo "subnet 192.168.94.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf
sudo echo "  range 192.168.94.2 192.168.94.252;" >> /etc/dhcp/dhcpd.conf
sudo echo "  option domain-name-servers 192.168.94.253;" >> /etc/dhcp/dhcpd.conf
sudo echo "  option routers 192.168.94.253;" >> /etc/dhcp/dhcpd.conf
sudo echo "  option broadcast-address 192.168.94.255;" >> /etc/dhcp/dhcpd.conf
sudo echo "  default-lease-time 600;" >> /etc/dhcp/dhcpd.conf
sudo echo "  max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf
sudo echo "}" >> /etc/dhcp/dhcpd.conf

sudo echo "DHCPD_CONF=/etc/dhcp/dhcpd.conf" >> /etc/default/isc-dhcp-server
sudo echo "DHCPD_PID=/var/run/dhcpd.pid" >> /etc/default/isc-dhcp-server
sudo echo 'INTERFACES="eth1"' >> /etc/default/isc-dhcp-server

#Restarting DHCP Service
echo "Restarting DHCP Server"
sudo service isc-dhcp-server restart
#Restarting Bind9
echo "Restarting DNS Server"
sudo service bind9 restart

#Restart networking service again....
echo "Restarting Networking Services again..."
sudo service networking restart

#Enabling Router
#Copy rules to
echo "Copying Firewall Rules to IPTables" 
sudo iptables-restore < iptables_rules.txt

#Install IPTables-Persistant
echo "Installing IPTables Persistant"
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get install iptables-persistent -q -y

#Restarting Networking Services
echo "Restarting Networking Services"
sudo service networking Restarting

#Let's Block Bad Sites...
echo "Blocking BAD Sites..."
sudo cp named.conf.options /etc/bind/

#Rebooting System
echo "Rebooting Pi"
sudo reboot
