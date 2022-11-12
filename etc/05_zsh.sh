#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

setup_zsh() {
  if [ "$(uname)" = "Linux" ]; then
    e_header "Setup zsh" "Start setup"
    ZSH_PATH=$(which zsh)

    e_log "Setup zsh" "Need root privilege"
    sudo e_done "Setup zsh" "root privilege"
    if [ $1 -ne 0 ]; then
      e_error "Setup zsh" "Wrong password"
      e_error "Setup zsh" "Abort the process"
      exit 1
    fi

    e_log "Setup zsh" "Adding shells..."
    sudo ZSH_PATH >>/etc/shells
    check_result $? "Setup zsh" "Add shells"

    e_log "Setup zsh" "Changing default shell..."
    sudo chsh -s ZSH_PATH
    check_result $? "Setup zsh" "Change default shell"
  fi
}

setup_zsh