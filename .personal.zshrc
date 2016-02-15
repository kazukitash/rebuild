export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.rbenv/bin:/opt/X11/bin:/opt/ImageMagick/bin"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export EDITOR="subl -w"

eval "$(rbenv init -)"

# [b4b4r07/zplug: A next-generation plugin manager for zsh](https://github.com/b4b4r07/zplug)
load_zplug() {
  source ~/.zplug/zplug
  zplug "b4b4r07/zplug"

  zplug "zsh-users/zsh-syntax-highlighting", nice:19

  zplug "junegunn/fzf-bin", as:command, from:gh-r, file:fzf | zplug "b4b4r07/easy-oneliner"

  # you must install terminal-notifier at HomeBrew before install marzocchi/zsh-notify
  zplug "marzocchi/zsh-notify"
  export SYS_NOTIFIER="$(which terminal-notifier)"
  export NOTIFY_COMMAND_COMPLETE_TIMEOUT=10

  [ ! $(zplug check) ] && zplug install
  zplug load

  [ -f ~/.oneliner.sh ] && ln -fns ~/.oneliner.sh ~/.zplug/repos/b4b4r07/easy-oneliner/easy-oneliner.txt
}

if [ -f ~/.zplug/zplug ]; then
  load_zplug
else
  printf "Install zplug? [y/N]: "
  if read -q; then
    echo; curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
    load_zplug
  fi
fi

