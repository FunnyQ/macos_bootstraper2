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

echo "Installing XCode CL tools.."
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
  echo "Installing Homebrew in x86 arch.. "
  try_use_x86 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ $cpu_architecture == "arm64" ]]; then
    echo "Installing Homebrew in arm64 arch.. "
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
else
  echo "Updating Homebrew.. "
  brew update
fi

# install basic tools via homebrew
info_echo "installing basic tools..."
brew tap "Homebrew/bundle" 2> /dev/null
try_use_arm_brew bundle --file=- <<EOF
brew 'autoconf'
brew 'curl-openssl'
brew 'gnupg'
brew 'libevent'
brew 'libtool'
brew 'libyaml'
brew 'vim'
brew 'z'
brew 'bat'
brew 'asdf'
EOF
try_use_x86_brew bundle --file= <<EOF
brew 'exa'
brew "mas"
EOF

# config for asdf
if [ ! -f ~/.asdfrc ]; then
cat > ~/.asdfrc <<EOF
  legacy_version_file = yes

EOF
fi

info_echo "Installing o-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install ruby
ruby_version="2.7.3"
info_echo "ensure Ruby $ruby_version installed..."
if test -z "$(asdf list ruby --bare|grep $ruby_version)"; then
  # set bundler as default gems
  if [ ! -f ~/.default-gems ]; then
cat > ~/.default-gems <<EOF
  bundler

EOF
  fi

  try_use_x86 asdf install ruby $ruby_version

  info_echo "Set Ruby $ruby_version as global default Ruby"
  asdf global ruby $ruby_version

  info_echo "Update to latest Rubygems version"
  gem update --system --no-document
fi

# install nodejs
info_echo "Install Node.js LTS version"
nodejs_version="14.15.3"
if test -z "$(asdf list ruby --bare|grep $ruby_version)"; then
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
  try_use_x86 asdf install nodejs $nodejs_version

  info_echo "Set nodejs $ruby_version as global default"
  asdf global nodejs $nodejs_version
fi

export npm_config_global=true
export npm_config_loglevel=silent
