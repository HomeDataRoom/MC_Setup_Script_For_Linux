#!/bin/bash

sudo git clone https://github.com/Rauks/Minecraft-RCON.git

cd Minecraft-RCON

sudo cp -r * /var/www/html

read -p "Type a password for your rcon console (something strong) " rpass

sudo sed -i "s/rcon.password=/rcon.password=$rpass/g" /opt/minecraft/server.properties
sudo sed -i "s/xtMJsVtmx0XypuId7jIb/$rpass/g" /var/www/html/config.php
sudo sed -i "s/localhost/127.0.0.1/g" /var/www/html/config.php
sudo sed -i "s/enable-rcon=false/enable-rcon=true/g" /opt/minecraft/server.properties
