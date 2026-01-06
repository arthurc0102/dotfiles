copy-buffer() {
    if [[ -z $BUFFER ]]; then
        zle -M "No command to copy"
        return 1
    fi

    echo -n "$BUFFER" | clipcopy
    zle -M "Copied command to clipboard"
}

zle -N copy-buffer
bindkey '^Xb' copy-buffer
