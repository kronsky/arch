#!/bin/bash
#устанока zsh, плагинов и тем
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
yay -S zsh-fast-syntax-highlighting zsh-autosuggestions
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
#темы gtk
yay -S matcha-gtk-theme-git papirus-maia-icon-theme-git paper-icon-theme-git capitaine-cursors
wget git.io/yay.sh && sh yay.sh && rm yay.sh
yay -S pamac-all timeshift youtube-dl
