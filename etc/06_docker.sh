#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_docker() {
  if isArch macOS; then
    e_header "Setup lima" "Start setup lima"

    e_log "Setup lima" "Enabling zsh completion"
    limactl completion zsh >$(brew --prefix)/share/zsh/site-functions/_limactl
    check_result $? "Setup lima" "Enable zsh completion"

    e_log "Setup lima" "Creating VM..."
    limactl create --tty=false --name=x86_64 --arch=x86_64 "$DOTPATH"/share/lima/docker.yml
    limactl create --tty=false --name=aarch64 --arch=aarch64 "$DOTPATH"/share/lima/docker.yml
    limactl start aarch64
    check_result $? "Setup lima" "Create VM"

    e_log "Setup lima" "Setting context..."
    docker context create lima-aarch64 --docker "host=unix://${HOME}/.lima/aarch64/sock/docker.sock"
    check_result $? "Setup lima" "Context create"
    docker context use lima-aarch64
    check_result $? "Setup lima" "Context use"
  elif isArch Linux; then
    e_header "Install docker" "Start installation"

    e_log "Install docker" "Need root privilege"
    sudo printf "\e[32;4mInstall docker\e[0m \e[32mRoot privilege - ✔  OK\e[0m\n"
    if [ $? -ne 0 ]; then
      e_error "Install docker" "Wrong password"
      e_error "Install docker" "Abort the process"
      exit 1
    fi

    e_log "Install docker" "Installing dependencies..."
    sudo apt-get update
    check_result $? "Install docker" "Update apt"
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    check_result $? "Install docker" "Install dependencies"

    e_log "Install docker" "Installing docker..."
    sudo mkdir -p /etc/apt/keyrings
    check_result $? "Install docker" "Create keyrings directory"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    check_result $? "Install docker" "Download gpg"
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    check_result $? "Install docker" "Add to apt source"
    sudo apt-get update
    check_result $? "Install docker" "Update apt"
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    check_result $? "Install docker" "Install docker"

    e_log "Install docker" "Installing docker compose..."
    sudo mkdir -p /usr/lib/docker/cli-plugins
    check_result $? "Install docker" "Create cli-plugins directory"
    sudo curl -Lf -o /usr/lib/docker/cli-plugins/docker-compose "https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64"
    check_result $? "Install docker" "Download docker-compose"
    sudo chmod +x /usr/lib/docker/cli-plugins/docker-compose
    check_result $? "Install docker" "Change access mode of docker-compose"
  else
    e_log "Install docker" "Unknown OS"
    e_error "Install docker" "Install"
    e_log "Install docker" "Skip the process"
  fi
}

install_docker
