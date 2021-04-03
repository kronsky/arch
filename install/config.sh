#!/bin/bash
echo "Переход на третий этап установки"
read -p "Пароль пользователя: " userpass

#sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#echo;
#echo $userpass;
curl -L http://install.ohmyz.sh | sh
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/kronsky/arch.git
cp -f ~/arch/config/.alias_zsh ~/
cp -f ~/arch/config/.p10k.zsh ~/
cp -f ~/arch/config/.zshrc ~/

echo "Установить темы GTK?"
read -p "1 - да, 0 - нет: " themes
if [[ $themes == 1 ]]; then
  yay -S matcha-gtk-theme-git papirus-maia-icon-theme-git paper-icon-theme-git capitaine-cursors --noconfirm
  echo $userpass;
fi
