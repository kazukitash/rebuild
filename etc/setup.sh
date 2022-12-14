#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

setup() {
  for i in $(ls "$DOTPATH"/etc | grep .sh$ | grep -v setup); do
    /bin/bash ${DOTPATH}/etc/$i
  done
}

setup
