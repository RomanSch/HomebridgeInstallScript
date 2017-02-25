#!/bin/bash

# Author: Roman Schulz
# inspired by:
# forum.smartapfel.de
# on GitHub:
# https://github.com/RomanSch/HomebridgeInstallScript
# Version 1.0.0.0

baseDir=$PWD/files
cd $baseDir
sudo mkdir log
sudo chmod 777 log

######################################
############# Functions ##############
######################################

function log(){
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
log "Which NodeJS Version you want to install? Please use form like this: 6.9.5"
read nodeVersion
log "Installing NodeJS in Version $nodeVersion"
wget https://nodejs.org/dist/v$nodeVersion/node-v$nodeVersion-linux-armv7l.tar.gz
tar -xvf node-v$nodeVersion-linux-armv7l.tar.gz
cd $baseDir/node-v$nodeVersion-linux-armv7l/
sudo cp -R * /usr/local/
cd $baseDir
sudo rm node-v$nodeVersion-linux-armv7l -r
sudo rm node-v$nodeVersion-linux-armv7l.tar.gz
log "Installing libavahi libdnssd"
sudo apt-get install libavahi-compat-libdnssd-dev
log "Installing latest NPM Release"
sudo npm install -g npm@latest
log "Installing homebridge via NPM"
sudo npm install -g --unsafe-perm homebridge@latest
log "Install Plugins? (Y/N)"
read installPlugins
if [ "$installPlugins" == "Y" -o "$installPlugins" == "y" ]
	then 
		until [ "$morePlugins" == "N" -o "$morePlugins" == "n" ]
		do 
			read -p "Enter the name of the plugin (e.g. harmonyhub)" plugin
			echo $plugin
			pluginBaseName="homebridge-"
			pluginName="$pluginBaseName$plugin"
			log "Installing Plugin: $pluginName"
			sudo npm install -g $pluginName@latest
			log "Weitere Plugins? (Y/N)"
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
	log "Do you want to start the Service now? (Y/N)" 
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
	log "Copying Start Stop Skripts to Desktop" 
	sudo cp HomebridgeRestart ~/Desktop/HomebridgeRestart
	sudo cp HomebridgeStart ~/Desktop/HomebridgeStart
	sudo cp HomebridgeStop ~/Desktop/HomebridgeStop
	sudo cp Journal ~/Desktop/HomebridgeLog
else
	log "No Service configuration selected"
fi
log "Restart Raspberry now? (Y/N)" 
read rebootNow
if [ "$rebootNow" == "y" -o "$rebootNow" == "Y" ]
then
	log "Rebooting Rasperry now" 
	sudo reboot
else 
	log "Please restart your Raspberry later" 
	log "Your Homebridge Installation was successful" 
	read -p "Press any key to exit the setup" exit
fi