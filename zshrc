ZSH_THEME="wezm"
COMPLETION_WAITING_DOTS="true"
plugins=(git node osx python)

export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Path configs
# Rust
export PATH="$HOME/.cargo/bin:$PATH"
# Go
export GOPATH=`go env GOPATH`
export PATH="$PATH:$GOPATH/bin"

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

# Aliases for:
# Editing
alias v="nvim"
alias vz="v $HOME/.zshrc"
alias vn="v $HOME/.config/nvim/init.vim"
# Gitting
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gap='ga -p'
alias gh='git checkout'
alias ghb='gh -b'
# Looking
alias l="exa --long --all"
alias lt="exa --long --all --tree"
alias cat="bat"
# Sourcing
alias clear="clear && source $HOME/.zshrc"
# Authenticating
alias agent='eval "$(ssh-agent -s)"; ssh-add ~/.ssh/id_rsa'
# Rubberducking
alias r='rubberduck'
