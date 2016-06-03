if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

install_packages() {
  e_newline && e_header "Installing Packages..."
  dnf install -y git imagemagick ffmpeg curl openssl povray tmux tree unrar wget zsh
  e_done "Install"
}

install_packages
