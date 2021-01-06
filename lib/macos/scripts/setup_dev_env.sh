#!/bin/sh

macOS_bootstrap="$(pwd -P)"

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

red=$(tput setaf 1)
green=$(tput setaf 2)
color_reset=$(tput sgr0)

error_echo() {
  printf "\n${red}%s.${color_reset}\n" "$1"
}

info_echo() {
  printf "\n${green}%s ...${color_reset}\n" "$1"
}

version() {
  echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'
}

catch_exit() {
  ret=$?
  test $ret -ne 0 && error_echo "Installation fails" >&2
  exit $ret
}

sudo -v
# Keep alive Root
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# identify CPU architecture
cpu_architecture="$(uname -m)"

alias try_use_x86=""
alias try_use_x86_brew="brew"
alias try_use_arm_brew="brew"

if [[ $cpu_architecture == "arm64" ]]; then
  alias try_use_x86="arch -x86_64"
  alias try_use_x86_brew="arch -x86_64 /usr/local/homebrew/bin/brew"
  alias try_use_arm_brew="arch -arm64 /opt/homebrew/bin/brew"
fi

try_use_arm_brew bundle --file=-<<EOF
tap 'heroku/brew'
tap 'puma/puma'

brew 'advancecomp'
brew 'ansible'
brew 'emojify'
brew 'geckodriver'
brew 'gifsicle'
brew 'git'
brew 'graphviz'
brew 'heroku'
brew 'htop'
brew 'httpie'
brew 'imagemagick'
brew 'jhead'
brew 'jonof/kenutils/pngout'
brew 'jpeg'
brew 'jpegoptim'
brew 'libpq'
brew 'mackup'
brew 'optipng'
brew 'overmind'
brew 'perl'
brew 'pinentry-mac'
brew 'pngcrush'
brew 'pngquant'
brew 'puma-dev'
brew 'readline'
brew 'ssh-copy-id'
brew 'terminal-notifier'
brew 'tree'
brew 'up'
brew 'watch'
brew 'watchman'
brew 'yarn'
brew 'zsh'

cask 'alfred3'
cask 'iterm2'
cask 'dropbox'
cask 'karabiner-elements'
cask 'keka'
cask 'keybase'
cask 'ngrok'
cask 'sequel-pro'
cask 'psequel'
cask 'flux'
cask 'discord'

cask 'font-fira-code'
cask 'font-source-code-pro-for-powerline'
cask 'font-hack-nerd-font'
cask 'font-public-sans'
cask 'font-jetbrains-mono-nerd-font'

cask 'visual-studio-code-insiders'
cask 'fork'
cask 'imageoptim'
cask 'insomnia'
cask 'postman'
cask 'vagrant'
cask 'vagrant-manager'
cask 'xquartz'
cask 'sketch'
cask 'calibre'
cask 'sigil'
cask 'spotify'
cask 'subler'
cask 'transmission'
cask 'geotag-photos-pro'
cask 'openemu'

cask 'google-chrome'
cask 'firefox-developer-edition'
cask 'microsoft-edge'
cask 'welly'
EOF

try_use_x86_brew bundle --file=-<<EOF
brew 'postgresql'
brew 'readline'
EOF

brew doctor && brew update && brew cleanup && brew upgrade && brew cask upgrade && mas upgrade
