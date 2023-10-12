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

# Simple confirmation that the script is moving on from the initial splash screen #
echo "Now onto the actual installation and setup!"
sleep 4
clear

# Port selection tool for the Minecraft server port #
while true; do
read -p "What port do you want your Minecraft server to be on? (Default: 25565) " mcPort

 if [[ $mcPort -ge 4096 ]]
    then
        echo Using port $mcPort.
        break
    elif [[ $mcPort == '' ]]
    then
        declare mcPort=25565
        echo "Going with the default port (25565)"
        break
    else
    echo Please choose legit port.
 fi
done
sleep 5
clear

# Updates the repos with latest packages #
sudo apt update
# Updates and upgrades packages and software #
sudo apt upgrade -y
# Installs screen #
sudo apt install screen -y
clear

#Creates the 'minecraft' user and group #
sudo useradd minecraft
sudo usermod -aG minecraft $USER

echo ""
echo "You have been added to the 'minecraft' group"
echo ""

# Prompts user to select which Minecraft launcher they want to download - you can modify this to add more launchers and options#
declare -A launchPaths=(
    [1]="PaperDownloader.sh"
    [2]="ForgeDownloader.sh"
)

echo ""
echo "#######################################################################"
echo "       Select the Minecraft server launcher you would like to use      "
echo "                PaperMC for regular Minecraft servers                  "
echo "                 Forge for modded Minecraft servers                    "
echo "#######################################################################"
echo ""
echo ""
echo "             PaperMC [1]                    Forge [2]                  "
echo ""

while true; do
    read -p "What Minecraft server launcher would you like to use? " mcLaunch

    if [[ $mcLaunch == 1 ]]; then
        echo Running the PaperMC Downloader
        break
    elif [[ $mcLaunch == 2 ]]; then
        echo Running the Forge Downloader
        break
    else
        echo Please choose a proper Minecraft launcher from the options.
    fi

done

# runs the downloader #
bash "${launchPaths[$mcLaunch]}"
clear
sleep 1

#Allows ports 22/tcp (SSH) and $mcPort/tcp (Minecraft) through and enables the ufw (Uncomplicated Firewall) #
sudo ufw allow 22/tcp 
#User generated port from port selection function #
sudo ufw allow $mcPort/tcp 
echo "y" | sudo ufw enable
echo ""
echo "Firewall is enabled; port 22 and $mcPort are open."
echo ""
sleep 4

# Changes the Minecraft default port to the one selected by the user #
sudo sed -i "s/server-port=25565/server-port=$mcPort/g" /opt/minecraft/server.properties

# Creates a Minecraft bash start script in /opt/minecraft (for convenience) #
sudo touch /opt/minecraft/MC_Start.sh
sudo chown minecraft:minecraft /opt/minecraft/MC_Start.sh
sudo tee /opt/minecraft/MC_Start.sh > /dev/null <<EOF
cd /opt/minecraft && screen -dm java -jar mcserver.jar nogui
EOF
sudo chmod +x /opt/minecraft/MC_Start.sh

#Creates Systemd service (used for auto-start feature)#
sudo tee /lib/systemd/system/minecraft.service > /dev/null <<EOF
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
sleep 10

sudo systemctl stop minecraft.service

#Creating a global aliases bash file#
sudo touch /etc/profile.d/minecraft-aliases.sh
sudo tee /etc/profile.d/minecraft-aliases.sh > /dev/null <<EOF
alias mcscreen="sudo su minecraft -c 'screen -dr'"
alias mcstop="sudo systemctl stop minecraft.service"
alias mcstart="sudo systemctl start minecraft.service"
alias mcrestart="sudo systemctl restart minecraft.service"
alias mcstatus="systemctl status minecraft.service"
alias mcdisable="systemctl disable minecraft.service"
alias mcenable="systemctl enable minecraft.service"
EOF

# Asks the user if they would like to install the Minecraft Rcon web console #
while true; do
clear
echo ""
echo ""
read -p "Would you like to install the Minecraft Web RCON Console " yn
echo ""
echo ""

# Check the user's response #
 case $yn in
	[yY] ) echo Installing Apache Web Server and the RCON Web Console;
        sleep 4
		bash Apache2Setup.sh;
  		break;;
	[nN] ) echo "Moving on then!";
        break;;
	* ) echo Invalid response;;
 esac
done


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
	[nN] ) echo okay;
        sleep 15;;
	* ) echo Invalid response;;
 esac
done

clear
exit
