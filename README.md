# dotfiles

[![macos](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml) [![linux](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml)

## インストールの仕方

スクリプトを Github から curl でダウンロードして実行する。

### Linux

```bash
sudo /bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotbuilds/main/install.sh)"
```

### macOS

```bash
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotbuilds/main/install.sh)"
```

## アップデートの仕方

Makefile の install コマンドを実行する。

```bash
make install
```

## インストール内容

### HomeBrew

以下の設定をする。

1. Xcode CLI のインストール
2. HomeBrew のインストール
3. Formula のインストール

インストールする Formula は以下の通り。

**macOS**

- Programing
  - brew "anyenv"
  - cask "github"
- Browser
  - cask "google-chrome"
- Image & Video
  - brew "ffmpeg"
  - brew "imagemagick"
- Git
  - brew "gh"
  - brew "diff-so-fancy"
- zsh syntax highlighting
- brew "zsh-syntax-highlighting"
- IME
  - cask "visual-studio-code"
- Cleaner
  - cask "appcleaner"

**Linux**

- Programing
  - brew "anyenv"
- Image & Video
  - brew "ffmpeg"
  - brew "imagemagick"
- Git
  - brew "gh"
  - brew "diff-so-fancy"
- zsh syntax highlighting
  - brew "zsh-syntax-highlighting"

### Ruby

rbenv 上の最新の Ruby をインストールする。

（参考）最新バージョンの取得方法

```bash
rbenv install -L | grep -v - | grep -e "^[ ]*[0-9].*" | tail -1
```

以下の Gem をインストールする。

なし

### Node

nodenv 上の最新の Node をインストールする。

以下の module をインストールする。

- typescript

### Python

pyenv 上の最新の Python をインストールする。

以下の package をインストールする。

なし

## Makefile

使い方は以下のコマンドで確認する。

```bash
make help
```
