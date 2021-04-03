#!/usr/bin/zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx &> /dev/null
# [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null

export PATH=$HOME/bin:$HOME/.bin:$HOME/.config/rofi/scripts:$HOME/.local/bin:/usr/local/bin:$PATH
export CPR_LIB=~/cpr

export HISTFILE=~/.zhistory
export HISTSIZE=3000
export SAVEHIST=3000

autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# ohmyzsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"
DISABLE_AUTO_UPDATE="true"
plugins=()
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
[[ ! -d $ZSH_CACHE_DIR ]] && mkdir -p $ZSH_CACHE_DIR
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export TERM="xterm-256color"
export EDITOR="$([[ -n $DISPLAY && $(command -v gedit) ]] && echo 'gedit' || echo 'micro' || echo 'nano')"
export BROWSER="$([[ -n $DISPLAY && $(command -v vivaldi) ]] && echo 'vivaldi' || echo 'firefox')"
export SSH_KEY_PATH="~/.ssh/dsa_id"
export XDG_CONFIG_HOME="$HOME/.config"
export _JAVA_AWT_WM_NONREPARENTING=1

# export GPG_TTY=$(tty)
[[ $(command -v bat) ]] && export MANPAGER="sh -c 'sed -e s/.\\\\x08//g | bat -l man -p'"
[[ -s ~/.env ]] && . ~/.env
[[ -f ~/.alias_zsh ]] && . ~/.alias_zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
