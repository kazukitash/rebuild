#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_docker() {
  case "$(uname)" in
  Darwin)
    e_header "Setup lima" "Start setup lima"

    e_log "Setup lima" "Enabling zsh completion"
    limactl completion zsh >$(brew --prefix)/share/zsh/site-functions/_limactl
    check_result $? "Setup lima" "Enable zsh completion"

    e_log "Setup lima" "Creating VM..."
    limactl start --name=default ~/.dotbuilds/share/lima/default.yml
    check_result $? "Setup lima" "Create VM"

    e_log "Setup lima" "Setting context..."
    docker context create lima-default --docker "host=unix://${HOME}/.lima/default/sock/docker.sock"
    check_result $? "Setup lima" "Context create"
    docker context use lima-default
    check_result $? "Setup lima" "Context use"
    ;;
  Linux)
    e_header "Install docker" "Start installation"

    e_log "Install docker" "Installing dependencies..."
    apt-get update
    check_result $? "Install docker" "Update apt"
    apt-get install ca-certificates curl gnupg lsb-release
    check_result $? "Install docker" "Install dependencies"

    e_log "Install docker" "Installing docker..."
    mkdir -p /etc/apt/keyrings
    check_result $? "Install docker" "Create keyrings directory"
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    check_result $? "Install docker" "Download gpg"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
    check_result $? "Install docker" "Add to apt source"
    apt-get update
    check_result $? "Install docker" "Update apt"
    apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    check_result $? "Install docker" "Install docker"

    e_log "Install docker" "Installing docker compose..."
    mkdir -p /usr/lib/docker/cli-plugins
    check_result $? "Install docker" "Create cli-plugins directory"
    curl -Lf -o /usr/lib/docker/cli-plugins/docker-compose "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64"
    check_result $? "Install docker" "Download docker-compose"
    chmod +x /usr/lib/docker/cli-plugins/docker-compose
    check_result $? "Install docker" "Change access mode of docker-compose"
    ;;
  *)
    e_log "Install docker" "Unknown OS"
    e_error "Install docker" "Install"
    e_log "Install docker" "Skip the process"
    ;;
  esac
}

install_docker
