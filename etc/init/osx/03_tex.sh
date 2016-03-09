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
  sudo ./tlmgr install here supertabular framed wrapfig cases comment subfigure dvipdfmx xparse txfonts
  e_done "Install"
}

setup_auto_extractbb() {
  e_newline && e_header "Setting TeX auto extractbb..."
  TEXPATH=/usr/local/texlive
  sudo mkdir -p $TEXPATH/texmf-local
  for texdir in $(ls $TEXPATH | grep -v texmf-local)
  do
    sudo ln -sfnv $TEXPATH/texmf-local $texdir/texmf-local
  done
  echo "shell_escape_commands = bibtex, bibtex8, bibtexu, upbibtex, biber, kpsewhih, makeindex, mendex, texindy, xindy, mpost, upmpost, repstopdf, epspdf, extractbb" | sudo tee /usr/texmf-local/web2c/texmf.cnf
  e_done "Setup"
}

selfupdate_tex
install_tex_jp_env
install_tex_basic
setup_auto_extractbb
