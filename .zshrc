export ZSH="$HOME/.oh-my-zsh"
export CUSTOM_ZSH="$HOME/.config/zsh"

ZSH_CUSTOM=$CUSTOM_ZSH

plugins=(git)

source $ZSH/oh-my-zsh.sh

# pnpm
export PNPM_HOME="/Users/baracaio/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
