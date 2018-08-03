if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

symlink_sources() {
  e_newline && e_header "Symlinking Program Sources..."
  ln -sfnv ~/Dropbox/sources ~/sources
    e_done "Symlink"
}

symlink_sources
