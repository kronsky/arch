#!/bin/bash
#read -p "Пароль пользователя: " userpass
#sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#echo;
#echo $userpass;
curl -L http://install.ohmyz.sh | sh
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/kronsky/arch.git
cp -f ~/arch/config/.alias_zsh ~/
cp -f ~/arch/config/.p10k.zsh ~/
cp -f ~/arch/config/.zshrc ~/


#wget git.io/yay.sh
#sh yay.sh
#echo $userpass;
#rm yay.sh
#yay -S pamac-all timeshift youtube-dl zsh-fast-syntax-highlighting zsh-autosuggestions --noconfirm
#echo $userpass;


echo "Установить темы GTK?"
read -p "1 - да, 0 - нет: " themes
if [[ $themes == 1 ]]; then
  yay -S matcha-gtk-theme-git papirus-maia-icon-theme-git paper-icon-theme-git capitaine-cursors --noconfirm
  echo $1;
fi

echo "####################################################################################"
echo "#####################  Все готово, можно перезагружать компьютер  ##################"
echo "####################################################################################"
