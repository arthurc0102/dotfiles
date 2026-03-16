function _tmux_attach_or_create_session() {
    # ref: https://github.com/ohmyzsh/ohmyzsh/blob/7de13621b376ab5e616dbc3729b52fbfde92d0e1/plugins/tmux/tmux.plugin.zsh#L178-L189

    local session_name start_dir
    if [[ -n "$1" ]]; then
        session_name="$1"
        [[ -n "$2" ]] && start_dir=$(realpath "$2")
    else
        # current directory without leading path
        local dir=${PWD##*/}
        # sha256 hash for the full working directory path
        local sha256=$(printf '%s' "$PWD" | sha256sum | cut -d  ' ' -f 1)
        # human friendly unique session name for this directory
        session_name="${dir}-${sha256:0:6}"
    fi

    # create or attach to the session
    if [[ -n "$start_dir" ]]; then
        tmux new -A -s "$session_name" -c "$start_dir"
    else
        tmux new -A -s "$session_name"
    fi
}

alias t='tmux'
alias tn='_tmux_attach_or_create_session'
