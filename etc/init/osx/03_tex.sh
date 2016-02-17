if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

cd /Library/TeX/texbin

selfupdate_tex() {
  e_newline && e_header "Updating TeX distributions..."
  sudo ./tlmgr update --self --all
  e_done "Update"
}

install_tex_jp_env() {
  e_newline && e_header "Installing TeX jp environment packages..."
  sudo ./tlmgr install ptex ptex2pdf jfontmaps jsclasses japanese-otf
  e_done "Install"
}

install_tex_basic() {
  e_newline && e_header "Installing TeX basic packages..."
  sudo ./tlmgr install here supertabular framed wrapfig cases comment subfigure
  e_done "Install"
}

selfupdate_tex
install_tex_jp_env
