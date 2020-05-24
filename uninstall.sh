#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo"
    exit
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

rm -rf $binPath
rm -rf $autostartPath/autoconfig.desktop

echo "Uninstalled. Reboot."
