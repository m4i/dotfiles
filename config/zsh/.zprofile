### Homebrew

if [[ -e /home/linuxbrew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -e /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi



### PATH

path=(~/bin(N-/) $path)

# 重複を削除する
typeset -U path



### Zellij

# VSCode の Terminal 起動時に zellij を起動する
if [[ "$TERM_PROGRAM" = vscode ]] && [[ -o interactive ]] && [[ -z "$ZELLIJ" ]] && command -v zellij &>/dev/null; then
  session_name=$(pwd | sed -e "s@^$HOME/@HOME/@" -e s@^/@@ -e 's/[^-0-9A-Za-z]/_/g' -e 's/__*/_/g')

  # https://github.com/zellij-org/zellij/issues/3213 が fix されたら削除する
  if [[ $OSTYPE =~ ^darwin ]]; then
    if [[ ${#session_name} -gt 24 ]]; then
      session_name=${session_name: -24}
    fi
  fi

  exec zellij attach --create $session_name
fi
