# Load Antigen
source ~/.antigen.zsh

# Load oh-my-zsh library
antigen use oh-my-zsh

# Theme
antigen bundle frmendes/geometry

# Bundles/plugins
antigen bundle git
antigen bundle heroku
antigen bundle tmuxinator
# antigen bundle zsh-users/zsh-completions

# SSH
antigen bundle ssh-agent

# Syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
