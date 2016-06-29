LAB=$HOME/Dropbox/laboratory
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$HOME/.zplug/bin:$PYENV_ROOT/bin:$HOME/.rbenv/bin:$HOME/.nodebrew/current/bin:/usr/local/sbin:$PATH:/opt/ImageMagick/bin:$HOME/bin:$LAB/bin
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export EDITOR="subl -w"
export RUBYLIB="$RUBYLIB:$LAB/lib"

(type rbenv >/dev/null 2>&1) && eval "$(rbenv init -)"
(type pyenv >/dev/null 2>&1) && eval "$(pyenv init -)"

# [b4b4r07/zplug: A next-generation plugin manager for zsh](https://github.com/b4b4r07/zplug)
setup_zplug() {
  source ~/.zplug/init.zsh
  zplug "b4b4r07/zplug"

  zplug "zsh-users/zsh-syntax-highlighting", nice:19

  zplug "kuahitz/tachyon2jpeg", as:command, use:bin/tachyon2jpeg

  zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf
  zplug "b4b4r07/easy-oneliner", on:"junegunn/fzf-bin"

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
    echo
    export ZPLUG_HOME=~/.zplug
    curl -sL get.zplug.sh | zsh
    setup_zplug
  fi
fi
