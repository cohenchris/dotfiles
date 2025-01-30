#!/bin/bash

# Arch Linux should be set up in this order:
# 1. Boot into live USB
# 2. Partition target disk
# 3. Create filesystems on target disk
# 4. Pacstrap target disk
# 5. Chroot into target disk
# 6. ----- Run this script -----
# 7. YADM dotfiles restore + bootstrap

if [[ "$(id -u)" -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Root user password
echo "First, we need to set a password for the root user."
passwd

# Personal user username/password
echo
echo "Now, we will set up your personal user."
read -p "Username: " USERNAME
useradd -mg wheel "${USERNAME}"
passwd ${USERNAME}
echo

# Set hostname
echo
read -p "Machine hostname: " HOSTNAME
echo ${HOSTNAME} > /etc/hostname

# Give sudo access to all members of the wheel group
echo "Giving sudo access to all members of the wheel group..."
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Enable NTP
echo "Enabling NTP..."
timedatectl set-ntp true

# Set language and time zone
echo
echo "Setting language and time zone..."
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime

# Configure local machine addresses
echo
echo "Configuring local machine addresses..."
echo -e "127.0.0.1 localhost\n::1 localhost\n127.0.1.1 arch.localdomain arch" > /etc/hosts

# Install core basic packages
echo
echo "Installing core basic packages..."
pacman -Syu --noconfirm \
  efibootmgr \
  networkmanager \
  network-manager-applet \
  wireless_tools \
  wpa_supplicant \
  dialog \
  os-prober \
  mtools \
  dosfstools \
  linux-lts-headers \
  git \
  bluez \
  bluez-utils \
  pulseaudio-bluetooth \
  xdg-utils \
  xdg-user-dirs \
  grub

# Enable internet
echo
echo "Enabling NetworkManager..."
systemctl enable NetworkManager

# Enable bluetooth
echo
echo "Enabling bluetooth..."
systemctl enable bluetooth

# Install GRUB
echo
echo "Installing GRUB bootloader..."
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Install paru AUR helper
echo
echo "Installing paru AUR helper..."
cd /home/${USERNAME}
sudo -u ${USERNAME} git clone https://aur.archlinux.org/paru.git
cd paru
sudo -u ${USERNAME} makepkg -si
cd ../
rm -rf paru/
cd

# ZFS
echo
echo "Installing and enabling ZFS utilities and services..."
paru -Syu zfs-dkms
sudo modprobe zfs
sudo systemctl enable zfs.target \
                      zfs-import.target \
                      zfs-volumes.target \
                      zfs-import-scan.service \
                      zfs-volume-wait.service \

# YADM
echo
echo "Installing YADM dotfiles manager..."
paru -Syu --noconfirm yadm

echo
echo "Setup complete!"
echo "If all has gone well, please reboot and remove the installation media."
echo "After reboot, system is ready for YADM dotfiles sync + bootstrapping script."
