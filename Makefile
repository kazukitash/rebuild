DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*) bin
EXCLUSIONS := .DS_Store .git
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

all: install

help:
	@echo "make list           #=> Show dot files in this repo"
	@echo "make deploy         #=> Create symlink to home directory"
	@echo "make update         #=> Fetch changes for this repo"
	@echo "make install        #=> Run make update, deploy, init"
	@echo "make clean          #=> Remove the dot files and this repo"

list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

update:
	git pull origin master

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

install: update deploy
	@exec $$SHELL
