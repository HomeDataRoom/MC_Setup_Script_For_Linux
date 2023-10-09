#!/bin/bash

#Starts the script and displays a message saying "Do you agree to the terms and conditions of the Minecraft EULA?"#
while true; do

read -p "Do you agree to the terms and conditions of the Minecraft EULA? (https://www.minecraft.net/en-us/eula): (y/n) " yn

#Check the user's response#
 case $yn in
	[yY] ) echo proceeding ahead...;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo Invalid response;;
 esac
done

#Initial splash screen for script#
#Friendly display for users; explains what to do (view instructions file basically)#
#This section is not mandatory, however it is nice to have to ensure everything is working like it should and allows users to know where to go for more information.#
sleep 4
clear
echo "########################################################"
echo "   Thank you for using the MC Setup Script For Linux!  "
echo "########################################################"
sleep 1
echo ""
echo "Please read the instructions file to understand what this" 
echo "script does, the requirements for this script and the"
echo "commands that are necessary to run your Minecraft server"
echo "after setup"
sleep 8
clear

#Simple confirmation that the script is moving on from the initial splash screen#
echo "Now onto the actual installation and setup!"
sleep 4
clear

#Updates the repos with latest packages#
sudo apt update
#Updates and upgrades packages and software#
sudo apt upgrade -y
#Installs openJDK Java Runtime Environment and screen#
sudo apt install openjdk-19-jre screen -y
#Allows ports 22/tcp (SSH) and 25565/tcp (Minecraft) through and enables the ufw (Uncomplicated Firewall)#
sudo ufw allow 22/tcp 
sudo ufw allow 25565/tcp 
echo "y" | sudo ufw enable
echo ""
echo "Firewall is enabled; port 22 and 25565 are open."
echo ""
sleep 4

#Downloads PaperMC version 1.20.2#
echo ""
echo 'Please wait while PaperMC 1.20.2 downloads'
echo ""
sleep 5
wget https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/217/downloads/paper-1.20.2-217.jar

#Makes the Minecraft directory in /opt#
sudo mkdir /opt/minecraft
#Gives the user running this script full ownership of the Minecraft directory#
sudo chown $USER:$USER /opt/minecraft
#Moves PaperMC to '/opt/minecraft' and renames it 'StartPaperMC'#
mv paper-1.20.2* /opt/minecraft/StartPaperMC.jar
#Start the Minecraft server so the right files and folders are created and downloaded#
cd /opt/minecraft
java -jar /opt/minecraft/StartPaperMC.jar nogui
#Accepts the EULA#
sed -i 's/false/true/g' eula.txt
#Creates a Minecraft start script in the root of the system (for convenience)#
sudo touch $HOME/MC_Start.sh
sudo chown $USER:$USER $HOME/MC_Start.sh
sudo echo "cd /opt/minecraft && screen -dm java -jar StartPaperMC.jar nogui" > $HOME/MC_Start.sh
sudo chmod +x $HOME/MC_Start.sh

#Creates Systemd service (used for auto-start feature)#
sudo tee -a /lib/systemd/system/minecraft.service > /dev/null <<EOF
[Unit]
Description=MC auto start script
Wants=network.target
After=network.target

[Service]
Type=forking
User=minecraft
Group=minecraft
ExecStart=/bin/bash /home/minecraft/MC_Start.sh

[Install]
WantedBy=multi-user.target
EOF

sudo sed -i "s/minecraft/"$USER"/g" /lib/systemd/system/minecraft.service

#Enables the minecraft.service, start the service, runs a status check for the service#
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service
sudo systemctl status minecraft.service

#Automatically puts you into the Minecraft console#
screen -r
