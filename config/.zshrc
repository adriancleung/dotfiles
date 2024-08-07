
# Custom aliases
alias dev="cd $HOME/dev"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias mkdir="mkdir -pv"
alias ll="ls -FGlAhp"
alias less="less -FSRXc"

alias edit="code"
alias f="open -a Finder ./"
alias ~="cd ~"
alias c="clear"
alias ..="cd ../"
alias ...="cd ../../"

function ydl() { youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "$1" -o "$2"; }
function q() { exit; }
cd() { builtin cd "$@"; ll; }

function conf() { code $HOME/.zshrc; }
function src() { source $HOME/.zshrc; }
function manpdf() { man -t "${1}" | open -f -a /System/Applications/Preview.app/ }

alias asso='aws sso login --profile admin-access'
alias timport='terraform import'
alias tplan='terraform plan'
alias tapply='terraform apply'
alias tswitch='terraform workspace select'

# Terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"