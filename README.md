# HomebridgeInstallScript
Automated Script to install <a href="https://github.com/nfarina/homebridge" target="_blank">Homebridge</a> and a few other things on a <a href="https://www.raspberrypi.org" targe="_blank">Raspberry Pi</a>. This script was inspired by the <a href="forum.smartapfel.de" target="_blank">Smartapfel.de Community</a>.

This script provides the following things in an automated way:
<ul>
<li>Installation of available Raspbian Updates (apt-get update/apt-get upgrade) </li>
<li>NodeJS in desired Version will be installed</li>
<li>Libavahi DNS package Installation</li>
<li>The latest Version of NPM</li>
<li>The latest Version of Hombridge Application</li>
<li>After the first steps you will be asked to install some Homebridge Plugins.</li>
<li>A default config.json will be copied to /var/homebridge. This ist the folder where homebridge is installed. You will need to edit the config.json on your own to configure your installed plugins.</li>
<li>Next step ist the configuration of the systemd Service (Start of Homebridge App after every boot and failure). This scripts creates a new user called homebridge to start the Homebridge service. Every needed file will be copied to the correct destination.</li>
<li>The script creates a few desktop shortcuts to start, stop and restart the Homebridge Service and to view the current log from Homebridge (Journalctl) on the desktop of the signed in user.</li>
<li>At least the script asks you to restart the Raspberry Pi</li>
</ul>
