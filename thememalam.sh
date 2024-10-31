#!/bin/bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

clear

installDarkenate() {
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    RESET='\033[0m'

    echo -e "${GREEN}Installing required dependencies...${RESET}"
    apt update -y > /dev/null 2>&1
    apt install git tar -y > /dev/null 2>&1

    echo -e "${GREEN}Cloning Darkenate theme...${RESET}"
    cd /var/www/pterodactyl/resources/scripts/ > /dev/null 2>&1 || { echo -e "${RED}Failed to change directory.${RESET}"; exit 1; }
    
    if [ -d "darkenate" ]; then
        echo -e "${GREEN}Removing old Darkenate theme files...${RESET}"
        rm -rf darkenate > /dev/null 2>&1
    fi
    
    git clone https://github.com/JasonHorkles/darkenate.git > /dev/null 2>&1
    
    echo -e "${GREEN}Moving the new theme files to the directory...${RESET}"
    mv darkenate /var/www/pterodactyl/resources/scripts/darkenate > /dev/null 2>&1

    echo -e "${GREEN}Rebuilding the Panel...${RESET}"
    cd /var/www/pterodactyl > /dev/null 2>&1 || { echo -e "${RED}Failed to change directory.${RESET}"; exit 1; }
    yarn build:production > /dev/null 2>&1
    echo -e "${GREEN}Optimizing the Panel...${RESET}"
    php artisan optimize:clear > /dev/null 2>&1

    echo -e "${GREEN}Darkenate theme installed successfully!${RESET}"
}

deleteDarkenate() {
    if [ -d "/var/www/pterodactyl/resources/scripts/darkenate" ]; then
        echo -e "${GREEN}Removing Darkenate theme...${RESET}"
        rm -rf /var/www/pterodactyl/resources/scripts/darkenate > /dev/null 2>&1
        echo -e "${GREEN}Darkenate theme deleted successfully!${RESET}"
    else
        echo -e "${RED}No Darkenate theme directory found.${RESET}"
    fi
}

installDarkenateQuestion() {
    while true; do
        read -p "Are you sure that you want to install the Darkenate theme [y/n]? " yn
        case $yn in
            [Yy]* ) installDarkenate; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

deleteDarkenateQuestion() {
    while true; do
        read -p "Are you sure that you want to delete the Darkenate theme [y/n]? " yn
        case $yn in
            [Yy]* ) deleteDarkenate; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

echo "Copyright (c) 2024 YourName"
echo "[1] Install Darkenate Theme"
echo "[2] Delete Darkenate Theme"
echo "[3] Exit"

read -p "Please enter a number: " choice
case $choice in
    1) installDarkenateQuestion ;;
    2) deleteDarkenateQuestion ;;
    3) exit ;;
    *) echo "Invalid choice." ; exit 1 ;;
esac
