#!/bin/sh
#
# ~/bin/installscript.sh
#
# This script is made to run after the installation of Manjaro Linux, it will
# help the user to install programs quickly. It lists the most popular apps
# by category so the user can easily find the applicaton he's looking for.
#
# Written by Ruben a.k.a. Culinax

PS3='> '
apps=()
cats=("Web browsers" "File Managers" "Text Editors")
web=("firefox" "chromium" "dwb" "midori" "opera" "uzbl" "luakit")
file=("thunar" "ranger" "pcmanfm" "spacefm" "rox" "mc")
text=("gvim" "gedit" "geany" "vim" "nano" "leafpad")



intro () {
    echo -e "\nHello and welcome to this awesome installation script!"
    echo "This small script will help you to get your system configured as fast as possible."
}



install() {
    if [[ -n $apps ]]; then
        sudo pacman -S "${apps[@]}"
    else
        echo -e "\nNo applications selected"
    fi
}

quit() {
    echo -e "\nQuitting..."
    break
}

show() {
    echo -e "\nCurrent apps listed for installation: "${apps[@]}""
}



maincat() {
    echo -e "\nMain category"
    select cat in "${cats[@]}" "Show List" "Install" "Install & Quit" "Cancel & Quit"; do
        case "$REPLY" in
            1) webcat ;;
            2) filecat ;;
            3) textcat ;;
            4) show ;;
            5) install ;;
            6) install; quit ;;
            7) quit ;;
            *) echo "Invalid Option"; continue;;
        esac
    done
}

webcat() {
    clear; echo -e "\nWeb Browsers"
    select opt in "Return" "${web[@]}"; do
        case "$REPLY" in
            1) clear; maincat ;;
            [2-$((${#web[@]}+1))]) apps+=($opt); echo -e "$opt added to the installation list\n" ;;
            *) echo "Invalid Option"; continue ;;
        esac
    done
}

clear
intro
maincat
