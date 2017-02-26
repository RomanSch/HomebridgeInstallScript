#!/bin/bash

# Author: Roman Schulz
# inspired by:
# forum.smartapfel.de
# on GitHub:
# https://github.com/RomanSch/HomebridgeInstallScript
# Version 1.0.0.1

baseDir=$PWD/files
cd $baseDir
sudo mkdir log
sudo chmod 777 log

######################################
############# Functions ##############
######################################

log(){
	#Logging and output to console
	message=$1
	echo $message
	echo "$(date +%Y-%m-%d_%H-%M-%S) - $message" >> log/install.log
}

######################################
######### Installationroutine ########     
######################################

log "Starting Homebridge Installation"
log "Do you want to install Systemupdates first? It is recommended. (Y/N)"
read updSystem
if [ "$updSystem" == "y" -o "$updSystem" == "Y" ]
then
	log "Start Systemupdate"
	sudo apt-get update -y
	sudo apt-get dist-upgrade -y
	sudo apt-get check
	sudo apt-get clean
else
	log "Please update your Raspbian and other Software later."
fi
log "Checking your Raspberry Pi Hardwareversion..."
hardwareVersion=sudo cat /proc/cpuinfo | grep Revision
if [[ "$hardwareVersion" =~ [0-9]{4}$ ]]
then 
	log "You own an older Version of Raspberry Pi (< Raspberry Pi 2)."
	architecture="6l"
else
	log "You own a new Raspberry Pi (>= Raspberry Pi 2)."
	architecture="7l"
fi
log "Which NodeJS Version you want to install? Please use form like this: 6.9.5"
read nodeVersion
log "Installing NodeJS in Version $nodeVersion"
wget https://nodejs.org/dist/v$nodeVersion/node-v$nodeVersion-linux-armv$architecture.tar.gz
tar -xvf node-v$nodeVersion-linux-armv$architecture.tar.gz
cd $baseDir/node-v$nodeVersion-linux-armv$architecture/
sudo cp -R * /usr/local/
cd $baseDir
sudo rm node-v$nodeVersion-linux-armv$architecture -r
sudo rm node-v$nodeVersion-linux-armv$architecture.tar.gz
log "Installing libavahi libdnssd"
sudo apt-get install libavahi-compat-libdnssd-dev
log "Installing latest NPM Release"
sudo npm install -g npm@latest
log "Installing homebridge via NPM"
sudo npm install -g --unsafe-perm homebridge@latest
log "Install Plugins? If you don't know what plugins have a look at https://www.npmjs.com (Y/N)"
read installPlugins
if [ "$installPlugins" == "Y" -o "$installPlugins" == "y" ]
	then 
		until [ "$morePlugins" == "N" -o "$morePlugins" == "n" ]
		do 
			log "Enter the name of the plugin (e.g. harmonyhub)"
			read plugin
			pluginBaseName="homebridge-"
			pluginName="$pluginBaseName$plugin"
			log "Installing Plugin: $pluginName"
			sudo npm install -g $pluginName@latest
			log "More Plugins? (Y/N)"
			read morePlugins
		done
	else
		log "Continue installation without plugins"
fi
log "Copying default config.json" 
log "You have to do the plugin configuration on your own. For more Infos refer to the Plugindistributor"
sudo cp config.json /var/homebridge/config.json	
log "Config.json copied to /var/homebridge. Edit this Config.json do make your Plugin Configuration"	
log "Do you want to configure the automatic Service to start Homebridge on every Boot? (Y/N)"
read installService
if [ "$installService" == "y" -o "$installService" == "Y" ]
then 
	log "Copying Service Files to Filesystem" 
	sudo cp homebridge /etc/default/homebridge
	sudo cp homebridge.service /etc/systemd/system/homebridge.service
	log "Service files copied to filesystem" 
	log "Create Service User homebridge" 
	sudo useradd -M --system --group sudo homebridge
	log "Service User Homebridge created" 
	log "Modify Sudoers.d for user homebridge" 
	sudo cp 011_homebridge_nopasswd /etc/sudoers.d/011_homebridge_nopasswd
	log "Sudoers.d modified" 
	log "Enable systemd Service" 
	sudo systemctl daemon-reload
	sudo systemctl enable homebridge
	log "Systemd Service enabled" 
	log "Copying Start Stop Skripts to Desktop" 
	sudo cp HomebridgeRestart ~/Desktop/HomebridgeRestart
	sudo cp HomebridgeStart ~/Desktop/HomebridgeStart
	sudo cp HomebridgeStop ~/Desktop/HomebridgeStop
	sudo cp Journal ~/Desktop/HomebridgeLog
else
	log "No Service configuration selected"
fi
log "Enable VNC Server to remote connect to Raspberry Desktop? (Y/N)"
read enableVncServer
if [ "$enableVncServer" == "y" -o "$enableVncServer" == "Y" ]
then
	if  sudo systemctl status vncserver-x11-serviced.service | grep -q inactive ;
	then
		log "Enabling VNC Server in Raspi-Config"
		sudo systemctl enable vncserver-x11-serviced.service
	else
		log "VNC Server already enabled"
	fi
else
	log "VNC Server activation not triggered"
fi
log "Cleanup of old unused stuff..."
sudo dpkg -P `dpkg -l | grep "^rc" | awk -F" " '{ print $2 }'`
log "Please don't forget to edit your config.json at /var/homebridge"
log "Restart Raspberry now? (Y/N)" 
read rebootNow
if [ "$rebootNow" == "y" -o "$rebootNow" == "Y" ]
then
	log "Rebooting Rasperry now" 
	sudo reboot
else 
	log "Please restart your Raspberry later" 
	log "Your Homebridge Installation was successful" 	
fi
log "Do you want to start the Service now? Don't forget to edit your config.json at /var/homebridge (Y/N)" 
read startServiceNow
if [ "$startServiceNow" == "y" -o "$startServiceNow" == "Y" ]
then
	log "Starting Homebridge Service now" 
	log "Starting Homebridge Journal" 
	lxterminal --geometry=150x50 -e sudo journalctl -f -u homebridge		
	log "Starting Homebridge Service" 
	sudo systemctl start homebridge
	log "Homebridge Serve started"
else 
	log "Servicestart not triggered"
fi
read -p "Press any key to exit the setup" exit