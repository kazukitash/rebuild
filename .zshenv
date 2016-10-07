# インンタラクティブシェルでもSSHでつないだシェルでも常に実行される
# 言語環境設定
export LANG=ja_JP.UTF-8

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=5000000
SAVEHIST=5000000

# 拡張設定
setopt auto_cd            # cdなしで移動
setopt globdots           # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt brace_ccl          # 範囲指定できるようにする。例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt hist_ignore_dups   # 重複した履歴を残さない

alias _=sudo
alias please=sudo
alias brew="env PATH=${PATH/$PYENV_ROOT\/shims:/} brew"
alias brews='brew list -1'
alias bubc='brew upgrade && brew cleanup'
alias bubo='brew update && brew outdated'
alias bubu='bubo && bubc'
alias ga='git add'
alias gcm='git commit -m'
alias gpl='git pull'
alias gph='git push'
alias gpp='gpl && gph'
alias grhh='git reset --hard HEAD'
alias gd="git diff"
alias tf='tail -f'
alias history='fc -l 1'
alias l='ls -lahp'
alias la='ls -lAhp'
alias ll='ls -lhp'
alias ls='ls -Gp'
alias lsa='ls -lahp'
alias mcm='make clean; make'
alias md='mkdir -p'

(type rbenv >/dev/null 2>&1) && eval "$(rbenv init -)"
(type pyenv >/dev/null 2>&1) && eval "$(pyenv init -)"

export PYENV_ROOT="$HOME/.pyenv"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
