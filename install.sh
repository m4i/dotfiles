#!/usr/bin/env bash
set -euo pipefail

function run() {
  echo "+ $*"
  "$@"
}

cd "$(dirname "${BASH_SOURCE[0]}")"


### Homebrew

if [[ "$(uname -s)" == Darwin ]]; then
  if [[ ! -x /opt/homebrew/bin/brew ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv bash)"
fi


### mise

if ! command -v mise &>/dev/null && [[ ! -x ~/.local/bin/mise ]]; then
  curl -fsSL https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"
run mise trust
run mise bootstrap --skip repos


### git

run mkdir -p ~/.config/git

# credential helper 等が書き込むので、Git の config は通常のファイルにする。
# 既存ファイルは保持し、初回のみ ~/dotfiles の設定を相対パスで include する。
if [[ ! -f ~/.config/git/config ]]; then
  cat > ~/.config/git/config <<'__EOF__'
[include]
	path = ../../dotfiles/config/git/config
__EOF__
fi

# github/gitignore の OS・エディタ用テンプレートを結合する。
{
  for template in macOS Windows Vim mise; do
    echo "### https://github.com/github/gitignore/blob/main/Global/$template.gitignore"
    curl -fsSL "https://raw.githubusercontent.com/github/gitignore/main/Global/$template.gitignore"
    echo
  done
} > ~/.config/git/ignore


### aqua

PATH=~/.local/share/aquaproj-aqua/bin:~/.cargo/bin:$PATH
export AQUA_GLOBAL_CONFIG=~/.config/aquaproj-aqua/aqua.yaml
AQUA_MACOS_CONFIG=~/.config/aquaproj-aqua/aqua-macos.yaml
AQUA_LINUX_CONFIG=~/.config/aquaproj-aqua/aqua-linux.yaml

# aqua は macOS では cargo が必要
if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ ! -e ~/.cargo/bin/cargo ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
  fi
  # aqua でインストールするバイナリが Homebrew を前提としているものは動かないので cargo install する
  sed -En 's! *- +name: +[^/]+/([^@]+)@([^ ]+) *$!\1 \2!p' "$AQUA_LINUX_CONFIG" |
    while read -r crate version; do
      case "$crate" in
        sheldon)
          options=(--features vendored-openssl)
          ;;
        *)
          options=()
          ;;
      esac
      run cargo install "$crate" --version "$version" --locked "${options[@]}"
    done
  AQUA_GLOBAL_CONFIG=$AQUA_MACOS_CONFIG:$AQUA_GLOBAL_CONFIG
else
  AQUA_GLOBAL_CONFIG=$AQUA_LINUX_CONFIG:$AQUA_GLOBAL_CONFIG
fi

if [[ ! -d ~/.local/share/aquaproj-aqua ]]; then
  curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.4/aqua-installer | bash
fi

run aqua install --all


### private

config-private/install.sh
