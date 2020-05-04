ZSH_THEME="agnoster"
plugins=(git node python fzf autojump zsh-autosuggestions zsh-syntax-highlighting)

export SHELL="zsh"
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Path configs
# Rust
export PATH="$HOME/.cargo/bin:$PATH"
# Go
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# History
HISTFILE=~/.zsh_history
HISTSIZE=1024
SAVEHIST=1024
setopt append_history
setopt hist_ignore_all_dups
unsetopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt bang_hist

# Functions
pullpasses() {
    if [ -n "$1" ]; then
        lpass show $(lpass ls | grep -i "$1" | awk '{ print $3 }' | sed 's/.$//')
    else
        echo "Error: missing search term"
    fi
}

pullpass() {
    if [ -n "$1" ]; then
        pullpasses "$1" | grep -i "Password:" | awk '{ print $2 }' | head -1 | pbcopy
    else
        echo "Error: missing search term"
    fi
}

# Aliases for:
# Editing
alias v="nvim"
alias vz="v /root/seastead/zshrc"
alias vn="v /root/seastead/init.vim"
alias sz="source /root/seastead/zshrc"
# Gitting
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gap='ga -p'
alias gh='git checkout'
alias ghb='gh -b'
alias gf='git diff'
# Looking
alias l="exa --long --all"
alias lt="exa --long --all --tree"
alias cat="bat"
alias f='fzf --bind "enter:execute(nvim {})"'
# Sourcing
alias clear="clear && source $HOME/.zshrc"
# Authenticating
alias agent='eval "$(ssh-agent -s)"; ssh-add ~/.ssh/id_rsa'
alias cerego-agent='eval "$(ssh-agent -s)"; ssh-add ~/.ssh/id_rsa_cerego'
# Rubberducking
alias r='rubberduck'
# thefuck
eval $(thefuck --alias)

# Autojump
[[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

# fzf
#determines search program for fzf
if type ag &> /dev/null; then
    export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'
fi
#refer rg over ag
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden'
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Startup script
echo "\nA smooth sea never made a skilled sailor.\n"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# rbenv
export PATH="/root/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
