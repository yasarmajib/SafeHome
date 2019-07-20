#!bin/bash

#Update RaspberryPi
sudo apt-get update -y
sudo apt-get upgrade -y
#Download Git
sudo apt-get install git -y
#Install OpenHAB
sudo apt-get install openhab2 -y
#Install IPTables-Persistant
sudo apt-get install iptables-persistant -y
#Insatll DHCP Server
sudo apt-get install isc-dhcp-server -y
#Install DNS Server
sudo apt-get install bind9 bind9utils dnsutils -y
#Install Apache2 Server
sudo apt-get install apache2 -y