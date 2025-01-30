# https://www.youtube.com/watch?v=CcSjnqreUcQ

######################
# PRELIMINARY CHECKS #
######################
# User must run as root
if [[ "$(id -u)" -ne 0 ]]; then
    echo "This script must be run as root" 
    exit 1
fi

# User must be in UEFI mode - this will be empty if not
if [ -z "$(ls /sys/firmware/efi)" ]; then
  echo "ERROR: The system is not booted in UEFI mode, cannot continue."
  exit
fi


##############################
# QUERY USER FOR DRIVE NAMES #
##############################
# List devices
fdisk -l

echo
echo "########################################"
echo "#           ***WARNING***              #"
echo "#  THIS SCRIPT WILL CREATE A ZFS ROOT  #"
echo "#  ROOT POOL ON THE SPECIFIED DEVICE.  #"
echo "#    MAKE ABSOLUTELY SURE THAT THE     #"
echo "#  DEVICE NAME IS CORRECT OR YOU RISK  #"
echo "#       CATASTROPHIC DATA LOSS.        #"
echo "########################################"

# Ask for ZFS root pool device name #1
echo
read -p "Enter targeted ZFS root pool device name #1 (in the format /dev/sdX): " ZFS_ROOT1_DEV_NAME

# Ask for ZFS root pool device name #2
echo
read -p "Enter targeted ZFS root pool device name #2 (in the format /dev/sdX): " ZFS_ROOT2_DEV_NAME

# Confirm choices
echo
fdisk -l ${ZFS_ROOT1_DEV_NAME}
echo
fdisk -l ${ZFS_ROOT2_DEV_NAME}
echo

read -p "Are these devices correct? (y/N) " yn

case $yn in
  [Yy]* ) ;;
  *     ) exit;;
esac


# TODO: find corresponding by-id for each device


################
# PARTITIONING #
################
# Destroy all existing partitions
sgdisk --zap-all ${ZFS_ROOT1_DEV_NAME}
sgdisk --zap-all ${ZFS_ROOT2_DEV_NAME}

# Create boot partitions
sgdisk -n1:0:+4G -t1:ef00 ${ZFS_ROOT1_DEV_NAME}
sgdisk -n1:0:+4G -t1:ef00 ${ZFS_ROOT2_DEV_NAME}

# Create ZFS partitions
sgdisk -n2:0:0 -t2:bf00 ${ZFS_ROOT1_DEV_NAME}
sgdisk -n2:0:0 -t2:bf00 ${ZFS_ROOT2_DEV_NAME}

# Create boot filesystem for both drives
mkfs.fat -F32 "${ZFS_ROOT1_DEV_NAME}"1
mkfs.fat -F32 "${ZFS_ROOT2_DEV_NAME}"1


##########################
# ZFS ROOT POOL CREATION #
##########################
# Enable ZFS kernel modules
modprobe zfs

# ZFS root
zpool create -f \
             -o ashift=12 \
             -O xattr=sa \
             -O compression=lz4 \
             -O atime=off
             -O canmount=off \
             -O acltype=posixacl\
             -O dnodesize=auto \
             -O normalizationn=formD \
             -O devices=off \
             -O mountpoint=none \
             -R /mnt \
             zroot "${ZFS_ROOT1_DEV_NAME}"2



# Create various datasets for root pool #1
zfs create -o mountpoint=none canmount=off zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default
zfs create -o mountpoint=none zroot/DATA
zfs create -o mountpoint=/home zroot/DATA/home
zfs create -o mountpoint=/root zroot/DATA/home/root

zfs create -o mountpoint=/var -o canmount=off zroot/DATA/var
zfs create zroot/var/log

zfs create -o mountpoint=/var/lib -o canmount=off zroot/var/lib

# Unmount all
zfs umount -a
rm -rf /mnt/*

# Export pool and re-import to /mnt
zpool export zroot
zpool import -d "${ZFS_ROOT1_DEV_NAME}"2 -R /mnt zroot -N

# Mount root, then other datasets
zfs mount zroot/ROOT/default
zfs mount -a


mkdir -p /mnt/{etc/zfs,boot/efi}
mount /dev/sda1 /mnt/boot/efi



#


# 
zpool set bootfs=zroot/ROOT/default zroot

# Install base tools + linux kernel + vim
pacstrap /mnt base base-devel linux-lts linux-firmware intel-ucode vim

# FSTAB
genfstab -U -p /mnt >> /mnt/etc/fstab
# Delete all lines that begin with zroot (ZFS handles these) or are empty
sed -i '/zroot/d;/^$/d' /mnt/etc/fstab


# Go into your new Arch partition
arch-chroot /mnt
