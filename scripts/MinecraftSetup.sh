#!/bin/bash

#Updates the repos with latest packages#
sudo apt update
#Updates and upgrades packages and software#
sudo apt upgrade -y
#Installs openJDK Java Runtime Environment and screen#
sudo apt install openjdk-19-jre screen -y
#Downloads PaperMC version 1.20.2#
echo 'Please wait while PaperMC 1.20.2 downloads'
wget https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/217/downloads/paper-1.20.2-217.jar
#Makes the Minecraft directory at the root of the system#
sudo mkdir /minecraft
#Gives the user running this script full ownership of the Minecraft directory#
sudo chown $USER:$USER /minecraft
#Moves PaperMC to '/minecraft' and renames it 'StartPaperMC'#
mv paper-1.20.2* /minecraft/StartPaperMC.jar
#Start the Minecraft server so the right files and folders are created and downloaded#
cd /minecraft
java -jar /minecraft/StartPaperMC.jar nogui
#Accepts the EULA#
sed -i 's/false/true/g' eula.txt
#Creates a Minecraft start script in the root of the system (for convenience)#
sudo touch /MC_Start.sh
sudo chown $USER:$USER /MC_Start.sh
sudo echo "cd /minecraft && screen -dm java -jar StartPaperMC.jar nogui" > /MC_Start.sh
sudo chmod +x /MC_Start.sh
#Starts the server again#
java -jar /minecraft/StartPaperMC.jar nogui
