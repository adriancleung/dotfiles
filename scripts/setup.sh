osascript -e 'tell application "System Preferences" to quit'

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'

cecho() {
  echo "${2}${1}${reset}"
  return
}

# =========================
# Install base environments
# =========================
cecho "Installing..." $green
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

xcode-select --install

# Install Homebrew
cecho "Installing Homebrew..." $green
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Stop stealing my data
brew analytics off
brew doctor
brew update

# Install Oh My Zsh
cecho "Installing Oh My Zsh..." $green
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Fonts
cecho "Installing fonts..." $green
curl -o "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Regular.ttf
curl -o "$HOME/Library/Fonts/MesloLGS NF Bold.ttf" https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Bold.ttf
curl -o "$HOME/Library/Fonts/MesloLGS NF Italic.ttf" https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Italic.ttf
curl -o "$HOME/Library/Fonts/MesloLGS NF Bold Italic.ttf" https://raw.githubusercontent.com/romkatv/powerlevel10k-media/master/MesloLGS%20NF%20Bold%20Italic.ttf

# Install Powerlevel10k
cecho "Installing Powerlevel10k..." $green
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo 'export ZSH_THEME="powerlevel10k/powerlevel10k"' >> $HOME/.zshrc
cp $SCRIPTPATH/../config/.p10k.zsh $HOME

# Install NVM
cecho "Installing NVM..." $green
/bin/bash-c "$(curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh)"

# Install Homebrew packages
cecho "Installing Homebrew packages..." $green
brew bundle --no-lock --cleanup --file $SCRIPTPATH/../config/Brewfile

# Install custom configs
cecho "Installing custom configs..." $green
cat $SCRIPTPATH/../config/.zshrc >> $HOME/.zshrc
cat $SCRIPTPATH/../config/.gitconfig >> $HOME/.gitconfig

# Set macOS defaults
cecho "Setting macOS defaults..." $green
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"
defaults write NSGlobalDomain "NSAutomaticSpellingCorrectionEnabled" -bool "false"
defaults write NSGlobalDomain "WebAutomaticSpellingCorrectionEnabled" -bool "false"
defaults write NSGlobalDomain "NSAutomaticCapitalizationEnabled" -bool "false"
defaults write NSGlobalDomain "NSAutomaticPeriodSubstitutionEnabled" -bool "false"
defaults write com.apple.HIToolbox "AppleFnUsageType" -int "2"
defaults write com.apple.desktopservices "DSDontWriteNetworkStores" -bool "true"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.messageshelper.MessageController "SOInputLineSettings" -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool "false"
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int "40"
defaults write com.apple.finder "NewWindowTarget" -string "PfHm"
defaults write com.apple.finder "NewWindowTargetPath" -string "file://${HOME}/"
killall Finder
killall Dock
killall Messages

cecho "Installation complete!" $green
echo
echo "Recommended to restart before continuing use"
echo