# radxa package

Radxa Zero 3 "cyberdeck" (1280x400 screen, own keyboard, no mouse, two rotary knobs). Stow it on top of
`macos common common-overrides` (Debian, so `./install.sh --os macos`), then `stow --no-folding -t ~ radxa`.

- Hyprland with Omarchy 4.5's keys (SUPER = the ⌘ key). `SUPER+K` lists every key with its description, grouped,
  and Enter runs it. Main ones: `SUPER+Enter` terminal, `SUPER+Space` launcher, `SUPER+Shift+B` Chromium,
  `SUPER+Shift+/` Bitwarden, `SUPER+Shift+L` LocalSend, `SUPER+Ctrl+V` clipboard history, `SUPER+Shift+W` writing,
  `SUPER+Esc` deck menu. Apps outside the repo: chromium, localsend (official arm64 .deb), Bitwarden desktop
  (official arm64 tar.gz in ~/.local/opt/bitwarden).
  No blur, shadows or animations (heat). `deck-session` falls back to Wayfire if Hyprland dies at start.
- `perf cool|fast`: CPU cap 1416 / 1608 MHz (fast reverts after 30 min). Caps live in /etc/default/deck-perf.
- `write [name]`: zen-mode note in the Obsidian vault Inbox, spell check uk+en.
- nvim: arrow keys enabled again (the knobs send arrows).
