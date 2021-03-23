#!/bin/bash

# Written by Chris Cohen
# 10-9-20

# Based off of
# https://github.com/imthenachoman/How-To-Secure-A-Linux-Server/blob/master/README.md

# ==============================
# ========== NOT DONE ==========
# ==============================

# THE SSH SERVER
# Create SSH Group For AllowGroups
# Secure /etc/ssh/sshd_config

# THE BASICS
# Limit Who Can Use sudo

# THE NETWORK
# iptables Intrusion Detection And Prevention with PSAD

# THE AUDITING
# File/Folder Integrity Monitoring With AIDE
# Rootkit Detection With Rkhunter
# logwatch - system log analyzer and reporter

# Everything in THE MISCELLANEOUS







# ============================================
# ===== Remove short Diffie-Hellman Keys =====
# ============================================
echo "Removing Diffie-Hellman keys under 3072 bits..."
# Make a backup of SSH's moduli file /etc/ssh/moduli
sudo cp --archive /etc/ssh/moduli /etc/ssh/moduli-COPY-$(date +"%Y%m%d%H%M%S")
# Remove any Diffie-Hellman keys under 3072 bits long
sudo awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli.tmp
sudo mv /etc/ssh/moduli.tmp /etc/ssh/moduli


# ============================================
# ========= 2-Factor Authentication =========
# ============================================
echo "Installing 2FA for all users using google-authenticator..."
sudo apt install libpam-google-authenticator
google-authenticator

# Make a backup of PAM's SSH configuration file /etc/pam.d/sshd
sudo cp --archive /etc/pam.d/sshd /etc/pam.d/sshd-COPY-$(date +"%Y%m%d%H%M%S")

# Change files to make SSH require 2FA to log in
echo -e "\nauth       required     pam_google_authenticator.so          # added by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")" | sudo tee -a /etc/pam.d/sshd
sudo sed -i -r -e "s/^(challengeresponseauthentication .*)$/# \1         # commented by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")/I" /etc/ssh/sshd_config
echo -e "\nChallengeResponseAuthentication yes         # added by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")" | sudo tee -a /etc/ssh/sshd_config
echo -e "\nAuthenticationMethods publickey,password publickey,keyboard-interactive        # added by $(whoami) on $data + "%Y-%m-%d @ %H:%M:%S")" | sudo tee -a /etc/ssh/sshd_config
sudo sed -i "s/^#@include common-auth$/@include common-auth/" /etc/pam.d/sshd
sudo systemctl restart sshd.service


# ============================================
# ========= Use NTP for system time ==========
# ============================================
echo "Syncing system time with NTP..."
sudo apt install ntp
# Make a backup of the NTP client's configuration file /etc/ntp.conf
sudo cp --archive /etc/ntp.conf /etc/ntp.conf-COPY-$(date +"%Y%m%d%H%M%S")

sudo sed -i -r -e "s/^((server|pool).*)/# \1         # commented by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")/" /etc/ntp.conf
echo -e "\npool pool.ntp.org iburst         # added by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")" | sudo tee -a /etc/ntp.conf
sudo service ntp restart


# ============================================
# ============= Securing /proc ==============
# ============================================
echo "Making PIDs in /proc unreadable..."
sudo cp --archive /etc/fstab /etc/fstab-COPY-$(date +"%Y%m%d%H%M%S")
echo -e "\nproc     /proc     proc     defaults,hidepid=2     0     0         # added by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")" | sudo tee -a /etc/fstab


# ============================================
# ======== Enforce secure passwords ==========
# ============================================
echo "Setting up secure password enforcement..."
sudo apt install libpam-pwquality
# Make a backup of PAM's password configuration file /etc/pam.d/common-password
sudo cp --archive /etc/pam.d/common-password /etc/pam.d/common-password-COPY-$(date +"%Y%m%d%H%M%S")
# Tell PAM to use libpam-pwquality
sudo sed -i -r -e "s/^(password\s+requisite\s+pam_pwquality.so)(.*)$/# \1\2         # commented by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")\n\1 retry=3 minlen=10 difok=3 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1 maxrepeat=3 gecoschec         # added by $(whoami) on $(date +"%Y-%m-%d @ %H:%M:%S")/" /etc/pam.d/common-password

# ============================================
# === Automatic Security Updates and Alerts ==
# ============================================
echo "Setting up automatic security updates and alerts..."
sudo apt install unattended-upgrades apt-listchanges apticron
sudo touch /etc/apt/apt.conf.d/51myunattended-upgrades

cat << EOF | sudo tee /etc/apt/apt.conf.d/51myunattended-upgrades
// Enable the update/upgrade script (0=disable)
APT::Periodic::Enable "1";

// Do "apt-get update" automatically every n-days (0=disable)
APT::Periodic::Update-Package-Lists "1";

// Do "apt-get upgrade --download-only" every n-days (0=disable)
APT::Periodic::Download-Upgradeable-Packages "1";

// Do "apt-get autoclean" every n-days (0=disable)
APT::Periodic::AutocleanInterval "7";

// Send report mail to root
//     0:  no report             (or null string)
//     1:  progress report       (actually any string)
//     2:  + command outputs     (remove -qq, remove 2>/dev/null, add -d)
//     3:  + trace on    APT::Periodic::Verbose "2";
APT::Periodic::Unattended-Upgrade "1";

// Automatically upgrade packages from these
Unattended-Upgrade::Origins-Pattern {
      "o=Debian,a=stable";
      "o=Debian,a=stable-updates";
      "origin=Debian,codename=${distro_codename},label=Debian-Security";
};

// You can specify your own packages to NOT automatically upgrade here
Unattended-Upgrade::Package-Blacklist {
};

// Run dpkg --force-confold --configure -a if a unclean dpkg state is detected to true to ensure that updates get installed even when the system got interrupted during a previous run
Unattended-Upgrade::AutoFixInterruptedDpkg "true";

//Perform the upgrade when the machine is running because we wont be shutting our server down often
Unattended-Upgrade::InstallOnShutdown "false";

// Send an email to this address with information about the packages upgraded.
Unattended-Upgrade::Mail "root";

// Always send an e-mail
Unattended-Upgrade::MailOnlyOnError "false";

// Remove all unused dependencies after the upgrade has finished
Unattended-Upgrade::Remove-Unused-Dependencies "true";

// Remove any new unused dependencies after the upgrade has finished
Unattended-Upgrade::Remove-New-Unused-Dependencies "true";

// Automatically reboot WITHOUT CONFIRMATION if the file /var/run/reboot-required is found after the upgrade.
Unattended-Upgrade::Automatic-Reboot "true";

// Automatically reboot even if users are logged in.
Unattended-Upgrade::Automatic-Reboot-WithUsers "true";'
EOF


# ============================================
# =================== UFW ====================
# ============================================
echo "Setting up UFW for a firewall..."

sudo apt install ufw
sudo ufw default allow outgoing comment 'allow all outgoing traffic'
sudo ufw default deny incoming comment 'deny all incoming traffic'
sudo ufw limit in ssh comment 'allow SSH connections in'
# allow traffic out on port 53 -- DNS
sudo ufw allow out 53 comment 'allow DNS calls out'

# allow traffic out on port 123 -- NTP
sudo ufw allow out 123 comment 'allow NTP out'

# allow traffic out for HTTP, HTTPS, or FTP
# apt might needs these depending on which sources you're using
sudo ufw allow out http comment 'allow HTTP traffic out'
sudo ufw allow out https comment 'allow HTTPS traffic out'
sudo ufw allow out ftp comment 'allow FTP traffic out'

# allow whois
sudo ufw allow out whois comment 'allow whois'

# allow traffic out on port 68 -- the DHCP client
# you only need this if you're using DHCP
sudo ufw allow out 68 comment 'allow the DHCP client to update'

# Plex
cat << EOF | sudo tee /etc/ufw/applications.d/plexmediaserver
[PlexMediaServer]
title=Plex Media Server
description=This opens up PlexMediaServer for http (32400), upnp, and autodiscovery.
ports=32469/tcp|32413/udp|1900/udp|32400/tcp|32412/udp|32410/udp|32414/udp|32400/udp
EOF
sudo ufw allow plexmediaserver

# Sonarr
cat << EOF | sudo tee /etc/ufw/applications.d/sonarr
[sonarr]
title=Sonarr
description=Sonarr is a PVR for Usenet and BitTorrent users
ports=8989/tcp|8989/udp
EOF
sudo ufw allow sonarr

# Radarr
cat << EOF | sudo tee /etc/ufw/applications.d/radarr
[radarr]
title=Radarr
description=Radarr is an independent fork of Sonarr reworked for automatically downloading movies via Usenet and BitTorrent.
ports=7878/tcp|7878/udp
EOF
sudo ufw allow radarr

# Lidarr
cat << EOF | sudo tee /etc/ufw/applications.d/lidarr
[lidarr]
title=Lidarr
description=Lidarr is an independent fork of Sonarr reworked for automatically downloading music via Usenet and BitTorrent.
ports=8686/tcp|8686/udp
EOF
sudo ufw allow lidarr

# Transmission-GTK
cat << EOF | sudo tee /etc/ufw/applications.d/transmission-gtk
[transmission-daemon]
title=Transmission
description=Transmission is a torrenting client with a web interface
ports=9091/tcp|9091/udp
EOF
sudo ufw allow transmission-daemon


sudo ufw enable


# ============================================
# ================= FAIL2BAN =================
# ============================================A
echo "Installing fail2ban to automatically ban suspicious IPs.."
sudo apt install fail2ban

# Create a jail that tells fail2ban to look at SSH logs and use ufw to ban/unban IPs
cat << EOF | sudo tee /etc/fail2ban/jail.d/ssh.local
[sshd]
enabled = true
banaction = ufw
port = ssh
filter = sshd
logpath = %(sshd_log)s
maxretry = 5
EOF

sudo fail2ban-client start
sudo fail2ban-client reload
sudo fail2ban-client add sshd


# ============================================
# ================== ClamAV ==================
# ============================================
echo "Installing ClamAV antivirus..."
sudo apt install clamav clamav-freshclam clamav-daemon

# Make a backup of config file /etc/clamav/freshclam.conf
sudo cp --archive /etc/clamav/freshclam.conf /etc/clamav/freshclam.conf-COPY-$(date +"%Y%m%d%H%M%S")

sudo service clamav-freshclam start

# make backup of daemon config file /etc/clamav/clamd.conf
sudo cp --archive /etc/clamav/clamd.conf /etc/clamav/clamd.conf-COPY-$(date +"%Y%m%d%H%M%S")


# ============================================
# =================== MISC ===================
# ============================================
# More secure random entropy pool
echo "Making the random entropy pool more secure..."
sudo apt-get install rng-tools

# chrootkit - Rootkit detection
echo "Installing chrootkit for rootkit detection..."
sudo apt install chkrootkit
sudo cp --archive /etc/chkrootkit.conf /etc/chkrootkit.conf-COPY-$(date +"%Y%m%d%H%M%S")
sudo dpkg-reconfigure chkrootkit

# lynis - linux security auditing
echo "Installing lynis for security auditing..."
sudo apt install apt-transport-https ca-certificates host
sudo wget -O - https://packages.cisofy.com/keys/cisofy-software-public.key | sudo apt-key add -
sudo echo "deb https://packages.cisofy.com/community/lynis/deb/ stable main" | sudo tee /etc/apt/sources.list.d/cisofy-lynis.list
sudo apt update
sudo apt install lynis host
sudo lynis update info
sudo lynis audit system


# ============================================
# ============================================


echo "           AVAILABLE PROGRAMS"
echo "           ------------------"
echo "clamscan                    --    Virus scanner"
echo "ufw                         --    Uncomplicated firewall"
echo "fail2ban                    --    Application intrusion detection"
echo "sudo chrootkit              --    Rootkit detection"
echo "sudo ss -lntup              --    Port usage"
echo "sudo lynis audit system     --    linux security audit"


read -p "It is strongly recommended to reboot. Would you like to reboot now? (y/N) "
if [[ $REPLY = "y" ]];
then
  reboot
else
  echo "Not rebooting..."
fi
