export DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

all: install

help:
	@echo "make prepare        #=> setupに必要なパッケージをインストールする。一度だけ実行する"
	@echo "make setup          #=> インストールスクリプトの実行"
	@echo "make update         #=> このリポジトリの変更をFetchする"
	@echo "make install        #=> make update, setupを実行する"

prepare:
	@/bin/bash $(DOTPATH)/etc/prepare.sh

setup:
	@/bin/bash $(DOTPATH)/etc/setup.sh

update:
	git pull origin main

install: update setup
	@exec $$SHELL
