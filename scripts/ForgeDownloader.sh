#!bin/bash

# Clears the screen #
clear

# List of Forge versions and their URLs #
declare -A forgeUrls=(
    [1]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.20.2-48.0.22/forge-1.20.2-48.0.22-installer.jar"
    [2]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.19.4-45.2.0/forge-1.19.4-45.2.0-installer.jar"
    [3]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.18.2-40.2.0/forge-1.18.2-40.2.0-installer.jar"
    [4]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.17.1-37.1.1/forge-1.17.1-37.1.1-installer.jar"
    [5]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.16.5-36.2.34/forge-1.16.5-36.2.34-installer.jar"
    [6]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.15.2-31.2.57/forge-1.15.2-31.2.57-installer.jar"
    [7]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.14.4-28.2.26/forge-1.14.4-28.2.26-installer.jar"
    [8]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.13.2-25.0.223/forge-1.13.2-25.0.223-installer.jar"
    [9]="https://maven.minecraftforge.net/net/minecraftforge/forge/1.12.2-14.23.5.2859/forge-1.12.2-14.23.5.2859-installer.jar"
)

# List of versions to select from (Displayed for the user) #

echo ""
echo "1).   1.20.2"
echo "2).   1.19.4"
echo "3).   1.18.2"
echo "4).   1.17.1"
echo "5).   1.16.5"
echo "6).   1.15.2"
echo "7).   1.14.4"
echo "8).   1.13.2"
echo "9).   1.12.2"
echo ""

# If, elif, then statement that loops if improper input was declared; chooses 1.20.2 if nothing is chosen, and selects the version you want if you input a version #
while true; do
    read -p "What version of Forge do you want? " mcVers

    if [[ $mcVers -ge 1 && $mcVers -le ${#forgeUrls[@]} ]]; then
        echo You selected $mcVers.
        break
    elif [[ $mcVers == '' ]]; then
        mcVers=1
        echo "Going with the default selection (1: 1.20.2)"
        break
    else
        echo Please choose a proper release of Forge.
    fi

done

# Get the Forge download URL for the selected version #
forgeUrl="${forgeUrls[$mcVers]}"

# Download Forge #
wget $forgeUrl

# Decides what version of OpenJDK you need #
    if [[ $mcVers -ge 4 && $mcVers -le ${#forgeUrls[@]} ]]; then
        echo "Downloading OpenJDK-8-JRE"
        sudo apt install openjdk-8-jre -y
        break
    elif [[ $mcVers -le 3 ]]; then
        echo "Downloading OpenJDK-17-JRE"
        sudo apt install openjdk-17-jre -y
        break
    else
        echo "Something has broken, please contact support@homedataroom.com"
    fi

# Makes the Minecraft directory in /opt #
sudo mkdir /opt/minecraft
# Gives the 'minecraft' running this script full ownership of the Minecraft directory #
sudo chown minecraft:minecraft /opt/minecraft
# Moves PaperMC to '/opt/minecraft' and renames it 'mcserver.jar' #
sudo mv forge-1* /opt/minecraft/


# Start the Minecraft server so the right files and folders are created and downloaded #
cd /opt/minecraft
# Switches to 'minecraft' user # 
sudo su minecraft <<EOF
bash
java -jar forge-1*-installer.jar --installServer
rm forge-1*-installer.jar
mv forge-*.jar mcserver.jar
java -jar /opt/minecraft/mcserver.jar nogui
#Accepts the EULA#
sed -i 's/false/true/g' eula.txt
exit 
exit
EOF
# Back to current user #
