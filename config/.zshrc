
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