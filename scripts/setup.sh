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
brew bundle --no-lock --cleanup --file $SCRIPTPATH/../config/Brewfile || true

# Install custom configs
cecho "Installing custom configs..." $green
cat $SCRIPTPATH/../config/.zshrc >> $HOME/.zshrc
cat $SCRIPTPATH/../config/.gitconfig > $HOME/.gitconfig
cat $SCRIPTPATH/../config/.gitignore > $HOME/.gitignore

# Set macOS defaults
cecho "Setting macOS defaults..." $green
# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Enable fast key press
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Disable auto-correct and capitalization
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Fn shows emojis
defaults write com.apple.HIToolbox AppleFnUsageType -int 2
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false
# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
# Higher bluetooth audio quality
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
# Finder open in Home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
# Add iOS & Watch Simulator to Launchpad
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"
# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
killall Finder
killall Dock
killall Messages

cecho "Installation complete!" $green
echo
echo "Recommended to restart before continuing use"
echo