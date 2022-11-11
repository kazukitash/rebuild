#!/bin/bash -xeu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

setup_lima() {
  e_newline && e_header "[Lima] Installing ..."
  limactl start ~/.dotbuilds/share/lima/default.yml
  docker context create lima-default --docker "host=unix:///Users/kazukitash/.lima/default/sock/docker.sock"
  docker context use lima-default
  e_done "Set up"
}

e_newline && e_header "[Lima] Install"
setup_lima
