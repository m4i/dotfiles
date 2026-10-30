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
  run brew bundle install --no-upgrade
fi


### mise

if ! command -v mise &>/dev/null && [[ ! -x ~/.local/bin/mise ]]; then
  curl -fsSL https://mise.run | sh
fi
export PATH="$HOME/.local/bin:$PATH"
run mise trust
run mise bootstrap --skip-dirty


### git

run mkdir -p ~/.config/git

# credential helper 等が書き込むので、Git の config は通常のファイルにする。
# 既存ファイルは保持し、初回のみ ~/dotfiles の設定を相対パスで include する。
if [[ ! -f ~/.config/git/config ]]; then
  run cp config/git/config-template ~/.config/git/config
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

PATH=~/.local/share/aquaproj-aqua/bin:$PATH

export AQUA_GLOBAL_CONFIG=~/.config/aquaproj-aqua/aqua.yaml
if [[ "$(uname -s)" == "Linux" ]]; then
  AQUA_GLOBAL_CONFIG=~/.config/aquaproj-aqua/aqua-linux.yaml:$AQUA_GLOBAL_CONFIG
fi

if [[ ! -d ~/.local/share/aquaproj-aqua ]]; then
  curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.4/aqua-installer | bash
fi

run aqua install --all


### herdr

if ! herdr plugin list --json | grep -q chmarax.herdr-nvim; then
  run herdr plugin install --yes ChmaraX/herdr-nvim
fi


### private

run config-private/install.sh
