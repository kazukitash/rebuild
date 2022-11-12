#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_formulas() {
  e_newline && e_header "[Homebrew] Installing formulas..."
  brew tap Homebrew/bundle
  if [ $? -ne 0 ]; then
    e_error "Tap Homebrew/bundle"
    exit 1
  fi
  case "$(uname)" in
  Darwin)
    e_done "OS detected. Start installation for macOS"
    brew bundle --file "$DOTPATH"/etc/macos/Brewfile
    ;;
  Linux)
    e_done "OS detected. Start installation for Linux"
    brew bundle --file "$DOTPATH"/etc/linux/Brewfile
    e_done "Zsh installed. Run following script to change your default shell \necho \$(which zsh) >>/etc/shells\nchsh -s \$(which zsh)"
    ;;
  *)
    e_error "Unknown OS. Abort the process"
    ;;
  esac
  e_done "Install"
}

install_formulas
