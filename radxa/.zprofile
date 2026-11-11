# tty1 autologin -> deck session (Hyprland, falls back to Wayfire). echo wayfire > ~/.config/deck/session to switch.
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
if [ "$TTY" = "/dev/tty1" ]; then
	exec ~/.local/bin/deck-session
fi
