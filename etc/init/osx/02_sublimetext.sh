if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

symlink_sublimetext_packages() {
  e_newline && e_header "Symlinking SublimeText Packages..."
  e_header "removing..."
  rm -rfv ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages
  rm -rfv ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
  e_header "symlinking..."
  ln -sfnv ~/.sublimetext/Installed\ Packages ~/Library/Application\ Support/Sublime\ Text\ 3
  ln -sfnv ~/.sublimetext/Packages ~/Library/Application\ Support/Sublime\ Text\ 3
  e_done "Symlink"
}

change_sublimetext_icon() {
  e_newline && e_header "Changing SublimeText Icon..."
  ln -sfnv ~/.sublimetext/Material-Theme-Icon/Icon.icns /Applications/Sublime\ Text.app/Contents/Resources/Sublime\ Text.icns
  e_done "Change"
}

symlink_sublimetext_packages
change_sublimetext_icon
