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
                        matcha-gtk-theme\
                        papirus-icon-theme\
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
                        python-distutils-extra"

build_packages="mate-menu rhythmbox-plugin-alternative-toolbar"

function remove_packages()
{
    echo -e "Removing Packages:"
    echo -e "  " $remove_packages_names
    echo -e
    for package in $remove_packages_names; do
        sudo pacman -Rsn $package
    done
}

function install_packages()
{
    echo -e "Installing Packages:"
    echo -e "  " $install_package_names
    echo -e
    sudo pamac install $install_package_names

    echo -e "Building Packages from AUR:"
    echo -e "  " $build_packages
    echo -e
    sudo pamac build $build_packages
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

    echo -e "Cloning papirus-folders started..."
    git clone https://github.com/FreaxMATE/papirus-folders.git
    echo -e "Cloning papirus-folders finished..."

    echo -e "Cloning Matcha-gtk-theme started..."
    git clone https://github.com/FreaxMATE/Matcha-gtk-theme.git
    echo -e "Cloning Matcha-gtk-theme finished..."

    echo -e "Cloning papirus-icon-theme started..."
    git clone https://github.com/FreaxMATE/papirus-icon-theme.git
    echo -e "Cloning papirus-icon-theme finished..."

    echo -e "Cloning caja-admin started..."
    git clone https://github.com/infirit/caja-admin.git
    echo -e "Cloning caja-admin finished..."

    echo -e "Cloning libreoffice-style-yaru-fullcolor started..."
    git clone https://github.com/ubuntu/libreoffice-style-yaru-fullcolor.git
    echo -e "Cloning libreoffice-style-yaru-fullcolors finished..."

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

    # install Matcha-gtk-theme
    echo -e "Installation of Matcha-gtk-theme started..."
    cd /home/$USER/src/Matcha-gtk-theme
    git checkout green
    sudo ./install.sh
    echo -e "Installation of Matcha-gtk-theme finished..."

    # install papirus-icon-theme
    echo -e "Installation of papirus-icon-theme started..."
    cd /home/$USER/src/papirus-icon-theme
    git checkout mate_green
    sudo make install
    echo -e "Installation of papirus-icon-theme finished..."

    # install papirus-folders
    echo -e "Installation of papirus-folders started..."
    cd /home/$USER/src/papirus-folders
    sudo make install
    papirus-folders -t Papirus  -C mategreen
    papirus-folders -t Papirus-Dark  -C mategreen
    echo -e "Installation of papirus-folders finished..."

    # install caja-admin
    echo -e "Installation of caja-admin started..."
    cd /home/$USER/src/caja-admin
    meson --prefix=/usr build
    cd build
    ninja
    sudo ninja install
    caja -q
    echo -e "Installation of caja-admin finished..."

    # install libreoffice-yaru-icon-theme
    echo -e "Installation of libreoffice-yaru-icon-theme started..."
    cd /home/$USER/src/libreoffice-style-yaru-fullcolor/
    sudo ./install.sh
    echo -e "Installation of libreoffice-yaru-icon-theme finished..."
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
    sudo cp redshift-gtk.desktop /home/$USER/.config/autostart/redshift-gtk.desktop

    # install template files
    cd /home/$USER/src/manjaro-mate-settings
    cp bash.sh /home/$USER/Templates/bash.sh
    cp c.c /home/$USER/Templates/c.c
    cp c++.cpp /home/$USER/Templates/c++.cpp
    cp header.h /home/$USER/Templates/header.h
    cp Java.java /home/$USER/Templates/Java.java
    cp python.py /home/$USER/Templates/python.py
    cp rust.rs /home/$USER/Templates/rust.rs

    # gsettings
    gsettings set org.mate.interface enable-animations false
    gsettings set org.mate.Marco.general theme "Matcha-dark-pueril"
    gsettings set org.mate.interface gtk-theme "Matcha-dark-pueril"
    gsettings set org.mate.interface icon-theme "Papirus-Dark"
    gsettings set org.mate.peripherals-mouse "xcursor-breeze-snow"

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

    cd /home/$USER/src/manjaro-mate-settings
    sudo install -Dbv slick-greeter.conf /etc/lightdm/slick-greeter.conf
    sudo install -Dbv index.theme /usr/share/icons/default/index.theme

    # bash
    cd /home/$USER/
    echo -e "export HISTCONTROL=ignoreboth:erasedups" >> /home/$USER/.bashrc
}

function remove()
{
    cd /home/$USER/
    mkdir src
    cd /home/$USER/src/
    rm -rf mate-layouts/
    rm -rf manjaro-mate-settings/
    rm -rf papirus-folders/
    rm -rf Matcha-gtk-theme/
    rm -rf papirus-icon-theme/
    rm -rf caja-admin/
    rm -rf libreoffice-style-yaru-fullcolor/

    clone_repos

    # uninstall mate-layouts
    cd /home/$USER/src/mate-layouts
    meson build --prefix=/usr
    cd build
    sudo ninja install
    sudo ninja uninstall

    # uninstall Matcha theme
    cd /home/$USER/src/Matcha-gtk-theme
    git checkout green
    sudo rm -rf /usr/share/themes/Matcha-*

    # uninstall Papirus icon theme
    cd /home/$USER/src/papirus-icon-theme
    git checkout mate_green
    sudo make install
    sudo make uninstall

    # uninstall papirus folders
    cd /home/$USER/src/papirus-folders
    sudo make install
    sudo make uninstall

    # uninstall caja-admin
    cd /home/$USER/src/caja-admin
    meson --prefix=/usr build
    cd build
    ninja
    sudo ninja install
    sudo ninja uninstall
    caja -q

    # install libreoffice yaru icon theme
    cd /home/$USER/src/libreoffice-style-yaru-fullcolor/
    sudo ./remove.sh

    # manual #
    # libreoffice set yaru mate icon theme
    sed -i "s/yaru_mate/auto/" /home/$USER/.config/libreoffice/4/user/registrymodifications.xcu

    # set menu icon to default Papirus icon
    cd /home/$USER/.icons/
    mv logo-manjaro-legacy.svg logo-manjaro-buffer.svg
    mv logo-manjaro.svg logo-manjaro-legacy.svg
    mv logo-manjaro-buffer.svg logo-manjaro.svg

    # set new face icon
    cd /home/$USER/
    mv .face-legacy .face-buffer
    mv .face .face-legacy
    mv .face-buffer .face

    # uninstall slideshow wallpaper
    sudo rm /usr/share/backgrounds/mountains-mate-breakfast.jpg
    sudo rm /usr/share/backgrounds/mountains-mate-morning.jpg
    sudo rm /usr/share/backgrounds/mountains-mate-noon.jpg
    sudo rm /usr/share/backgrounds/mountains-mate-afternoon.jpg
    sudo rm /usr/share/backgrounds/mountains-mate-evening.jpg
    sudo rm /usr/share/backgrounds/mountains-mate-night.jpg
    sudo rm /usr/share/backgrounds/mountains-mate.xml

    # do not start redshift automatically
    rm /home/$USER/.config/autostart/redshift-gtk.desktop
 
    # uninstall template files
    rm /home/$USER/Templates/bash.sh
    rm /home/$USER/Templates/c.c
    rm /home/$USER/Templates/c++.cpp
    rm /home/$USER/Templates/header.h
    rm /home/$USER/Templates/Java.java
    rm /home/$USER/Templates/python.py
    rm /home/$USER/Templates/rust.rs

    # gsettings
    gsettings reset org.mate.interface enable-animations
    gsettings reset org.mate.interface gtk-theme
    gsettings reset org.mate.interface icon-theme

    gsettings reset org.mate.caja.desktop computer-icon-visible
    gsettings reset org.mate.caja.desktop home-icon-visible
    gsettings reset org.mate.caja.desktop trash-icon-visible
    gsettings reset org.mate.caja.desktop volumes-visible
    gsettings reset org.mate.background picture-options
    gsettings reset org.mate.Marco.global-keybindings run-command-terminal

    mate-layouts --layout default
}

function install()
{
    install_packages
    clone_repos
    build_from_source
    default_settings
}

function usage() {
  echo -e
  echo -e "Usage"
  echo -e "  ./matify install        : install matify default settings"
  echo -e "  ./matify remove         : revert to default settings"
  echo -e
  exit 1
}

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
    usage
    exit 0
fi

if [ "$1" == "install" ]; then
    install
elif [ "$1" == "remove" ]; then
    remove
else
    echo -e "Unknown option \"$1\""
    usage
fi
