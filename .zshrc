if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
BREW_PREFIX="$(brew --prefix)"

FPATH="$BREW_PREFIX/share/zsh/site-functions:$FPATH"
autoload -Uz compinit
compinit -C


eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

export PATH="$BREW_PREFIX/opt/python@3.14/libexec/bin:$PATH"
export PATH="$BREW_PREFIX/opt/make/libexec/gnubin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$BREW_PREFIX/opt/openjdk@21/bin:$PATH"
export PATH="$BREW_PREFIX/opt/llvm/bin:$BREW_PREFIX/opt/bison/bin:$PATH"
export SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_REQUIRE_TAP_TRUST=1
export BAT_THEME_DARK="Catppuccin Mocha"
export NODE_EXTRA_CA_CERTS="$BREW_PREFIX/etc/ca-certificates/cert.pem"
export EDITOR="nvim"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

flux9s() { DYLD_LIBRARY_PATH=$BREW_PREFIX/opt/openssl@3/lib command flux9s "$@" }

google() {
  local query="${(j:+:)@}"
  open "https://www.google.com/search?q=${query}"
}

yt() {
  open "https://www.youtube.com/results?search_query=${(j:+:)@}"
}

extract() {
  case $1 in
    *.tar.gz)  tar xzf $1   ;;
    *.tar.bz2) tar xjf $1   ;;
    *.zip)     unzip $1     ;;
    *.gz)      gunzip $1    ;;
    *.tar)     tar xf $1    ;;
    *.7z)      7z x $1      ;;
    *.jar)     jar xf $1    ;;
    *)         echo "unknown format" ;;
  esac
}

opencode-isolated() {
  local cwd
  cwd="$(pwd)"
  sandbox-exec -p "
    (version 1)
    (deny default)
    (allow process*)
    (allow signal)
    (allow file-read-metadata)
    (allow file-read* file-write*
      (subpath \"${cwd}\")
      (subpath \"${HOME}/.local/share/opencode\")
      (subpath \"${HOME}/.local/state/opencode\")
      (subpath \"${HOME}/.config/opencode\")
      (subpath \"${HOME}/.cache/opencode\")
      (subpath \"/private/tmp\")
      (subpath \"/private/var/folders\")
      (subpath \"/dev\"))
    (allow file-read*
      (subpath \"/usr\")
      (subpath \"/Library\")
      (subpath \"/System\")
      (subpath \"/private/var\")
      (subpath \"/etc\")
      (subpath \"${BREW_PREFIX}\")
      (literal \"/\"))
    (allow file-ioctl
      (subpath \"/dev\"))
    (allow network-outbound)
    (allow ipc-posix*)
    (allow sysctl-read)
    (allow mach-lookup)
  " "${BREW_PREFIX}/bin/opencode" "$@"
}

nvim() {
    for arg in "$@"; do
        if [[ "$arg" == *.sops.* ]] && [[ "$arg" != .sops.yaml ]]; then
            if gum confirm --default=0 --no-show-help "decrypt $arg???"; then
                sops edit "$arg"
            elif (( $? != 130 )); then
                command nvim "$@"
            fi
            return
        fi
    done
    command nvim "$@"
}

alias {b,brwe}=brew
alias cat=bat
alias cd=z
alias {sl,ls}=lsd
alias lst='lsd --tree'
alias m=make
alias j=just
alias g=git
alias k=kubectl
alias n=nvim
alias lock='pmset displaysleepnow'
alias t=talosctl
alias gitui='gitui -t catppuccin-mocha.ron'
alias cdf='cd "$(osascript -e '\''tell app "Finder" to POSIX path of (insertion location as alias)'\'')"'
alias f9s=flux9s
alias opencode='gum confirm --default=0 --no-show-help "not isolated opencode???" && opencode'
alias sopsd='sops -d -i'
alias sopse='sops -e -i'
alias zshs='source ~/.zshrc'
alias zshe='nvim ~/.zshrc'
alias ssh-keychain='ssh-add --apple-use-keychain ~/.ssh/id_ed25519'
alias sudo-touch='sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local'

source $BREW_PREFIX/share/fzf-tab/fzf-tab.zsh
source $BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
