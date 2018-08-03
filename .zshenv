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
setopt no_global_rcs      # macOSの/etc/zprofileに余計なことが書いてあるので読まない
setopt hist_ignore_dups   # 重複した履歴を残さない

alias _=sudo
alias please=sudo
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

# python3用の設定
alias python='python3'
alias pip='pip3'
alias python2='/usr/bin/python'

# PDF結合
alias pdfjoin='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

export PATH=$HOME/.zplug/repos/b4b4r07/zplug/bin:$HOME/.zplug/bin:$HOME/.nodebrew/current/bin:/opt/X11/bin:/opt/ImageMagick/bin:$HOME/.rbenv/bin:$HOME/.nodebrew/current/bin:$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
export NODEBREW_ROOT=/usr/local/var/nodebrew

(type rbenv >/dev/null 2>&1) && eval "$(rbenv init -)"
