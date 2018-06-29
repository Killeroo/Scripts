#!/bin/bash

# Config
set account_name=Metis
set account_password=password

# Installation
echo "-> Updating packages"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get clean
echo "-> Installing Xorg display server"
sudo apt-get install -y --no-install-recommends xserver-xorg
echo "-> Installing desktop enviroment"
sudo apt-get install -y xfce4 xfce4-terminal
#echo "-> Installing login manager"
#sudo apt-get install -lightdm
echo "-> Installation complete."
read -r -p "-> Would you like to set up a new account? [Y/n] " response
case "$response" in 
	[yY][eE][sS]|[yY])
	    sudo adduser --system --home /home/$account_name --disabled-password --shell /bin/bash $account_name
	    (echo $account_password; echo $account_password; ) | sudo passwd $account_name
	    sudo usermod -aG sudo $account_name
	    echo "-> Account created."
	    ;;
	*)
	     
	    ;;
esac
echo
echo "Please run 'sudo reboot' or 'startx'"
