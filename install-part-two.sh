#!/bin/bash
read -p "введи имя компьютера: " hostname
read -p "введи имя пользователя: " username
read -p "на какое утройство устанавливать загрузчик (например sda)?: " disk
echo $hostname > /etc/hostname
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
echo -e "en_US.UTF-8 UTF-8\nru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
mkinitcpio -p linux
pacman -Syy
pacman -S grub --noconfirm
grub-install /dev/$disk
grub-mkconfig -o /boot/grub/grub.cfg
useradd -m -g users -G wheel -s /bin/bash $username
echo 'пароль root'
passwd
echo 'пароль пользователя'
passwd $username
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy
pacman -Syy && sudo pacman -S gnome networkmanager network-manager-applet ppp ttf-liberation ttf-dejavu f2fs-tools dosfstools ntfs-3g alsa-lib alsa-utils file-roller p7zip unrar gvfs aspell-ru git curl wget mc htop reflector chrome-gnome-shell vivaldi ranger gnome-tweaks telegram-desktop zsh gimp libreoffice-fresh-ru screenfetch atom rhythmbox --noconfirm
systemctl enable gdm NetworkManager
#wget git.io/yay.sh && sh yay.sh && rm yay.sh
#yay -S pamac-all zsh-fast-syntax-highlighting zsh-autosuggestions timeshift youtube-dl
#yay -S matcha-gtk-theme-git papirus-maia-icon-theme-git paper-icon-theme-git capitaine-cursors
echo "какой драйвер на графику ставить?"
read -p "0 - вируталка, 1 - intel, 2 - nvidia свободный, 3 - nvidia проприетарный, 4 - amd новые gpu, 5 - amd старые gpu,  - nvidia свободный: " video
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
  pacman -Sy
fi
echo 'установка завершена! делай ребут.'
