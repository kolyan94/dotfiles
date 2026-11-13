#!/bin/bash
# kitty window -> session on the launchd tmux server (local.tmux.server).
# First window attaches "main"; extra windows get their own session that disappears when the window closes.
TM=$HOME/.local/share/mise/installs/tmux/latest/tmux
[ -x "$TM" ] || exec /bin/zsh -l
# Right after login kitty can start before launchd's tmux server; start that server first so tmux runs under it
SOCK=/private/tmp/tmux-$(id -u)/default
if [ ! -S "$SOCK" ]; then
  launchctl kickstart gui/$(id -u)/local.tmux.server 2>/dev/null
  for _ in 1 2 3 4 5 6 7 8 9 10; do [ -S "$SOCK" ] && break; sleep 0.5; done
fi
if "$TM" has-session -t main 2>/dev/null && [ -n "$("$TM" list-clients -t main 2>/dev/null)" ]; then
  exec "$TM" new-session \; set-option destroy-unattached on
fi
exec "$TM" new-session -A -s main
