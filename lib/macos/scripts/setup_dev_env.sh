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


try_use_arm_brew tap 'heroku/brew'
try_use_arm_brew tap 'puma/puma'
try_use_arm_brew tap 'homebrew/cask-fonts'
try_use_arm_brew tap 'homebrew/cask-versions'


# CLI or important libs, softwares
#try_use_arm_brew install 'geckodriver'
#try_use_arm_brew install 'htop'
try_use_arm_brew install 'advancecomp'
try_use_arm_brew install 'ansible'
try_use_arm_brew install 'bottom'
try_use_arm_brew install 'emojify'
try_use_arm_brew install 'gifsicle'
try_use_arm_brew install 'git'
try_use_arm_brew install 'gnu-sed'
try_use_arm_brew install 'gping'
try_use_arm_brew install 'graphviz'
try_use_arm_brew install 'heroku'
try_use_arm_brew install 'httpie'
try_use_arm_brew install 'imagemagick'
try_use_arm_brew install 'jhead'
try_use_arm_brew install 'jonof/kenutils/pngout'
try_use_arm_brew install 'jpeg'
try_use_arm_brew install 'jpegoptim'
try_use_arm_brew install 'libpq'
try_use_arm_brew install 'mackup'
try_use_arm_brew install 'optipng'
try_use_arm_brew install 'overmind'
try_use_arm_brew install 'perl'
try_use_arm_brew install 'pinentry-mac'
try_use_arm_brew install 'pngcrush'
try_use_arm_brew install 'pngquant'
try_use_arm_brew install 'postgresql'
try_use_arm_brew install 'puma-dev'
try_use_arm_brew install 'readline'
try_use_arm_brew install 'readline'
try_use_arm_brew install 'ssh-copy-id'
try_use_arm_brew install 'svn'
try_use_arm_brew install 'terminal-notifier'
try_use_arm_brew install 'tree'
try_use_arm_brew install 'up'
try_use_arm_brew install 'watch'
try_use_arm_brew install 'watchman'
try_use_arm_brew install 'yarn'
try_use_arm_brew install 'zsh'

# Fonts
try_use_arm_brew install --cask 'font-source-code-pro-for-powerline'
try_use_arm_brew install --cask 'font-public-sans'
try_use_arm_brew install --cask 'font-jetbrains-mono-nerd-font'
try_use_arm_brew install --cask 'font-ibm-plex-mono'

# Browsers
#try_use_arm_brew install --cask 'google-chrome'
#try_use_arm_brew install --cask 'microsoft-edge'
try_use_arm_brew install --cask 'brave-browser'
try_use_arm_brew install --cask 'firefox-developer-edition'
try_use_arm_brew install --cask 'welly'

# Applications
#try_use_arm_brew install --cask 'flux'
#try_use_arm_brew install --cask 'geotag-photos-pro'
#try_use_arm_brew install --cask 'imageoptim'
#try_use_arm_brew install --cask 'insomnia'
#try_use_arm_brew install --cask 'keybase'
#try_use_arm_brew install --cask 'postman'
#try_use_arm_brew install --cask 'sequel-pro'
#try_use_arm_brew install --cask 'sketch'
#try_use_arm_brew install --cask 'spotify'
#try_use_arm_brew install --cask 'subler'
#try_use_arm_brew install --cask 'transmission'
#try_use_arm_brew install --cask 'xquartz'
try_use_arm_brew install --cask 'alfred'
try_use_arm_brew install --cask 'appcleaner'
try_use_arm_brew install --cask 'calibre'
try_use_arm_brew install --cask 'discord'
try_use_arm_brew install --cask 'disk-inventory-x'
try_use_arm_brew install --cask 'docker'
try_use_arm_brew install --cask 'dropbox'
try_use_arm_brew install --cask 'figma'
try_use_arm_brew install --cask 'figmadaemon'
try_use_arm_brew install --cask 'fork'
try_use_arm_brew install --cask 'iterm2'
try_use_arm_brew install --cask 'karabiner-elements'
try_use_arm_brew install --cask 'keka'
try_use_arm_brew install --cask 'kobo'
try_use_arm_brew install --cask 'ngrok'
try_use_arm_brew install --cask 'notion'
try_use_arm_brew install --cask 'openemu'
try_use_arm_brew install --cask 'rubymine'
try_use_arm_brew install --cask 'sigil'
try_use_arm_brew install --cask 'slack-beta'
try_use_arm_brew install --cask 'vagrant'
try_use_arm_brew install --cask 'vagrant-manager'
try_use_arm_brew install --cask 'visual-studio-code'
try_use_arm_brew install --cask 'zeplin'

try_use_arm_brew bundle --file=-<<EOF
mas 'Keynote', id: 409_183_694
mas 'Pages', id: 409_201_541
mas 'Numbers', id: 409_203_825
mas '1Password', id: 443_987_910
mas 'OpenConv', id: 892_308_325
mas 'iStat Menus', id: 1_319_778_037
mas 'Byword', id: 420_212_497
mas 'Spark', id: 1_176_895_641
mas 'Moom', id: 419_330_170
mas 'LINE', id: 539_883_307
EOF
fi

try_use_arm_brew doctor && try_use_arm_brew update && try_use_arm_brew cleanup && try_use_arm_brew upgrade && try_use_arm_brew cask upgrade
try_use_x86_brew doctor && try_use_x86_brew update && try_use_x86_brew cleanup && try_use_x86_brew upgrade && try_use_x86_brew cask upgrade
