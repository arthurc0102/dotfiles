# 這兩個 function本來用來處理右邊的資訊出現在第二行的問題
# 不過後台 theme 修好了這個問題所以就用不到了
# 如果還需要用到在 SPACESHIP_RPROMPT_ORDER 開頭加上 rprompt_prefix 結尾加上 rprompt_suffix
#
# spaceship_rprompt_prefix() {
#   echo -n '%{'$'\e[1A''%}'
# }
#
# spaceship_rprompt_suffix() {
#   echo -n '%{'$'\e[1B''%}'
# }

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
SPACESHIP_RPROMPT_ORDER=(exit_code time exec_time)
SPACESHIP_PROMPT_ORDER=(user host dir git line_sep venv char)
