export XDG_CACHE_HOME=~/.cache
export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.local/share
export XDG_STATE_HOME=~/.local/state

mkdir -p \
  "$XDG_CACHE_HOME" \
  "$XDG_CONFIG_HOME" \
  "$XDG_DATA_HOME" \
  "$XDG_STATE_HOME"

path=(/opt/homebrew/bin(N-/) $path)
path=(~/.cargo/bin(N-/) $path)
path=(~/.local/share/aquaproj-aqua/bin(N-/) $path)
path=(~/.local/bin(N-/) $path)
path=(~/.devcontainers/bin(N-/) $path)
path=(~/bin(N-/) $path)
typeset -U path # 重複を削除

# Disable shell session support in /etc/zshrc_Apple_Terminal
SHELL_SESSIONS_DISABLE=1

# aqua
export AQUA_GLOBAL_CONFIG=~/.config/aquaproj-aqua/aqua.yaml
if [[ "$(uname -s)" == "Linux" ]]; then
  AQUA_GLOBAL_CONFIG=~/.config/aquaproj-aqua/aqua-linux.yaml:$AQUA_GLOBAL_CONFIG
fi
