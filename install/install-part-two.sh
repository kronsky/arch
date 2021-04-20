#!/bin/bash
echo "####################################################################################"
read -p "Имя компьютера: " hostname
read -p "Имя пользователя: " username
read -p "Пароль root: " rootpass
read -p "Пароль пользователя "$username": " userpass
#read -p "На какое утройство устанавливать загрузчик? /dev/" disk
#echo "Загрузчик bios или efi?"
#read -p "1 - bios, 2 - efi: " loader

echo $hostname > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
echo -e "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
mkinitcpio -p linux
pacman -Syy
if [[ $2 == 1 ]]; then
  pacman -S grub --noconfirm
  grub-install /dev/$1
  grub-mkconfig -o /boot/grub/grub.cfg
elif [[ $2 == 2 ]]; then
  pacman -S grub efibootmgr --noconfirm
  grub-install /dev/$1
  grub-mkconfig -o /boot/grub/grub.cfg
fi
useradd -m -g users -G wheel -s /bin/bash $username
(
  echo $rootpass;
  echo $rootpass;
) | passwd
(
  echo $userpass;
  echo $userpass;
) | passwd $username
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo ""
echo "####################################################################################"
echo "######  Установлена чистая система Arch, продолжаем установку DE и программ?  ######"
echo "####################################################################################"
echo ""
read -p "1 - Продолжаем установку, 0 - Нет, я хочу чистый арч " next
if [[ $next == 0 ]]; then
  echo ""
  echo "####################################################################################"
  echo "#########  Установлена чистая система Arch, можно перезагружать компьютер  #########"
  echo "####################################################################################"
  echo ""
elif [[ $next == 1 ]]; then
  echo "Продолжаем установку"
  echo "Какой DE ставим?"
  read -p "1 - Gnome, 2 - KDE " de
  pacman -Syy
  if [[ $de == 1 ]]; then
    sudo pacman -S gnome chrome-gnome-shell gnome-tweaks rhythmbox network-manager-applet --noconfirm
    systemctl enable gdm
  elif [[ $de == 2 ]]; then
    sudo pacman -S plasma-desktop plasma-wayland-session sddm konsole plasma-nm gwenview dolphin plasma-pa powerdevil kscreen kde-gtk-config breeze-gtk sddm-kcm --noconfirm
    systemctl enable sddm
  fi
  sudo pacman -S networkmanager ppp ttf-liberation ttf-dejavu f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils alsa-plugins file-roller p7zip unrar gvfs aspell-ru git curl wget mc htop reflector ranger zsh screenfetch vivaldi telegram-desktop gimp libreoffice-fresh-ru atom --noconfirm
  systemctl enable NetworkManager
  echo "####################################################################################"
  echo "Какой графический драйвер ставить?"
  read -p "0 - Вируталка, 1 - Intel, 2 - Nvidia свободный, 3 - Nvidia проприетарный, 4 - AMD новые gpu, 5 - AMD старые gpu " video
  if [[ $video == 1 ]]; then
    pacman -S xf86-video-intel mesa lib32-mesa --noconfirm
  elif [[ $video == 2 ]]; then
    pacman -S xf86-video-nouveau mesa lib32-mesa --noconfirm
  elif [[ $video == 3 ]]; then
    pacman -S nvidia nvidia-utils lib32-nvidia-utils --noconfirm
  elif [[ $video == 4 ]]; then
    pacman -S xf86-video-amdgpu mesa lib32-mesa --noconfirm
  elif [[ $video == 5 ]]; then
    pacman -S xf86-video-ati mesa lib32-mesa --noconfirm
  elif [[ $video == 0 ]]; then
    echo "Пропускаем ..."
  fi
  su $username sh -c "$(curl -fsSL https://raw.githubusercontent.com/kronsky/arch/main/install/install-part-three.sh)"
fi
