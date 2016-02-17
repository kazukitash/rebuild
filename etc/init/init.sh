#!/bin/sh

if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

init() {
  for i in "$DOTPATH"/etc/init/"$(get_os)"/*.sh
  do
    bash $i
  done
}

init
