# Homebridge automated Installation Script
Automated Script to install <a href="https://github.com/nfarina/homebridge" target="_blank">Homebridge</a> and a few other things on a <a href="https://www.raspberrypi.org" targe="_blank">Raspberry Pi</a>. This script was inspired by the <a href="forum.smartapfel.de" target="_blank">Smartapfel.de Community</a>.

This script provides the following things in an automated way:
<ul>
<li>Installation of available Raspbian Updates (apt-get update/apt-get upgrade) Optional you can update the Raspberry Firmware (rpi-update)</li>
<li>Checks the Raspberry Version and considers this for the NodeJS Installation.</li>
<li>NodeJS in desired Version will be installed. If no Version is provided 9.11.2 will be installed.</li>
<li>Libavahi DNS package Installation</li>
<li>The latest Version of NPM</li>
<li>The latest Version of Hombridge Application</li>
<li>After the first steps you will be asked to install some Homebridge Plugins. Provide the name (e.g. for homebridge-harmonhub provide harmonyhub) and teh desired version of the plugin (no provided Version means latest available)</li>
<li>You are able to provide your own config.json (in case of backup for example). If not a default config.json will be copied to /var/homebridge. You need to edit this config.json if you want to make the pluginconfiguration</li>
<li>Next step ist the configuration of the systemd Service (Start of Homebridge App after every boot and failure). This scripts creates a new user called homebridge to start the Homebridge service. Every needed file will be copied to the correct destination.</li>
<li>The script creates a few desktop shortcuts to start, stop and restart the Homebridge Service and to view the current log from Homebridge (Journalctl) on the desktop of the signed in user.</li>
<li>Cleanup of Installation leftovers and old configuration files</li>
<li>At least the script asks you to restart the Raspberry Pi</li>
</ul>

Call the HomebridgeInstall File via Terminal by calling "bash \<path to the script\>" or make the file
executable and call it with a doubleclick and start with the terminal 
