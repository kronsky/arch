#!/bin/bash
loadkeys ru
setfont cyr-sun16
echo "Загрузчик bios или efi?"
read -p "1 - bios, 2 - uefi -->> " loader
fdisk -l
read -p "На какое утройство устанавливать систему? /dev/" disk
disktype=; for n in $disk; do disktype+=${n::2}; done
read -p "Имя компьютера: " hostname
read -p "Имя пользователя: " username
read -p "Пароль root: " rootpass
read -p "Пароль пользователя "$username": " userpass
echo "Будем ставить окружение и графические драйвера?"
read -p "1 - Да, 0 - Нет, я хочу чистый арч -->> " depo
if [[ $depo == 1 ]]; then
  echo "Какое окружение будем ставить?"
  read -p "1 - Gnome, 2 - KDE  -->> " de
  echo "Какой графический драйвер ставить?"
  read -p "0 - Вируталка, 1 - Intel, 2 - Nvidia свободный, 3 - Nvidia проприетарный, 4 - AMD новые gpu, 5 - AMD старые gpu: -->> " video
elif [[ $depo == 0 ]]; then
  de = 0
  video = 0
fi
echo "#####################################################################################"

function fuefi {
  (
    echo g;
    echo w;
  ) | fdisk /dev/$disk
  (
    echo n;
    echo;
    echo;
    echo +100M;
    echo y;
    echo w;
  ) | fdisk /dev/$disk
  (
    echo n;
    echo;
    echo;
    echo +300M;
    echo y;
    echo w;
  ) | fdisk /dev/$disk
  (
    echo n;
    echo;
    echo;
    echo;
    echo y;
    echo w;
  ) | fdisk /dev/$disk

  if [ $disktype == nv ] || [ $disktype == mm ]; then
    volume1="${disk}p1"
    volume2="${disk}p2"
  else
    volume1="${disk}1"
    volume2="${disk}2"
  fi

  echo y | mkfs.fat -F32 /dev/$volume1
  echo y | mkfs.ext4 /dev/$volume2 -L boot
  echo y | mkfs.btrfs /dev/$volume3 -L btrfs

  mount /dev/$volume3 /mnt

  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home
  btrfs subvolume create /mnt/@snapshots
  umount /mnt

  mount -o noatime,compress=zstd:2,space_cache=v2,discard=async,subvol=@ /dev/$volume3 /mnt
  mkdir /mnt/{boot,home,snapshots}
  mount -o noatime,compress=zstd:2,space_cache=v2,discard=async,subvol=@home /dev/$volume3 /mnt/home
  mount /dev/$volume2 /mnt/boot
  mount -o noatime,compress=zstd:2,space_cache=v2,discard=async,subvol=@snapshots /dev/$volume3 /mnt/snapshots
  mkdir /mnt/boot/efi
  mount /dev/$volume1 /mnt/boot/efi
}

function bios {
  echo "Пока не доступно"
  exit
}

if [[ $loader == 1 ]]; then
  fbios
elif [[ $loader == 2 ]]; then
  fuefi
fi

fdisk -l
timedatectl set-ntp true
pacman -Sy  && pacman -S reflector --noconfirm
reflector --verbose -c Russia -a 5 --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware btrfs-progs nano netctl dhcpcd
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt sh -c "$(curl -fsSL \
  https://raw.githubusercontent.com/kronsky/arch/main/install/install-part-two.sh)" \
  0 $disk $loader $hostname $username $rootpass $userpass $depo $de $video
