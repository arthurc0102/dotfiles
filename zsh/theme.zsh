spaceship_rprompt_prefix() {
  echo -n '%{'$'\e[1A''%}'
}

spaceship_rprompt_suffix() {
  echo -n '%{'$'\e[1B''%}'
}

SPACESHIP_CHAR_SYMBOL='$ '
SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=') '
SPACESHIP_VENV_COLOR='magenta'
SPACESHIP_DIR_TRUNC='0'
SPACESHIP_DIR_TRUNC_REPO='true'
SPACESHIP_GIT_SYMBOL=''
SPACESHIP_EXIT_CODE_SHOW='true'
SPACESHIP_TIME_SHOW='true'
SPACESHIP_EXEC_TIME_ELAPSED='0'
SPACESHIP_RPROMPT_ORDER=(rprompt_prefix exit_code time exec_time rprompt_suffix)
SPACESHIP_PROMPT_ORDER=(user host dir git line_sep venv char)
