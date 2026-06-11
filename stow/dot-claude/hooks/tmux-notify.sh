#!/bin/bash
#
# Claude Code "Notification" hook — make desktop notifications work inside tmux.
#
# WHY THIS EXISTS
#   Claude Code raises desktop notifications by emitting an OSC 9 escape
#   sequence, which the outer terminal (Ghostty, iTerm2, ...) turns into a
#   native notification. But inside tmux a *bare* OSC 9 never reaches the outer
#   terminal — tmux swallows it. Claude Code does NOT wrap it for tmux itself
#   (still true as of 2026-06), so we re-emit the sequence wrapped in tmux's
#   "passthrough" envelope, which tells tmux to forward the inner bytes to the
#   outer terminal untouched. Requires `set -g allow-passthrough on` in tmux.
#   Ref: https://github.com/anthropics/claude-code/issues/19976
#
# THE NON-OBVIOUS GOTCHA (the bug this file used to have)
#   Claude Code runs hooks with NO controlling terminal. So the "obvious" target
#   `> /dev/tty` fails silently (there is no /dev/tty), and `> /dev/stdout` is
#   captured by Claude Code rather than reaching the screen. The fix: ask tmux
#   for our pane's real PTY device and write straight to that.

# Outside tmux there's nothing to wrap — Claude Code's native OSC 9 works fine,
# so bail before touching stdin and let it handle the notification itself.
[ -z "$TMUX" ] && exit 0

# Claude Code feeds the hook a JSON payload on stdin; grab it.
read -r input

# Notification text (falls back to a generic label if the field is missing).
message=$(echo "$input" | jq -r '.message // "Claude Code"')

# Resolve the PTY device backing THIS pane. $TMUX_PANE is set by tmux for the
# pane Claude Code runs in; prefer it so we target the right pane even if focus
# has moved. Fall back to the active pane if it's somehow unset.
if [ -n "$TMUX_PANE" ]; then
  pane_tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}')
else
  pane_tty=$(tmux display-message -p '#{pane_tty}')
fi

# Write the wrapped sequence directly to that PTY. Breakdown:
#   \033P tmux ;      DCS — opens a tmux passthrough block
#   \033\033          one ESC, doubled (tmux requires every ESC in the payload
#                     to be doubled); this is the ESC that starts the OSC below
#   ]9; <message> \007  OSC 9 + BEL — "show a desktop notification" (iTerm2/Ghostty)
#   \033\\            ST — closes the passthrough block
# tmux unwraps this and forwards the inner OSC 9 to the outer terminal.
#
# Note: the terminal only shows a *banner* when it isn't the frontmost app
# (macOS silently routes a foreground app's own notifications to Notification
# Center) — i.e. you see it precisely when you've switched away, which is the
# point.
[ -n "$pane_tty" ] && printf '\033Ptmux;\033\033]9;%s\007\033\\' "$message" > "$pane_tty"
