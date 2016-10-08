if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

cd "$DOTPATH"/etc/init/assets/ruby

install_ruby() {
  e_newline && e_header "Installing Ruby..."
  if rbenv versions | grep -q "$RUBY_VERSION"; then
    e_header "Ruby is already installed"
  else
    rbenv install $RUBY_VERSION
    if [ $? -ne 0 ]; then
      e_error "failed to install Ruby"
      exit 1
    fi
  fi
  rbenv global $RUBY_VERSION
  e_done "Install"
}

install_gems() {
  e_newline && e_header "Installing Ruby gems..."
  rbenv exec gem install bundler
  if [ $? -ne 0 ]; then
    e_error "failed to install gem bundler"
    exit 1
  fi
  bundle install
  e_done "Install"
}

install_my_gems() {
  e_newline && e_header "Installing My gems..."
  gem specific_install -l "https://github.com/kazukitash/pihman"
  e_done "Install"
}

install_ruby
install_gems
install_my_gems