# Yazi theme, rendered by Omarchy on every `omarchy theme set` / `omarchy theme refresh`
# into ~/.local/state/omarchy/current/theme/yazi-theme.toml, then copied to
# ~/.config/yazi/theme.toml by hooks/theme-set.d/dotfiles-yazi (see the dotfiles repo).
# Derived from the tokyonight-moon flavor; every color is an Omarchy theme variable, so yazi
# follows whichever theme is active. No background is set, so the terminal's (transparent)
# background shows through.

[mgr]
cwd = { fg = "{{ dark_foreground }}", italic = true }

# Find
find_keyword = { fg = "{{ background }}", bg = "{{ orange }}", bold = true }
find_position = { fg = "{{ bright_cyan }}", bg = "{{ mix background cyan 25% }}", bold = true }

# Symlink
symlink_target = { italic = true }

# Marker
marker_copied = { fg = "{{ green }}", bg = "{{ green }}" }
marker_cut = { fg = "{{ red }}", bg = "{{ red }}" }
marker_marked = { fg = "{{ magenta }}", bg = "{{ magenta }}" }
marker_selected = { fg = "{{ blue }}", bg = "{{ blue }}" }

# Count
count_copied = { fg = "{{ background }}", bg = "{{ green }}" }
count_cut = { fg = "{{ background }}", bg = "{{ red }}" }
count_selected = { fg = "{{ background }}", bg = "{{ blue }}" }

# Border
border_symbol = "│"
border_style = { fg = "{{ cyan }}" }

# Tab
[tabs]
active = { fg = "{{ background }}", bg = "{{ accent }}" }
inactive = { fg = "{{ accent }}", bg = "{{ muted }}" }

[mode]
normal_main = { fg = "{{ background }}", bg = "{{ accent }}", bold = true }
normal_alt = { fg = "{{ accent }}", bg = "{{ muted }}" }

select_main = { fg = "{{ background }}", bg = "{{ magenta }}", bold = true }
select_alt = { fg = "{{ magenta }}", bg = "{{ muted }}" }

unset_main = { fg = "{{ background }}", bg = "{{ bright_magenta }}", bold = true }
unset_alt = { fg = "{{ bright_magenta }}", bg = "{{ muted }}" }

# Hover
[indicator]
parent = { bg = "{{ selection }}" }
current = { bg = "{{ selection }}" }
preview = { bg = "{{ selection }}" }

[status]
overall = { fg = "{{ bright_foreground }}" }
sep_left = { open = "", close = "" }
sep_right = { open = "", close = "" }

# Permissions
perm_type = { fg = "{{ blue }}" }
perm_read = { fg = "{{ yellow }}" }
perm_write = { fg = "{{ red }}" }
perm_exec = { fg = "{{ green }}" }
perm_sep = { fg = "{{ muted }}" }

# Progress
progress_label = { fg = "{{ bright_foreground }}", bold = true }
progress_normal = { fg = "{{ accent }}", bg = "{{ selection }}" }
progress_error = { fg = "{{ red }}", bg = "{{ selection }}" }

# Which
[which]
cols = 3
mask = { bg = "{{ dark_background }}" }
cand = { fg = "{{ bright_cyan }}" }
rest = { fg = "{{ blue }}" }
desc = { fg = "{{ magenta }}" }
separator = " ➜ "
separator_style = { fg = "{{ muted }}" }

# Confirm
[confirm]
border = { fg = "{{ bright_cyan }}" }
title = { fg = "{{ cyan }}" }
body = {}
list = {}
btn_yes = { bg = "{{ mix background accent 30% }}" }
btn_no = {}
btn_labels = ["  [Y]es  ", "  (N)o  "]

# Spot
[spot]
border = { fg = "{{ cyan }}" }
title = { fg = "{{ cyan }}" }

# Notification
[notify]
title_info = { fg = "{{ bright_cyan }}" }
title_warn = { fg = "{{ yellow }}" }
title_error = { fg = "{{ red }}" }

# Picker
[pick]
border = { fg = "{{ cyan }}" }
active = { fg = "{{ bright_foreground }}", bg = "{{ mix background accent 30% }}" }
inactive = { fg = "{{ bright_foreground }}" }

# Input
[input]
border = { fg = "{{ bright_cyan }}" }
title = { fg = "{{ bright_cyan }}" }
value = { fg = "{{ bright_magenta }}" }
selected = { bg = "{{ mix background accent 30% }}" }

# Completion
[cmp]
border = { fg = "{{ bright_cyan }}" }
active = { fg = "{{ bright_foreground }}", bg = "{{ selection }}" }
inactive = { fg = "{{ bright_foreground }}" }

# Task manager
[tasks]
border = { fg = "{{ cyan }}" }
title = { fg = "{{ cyan }}" }
hovered = { fg = "{{ bright_foreground }}", bg = "{{ mix background accent 30% }}" }

# Help menu
[help]
on = { fg = "{{ green }}" }
run = { fg = "{{ magenta }}" }
desc = { fg = "{{ bright_cyan }}" }
hovered = { bg = "{{ selection }}" }
footer = { fg = "{{ bright_foreground }}", bg = "{{ dark_background }}" }

# File-specific styles
[filetype]
rules = [
  # Images
  { mime = "image/*", fg = "{{ yellow }}" },

  # Media
  { mime = "{audio,video}/*", fg = "{{ magenta }}" },

  # Archives
  { mime = "application/*zip", fg = "{{ red }}" },
  { mime = "application/x-{tar,bzip*,7z-compressed,xz,rar}", fg = "{{ red }}" },

  # Documents
  { mime = "application/{pdf,doc,rtf,vnd.*}", fg = "{{ bright_cyan }}" },

  # Special files
  { url = "*", is = "orphan", bg = "{{ red }}" },
  { url = "*", is = "exec", fg = "{{ green }}" },

  # Fallback
  { url = "*/", fg = "{{ magenta }}" },
  { url = "*", fg = "{{ foreground }}" },
]
