### YOUR CONFIGURATION
### Paths
LW_PATH=~/lunar
GOPATH=~/go
GOBIN="$GOPATH/bin"
PATH="$GOBIN:$PATH"
GOPRIVATE="go.lunarway.com,github.com/lunarway"

# Source ~/.zsh_secrets if it exists
if [[ -f ~/.zshenv ]]; then
  source ~/.zshenv
fi

export HOMEBREW_GITHUB_API_TOKEN=$(gh auth token)
export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"

# Load Zinit
if [[ ! -f ~/.zinit/bin/zi.zsh ]]; then
  git clone https://github.com/zdharma/zinit.git ~/.zinit/bin
fi
source ~/.zinit/bin/zi.zsh

# Load default plugins from lw-zsh then run k8s_init after
zinit ice wait silent atload:"k8s_init mgd@lunar.app"; zinit load "lunarway/lw-zsh"

# My plugins
zinit light "zsh-users/zsh-syntax-highlighting"
zinit light "zsh-users/zsh-completions"
zinit light "zsh-users/zsh-autosuggestions"
zinit light "Aloxaf/fzf-tab"
zinit light "agkozak/zsh-z"
zinit light "mafredri/zsh-async"

# Load Completions
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+168); do #Only do it once a week. No slow terminal for me please
  compinit
done
compinit -C

# Update zinit once in a while
RANDOM_NUMBER=$((RANDOM % 100 + 1))
# Check for updates and install them
if [[ $RANDOM_NUMBER -eq 1 ]]; then
  zinit self-update
  zinit update --parallel
fi

### Controls
bindkey "^[[1;5C" forward-word  
bindkey "^[[1;5D" backward-word
bindkey "^p" autosuggest-accept # Change autosuggest from arrow key to ctrl+p
bindkey "^n" history-search-forward

### Options
DISABLE_AUTO_UPDATE="true"

### History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

### Completion styling
zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}" # Ignore casing
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}" # Use ls colors in completions

### Aliases
alias nv="nvim ."
alias genenv="shuttle run generate_dotenv && mv local.env .env && echo 'Renamed to .env'"
alias clone="fuzzy-clone -c"
alias ls="ls --color"
alias get_open_partners_prs="echo -n 'Want to fetch all open PartnersLib PRs? (y/n) ' && \
    read confirm && [[ \$confirm == [yY] ]] && \
    gh search prs \
        'Updated go.lunarway.com/banking-services-partners' \
        --state=open --json url | \
    jq '.[] | .url' | \
    xargs -I {} gh pr view {} --json headRepository,url,additions,deletions | \
    jq '{url, repo_name:.headRepository.name, additions, deletions}'"
alias merge_open_partners_prs="echo -n 'Want to !APPROVE! all open PartnersLib PRs? (y/n) ' && \
    read confirm && [[ \$confirm == [yY] ]] && \
    gh search prs \
        'Updated go.lunarway.com/banking-services-partners' \
        --match title --review-requested=@me --state=open --json title,url | \
    jq '.[] | .url' | \
    xargs -I {} gh pr review {} --approve"


### THEME OVERRIDES HERE
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[unknown-command]='fg=red,bold'

### Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
