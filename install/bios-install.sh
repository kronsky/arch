#!/bin/bash
loadkeys ru
setfont cyr-sun16
read -p "На какое утройство устанавливать систему? /dev/" disk
read -p "Какого размера будет root раздел? (в гигабайтах): " root
read disk
(
  echo o;
  echo w;
) | fdisk /dev/$disk
(
  echo n;
  echo;
  echo;
  echo;
  echo +100M;
  echo n;
  echo;
  echo;
  echo;
  echo "+"$root"G;"
  echo n;
  echo p;
  echo;
  echo;
  echo;
  echo a;
  echo 1;
  echo w;
) | fdisk /dev/$disk
volume1="${disk}1"
volume2="${disk}2"
volume3="${disk}3"
echo y | mkfs.ext2  /dev/$volume1 -L boot
echo y | mkfs.ext4  /dev/$volume2 -L root
echo y | mkfs.ext4  /dev/$volume3 -L home
mount /dev/$volume2 /mnt
mkdir /mnt/{boot,home}
mount /dev/$volume1 /mnt/boot
mount /dev/$volume3 /mnt/home
fdisk -l
timedatectl set-ntp true
pacman -Sy  && pacman -S reflector --noconfirm
reflector --verbose -l 5 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware nano netctl dhcpcd
genfstab -pU /mnt >> /mnt/etc/fstab
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/kronsky/arch/main/install/install-part-two.sh)"
