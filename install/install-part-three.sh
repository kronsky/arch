#!/bin/bash
echo "Переход на третий этап установки"
read -p "Пароль пользователя: " userpass
wget git.io/yay.sh
sh yay.sh
echo $userpass;
rm yay.sh
yay -S pamac-all timeshift youtube-dl zsh-fast-syntax-highlighting zsh-autosuggestions --noconfirm
echo $userpass;
echo "####################################################################################"
echo "#####################  Все готово, можно перезагружать компьютер  ##################"
echo "####################################################################################"
