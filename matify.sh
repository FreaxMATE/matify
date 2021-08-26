#!/bin/bash

# Copyright (C) 2020 Konstantin Unruh <freaxmate@protonmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

black="\e[0;30m"
red="\e[0;31m"
green="\e[0;32m"
yellow="\e[0;33m"
blue="\e[0;34m"
purple="\e[0;35m"
cyan="\e[0;36m"
white="\e[0;37m"

remove_packages_names="pidgin\
                        hexchat\
                        papirus-maia-icon-theme\
                        imagewriter\
                        thunderbird\
                        timeshift\
                        bauh\
                        lollypop\
                        steam-manjaro\
                        snapd\
                        mate-tweak\
                        vlc"

install_package_names="python-wheel\
                        make\
                        matcha-gtk-theme\
                        meson\
                        gettext\
                        python-caja\
                        python-pip\
                        bash-completion\
                        rhythmbox\
                        celluloid\
                        gcc\
                        redshift\
                        git\
                        gnome-passwordsafe\
                        libreoffice-still\
                        celluloid\
                        evolution\
                        simple-scan\
                        python-psutil\
                        python-setproctitle\
                        python-distro\
                        libnotify\
                        python-setuptools\
                        python-distutils-extra\
                        ttf-fira-code\
                        gtkhash-caja"

build_packages="caja-admin\
                mate-menu\
                libreoffice-style-yaru-fullcolor\
                papirus-mate-icon-theme\
                rhythmbox-plugin-alternative-toolbar\
                volctl"

function remove_packages()
{
    echo -e "Removing Packages:"
    echo -e "  " $remove_packages_names
    echo -e
    for package in $remove_packages_names; do
        if [ $package == "thunderbird" ]; then
            sudo pacman -Rsndd --noconfirm $package
        else
            sudo pacman -Rsn --noconfirm $package
        fi
    done
}

function install_packages()
{
    echo -e "Installing Packages:"
    echo -e "  " $install_package_names
    echo -e
    for package in $install_package_names; do
        sudo pamac install --no-confirm $package
    done
    echo -e "Building Packages from AUR:"
    echo -e "  " $build_packages
    echo -e
    for package in $build_packages; do
        sudo pamac build --no-confirm $package
    done
}

function clone_repos()
{
    mkdir /home/$USER/src/
    cd /home/$USER/src/
    echo -e "Cloning mate-layouts started..."
    git clone https://github.com/FreaxMATE/mate-layouts.git
    echo -e "Cloning mate-layouts finished..."

    echo -e "Cloning manjaro-mate-settings started..."
    git clone https://github.com/FreaxMATE/manjaro-mate-settings.git
    echo -e "Cloning manjaro-mate-settings finished..."
}

function build_from_source()
{
    # install mate-layouts
    echo -e "Installation of mate-layouts started..."
    cd /home/$USER/src/mate-layouts
    meson build --prefix=/usr
    cd build
    sudo ninja install
    echo -e "Installation of mate-layouts finished..."
}

function default_settings()
{
    # libreoffice set yaru mate icon theme
    cd /home/$USER/src/manjaro-mate-settings
    install -Dv registrymodifications.xcu /home/$USER/.config/libreoffice/4/user/registrymodifications.xcu

    # set menu icon to default Papirus icon
    cd /home/$USER/.icons/
    mv logo-manjaro.svg logo-manjaro-legacy.svg
    cd /home/$USER/src/manjaro-mate-settings
    cp logo-manjaro.svg /home/$USER/.icons/logo-manjaro.svg

    # set new face icon
    cd /home/$USER/
    mv .face .face-legacy
    cd /home/$USER/src/manjaro-mate-settings
    cp .face /home/$USER/.face

    # install slideshow wallpaper
    cd /home/$USER/src/manjaro-mate-settings
    sudo cp mountains-mate-breakfast.jpg /usr/share/backgrounds/mountains-mate-breakfast.jpg
    sudo cp mountains-mate-morning.jpg /usr/share/backgrounds/mountains-mate-morning.jpg
    sudo cp mountains-mate-noon.jpg /usr/share/backgrounds/mountains-mate-noon.jpg
    sudo cp mountains-mate-afternoon.jpg /usr/share/backgrounds/mountains-mate-afternoon.jpg
    sudo cp mountains-mate-evening.jpg /usr/share/backgrounds/mountains-mate-evening.jpg
    sudo cp mountains-mate-night.jpg /usr/share/backgrounds/mountains-mate-night.jpg
    sudo cp mountains-mate.xml /usr/share/backgrounds/mountains-mate.xml
    gsettings set org.mate.background picture-filename /usr/share/backgrounds/mountains-mate.xml

    # start redshift automatically
    cd /home/$USER/src/manjaro-mate-settings
    cp redshift-gtk.desktop /home/$USER/.config/autostart/redshift-gtk.desktop

    # install template files
    cd /home/$USER/src/manjaro-mate-settings
    cp bash.sh /home/$USER/Templates/bash.sh
    cp c.c /home/$USER/Templates/c.c
    cp c++.cpp /home/$USER/Templates/c++.cpp
    cp header.h /home/$USER/Templates/header.h
    cp Java.java /home/$USER/Templates/Java.java
    cp python.py /home/$USER/Templates/python.py
    cp rust.rs /home/$USER/Templates/rust.rs

    # qt settings
    cd /home/$USER/src/manjaro-mate-settings
    install -Dbv qt5ct.conf /home/$USER/.config/qt5ct/qt5ct.conf
    install -Dbv kvantum.kvconfig /home/$USER/.config/Kvantum/kvantum.kvconfig

    # panel layout
    mate-layouts --layout default

    # replace mate-volume-control-status-icon with volctl
    cd /home/$USER/src/manjaro-mate-settings
    rm /home/$USER/.config/autostart/mate-volume-control-status-icon.desktop
    sudo rm /etc/xdg/autostart/mate-volume-control-status-icon.desktop
    sudo rm /usr/etc/xdg/autostart/mate-volume-control-status-icon.desktop
    cp volctl.desktop /home/$USER/.config/autostart/volctl.desktop


    # gsettings
    gsettings set org.mate.interface enable-animations false
    gsettings set org.mate.Marco.general theme "Matcha-pueril"
    gsettings set org.mate.interface gtk-theme "Matcha-pueril"
    gsettings set org.mate.interface icon-theme "Papirus-MATE"
    gsettings set org.mate.peripherals-mouse cursor-theme "xcursor-breeze"

    gsettings set org.mate.interface document-font-name "Fira Code Medium 10"
    gsettings set org.mate.interface font-name "Fira Code Medium 10"
    gsettings set org.mate.interface monospace-font-name "Fira Code Medium 10"
    gsettings set org.mate.Marco.general titlebar-font "Fira Code Bold 10"

    gsettings set org.mate.caja.desktop computer-icon-visible false
    gsettings set org.mate.caja.desktop home-icon-visible false
    gsettings set org.mate.caja.desktop trash-icon-visible false
    gsettings set org.mate.caja.desktop volumes-visible false
    gsettings set org.mate.background picture-options zoom
    gsettings set org.mate.Marco.global-keybindings run-command-terminal "<Primary><Alt>t"
    gsettings set org.mate.screensaver picture-filename "/usr/share/backgrounds/manjaro-wallpapers-18.0/wMJ_neutral_textured_warm.jpg"

    gsettings set io.github.celluloid-player.Celluloid csd-enable false

    gsettings set org.gnome.rhythmbox.plugins active-plugins "['iradio', 'mpris', 'android', 'notification', 'audiocd', 'mtpdevice', 'daap', 'mmkeys', 'dbus-media-server', 'generic-player', 'audioscrobbler', 'rb', 'alternative-toolbar', 'artsearch', 'power-manager']"
    gsettings set org.gnome.rhythmbox.plugins.alternative_toolbar display-type 2
    gsettings set org.gnome.rhythmbox.plugins.alternative_toolbar enhanced-sidebar true

    gsettings set apps.volctl:/apps/volctl/ mixer-command 'mate-volume-control'
    gsettings set apps.volctl:/apps/volctl/ osd-enabled false
    gsettings set apps.volctl:/apps/volctl/ prefer-gtksi false
    gsettings set apps.volctl:/apps/volctl/ show-percentage true

    gsettings set org.mate.control-center.keybinding:/org/mate/desktop/keybindings/custom0/ name 'Passwordsafe'
    gsettings set org.mate.control-center.keybinding:/org/mate/desktop/keybindings/custom0/ action 'gnome-passwordsafe'
    gsettings set org.mate.control-center.keybinding:/org/mate/desktop/keybindings/custom0/ binding '<Primary><Alt>s'

    cd /home/$USER/src/manjaro-mate-settings
    sudo install -Dbv slick-greeter.conf /etc/lightdm/slick-greeter.conf
    sudo install -Dbv index.theme /usr/share/icons/default/index.theme

    # bash
    cd /home/$USER/
    echo -e "export HISTCONTROL=ignoreboth:erasedups" >> /home/$USER/.bashrc
}

function install_matify()
{
    remove_packages
    install_packages
    clone_repos
    build_from_source
    default_settings
}

function usage() {
  echo -e
  echo -e "Usage"
  echo -e "  ./matify install        : install matify default settings"
  echo -e
  exit 1
}

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    usage
    exit 0
fi

if [ "$1" == "install" ]; then
    install_matify
else
    echo -e "Unknown option \"$1\""
    usage
fi
