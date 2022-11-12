#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_python() {
  e_header "Install Python" "Start installation Python"

  e_log "Install Python" "Checking installed Python..."
  if pyenv versions | grep -q $(echo $PYTHON_VERSION); then
    e_done "Install Python" "ver.$PYTHON_VERSION is already installed"
  else
    e_log "Install Python" "ver.$PYTHON_VERSION is NOT installed"
    e_log "Install Python" "Installing ver.$PYTHON_VERSION..."
    pyenv install $PYTHON_VERSION
    check_result $? "Install Python" "Install"
  fi

  e_log "Install Python" "Changing global Python version..."
  pyenv global $PYTHON_VERSION
  check_result $? "Install Python" "Change global Python version"
}

install_packages() {
  e_header "Install packages" "Start installation Python packages"

  e_log "Install packages" "Updating pip..."
  pip install --upgrade pip
  check_result $? "Install packages" "Update pip"

  case "$(uname)" in
  Darwin)
    e_done "Install packages" "Installing for macOS..."
    pip install -r ${DOTPATH}/etc/macos/requirements.txt
    check_result $? "Install packages" "Install"
    ;;
  Linux)
    e_done "Install packages" "Installing for Linux..."
    pip install -r ${DOTPATH}/etc/linux/requirements.txt
    check_result $? "Install packages" "Install"
    ;;
  *)
    e_log "Install packages" "Unknown OS"
    e_error "Install packages" "Install"
    e_log "Install packages" "Skip the process"
    ;;
  esac

  e_log "Install packages" "Cleaning packages"
  pip cache purge
  check_result $? "Install packages" "Cleanup packages"
}

install_python
install_packages
