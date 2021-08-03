# Fix emacs error
if [[ $TERM = dumb ]]; then
    unset zle_bracketed_paste
fi
