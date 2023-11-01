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

# Check macOS version
required_osx_version="11.1"
osx_version=$(/usr/bin/sw_vers -productVersion)

info_echo "Checking macOS version"
if [ "$(version "$osx_version")" -lt "$(version "$required_osx_version")" ]; then
  error_echo "Your macOS $osx_version version is older then required $required_osx_version version. Exiting"
  exit
fi

echo "Installing XCode CLI tools.."
xcode-select --install

# identify CPU architecture
cpu_architecture="$(uname -m)"

alias try_use_x86=""
alias try_use_x86_brew="brew"
alias try_use_arm_brew="brew"

if [[ $cpu_architecture == "arm64" ]]; then

  echo "Installing Rosetta 2.."
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license

  alias try_use_x86="arch -x86_64"
  alias try_use_x86_brew="arch -x86_64 /usr/local/homebrew/bin/brew"
  alias try_use_arm_brew="arch -arm64 /opt/homebrew/bin/brew"
fi

# Homebrew
if [[ $(command -v brew) == "" ]]; then
  if [[ $cpu_architecture == "arm64" ]]; then
    echo "Installing Homebrew in arm64 arch.. "
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo 'export PATH=/opt/homebrew/bin:$PATH' >> $HOME/.zshrc
  fi
  echo "Installing Homebrew in x86 arch.. "
  try_use_x86 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  echo 'export PATH=/usr/local/bin:$PATH' >> $HOME/.zshrc
else
  echo "Updating Homebrew.. "
  try_use_arm_brew update
  try_use_x86_brew update
fi

# install basic tools via homebrew
info_echo "installing basic tools..."

try_use_arm_brew install autoconf
try_use_arm_brew install curl-openssl
try_use_arm_brew install gnupg
try_use_arm_brew install libevent
try_use_arm_brew install libtool
try_use_arm_brew install libyaml
try_use_arm_brew install vim
try_use_arm_brew install zoxide
try_use_arm_brew install bat
try_use_arm_brew install exa
try_use_arm_brew install mas
try_use_arm_brew install mackup
try_use_arm_brew install fzf


if [ ! -f ~/.oh-my-zsh ]; then
  info_echo "Installing o-my-zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# config for asdf
if [ ! -f ~/.asdfrc ]; then
  info_echo "install asdf"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0
  echo '. $HOME/.asdf/asdf.sh' >> $HOME/.zshrc
  info_echo ".asdfrc not existed, will create one for support legacy version files..."
cat > ~/.asdfrc <<EOF
  legacy_version_file = yes

EOF
source ~/.zshrc
fi

# install ruby
ruby_version="3.2.2"
info_echo "ensure Ruby $ruby_version installed..."
if test -z "$(asdf list ruby --bare|grep $ruby_version)"; then
  # set bundler as default gems
  if [ ! -f ~/.default-gems ]; then
cat > ~/.default-gems <<EOF
  bundler

EOF
  fi
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git

  asdf install ruby $ruby_version

  info_echo "Set Ruby $ruby_version as global default Ruby"
  asdf global ruby $ruby_version

  info_echo "Update to latest Rubygems version"
  gem update --system --no-document
fi

# install nodejs
info_echo "Install Node.js LTS version"
nodejs_version="lts-gallium"
if test -z "$(asdf list nodejs --bare|grep $nodejs_version)"; then

  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
  try_use_x86 asdf install nodejs $nodejs_version

  info_echo "Set nodejs $nodejs_version as global default"
  asdf global nodejs $nodejs_version
fi

export npm_config_global=true
export npm_config_loglevel=silent
