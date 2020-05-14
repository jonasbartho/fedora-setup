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

# Google Chrome repo
#sudo dnf install fedora-workstation-repositories -y
####################################################


# Download and cache metadata for all known repos
sudo dnf makecache

# Download necessary dependency scripts for the setup script
wget https://raw.githubusercontent.com/jonasbartho/fedora-setup/master/fedora.packages.sh
wget https://raw.githubusercontent.com/jonasbartho/fedora-setup/master/bashrc.aliases

# Install TeamViewer
sudo dnf install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -y

# grep necessary packages to install
sudo dnf install $(grep "^[^#]" ~/fedora.packages) -y

# Flatpak apps:
sudo dnf install flatpak -y
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.spotify.Client
flatpak install -y flathub io.github.celluloid_player.Celluloid
flatpak install -y flathub com.visualstudio.code
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub org.pulseaudio.pavucontrol

# Remove auto-hide functionality that automatically  is enabled on new Fedora Workstation installs. This can be disabled by running:
sudo grub2-editenv - unset menu_auto_hide

# blacklist annoying beep sound when locking the screen with i3lock-fancy.
# This has the effect of disabling the system bell entirely, which in 99.99% of cases is unwanted, surprising, embarrassing, humiliating, or even painful. 
echo "blacklist pcspkr" | sudo tee -a /etc/modprobe.d/blacklist.conf

#Custom shell prompt with aliases Source: https://www.linuxquestions.org/questions/linux-general-1/ultimate-prompt-and-bashrc-file-4175518169/
cat ~/bashrc.aliases >> ~/.bashrc

# Compile i3lock-fancy(Awesome WM dependency to lock screen)
mkdir build;cd build/
git clone https://github.com/meskarune/i3lock-fancy.git
cd i3lock-fancy/
sudo make install
