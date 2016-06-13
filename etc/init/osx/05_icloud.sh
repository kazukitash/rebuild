if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

symlink_icloud() {
  e_newline && e_header "Symlinking iCloud Drive..."
  ln -sfnv ~/Library/Mobile\ Documents/com~apple~CloudDocs ~/iCloud
  e_done "Symlink"
}

symlink_sources() {
  e_newline && e_header "Symlinking Program Sources..."
  ln -sfnv ~/Library/Mobile\ Documents/com~apple~CloudDocs/sources/c ~/c_src
  ln -sfnv ~/Library/Mobile\ Documents/com~apple~CloudDocs/sources/javascript ~/js_src
  ln -sfnv ~/Library/Mobile\ Documents/com~apple~CloudDocs/sources/python ~/py_src
  ln -sfnv ~/Library/Mobile\ Documents/com~apple~CloudDocs/sources/ruby ~/rb_src
  ln -sfnv ~/Library/Mobile\ Documents/com~apple~CloudDocs/sources/shell ~/sh_src
  ln -sfnv ~/Library/Mobile\ Documents/com~apple~CloudDocs/sources/www ~/www_src
  e_done "Symlink"
}

symlink_icloud
symlink_sources
