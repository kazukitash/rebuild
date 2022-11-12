#!/bin/bash -eu

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
[ "$(uname)" = "Linux" ] && export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

TARBALL_URL=https://github.com/kazukitash/dotfiles/archive/main.tar.gz
if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=~/.rebuild
fi
GITHUB_URL=https://github.com/kazukitash/rebuild.git

has() {
  type "$1" >/dev/null 2>&1
  return $?
}

if has "anyenv"; then
  eval "$(anyenv init -)"
  if has "rbenv"; then
    RUBY_VERSION=$(rbenv install -l | grep -v - | grep -e "^[ ]*[0-9]\+.[0-9]\+.[0-9]\+$" | tail -1)
  fi
  if has "nodenv"; then
    NODE_VERSION=$(nodenv install -l | grep -v - | grep -e "^[ ]*[0-9]\+.[0-9]\+.[0-9]\+$" | tail -1)
  fi
  if has "pyenv"; then
    PYTHON_VERSION=3.10.8
  fi
fi

e_header() {
  printf "\n\e[33;4m%s\e[0m \e[33;1m%s\e[0m\n" "$1" "$2"
}

e_log() {
  printf "\e[37;4m%s\e[0m \e[37m%s\e[0m\n" "$1" "$2"
}

e_done() {
  printf "\e[32;4m%s\e[0m \e[32m%s - ✔  OK\e[0m\n" "$1" "$2"
}

e_error() {
  printf "\e[31;4m%s\e[0m \e[31m%s - ✖  Failed\e[0m\n" "$1" "$2" 1>&2
}

dotfiles_download() {
  e_newline && e_header "Downloading dotfiles..."
  if has "git"; then
    git clone --recursive "$GITHUB_URL" "$DOTPATH"
  elif has "curl" || has "wget"; then
    if has "curl"; then
      curl -L "$TARBALL_URL"
    elif has "wget"; then
      wget -O - "$TARBALL_URL"
    fi | tar xvz
    if [ ! -d dotfiles-main ]; then
      e_error "dotfiles-main: not found"
      exit 1
    fi
    mv -f dotfiles-main "$DOTPATH"
  else
    e_error "curl or wget required"
    exit 1
  fi
  e_done "Download"
}

dotfiles_deploy() {
  e_newline && e_header "Deploying dotfiles..."
  cd "$DOTPATH"
  make deploy
  e_done "Deploy"
}

dotfiles_setup() {
  e_newline && e_header "Setting dotfiles..."
  cd "$DOTPATH"
  make setup
  e_done "Set up"
}

dotfiles_logo='
██████╗ ███████╗██████╗ ██╗   ██╗██╗██╗     ██████╗
██╔══██╗██╔════╝██╔══██╗██║   ██║██║██║     ██╔══██╗
██████╔╝█████╗  ██████╔╝██║   ██║██║██║     ██║  ██║
██╔══██╗██╔══╝  ██╔══██╗██║   ██║██║██║     ██║  ██║
██║  ██║███████╗██████╔╝╚██████╔╝██║███████╗██████╔╝
╚═╝  ╚═╝╚══════╝╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝
'

# main
# shell の option を確認してインタラクティブである場合は終了する
if echo "$-" | grep -q "i"; then
  e_newline && e_error "Can not continue with interactive shell. Abort the process"
  exit 1
else
  # 実行ソースを確認して、ファイルから実行している場合（bash a.sh）はライブラリのみ読み込んで続ける。
  if [ "$0" = "${BASH_SOURCE:-}" ] || [ "${DOTPATH}/install.sh" = "${BASH_SOURCE:-}" ]; then
    e_done "Libraries are load"
  else
    # bash -c "$(cat a.sh)" もしくは cat a.sh | bash の場合実行する
    # BASH_EXECUTION_STRING で -c オプションで渡された文字列を出力する。nullなら:-で空文字列に置換し-nで空文字列判定する
    # パイプで渡されていたら/dev/stdinがFIFOになりパイプとして判定される
    if [ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]; then
      case "$(uname)" in
      "Darwin" | "Linux")
        e_newline && e_header "Start installation for macOS/Linux..."
        ;;
      *)
        e_newline && e_error "Unknown OS. Abort the process"
        exit 1
        ;;
      esac
      echo "$dotfiles_logo"
      dotfiles_download
      dotfiles_deploy
      dotfiles_setup
      e_done "All processing"
      e_newline && e_header "Now continue with rebooting your shell."
    fi
  fi

prepare() {
  e_header "Prepare" "Start prepare"

  e_log "Prepare" "Changing directory..."
  cd "$DOTPATH"

  e_log "Prepare" "Preparing..."
  make prepare
  e_done "Prepare" "Prepare"
}
  prepare
fi
