eval "$(~/.homebrew/bin/brew shellenv)"

export FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
autoload -Uz compinit
compinit

source <(fzf --zsh)
source <(zoxide init zsh)
alias cd=z

export PATH="/Users/mishaartemiev/.homebrew/opt/openjdk/bin:$PATH"
export PATH="/Users/mishaartemiev/.ghcup/bin:$PATH"

alias brwe=brew

export SSL_CERT_FILE="$(brew --prefix)/share/ca-certificates/cacert.pem"
export BAT_THEME_DARK="Catppuccin Mocha"

alias ls=lsd
alias lst="lsd --tree"
alias j=just
alias m=make
alias cat='bat --paging=never'
