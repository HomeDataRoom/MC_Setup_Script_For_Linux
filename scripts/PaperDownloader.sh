#!bin/bash

# List of PaperMC versions and their URLs #
declare -A paperUrls=(
    [1]="https://api.papermc.io/v2/projects/paper/versions/1.20.2/builds/224/downloads/paper-1.20.2-224.jar"
    [2]="https://api.papermc.io/v2/projects/paper/versions/1.19.4/builds/550/downloads/paper-1.19.4-550.jar"
    [3]="https://api.papermc.io/v2/projects/paper/versions/1.18.2/builds/388/downloads/paper-1.18.2-388.jar"
    [4]="https://api.papermc.io/v2/projects/paper/versions/1.17.1/builds/411/downloads/paper-1.17.1-411.jar"
    [5]="https://api.papermc.io/v2/projects/paper/versions/1.16.5/builds/794/downloads/paper-1.16.5-794.jar"
    [6]="https://api.papermc.io/v2/projects/paper/versions/1.15.2/builds/393/downloads/paper-1.15.2-393.jar"
    [7]="https://api.papermc.io/v2/projects/paper/versions/1.14.4/builds/245/downloads/paper-1.14.4-245.jar"
    [8]="https://api.papermc.io/v2/projects/paper/versions/1.13.2/builds/657/downloads/paper-1.13.2-657.jar"
    [9]="https://api.papermc.io/v2/projects/paper/versions/1.12.2/builds/1620/downloads/paper-1.12.2-1620.jar"
)

# List of versions to select from (Displayed for the user) #

echo "1. 1.20.2"
echo "2. 1.19.4"
echo "3. 1.18.2"
echo "4. 1.17.1"
echo "5. 1.16.5"
echo "6. 1.15.2"
echo "7. 1.14.4"
echo "8. 1.13.2"
echo "9. 1.12.2"

# If, elif, then statement that loops if improper input was declared; chooses 1.20.2 if nothing is chosen, and selects the version you want if you input a version #
while true; do
    read -p "What version of PaperMC do you want? " mcVers

    if [[ $mcVers -ge 1 && $mcVers -le ${#paperUrls[@]} ]]; then
        echo You selected $mcVers.
        break
    elif [[ $mcVers == '' ]]; then
        mcVers=1
        echo "Going with the default selection (1: 1.20.2)"
        break
    else
        echo Please choose a proper release of PaperMC.
    fi

done

# Get the PaperMC download URL for the selected version #
paperUrl="${paperUrls[$mcVers]}"

# Download PaperMC #
wget $paperUrl

# Decides what version of OpenJDK you need #
    if [[ $mcVers -ge 4 && $mcVers -le ${#paperUrls[@]} ]]; then
        echo "Downloading OpenJDK-8-JRE"
        sudo apt install openjdk-8-jre
        break
    elif [[ $mcVers -le 3 ]]; then
        echo "Downloading OpenJDK-17-JRE"
        sudo apt install openjdk-17-jre
        break
    else
        echo "Something has broken, please contact support@homedataroom.com"
    fi

