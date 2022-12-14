#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_formulas() {
  e_header "Install formulas" "Start install Homebrew formulas"

  e_log "Install formulas" "Updating..."
  brew update
  check_result $? "Install formulas" "Update"

  e_log "Install formulas" "Installing..."
  case "$(uname)" in
  Darwin)
    e_log "Install formulas" "Installing for macOS..."
    brew bundle --file "$DOTPATH"/etc/macos/Brewfile
    check_result $? "Install formulas" "Install"
    ;;
  Linux)
    e_log "Install formulas" "Installing for Linux..."
    brew bundle --file "$DOTPATH"/etc/linux/Brewfile
    check_result $? "Install formulas" "Install"
    ;;
  *)
    e_log "Install formulas" "Unknown OS"
    e_error "Install formulas" "Install"
    e_log "Install formulas" "Skip the process"
    ;;
  esac

  e_log "Install formulas" "Cleaning up..."
  brew cleanup
  check_result $? "Install formulas" "Clean up"
}

install_formulas
