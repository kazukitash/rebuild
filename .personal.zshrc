export PATH=$HOME/.zplug/bin:$HOME/.rbenv/bin:/usr/local/bin:$PATH:/opt/ImageMagick/bin:$HOME/bin
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export EDITOR="subl -w"

(type rbenv >/dev/null 2>&1) && eval "$(rbenv init -)"

# [b4b4r07/zplug: A next-generation plugin manager for zsh](https://github.com/b4b4r07/zplug)
setup_zplug() {
  source ~/.zplug/zplug
  zplug "b4b4r07/zplug"

  zplug "zsh-users/zsh-syntax-highlighting", nice:19

  zplug "kazukitash/tachyon2jpeg", as:command, of:bin/tachyon2jpeg

  zplug "junegunn/fzf-bin", as:command, from:gh-r, file:fzf | zplug "b4b4r07/easy-oneliner"

  # you must install terminal-notifier at HomeBrew before install marzocchi/zsh-notify
  if type terminal-notifier >/dev/null 2>&1; then
    zplug "marzocchi/zsh-notify"
    export SYS_NOTIFIER="$(which terminal-notifier)"
    export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10
  fi

  [ ! $(zplug check) ] && zplug install
  zplug load

  [ -f ~/.oneliner ] && ln -fns ~/.oneliner ~/.zplug/repos/b4b4r07/easy-oneliner/easy-oneliner.txt
}

if [ -f ~/.zplug/zplug ]; then
  setup_zplug
else
  printf "Could not find zplug. Would you install zplug? [y/N]: "
  if read -q; then
    echo; curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
    setup_zplug
  fi
fi
