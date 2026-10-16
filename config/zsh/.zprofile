### Homebrew

if [[ -e /home/linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -e /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi



### PATH

path=(~/.local/bin(N-/) $path)
path=(~/.devcontainers/bin(N-/) $path)
path=(~/bin(N-/) $path)

# 重複を削除する
typeset -U path



### Zellij

# VSCode の Terminal 起動時に zellij を起動する
if [[ "$TERM_PROGRAM" = vscode ]] && [[ -o interactive ]] && [[ -z "$ZELLIJ" ]] && command -v zellij &>/dev/null; then
  ~/dotfiles/bin/zellij-here
fi
