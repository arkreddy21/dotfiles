# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/arkreddy/.zshrc'
# End of lines added by compinstall

export TERMINAL=kitty
export BAT_THEME="Solarized (dark)"
export PATH=$PATH:~/.local/bin:~/.cargo/bin

######## Aliases ########
# alias ls='ls --color'
alias l='eza --hyperlink --icons '
alias s="sudo "
alias c="clear"
alias gte="gnome-text-editor "
alias py="python "
alias pn="pnpm "
alias zed="zeditor "
alias set-intel="sudo envycontrol -s integrated"
alias set-hybrid="sudo envycontrol -s hybrid"
alias ff="fastfetch"
alias db="distrobox "

alias nap="systemctl suspend"
alias die="poweroff"
alias vpn-upb="cd ~/.cert && sudo openvpn --config ~/.cert/upb_linux_udp_redirect.ovpn"
alias vpn-hni="cd ~/.cert && sudo openvpn --config ~/.cert/hni_linux_udp_default.ovpn"

# temporarily allow scanning libs in /usr/local by running expld 
# (security risk to always allow)
alias expld="export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH"

##########################

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
source <(fzf --zsh)

# fnm
#FNM_PATH="/home/arkreddy/.local/share/fnm"
#if [ -d "$FNM_PATH" ]; then
#  export PATH="$FNM_PATH:$PATH"
#  eval "`fnm env`"
#fi

#eval "$(fnm env --use-on-cd --shell zsh)"


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
# use zinit self-update to update

# Add in zsh plugins
# Completions - load before compinit, no turbo
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting

autoload -Uz compinit && compinit -C
zinit cdreplay -q


# bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#-----------------------------

source ~/.secrets


################# Handy commands #############
# du -sh * | sort -h # Show disk usage of files and directories in cwd
# binsider
