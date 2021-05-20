#!/bin/bash
echo $3 > /etc/hostname
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
useradd -m -g users -G wheel -s /bin/bash $4
(
  echo $5;
  echo $5;
) | passwd
(
  echo $6;
  echo $6;
) | passwd $4
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
sudo reflector --verbose -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy
sudo pacman -S networkmanager ppp ttf-liberation ttf-dejavu f2fs-tools dosfstools \
  ntfs-3g alsa-lib alsa-utils alsa-plugins file-roller p7zip unrar gvfs aspell-ru \
  git curl wget mc htop reflector ranger zsh screenfetch --noconfirm
if [[ $7 == 1 ]]; then
  if [[ $8 == 1 ]]; then
    sudo pacman -S gnome chrome-gnome-shell gnome-tweaks rhythmbox network-manager-applet --noconfirm
    systemctl enable gdm
  elif [[ $8 == 2 ]]; then
    sudo pacman -S plasma-desktop plasma-wayland-session sddm konsole plasma-nm \
    gwenview dolphin plasma-pa powerdevil kscreen kde-gtk-config breeze-gtk sddm-kcm --noconfirm
    systemctl enable sddm
  fi
  sudo pacman -S vivaldi telegram-desktop gimp libreoffice-fresh-ru atom --noconfirm
  systemctl enable NetworkManager
  if [[ $9 == 1 ]]; then
    pacman -S xf86-video-intel mesa lib32-mesa --noconfirm
  elif [[ $9 == 2 ]]; then
    pacman -S xf86-video-nouveau mesa lib32-mesa --noconfirm
  elif [[ $9 == 3 ]]; then
    pacman -S nvidia nvidia-utils lib32-nvidia-utils --noconfirm
  elif [[ $9 == 4 ]]; then
    pacman -S xf86-video-amdgpu mesa lib32-mesa --noconfirm
  elif [[ $9 == 5 ]]; then
    pacman -S xf86-video-ati mesa lib32-mesa --noconfirm
  elif [[ $9 == 0 ]]; then
    echo "Пропускаем ..."
  fi
  curl -OL https://raw.githubusercontent.com/kronsky/arch/main/install/config.sh
  chmod +x config.sh
fi
echo ""
echo "####################################################################################"
echo "###############  Установка завершена, можно перезагружать компьютер  ###############"
echo "####################################################################################"
