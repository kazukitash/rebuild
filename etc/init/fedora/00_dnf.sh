if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

enable_rpm_fusion() {
  e_newline && e_header "Enable RPM Fusion..."
  su -c 'dnf install -y http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'
  e_done "Enable"
}

install_packages() {
  e_newline && e_header "Installing Packages..."
  su -c 'dnf install -y git imagemagick ffmpeg curl openssl povray tmux tree wget zsh gcc'
  e_done "Install"
}

enable_rpm_fusion
install_packages
