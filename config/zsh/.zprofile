command -v brew &>/dev/null && eval "$(brew shellenv)"

# VSCode の Terminal 起動時に zellij を起動する
if [[ "$TERM_PROGRAM" = vscode ]] && [[ -o interactive ]] && [[ -z "$ZELLIJ" ]] && command -v zellij &>/dev/null; then
  ~/dotfiles/bin/zellij-here
fi
