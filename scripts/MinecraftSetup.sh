#!/bin/bash

#Starts the script and displays a message saying "Do you agree to the terms and conditions of the Minecraft EULA?"#
while true; do

read -p "Do you agree to the terms and conditions of the Minecraft EULA? (https://www.minecraft.net/en-us/eula): (y/n) " yn

#Check the user's response#
 case $yn in
	[yY] ) echo proceeding ahead...;
		break;;
	[nN] ) echo You need to agree to the EULA in order to run the server;
        echo exiting...;
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

#Creates the 'minecraft' user and group#
sudo useradd minecraft
sudo groupadd minecraft
sudo usermod -aG minecraft $USER

echo ""
echo "You have been added to the 'minecraft' group"
echo ""

#Downloads PaperMC version 1.20.2#
echo ""
echo 'Please wait while PaperMC 1.20.2 downloads'
echo ""
sleep 5
wget https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/217/downloads/paper-1.20.2-217.jar

#Makes the Minecraft directory in /opt#
sudo mkdir /opt/minecraft
#Gives the 'minecraft' running this script full ownership of the Minecraft directory#
sudo chown minecraft:minecraft /opt/minecraft
#Moves PaperMC to '/opt/minecraft' and renames it 'StartPaperMC.jar'#
sudo mv paper-1.20.2* /opt/minecraft/StartPaperMC.jar
sudo chown minecraft:minecraft /opt/minecraft/StartPaperMC.jar
#Start the Minecraft server so the right files and folders are created and downloaded#
cd /opt/minecraft
#Switches to 'minecraft' user# 
sudo su minecraft <<EOF
bash
java -jar /opt/minecraft/StartPaperMC.jar nogui
#Accepts the EULA#
sed -i 's/false/true/g' eula.txt
exit 
exit
EOF
#Back to current user#

#Creates a Minecraft bash start script in /opt/minecraft (for convenience)#
sudo touch /opt/minecraft/MC_Start.sh
sudo chown minecraft:minecraft /opt/minecraft/MC_Start.sh
sudo tee -a /opt/minecraft/MC_Start.sh > /dev/null <<EOF
cd /opt/minecraft && screen -dm java -jar StartPaperMC.jar nogui
EOF
sudo chmod +x /opt/minecraft/MC_Start.sh

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
ExecStart=/bin/bash /opt/minecraft/MC_Start.sh

[Install]
WantedBy=multi-user.target
EOF

#Enables the minecraft.service, start the service, runs a status check for the service#
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service
sudo systemctl status minecraft.service

echo ""
echo "Minecraft service has been created and enabled"
echo ""
sleep 4

#Creating a global aliases bash file#
sudo touch /etc/profile.d/minecraft-aliases.sh
sudo tee -a /etc/profile.d/minecraft-aliases.sh > /dev/null <<EOF
alias mcscreen="sudo su minecraft -c 'screen -dr'"
alias mcstop="sudo systemctl stop minecraft.service"
alias mcstart="sudo systemctl start minecraft.service"
alias mcrestart="sudo systemctl restart minecraft.service"
alias mcstatus="systemctl status minecraft.service"
alias mcdisable="systemctl disable minecraft.service"
alias mcenable="systemctl enable minecraft.service"
EOF

#Displays a finished screen and gives some simple instructions on how to use the aliases created#

clear
echo ""
echo ""
echo "#################################################################"
echo "        Thank you for using the MC Setup Script for Linux        "
echo "                Created by: The HomeDataRoom Team                "
echo "#################################################################"
echo ""
echo ""
echo "    We have created a set of aliases for a variety of commands   "
echo "      which should help simplify management of the Minecraft     "
echo "      server; especially for users and Minecraft admins who      "
echo "      are not familiar with Linux, Linux commands, and best      "
echo "               security and management practices                 "
echo ""
echo ""
echo "   The aliases are stored in '/etc/profile.d/minecraft-aliases.sh'"
echo "   and they are as follows:"
echo ""
echo "   mcscreen - this brings up the Minecraft server console"
echo "   mcstart - this starts the Minecraft systemd service"
echo "   mcstop - this stops the Minecraft systemd service"
echo "   mcstatus - this checks the status of the Minecraft systemd service"
echo "   mcrestart - this restarts the Minecraft systemd service"
echo "   mcdisable - this disables the Minecraft systemd service (prevents auto start function)"
echo "   mcenable - this enables the Minecraft systemd service (enables the auto start function)"
echo ""
echo "   Please log out of your current session on Linux and log back in"
echo "   to be able to use the aliases; otherwise, the server is running"
echo "   and does not need any further attention from you               "
echo ""
echo "   There may be more aliases created later down the road as we   "
echo "   develope more features, functions, and other scripts to this  "
echo "   project. If we add more aliases or fully fledged scripts, we  "
echo "   will leave information for those things inside the            "
echo "   instructions.txt file and on this finish screen after setup   "
echo ""

#Asks the user if they would like to close the final information screen#
while true; do

read -p "Do you wish to close this finish screen?: (y/n) " yn

#Check the user's response#
 case $yn in
	[yY] ) echo closing screen;
		break;;
	[nN] ) echo okay;;
	* ) echo Invalid response;;
 esac
done

clear
exit
