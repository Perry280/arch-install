#!/bin/bash

set -eu

echo "Partitioning disk"

DISK=""
EFI=""
SWAP=""
ROOT=""
if [ -b "/dev/sda" ]; then
    DISK="/dev/sda"
    EFI="${DISK}1"
    SWAP="${DISK}2"
    ROOT="${DISK}3"
elif [ -b "/dev/nvme0n1" ]; then
    DISK="/dev/nvme0n1"
    EFI="${DISK}p1"
    SWAP="${DISK}p2"
    ROOT="${DISK}p3"
else
    echo "Disk not found."
    echo "Exiting..."
    exit 1
fi

echo "Disk $DISK found"

pacman -S --noconfirm --needed gdisk

echo "Deleting all existing partitions"
sgdisk --zap-all "$DISK"
echo "Creating GPT"
sgdisk --clear "$DISK"

echo "Creating EFI partition"
# EFI partition
# ef00 EFI system partition
EFI_START=2048
EFI_SIZE="+1G"
sgdisk --new=1:"$EFI_START":"$EFI_SIZE" --typecode=1:ef00 --change-name=1:"EFI" "$DISK"

echo "Creating swap partition"
# Swap partition
# 8200 Linux swap
SWAP_START=$(sgdisk --first-aligned-in-largest "$DISK")
SWAP_SIZE="+4G"
sgdisk --new=2:"$SWAP_START":"$SWAP_SIZE" --typecode=2:8200 --change-name=2:"Swap" "$DISK"

echo "Creating root partition"
# Root partition
# 8304 Linux x86-64 root (/)
ROOT_START=$(sgdisk --first-aligned-in-largest "$DISK")
ROOT_SIZE="0"
sgdisk --new=3:"$ROOT_START":"$ROOT_SIZE" --typecode=3:8304 --change-name=3:"Root" "$DISK"

sgdisk -p "$DISK"

echo "Formatting partitions"
mksf.fat -F 32 "$EFI"
mkswap "$SWAP"
mkfs.ext4 "$ROOT"

echo "Mounting partitions"
mount "$ROOT" /mnt
mkdir /mnt/efi
mount -o uid=0,gid=0,fmask=0077,dmask=0077 "$EFI" /mnt/efi
swapon "$SWAP"
