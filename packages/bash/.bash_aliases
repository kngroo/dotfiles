# Modern CLI tool replacements (rice setup)
# On Debian/Ubuntu, bat/fd install as `batcat`/`fdfind`; the "bash" package's
# post-install step symlinks ~/.local/bin/bat and ~/.local/bin/fd to them, so
# these aliases can just use the standard names on every platform.
alias cat='bat'
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first -l'
alias la='eza --icons --group-directories-first -la'
alias lt='eza --icons --group-directories-first --tree'
alias df='duf'

# fetch tool alias
alias neofetch='fastfetch'
