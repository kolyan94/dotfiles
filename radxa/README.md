# radxa package

Radxa Zero 3 "cyberdeck" (1280x400 screen, own keyboard, no mouse, two rotary knobs). Stow it on top of
`macos common common-overrides` (Debian, so `./install.sh --os macos`), then `stow --no-folding -t ~ radxa`.

- Hyprland with Omarchy's keys (SUPER = the ⌘ key): `SUPER+Enter` terminal, `SUPER+Space` launcher,
  `SUPER+W` close, `SUPER+1..5` workspaces, `SUPER+Esc` deck menu, `SUPER+K` key list, `SUPER+Shift+W` writing.
  No blur, shadows or animations (heat). `deck-session` falls back to Wayfire if Hyprland dies at start.
- `perf cool|fast`: CPU cap 1104 / 1416 MHz (fast reverts after 30 min). Caps live in /etc/default/deck-perf.
- `write [name]`: zen-mode note in the Obsidian vault Inbox, spell check uk+en.
- nvim: arrow keys enabled again (the knobs send arrows).
