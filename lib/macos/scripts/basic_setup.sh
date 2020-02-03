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
required_osx_version="10.14.0"
osx_version=$(/usr/bin/sw_vers -productVersion)

info_echo "Checking macOS version"
if [ "$(version "$osx_version")" -lt "$(version "$required_osx_version")" ]; then
  error_echo "Your macOS $osx_version version is older then required $required_osx_version version. Exiting"
  exit
fi

echo "Installing XCode CL tools.."
xcode-select --install

if [[ $(command -v brew) == "" ]]; then
  echo "Installing Homebrew.. "
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo "Updating Homebrew.. "
  brew update
fi

info_echo "ensure mas installed..."
brew tap "Homebrew/bundle" 2> /dev/null
brew bundle --file=- <<EOF
brew "mas"
EOF

info_echo "ensure rbenv installed..."
brew tap "Homebrew/bundle" 2> /dev/null
brew bundle --file=- <<EOF
brew "rbenv"
brew 'ruby-build'
brew 'rbenv-default-gems'
EOF

info_echo "ensure nvm installed"
brew bundle --file=- <<EOF
brew "nvm"
EOF

info_echo "Installing o-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# sudo chsh -s $(which zsh) $(whoami)

info_echo "Enable rbenv alias"
eval "$(rbenv init -)"

if [[ ! -f "$(brew --prefix rbenv)/default-gems" ]]; then
  info_echo "Set default gems list"
  echo "bundler" >> "$(brew --prefix rbenv)/default-gems"
  echo "rails" >> "$(brew --prefix rbenv)/default-gems"
fi

ruby_version="2.6.5"
info_echo "ensure Ruby $ruby_version installed..."
if test -z "$(rbenv versions --bare|grep $ruby_version)"; then
  rbenv install $ruby_version

  info_echo "Set Ruby $ruby_version as global default Ruby"
  rbenv global $ruby_version

  info_echo "Update to latest Rubygems version"
  gem update --system --no-document
fi

info_echo "Enable NVM alias"
# we need disable -e during sourcing nvm.sh b/c of
# https://github.com/creationix/nvm/issues/721
# https://github.com/travis-ci/travis-ci/issues/3854#issuecomment-99492695
set +e
source "$(brew --prefix nvm)/nvm.sh"
set -e


info_echo "Install Node.js LTS version"
nvm install --lts


info_echo "Set latest Node.js version as global default Node"
nvm use --lts

export npm_config_global=true
export npm_config_loglevel=silent
