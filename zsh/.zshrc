# ============================================================================
# ZSH Configuration
# ============================================================================

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# ============================================================================
# Environment Variables
# ============================================================================

# XDG Config
export XDG_CONFIG_HOME="$HOME/.config/dotfiles"

# Java
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home/"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools


# Dotfiles scripts (tmux-sessionizer, ...)
export PATH="$HOME/.config/dotfiles/bin:$PATH"

# API keys live in .zshrc.local (gitignored)
[[ -f "$HOME/.config/dotfiles/zsh/.zshrc.local" ]] && source "$HOME/.config/dotfiles/zsh/.zshrc.local"

# ============================================================================
# React Native Aliases
# ============================================================================

# Run commands
alias rnios="yarn react-native run-ios"
alias rnandroid="yarn react-native run-android"
alias rnstart="yarn react-native start"
alias rnclear="yarn react-native start --reset-cache"

# Build commands (subshells: always the current project's android/ios, never a zoxide guess)
alias keystore="(cd android/app && keytool -genkeypair -v -keystore moeed.keystore -alias moeed -keyalg RSA -keysize 2048 -validity 10000)"
alias rnapk="(cd android && ./gradlew assembleRelease)"
alias rndebug="(cd android && ./gradlew assembleDebug)"
alias rngradleclean="(cd android && ./gradlew clean)"
alias rnprebuild="npx react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res"

# iOS Pods
alias podi="(cd ios && pod install)"

# Clean commands
alias aclean="rngradleclean"
alias rnclean='rm -rf node_modules && yarn install && (cd ios && pod install) && yarn react-native start --reset-cache'

# Expo
alias expoios='npx expo run:ios'
alias expoandroid='npx expo run:android'
alias expostart='npx expo start'
alias expoclear='npx expo start -c'
alias expobuild='eas build'
alias exposubmit='eas submit'
alias expoprebuild='npx expo prebuild'
alias expoclean='npx expo prebuild --clean'

# ============================================================================
# Yarn Aliases
# ============================================================================

alias ya="yarn add"
alias yad="yarn add -D"
alias yar="yarn remove"
alias yau="yarn upgrade"
alias ys="yarn start"
alias yb="yarn build"
alias yt="yarn test"
alias yclean="rm -rf node_modules && yarn install"

# ============================================================================
# Development Tools
# ============================================================================

# IDEs
alias astudio="open -a /Applications/Android\ Studio.app"
alias xworkspace="open ios/*.xcworkspace"

# Git
alias g="lazygit"
alias githome='git config user.name "Moeed Sarwar" && git config user.email "moeedsarwar112@gmail.com"'

# Neovim
alias n='nvim .'
alias conf='cd ~/.config/dotfiles/nvim'

# ============================================================================
# Tmux Aliases
# ============================================================================

alias t="tmux"
alias td="tmux detach"
alias tn="tmux new -s"
alias ta="tmux attach -t"
alias tl="tmux ls"
alias tk="tmux kill-session -t"

# Smart tmux: attach if session exists, create if not (aliases can't take $1)
unalias ts 2>/dev/null
function ts { tmux new -A -s "${1:-main}"; }

# Pick a project and open/attach its tmux session (editor / shell / metro)
alias tp="tmux-sessionizer"

# ============================================================================
# Project Navigation
# ============================================================================

alias donezo="tmux-sessionizer ~/Projects/ReactNative/tasker"
alias tclient="cd ~/Projects/ReactNative/tasker/client"
alias tserver="cd ~/Projects/ReactNative/tasker/backend"

# ============================================================================
# General Aliases
# ============================================================================

alias c='clear'
alias ip="ifconfig en0 | grep inet | awk '{ print \$2 }'"

# ============================================================================
# Configuration Files
# ============================================================================

alias aeroconf="nvim ~/.config/dotfiles/aerospace/aerospace.toml"
alias zshconf="nvim ~/.config/dotfiles/zsh/.zshrc"
alias zshreload="source ~/.zshrc && echo 'ZSH Reloaded!'"
alias tmuxconf="nvim ~/.config/dotfiles/tmux/tmux.conf"
alias tmuxreload="tmux source-file ~/.config/dotfiles/tmux/tmux.conf && echo 'Tmux Reloaded!'"
alias nvimconf="nvim ~/.config/dotfiles/nvim/lua/"
alias starshipconf="nvim ~/.config/dotfiles/starship/starship.toml"

# ============================================================================
# Tool Initialization
# ============================================================================

# Zoxide
eval "$(zoxide init zsh)"

# Starship Prompt
export STARSHIP_CONFIG="$HOME/.config/dotfiles/starship/starship.toml"
eval "$(starship init zsh)"
eval "$(rbenv init - zsh)"

alias kage="python3 main.py"
