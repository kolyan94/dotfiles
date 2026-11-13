#!/bin/bash
# kitty window -> tmux. The first window attaches session "main"; extra windows get their own session
# that disappears when the window closes. Without tmux it falls back to a plain login zsh.
TM=""
for t in "$HOME/.local/share/mise/installs/tmux/latest/tmux" /opt/homebrew/bin/tmux /usr/local/bin/tmux /usr/bin/tmux; do
  [ -x "$t" ] && TM=$t && break
done
[ -n "$TM" ] || exec /bin/zsh -l
# Mac mini runs the tmux server under launchd (local.tmux.server, see hosts/mac-mini). Right after login
# kitty can start before it, so start that server first and tmux sessions run under launchd.
if launchctl print "gui/$(id -u)/local.tmux.server" >/dev/null 2>&1; then
  SOCK=/private/tmp/tmux-$(id -u)/default
  if [ ! -S "$SOCK" ]; then
    launchctl kickstart "gui/$(id -u)/local.tmux.server" 2>/dev/null
    for _ in 1 2 3 4 5 6 7 8 9 10; do [ -S "$SOCK" ] && break; sleep 0.5; done
  fi
fi
if "$TM" has-session -t main 2>/dev/null && [ -n "$("$TM" list-clients -t main 2>/dev/null)" ]; then
  exec "$TM" new-session \; set-option destroy-unattached on
fi
exec "$TM" new-session -A -s main
