#!/usr/bin/env bash
#
# Claude Code "SessionStart" hook — make ssh (and git over ssh) work inside the
# macOS sandbox.
#
# WHY THIS EXISTS
#   With the sandbox on, Claude Code funnels outbound traffic through a local
#   proxy and injects, for git:
#     GIT_SSH_COMMAND="ssh -o ControlMaster=no -o ControlPath=none \
#                          -o ProxyCommand='nc -X 5 -x localhost:<port> %h %p'"
#   That proxy is SOCKS5 *with* username/password auth — see $ALL_PROXY, e.g.
#   http://srt:<token>@localhost:<port> — but macOS's /usr/bin/nc speaks only
#   unauthenticated SOCKS5: it offers -X/-x and no proxy-credential flag at all
#   (not even OpenBSD's -P), and the injected command passes no credentials
#   either. So the handshake dies before ssh even starts:
#     nc: authentication method negotiation failed
#     Connection closed by UNKNOWN port 65535
#     fatal: Could not read from remote repository.
#   That wording is from the upstream report; Apple's nc is less forthcoming and
#   just prints `error = 0 1` twice, which greps for nothing useful — so if you
#   ever see that, this is what you're looking at.
#   Every ssh-based git pull/push/fetch fails. Upstream bug, filed 2026-06-24
#   and labeled a regression (still open as of 2026-07-28):
#   https://github.com/anthropics/claude-code/issues/70684
#
# HOW WE FIX IT
#   We can't edit the injected ProxyCommand, but we *can* change which `nc` it
#   resolves to. Claude Code hands SessionStart hooks a scratch file in
#   $CLAUDE_ENV_FILE and loads whatever we append to it into the session
#   environment — so one `export PATH=...` line is enough to put
#   ~/.claude/hooks/bin ahead of /usr/bin for the rest of the session, letting
#   our own `nc` shim shadow Apple's. The shim's job is to re-dispatch the call
#   to ncat, the one netcat that can authenticate to a proxy (--proxy-auth).
#   Approach borrowed from cblecker's sandbox-ssh-fix plugin:
#   https://github.com/cblecker/claude-plugins/tree/4d1a0f4559e9cd1969065f5dd0ff0c27dc08b579/sandbox-ssh-fix
#
# THE SHIM ITSELF
#   bin/nc does the translating and documents its own rules: the four gates it
#   steps aside for (chief among them "am I actually under the sandbox?"), why it
#   only ever lends the credentials to the proxy they were issued for, why they
#   travel in $NCAT_PROXY_AUTH instead of argv, and why it dials 127.0.0.1 rather
#   than localhost. Read it there rather than duplicating it here.

set -euo pipefail

readonly SHIM_DIR="${HOME}/.claude/hooks/bin"

# No $CLAUDE_ENV_FILE means nothing is listening for env changes (hook run by
# hand, or a Claude Code without the feature), so exporting PATH would go
# nowhere. Leave quietly instead of failing a session we can't help.
[[ -n "${CLAUDE_ENV_FILE:-}" ]] || exit 0

# macOS only, and silently so. The bug is Apple's nc having no way to pass proxy
# credentials, so this is the only platform with anything to repair. It also
# matters that we bail *before* touching PATH: this file ships in the shared
# `stow` package, not `stow-osx`, so ~/.claude on a Linux box has bin/nc sitting
# in it too — and nothing but the line below ever puts that directory on PATH.
# Skipping here is what keeps that shim, whose own fallback is a hardcoded
# /usr/bin/nc, from ever answering to `nc` on a host where nc lives elsewhere.
[[ "$(uname -s)" == Darwin ]] || exit 0

# Don't advertise a PATH entry we haven't got. Pull this repo without re-running
# setup.zsh, or land a half-finished `stow --restow` (link_config_files uses
# --no-folding, so this directory needs a symlink of its own), and the export
# would point at nothing: ssh would go on resolving `nc` to Apple's build while
# the transcript showed a clean run. A silent failure that mimics success is the
# one outcome worse than a loud one.
if [[ ! -x "${SHIM_DIR}/nc" ]]; then
    echo "fix-ssh-in-sandbox.sh: ${SHIM_DIR}/nc is missing — re-run setup.zsh (or \`stow --restow\`); ssh in the sandbox is broken." >&2
    exit 1
fi

if ! command -v ncat >/dev/null 2>&1; then
    # One line, carrying both the problem and the fix: the transcript renders a
    # failed hook as a "hook error" notice plus only the FIRST LINE of stderr,
    # so a second line would never be read. The why lives in the header above.
    echo 'fix-ssh-in-sandbox.sh: ncat not found — ssh in the sandbox is broken; fix with `brew install nmap`.' >&2
    # Warn, don't block. Nothing here is worth stopping work over: without our
    # PATH line ssh just keeps resolving `nc` to Apple's build — the same
    # broken-but-familiar state as if this hook had never run — so the worst
    # case is the status quo, never a session we've made worse. Exiting
    # non-zero is purely how the warning gets seen: it renders as a "hook
    # error" notice in the transcript, and SessionStart hooks cannot abort a
    # session with ANY exit code (not even 2), so this can't lock us out.
    # Exiting 0 would be wrong for a different reason — on success Claude Code
    # feeds the hook's stdout to Claude as context, which is not who needs to
    # hear about a missing brew package.
    exit 1
fi

# Prepend, so our shim wins over /usr/bin/nc. \${PATH} stays unexpanded here on
# purpose: it must be resolved when Claude Code loads the line, against the
# session's PATH, not against this hook's.
#
# WHY WE RUN ON EVERY SessionStart EVENT, AND WHY THE WRITE IS GUARDED
#   settings.json deliberately gives this hook no "matcher", so it fires on all
#   five events (startup, resume, clear, compact, fork). Claude Code loads a
#   session's environment from ~/.claude/session-env/<sessionId>/, reading every
#   *-hook-<n>.sh in THAT directory and no other: an id that survives (compact,
#   resume) still has our line on disk and needs nothing from us, but every new
#   id (/clear, fork) starts on an empty directory and needs it written again.
#   Narrowing this to "startup" would leave ssh broken from the first /clear on.
#   The flip side is that a surviving id re-runs us against a file that already
#   holds the line, and Claude Code never truncates or rotates these (it clears
#   only the filechanged-/cwdchanged- ones), so a bare >> would prepend the same
#   directory once per event and PATH would grow all session long. Hence: append
#   only what isn't already there. Not `>` — the <n> in the filename is a
#   position in settings.json rather than an identity, so reordering the hooks
#   can hand us a file another hook is using, and truncating would eat its work.
path_line="export PATH=\"${SHIM_DIR}:\${PATH}\""
grep -qxF "${path_line}" "${CLAUDE_ENV_FILE}" 2>/dev/null \
    || printf '%s\n' "${path_line}" >> "${CLAUDE_ENV_FILE}"
