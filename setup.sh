#!/usr/bin/bash

## Setup script fedora for laptop

cd ~

### Setup repositories: ###
####################################################
# Brave browser
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

# Rpmfusion repo(Third-party software)
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Terraform baby!
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

# Google Chrome repo
sudo dnf install fedora-workstation-repositories -y
sudo dnf config-manager --set-enabled google-chrome
####################################################


# Download and cache metadata for all known repos
sudo dnf makecache

#VirtualBox setup for fedora32: https://tecadmin.net/install-oracle-virtualbox-on-fedora/
#Secure boot can be disabled if you don't wont to sign..

# Download necessary dependency scripts for the setup script(downloads only the file if github has a newer version)
wget -N https://raw.githubusercontent.com/jonasbartho/fedora-setup/master/fedora.packages.sh
wget -N https://raw.githubusercontent.com/jonasbartho/fedora-setup/master/bashrc.aliases

# Download checkinstall for fedora - use this instead of "make install" whenever possible - it will create a rpm file that you can uninstall using your favorite package manager
# Dependencies of checkinstall are "make","rpm-build","gcc" and "rpmdevtools"
# Usage: cd compilefolder;sudo make;sudo checkinstall --install=no
#wget - N https://raw.githubusercontent.com/rpmsphere/x86_64/master/c/checkinstall-1.6.2-1.x86_64.rpm
# sudo dnf install ./checkinstall-1.6.2-1.x86_64.rpm -y
# rpmdev-setuptree #create rpmbuild tree under home

# Install TeamViewer
#sudo dnf install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -y

# grep necessary packages to install
sudo dnf install $(grep "^[^#]" ~/fedora.packages.sh) -y

# Flatpak apps:
sudo dnf install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.spotify.Client
flatpak install -y flathub io.github.celluloid_player.Celluloid
flatpak install -y flathub com.visualstudio.code
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub org.pulseaudio.pavucontrol
#flatpak install -y flathub com.jetbrains.PyCharm-Community

#flatpak install flathub org.godotengine.Godot
#flatpak install flathub org.blender.Blender
#flatpak install flathub org.kde.krita

# Remove auto-hide functionality that automatically  is enabled on new Fedora Workstation installs. This can be disabled by running:
sudo grub2-editenv - unset menu_auto_hide

# blacklist annoying beep sound when locking the screen with i3lock-fancy.
# This has the effect of disabling the system bell entirely, which in 99.99% of cases is unwanted, surprising, embarrassing, humiliating, or even painful. 
echo "blacklist pcspkr" | sudo tee -a /etc/modprobe.d/blacklist.conf

# Custom shell prompt with aliases Source: https://www.linuxquestions.org/questions/linux-general-1/ultimate-prompt-and-bashrc-file-4175518169/
cat ~/bashrc.aliases >> ~/.bashrc

# Enable numbering in all files
echo "set number" >> ~/.exrc

# Compile i3lock-fancy(Awesome WM dependency to lock screen)
mkdir build;cd build/
git clone https://github.com/meskarune/i3lock-fancy.git
cd i3lock-fancy/
sudo make install

# update the system!
sudo dnf upgrade -y
