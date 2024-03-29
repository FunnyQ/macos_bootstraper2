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
try_use_arm_brew install 'htop'
try_use_arm_brew install 'advancecomp'
try_use_arm_brew install 'ansible'
try_use_arm_brew install 'bottom'
try_use_arm_brew install 'emojify'
try_use_arm_brew install 'gifsicle'
try_use_arm_brew install 'git'
try_use_arm_brew install 'gnu-sed'
try_use_arm_brew install 'graphviz'
try_use_arm_brew install 'httpie'
try_use_arm_brew install 'imagemagick'
try_use_arm_brew install 'jhead'
try_use_arm_brew install 'jonof/kenutils/pngout'
try_use_arm_brew install 'jpeg'
try_use_arm_brew install 'jpegoptim'
try_use_arm_brew install 'libpq'
try_use_arm_brew install 'optipng'
try_use_arm_brew install 'overmind'
try_use_arm_brew install 'perl'
try_use_arm_brew install 'pinentry-mac'
try_use_arm_brew install 'pngcrush'
try_use_arm_brew install 'pngquant'
try_use_arm_brew install 'postgresql'
try_use_arm_brew install 'puma-dev'
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
#try_use_arm_brew install --cask 'font-source-code-pro-for-powerline'
try_use_arm_brew install --cask 'font-meslo-lg-nerd-font' # best font for iTerm
#try_use_arm_brew install --cask 'font-public-sans'
#try_use_arm_brew install --cask 'font-jetbrains-mono-nerd-font'
#try_use_arm_brew install --cask 'font-ibm-plex-mono'

# Browsers
try_use_arm_brew install --cask 'arc'
try_use_arm_brew install --cask 'sigmaos'
try_use_arm_brew install --cask 'firefox-developer-edition'
#try_use_arm_brew install --cask 'welly'

# Applications
#try_use_arm_brew install --cask 'flux'                # only if monitor not support for night shift
#try_use_arm_brew install --cask 'imageoptim'          # compress images
#try_use_arm_brew install --cask 'insomnia'            # paw alternative
#try_use_arm_brew install --cask 'keybase'             # SNS public keys management
#try_use_arm_brew install --cask 'postman'             # only if need co-work with postman user
#try_use_arm_brew install --cask 'sequel-pro'          # use TablePlus instead
#try_use_arm_brew install --cask 'sketch'              # use sketch workspace web reader instead
#try_use_arm_brew install --cask 'spotify'
#try_use_arm_brew install --cask 'subler'              # only if you still need to deal with encoding issues of str files
#try_use_arm_brew install --cask 'transmission'        # only if you still use BT for download stuff
#try_use_arm_brew install --cask 'xquartz'             # only if image process have issues
#try_use_arm_brew install --cask 'amethyst'
try_use_arm_brew install --cask 'alfred'
try_use_arm_brew install --cask 'calibre'
#try_use_arm_brew install --cask 'discord'             # use web app instead
try_use_arm_brew install --cask 'dropbox'
try_use_arm_brew install --cask 'setapp'
#try_use_arm_brew install --cask 'figma'               # use web app instead
#try_use_arm_brew install --cask 'figmadaemon'         # only if there are font issues in figma
#try_use_arm_brew install --cask 'fliqlo'              # screen saver, use epoch-flip-clock instead
try_use_arm_brew install --cask 'elgato-stream-deck'
try_use_arm_brew install --cask 'epoch-flip-clock'
try_use_arm_brew install --cask 'fork'
try_use_arm_brew install --cask 'iterm2'
try_use_arm_brew install --cask 'cool-retro-term'
try_use_arm_brew install --cask 'jetbrains-toolbox'
try_use_arm_brew install --cask 'karabiner-elements'
try_use_arm_brew install --cask 'keka'
try_use_arm_brew install --cask 'kobo'
#try_use_arm_brew install --cask 'ngrok'               # not support custom domain (example.test) for free
#try_use_arm_brew install --cask 'notion'              # use web app instead
#try_use_arm_brew install --cask 'openemu'
#try_use_arm_brew install --cask 'rubymine'            # use jetbrains-toolbox for manage versions and more features
try_use_arm_brew install --cask 'sigil'
#try_use_arm_brew install --cask 'slack'               # use web app instead
#try_use_arm_brew install --cask 'vagrant'
#try_use_arm_brew install --cask 'vagrant-manager'
try_use_arm_brew install --cask 'visual-studio-code'
try_use_arm_brew install --cask 'obsidian'
try_use_arm_brew install --cask 'orbstack'
#try_use_arm_brew install --cask 'topnotch'
try_use_arm_brew install --cask 'warp'
#try_use_arm_brew install --cask 'zeplin'              # use sketch workspace web reader instead

try_use_arm_brew bundle --file=-<<EOF
mas '1Password', id: 443_987_910
mas 'Affinity Photo', id: 824183456
mas 'Dark Reader for Safari', id: 1438243180
mas 'Furiganify!', id: 1151320968
mas 'Keynote', id: 409_183_694
mas 'LINE', id: 539_883_307
mas 'Moom', id: 419_330_170
mas 'NepTunes', id: 1006739057
mas 'Numbers', id: 409_203_825
mas 'Octotree', id: 1457450145
mas 'OpenConv', id: 892_308_325
mas 'Pages', id: 409_201_541
mas 'iStat Menus', id: 1_319_778_037
EOF
fi

try_use_arm_brew doctor && try_use_arm_brew update && try_use_arm_brew cleanup && try_use_arm_brew upgrade && try_use_arm_brew cask upgrade
try_use_x86_brew doctor && try_use_x86_brew update && try_use_x86_brew cleanup && try_use_x86_brew upgrade && try_use_x86_brew cask upgrade
