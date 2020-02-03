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

info_echo "Install Brew formalue"
brew tap "Homebrew/bundle" 2> /dev/null
brew bundle --file=$1
