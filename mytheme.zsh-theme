function virtualenv_info(){
  if [[ -n "$VIRTUAL_ENV" ]]; then
      venv="${VIRTUAL_ENV##*/}"
  else
      venv='none'
  fi
  [[ -n "$venv" ]] && echo "venv: $venv"
}

function my_git_prompt() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is anything staged?
  if $(echo "$INDEX" | grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS=" $STATUS"
  fi

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(my_current_branch)$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_current_branch() {
  echo $(current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg[red]%}(ssh) "
  fi
}

ZSH_THEME_PROMPT_RETURNCODE_PREFIX="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" $fg[white] %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[magenta]%}↑"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}●"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}●"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✕"
ZSH_THEME_GIT_PROMPT_SUFFIX=" $fg[white]%{$reset_color%}"

export VIRTUAL_ENV_DISABLE_PROMPT=1

PROMPT='%{$fg[cyan]%}[$(virtualenv_info)]%{$reset_color%} $(my_git_prompt)
$(ssh_connection)%{$fg[green]%}%1~%{$reset_color%}%{$fg[red]%}%{$reset_color%}%{$fg[green]%} ⇒%{$reset_color%} '
