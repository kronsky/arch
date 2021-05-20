#!/bin/bash
loadkeys ru
setfont cyr-sun16
echo "Загрузчик bios или efi?"
read -p "1 - bios, 2 - efi -->> " loader
fdisk -l
read -p "На какое утройство устанавливать систему? /dev/" disk
disktype=; for n in $disk; do disktype+=${n::2}; done
echo ""
echo "#####################################################################################"
echo "#####  На системном диске будет создан загрузочный раздел, root и home разделы.  ####"
echo "####  После создания раздела root, home займёт все оставшиеся пространство диска ####"
echo "#####################################################################################"
echo ""
read -p "Какого размера будет root раздел? (в гигабайтах): " root
echo "#####################################################################################"
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
if [[ $loader == 1 ]]; then
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
    echo y;
    echo n;
    echo;
    echo;
    echo;
    echo "+"$root"G;"
    echo y;
    echo n;
    echo;
    echo;
    echo;
    echo;
    echo y;
    echo a;
    echo 1;
    echo w;
  ) | fdisk /dev/$disk

  if [ $disktype == nv ] || [ $disktype == mm ]; then
    volume1="${disk}p1"
    volume2="${disk}p2"
    volume3="${disk}p3"
  else
    volume1="${disk}1"
    volume2="${disk}2"
    volume3="${disk}3"
  fi
  echo y | mkfs.ext2  /dev/$volume1 -L boot
  echo y | mkfs.ext4  /dev/$volume2 -L root
  echo y | mkfs.ext4  /dev/$volume3 -L home
  mount /dev/$volume2 /mnt
  mkdir /mnt/{boot,home}
  mount /dev/$volume1 /mnt/boot
  mount /dev/$volume3 /mnt/home
elif [[ $loader == 2 ]]; then
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
    echo w;
  ) | fdisk /dev/$disk
  (
    echo n;
    echo;
    echo;
    echo +"$root"G;
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
  (
    echo t;
    echo 1;
    echo 1;
    echo w;
  ) | fdisk /dev/$disk
  if [ $disktype == nv ] || [ $disktype == mm ]; then
    volume1="${disk}p1"
    volume2="${disk}p2"
    volume3="${disk}p3"
  else
    volume1="${disk}1"
    volume2="${disk}2"
    volume3="${disk}3"
  fi
  echo y | mkfs.fat -F32 /dev/$volume1
  echo y | mkfs.ext4  /dev/$volume2
  echo y | mkfs.ext4  /dev/$volume3
  mount /dev/$volume2 /mnt
  mkdir /mnt/home
  mkdir -p /mnt/boot/efi
  mount /dev/$volume1 /mnt/boot/efi
  mount /dev/$volume3 /mnt/home
fi
fdisk -l
timedatectl set-ntp true
pacman -Sy  && pacman -S reflector --noconfirm
reflector --verbose -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacstrap /mnt base base-devel linux linux-firmware nano netctl dhcpcd
genfstab -pU /mnt >> /mnt/etc/fstab
arch-chroot /mnt sh -c "$(curl -fsSL \
  https://raw.githubusercontent.com/kronsky/arch/main/install/install-part-two.sh)" \
  0 $disk $loader $hostname $username $rootpass $userpass $depo $de $video
