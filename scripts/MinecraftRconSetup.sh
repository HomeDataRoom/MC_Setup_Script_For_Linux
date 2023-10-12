#!/bin/bash

sudo git clone https://github.com/Rauks/Minecraft-RCON.git

cd Minecraft-RCON

# Moves Minecraft RCON web console files to web directory #
sudo cp -r * /var/www/html

clear
# Asks user to create a password for RCON (the user will never use this again nor see this again unless they open up RCON to the world) #
read -p "Type a password for your rcon console (something strong): " rpass

# Changes 'localhost' to '127.0.0.1'; why? because I don't like using localhost, I prefer '127.0.0.1'#
sudo sed -i "s/localhost/127.0.0.1/g" /var/www/html/config.php
# Passes user input 'rpass' to command that will replace the current string of random with the users own password#
sudo sed -i "s/xtMJsVtmx0XypuId7jIb/$rpass/g" /var/www/html/config.php
# enables Minecraft rcon #
sudo sed -i "s/enable-rcon=false/enable-rcon=true/g" /opt/minecraft/server.properties

# Stops Minecraft to refresh the server.properies file #
sudo systemctl stop minecraft.service 
sleep 1
sudo systemctl start minecraft.service

sleep 4
sudo sed -i "s/rcon.password=/rcon.password=$rpass/g" /opt/minecraft/server.properties

echo ""
echo "Minecraft RCON web console is setup!!!"
echo ""

# Restarts both minecraft.service and apache2.service #
sudo systemctl reload apache2.service
