#!/bin/bash
loadkeys ru
setfont cyr-sun16
echo 'На какое утройство устанавливать (например sda)?'
read disk
(
  echo g;
  echo w;
) | fdisk /dev/$disk
(
  echo n;
  echo;
  echo;
  echo +500M;
  echo y;
  echo n;
  echo;
  echo;
  echo +40G;
  echo y;
  echo n;
  echo;
  echo;
  echo;
  echo y;
  echo t;
  echo 1;
  echo w;
) | fdisk /dev/$disk
volume1="${disk}1"
volume2="${disk}2"
volume3="${disk}3"
echo y | mkfs.fat -F32 /dev/$volume1
echo y | mkfs.ext4  /dev/$volume2
echo y | mkfs.ext4  /dev/$volume3
mount /dev/$volume2 /mnt
mkdir /mnt/home
mkdir -p /mnt/boot/efi
mount /dev/$volume1 /mnt/boot/efi
mount /dev/$volume3 /mnt/home
fdisk -l
timedatectl set-ntp true
pacman -Sy  && pacman -S reflector --noconfirm
reflector --verbose -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware nano netctl dhcpcd
genfstab -pU /mnt >> /mnt/etc/fstab
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/kronsky/archlinux/main/install-part-two.sh)"
