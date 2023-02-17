#!/bin/bash -eu

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
if [ "$(uname)" = "Linux" ]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
else
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

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

check_result() {
  if [ $1 -eq 0 ]; then
    e_done "$2" "$3 completed"
  else
    e_error "$2" "$3 failed"
    exit 1
  fi
}

# shell の option を確認してインタラクティブである場合は終了する
check_interactive_shell() {
  if echo "$-" | grep -q "i"; then
    e_error "Check execution" "Can not continue with interactive shell. Abort the process"
    exit 1
  fi
}

# 実行ソースを確認して、ファイルから実行している場合（bash a.sh）はライブラリのみ読み込んで続ける。
check_execution_by_file() {
  if [ "$0" = "${BASH_SOURCE:-}" ] || [ "${DOTPATH}/install.sh" = "${BASH_SOURCE:-}" ]; then
    e_done "Check execution" "Libraries are load"
    return 1
  else
    return 0
  fi
}

# bash -c "$(cat a.sh)" もしくは cat a.sh | bash の場合実行する
# BASH_EXECUTION_STRING で -c オプションで渡された文字列を出力する。nullなら:-で空文字列に置換し-nで空文字列判定する
# パイプで渡されていたら/dev/stdinがFIFOになりパイプとして判定される
check_execution_by_string() {
  if !([ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]); then
    e_error "Check exection" "Can not continue with the execution type. Abort the process"
    exit 1
  fi
}

# macOSとLinuxのみ実行
check_os() {
  case "$(uname)" in
  "Darwin")
    e_done "Check OS" "macOS"
    e_log "Check OS" "Start installation for macOS"
    ;;
  "Linux")
    e_done "Check OS" "Linux"
    e_log "Check OS" "Start installation for Linux"
    ;;
  *)
    e_log "Check OS" "Unknown OS"
    e_error "Check OS" "Abort the process"
    exit 1
    ;;
  esac
}

dotfiles_logo='
██████╗ ███████╗██████╗ ██╗   ██╗██╗██╗     ██████╗
██╔══██╗██╔════╝██╔══██╗██║   ██║██║██║     ██╔══██╗
██████╔╝█████╗  ██████╔╝██║   ██║██║██║     ██║  ██║
██╔══██╗██╔══╝  ██╔══██╗██║   ██║██║██║     ██║  ██║
██║  ██║███████╗██████╔╝╚██████╔╝██║███████╗██████╔╝
╚═╝  ╚═╝╚══════╝╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝
'

download_rebuild() {
  e_header "Download rebuild" "Start download rebuild repository"

  e_log "Download rebuild" "Downloading..."
  if !([ -e ~/.rebuild ]); then
    git clone --recursive "$GITHUB_URL" "$DOTPATH"
  fi
  check_result $? "Download rebuild" "Download"
}

prepare() {
  e_header "Prepare" "Start prepare"

  e_log "Prepare" "Changing directory..."
  cd "$DOTPATH"

  e_log "Prepare" "Preparing..."
  make prepare
  e_done "Prepare" "Prepare"
}

setup_rebuild() {
  e_header "Setup rebuild" "Start setup rebuild"

  e_log "Setup rebuild" "Changing directory..."
  cd "$DOTPATH"

  e_log "Setup rebuild" "Setting..."
  make setup
  e_done "Setup rebuild" "Setup"
}

# main
check_interactive_shell
if check_execution_by_file; then
  check_execution_by_string
  check_os
  echo "$dotfiles_logo"
  download_rebuild
  prepare
  setup_rebuild
fi
