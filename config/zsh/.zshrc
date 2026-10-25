### history

mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=2000000 # HIST_EXPIRE_DUPS_FIRST によれば HISTSIZE > SAVEHIST すべきとのこと
SAVEHIST=1000000

setopt EXTENDED_HISTORY         # 開始時刻:経過秒数を記録する
setopt HIST_EXPIRE_DUPS_FIRST   # 履歴上限に達したら重複から削除
setopt HIST_FCNTL_LOCK          # パフォーマンス向上
#setopt HIST_IGNORE_ALL_DUPS    # HIST_IGNORE_DUPS を採用しないなら当然こちらも採用しない
#setopt HIST_IGNORE_DUPS        # 同じコマンドでも経過時間が知りたい時があるので採用しない
setopt HIST_IGNORE_SPACE        # 余分な空白を削除
setopt HIST_REDUCE_BLANKS       # 連続したスペースを1つにする
setopt HIST_SAVE_NO_DUPS        # シェル終了時に重複を削除する
setopt INC_APPEND_HISTORY_TIME  # コマンド実行完了後すぐに経過秒数と共に記録する
#setopt SHARE_HISTORY           # 経過秒数を記録したいので採用しない



### alias

alias diff='git diff --no-index'
alias lt='eza -la -T -I ".git|.venv|node_modules|cdk.out"'



### completion

if [[ -n $HOMEBREW_PREFIX ]]; then
  fpath=(
    $HOMEBREW_PREFIX/share/zsh/site-functions(N-/)
    $fpath
  )
fi
typeset -U fpath # 重複削除

mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"



### sheldon

export SHELDON_DATA_DIR="$HOME/dotfiles/.share/sheldon"



### others

# aqua による shim があるため command -v では確認できない
fzf      --version &>/dev/null && source <(fzf --zsh)
mise     --version &>/dev/null && eval "$(mise activate zsh)"
sheldon  --version &>/dev/null && eval "$(sheldon source)"
starship --version &>/dev/null && eval "$(starship init zsh)"



### oh-my-zsh

#if [[ -d ~/.local/share/ohmyzsh ]]; then
#  export ZSH=~/.local/share/ohmyzsh
#elif [[ -d ~/.oh-my-zsh ]]; then
#  export ZSH=~/.oh-my-zsh
#fi
#if [[ -d $ZSH ]]; then
#  if [[ -f $ZSH/custom/themes/devcontainers.zsh-theme ]]; then
#    ZSH_THEME="devcontainers"
#  else
#    ZSH_THEME="simple"
#  fi
#  HIST_STAMPS="yyyy-mm-dd"
#  plugins=(git copyfile)
#  source $ZSH/oh-my-zsh.sh
#fi
