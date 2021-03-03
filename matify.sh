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

remove_packages="python-pip imagewriter thunderbird timeshift bauh lollypop steam-manjaro snapd mate-tweak"

install_packages="gcc redshift git gnome-passwordsafe gnome-podcasts gnome-boxes glade libreoffice-still devhelp audacity celluloid easytag tuxguitar rhythmbox evolution simple-scan"

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

cd /home/$USER/
mkdir src
cd /home/$USER/src
# install opt software

git clone https://github.com/FreaxMATE/mate-layouts
cd mate-layouts
sudo pip3 install .
mate-layouts --layout default

cd /home/$USER/.icons/
mv logo-manjaro.svg logo-manjaro-legacy.svg
cd /home/$USER/src
git clone https://github.com/FreaxMATE/manjaro-mate-settings
cd manjaro-mate-settings
mv logo-manjaro.svg /home/$USER/.icons/

sudo mv mountains-mate-breakfast.jpg /usr/share/backgrounds/mountains-mate-breakfast.jpg
sudo mv mountains-mate-morning.jpg /usr/share/backgrounds/mountains-mate-morning.jpg
sudo mv mountains-mate-noon.jpg /usr/share/backgrounds/mountains-mate-noon.jpg
sudo mv mountains-mate-afternoon.jpg /usr/share/backgrounds/mountains-mate-afternoon.jpg
sudo mv mountains-mate-evening.jpg /usr/share/backgrounds/mountains-mate-evening.jpg
sudo mv mountains-mate-night.jpg /usr/share/backgrounds/mountains-mate-night.jpg
sudo mv mountains-mate.xml /usr/share/backgrounds/mountains-mate.xml
gsettings set org.mate.background picture-filename /usr/share/backgrounds/mountains-mate.xml


sudo mv redshift-gtk.desktop /home/$USER/.config/autostart/redshift-gtk.desktop

gsettings set org.mate.interface enable-animations false

