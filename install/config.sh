#!/bin/bash

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

git clone https://github.com/kronsky/arch.git
cp -f ~/arch/config/.alias_zsh ~/
cp -f ~/arch/config/.zshrc ~/

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S youtube-dl zsh-fast-syntax-highlighting zsh-autosuggestions --noconfirm
