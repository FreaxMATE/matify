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

remove_packages="pidgin hexchat matcha-gtk-theme papirus-icon-theme papirus-maia-icon-theme python-pip imagewriter thunderbird timeshift bauh lollypop steam-manjaro snapd mate-tweak vlc"

install_packages="meson gettext policykit-1 caja-python bash-completion celluloid gcc redshift git gnome-passwordsafe gnome-podcasts gnome-boxes glade libreoffice-still devhelp audacity celluloid easytag rhythmbox evolution simple-scan python-psutil python-setproctitle python-distro libnotify python-setuptools python-distutils-extra"

build_packages="rhythmbox-plugin-alternative-toolbar-git mate-menu"

echo "Removing Packages: "
echo "  " $remove_packages
echo
for package in $remove_packages; do
    sudo pacman -Rsn $package
done

echo "Installing Packages: "
echo "  " $install_packages
echo
sudo pamac install $install_packages

echo "Building Packages from AUR: "
echo "  " $build_packages
echo
sudo pamac build $build_packages

cd /home/$USER/
mkdir src && cd /home/$USER/src/
rm -rf mate-layouts
rm -rf manjaro-mate-settings
rm -rf papirus-folders
rm -rf Matcha-gtk-theme
rm -rf papirus-icon-theme
rm -rf caja-admin

# install opt software
cd /home/$USER/src/
git clone https://github.com/FreaxMATE/mate-layouts.git
git clone https://github.com/FreaxMATE/manjaro-mate-settings.git
git clone https://github.com/FreaxMATE/papirus-folders.git
git clone https://github.com/FreaxMATE/Matcha-gtk-theme.git
git clone https://github.com/FreaxMATE/papirus-icon-theme.git
git clone https://github.com/infirit/caja-admin.git
git clone https://github.com/ubuntu/libreoffice-style-yaru-fullcolor.git

# install custom manjaromate layouts
cd /home/$USER/src/manjaro-mate-settings
sudo cp default-manjaromate-tweak.layout /usr/share/mate-panel/layouts/default-manjaromate-tweak.layout

# install mate-layouts
cd /home/$USER/src/mate-layouts
sudo pip3 install .
mate-layouts --layout default-manjaromate-tweak


# set menu icon to default Papirus icon
cd /home/$USER/.icons/
mv logo-manjaro.svg logo-manjaro-legacy.svg
cd /home/$USER/src/manjaro-mate-settings
mv logo-manjaro.svg /home/$USER/.icons/

# install slideshow wallpaper
cd /home/$USER/src/manjaro-mate-settings
sudo mv mountains-mate-breakfast.jpg /usr/share/backgrounds/mountains-mate-breakfast.jpg
sudo mv mountains-mate-morning.jpg /usr/share/backgrounds/mountains-mate-morning.jpg
sudo mv mountains-mate-noon.jpg /usr/share/backgrounds/mountains-mate-noon.jpg
sudo mv mountains-mate-afternoon.jpg /usr/share/backgrounds/mountains-mate-afternoon.jpg
sudo mv mountains-mate-evening.jpg /usr/share/backgrounds/mountains-mate-evening.jpg
sudo mv mountains-mate-night.jpg /usr/share/backgrounds/mountains-mate-night.jpg
sudo mv mountains-mate.xml /usr/share/backgrounds/mountains-mate.xml
gsettings set org.mate.background picture-filename /usr/share/backgrounds/mountains-mate.xml

# start redshift automatically
cd /home/$USER/src/manjaro-mate-settings
sudo mv redshift-gtk.desktop /home/$USER/.config/autostart/redshift-gtk.desktop

# install Matcha theme
cd /home/$USER/src/Matcha-gtk-theme
git checkout green
sudo ./install.sh

# install Papirus icon theme
cd /home/$USER/src/papirus-icon-theme
sudo make install

# install papirus folders
cd /home/$USER/src/papirus-folders
sudo make install
papirus-folders -t Papirus-Dark  -C mategreen

# install template files
cd /home/$USER/src/manjaro-mate-settings
cp bash.sh /home/$USER/Templates/bash.sh
cp c.c /home/$USER/Templates/c.c
cp c++.c /home/$USER/Templates/c++.c
cp header.h /home/$USER/Templates/header.h
cp Java.java /home/$USER/Templates/Java.java
cp python.py /home/$USER/Templates/python.py
cp rust.rs /home/$USER/Templates/rust.rs

# install yaru theme for libreoffice
cd /home/$USER/src/libreoffice-style-yaru-fullcolor
sudo ./install.sh

# install caja-admin
cd /home/$USER/src/caja-admin
meson --prefix=/usr build
cd build
ninja
sudo ninja install
caja -q

# theme, animations
gsettings set org.mate.interface enable-animations false
gsettings set org.mate.interface gtk-theme Matcha-pueril
gsettings set org.mate.interface icon-theme Papirus

gsettings set org.mate.caja.desktop computer-icon-visible false
gsettings set org.mate.caja.desktop home-icon-visible false
gsettings set org.mate.caja.desktop trash-icon-visible false
gsettings set org.mate.caja.desktop volumes-visible false
gsettings set org.mate.background picture-options zoom

# bash
cd /home/$USER/
echo "export HISTCONTROL=ignoreboth:erasedups" >> cd /home/$USER/.bashrc
