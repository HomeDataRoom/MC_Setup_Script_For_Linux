# MC_Setup_Script_For_Linux
Easily setup a Minecraft: Java Edition server on Linux

Before running this script, please note that you must be running a modern Linux operating system that uses the APT package manager (Debian 8 or later, or Ubuntu 20 or later). This script has only been tested on a Ubuntu server, but it should work on Debian and Mint as well.

To run the script on your server or computer:

1. Make sure you have administrative (root) privileges.
2. Run "git clone https://github.com/HomeDataRoom/MC_Setup_Script_For_Linux.git" from your Linux console.
3. or download the .zip from "https://github.com/HomeDataRoom/MC_Setup_Script_For_Linux/archive/refs/heads/main.zip"
4. Once the file(s) are downloaded (and/or unzipped), go into the 'scripts' folder
5. Run "chmod +x MinecraftSetup.sh". This will allow you to execute the script.
6. Then run "./MinecraftSetup.sh". This runs the script.
For more specifics about what the script does, go to the instructions file in the script's folder.

By running this script, you automatically agree to the terms and conditions of PaperMC and the [Minecraft EULA](https://www.minecraft.net/eula).



## The Roadmap for this project 
As time goes on, we plan to add more functionality and settings to this script so you can create a simple auto setup script which caters to your needs better.
The features and functions on the roadmap are not shown in any specific order unless they are specifically specified with parentheses


1. ~~Prompt to agree to the Minecraft EULA~~ 
2. ~~Install all Minecraft files to /opt~~
3. ~~Open up port 25565/tcp~~
4. ~~Create a systemd autostart script (when the computer turns on, the Minecraft server automatically is run)~~
5. Display a list of commands that can help you manage the Minecraft server; such as: 'htop', 'systemctl status minecraft.service', 'screen -r', etc
6. Create a 'minecraft' user and group
7. Create aliases for commands that help manage the minecraft server such as a start and stop command, status command, reset server command, etc
8. Minecraft version selection 
9. Auto select the correct version of OpenJDK
10. Minecraft launcher selection (PaperMC, Bukkit, Forge, etc)
11. RCON Password Creation
12. Open up port 25575/tcp
13. Minecraft port selector
14. Server reset command and prompt (deletes the world files so upon next restart, the server is loaded as a new world)
15. Simple properties and settings selector (difficulty, gamemode, etc)
16. Simple Minecraft management webserver
17. Create a simple document going over each command, function/feature, application, and script of this project 

Some of these are temporary goals which help achieve a larger goal on the list. If something doesn't make sense to be on here, it's probably because it's going to be used later in a bigger feature or function.
