#!/bin/sh
disk=$1
if [ -z $1 ]; then echo "Missing Disk Parameter (\$1)"; exit 1; fi
# Ask for Confirmation
echo "Format Disk $disk ?"
read -p "Continue (y/N)?" -n 1 confirm; printf "\n"
if [[ -z "$confirm" || "$confirm" =~ [^Yy] ]]; then echo "Cancelled"; exit 1; fi;
echo "Unmounting /mnt"
umount -Rf /mnt
echo "Clearing Disk $disk"
sgdisk --clear $disk
echo "Making EFI Partition"
sgdisk --new 1:0:+512M --typecode=1:ef00 $disk
echo "Making Data Partition"
sgdisk --new 2:0:0 $disk
echo "Calling File System Creation Script"
./FilesystemSetup.sh ${disk}1 ${disk}2