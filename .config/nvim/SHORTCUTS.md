# Neovim Shortcuts Reference

This document contains all the key shortcuts for your optimized Neovim configuration, organized by functionality. **Bold shortcuts** are the most commonly used ones you should memorize first.

## 🚀 Essential Navigation

### Basic Movement
- **`h/j/k/l`** - Basic movement (left/down/up/right)
- **`w/b`** - Word forward/backward
- **`0/^/$`** - Beginning of line/first non-blank/end of line
- **`gg/G`** - Top/bottom of file
- **`Ctrl+d/Ctrl+u`** - Page down/up (centered)
- **`n/N`** - Next/previous search result (centered)

### Lightning-Fast Navigation (Flash)
- **`s + letters`** - Jump to any visible location instantly
- `S` - Jump to treesitter nodes (functions, classes)
- `r` - Remote flash (for operators)
- `R` - Treesitter search

### File & Buffer Management
- **`<leader>sf`** - Search files
- **`<leader>sg`** - Search by grep (live search)
- **`<leader><leader>`** - Switch between buffers
- **`Shift+h/Shift+l`** - Previous/next buffer
- **`-`** - Open file explorer (Oil)
- `<space>-` - Open floating file explorer

## 📝 Text Editing

### Essential Editing
- **`i/a`** - Insert before/after cursor
- **`I/A`** - Insert at beginning/end of line
- **`o/O`** - Open new line below/above
- **`x/X`** - Delete character under/before cursor
- **`dd`** - Delete line
- **`yy`** - Yank (copy) line
- **`p/P`** - Paste after/before cursor

### Advanced Editing
- **`Ctrl+n`** - Multi-cursor: select word under cursor
- `Ctrl+Shift+n` - Multi-cursor: select all occurrences
- `Ctrl+x` - Multi-cursor: skip current selection
- `Ctrl+p` - Multi-cursor: remove current selection
- **`<leader>y`** - Copy to system clipboard
- **`<leader>p`** - Paste without yanking (in visual mode)
- `<leader>d` - Delete without yanking

### Text Objects & Selection
- **`af/if`** - Select around/inside function
- **`ac/ic`** - Select around/inside class
- `as/is` - Select around/inside scope
- `]m/[m` - Next/previous function start
- `]]/[[` - Next/previous class start

### Movement & Manipulation
- **`J`** - Join lines (keeping cursor position)
- `Alt+j/Alt+k` - Move lines up/down (visual mode)
- **`</>`** - Indent left/right (keeps selection in visual)
- `<leader>s` - Replace word under cursor globally

## 🔍 Search & Replace

### Basic Search
- **`/pattern`** - Search forward
- **`?pattern`** - Search backward
- **`*/#`** - Search word under cursor forward/backward
- `<Esc>` - Clear search highlights

### Advanced Search & Replace
- **`<leader>sr`** - Open project-wide search & replace (Spectre)
- `<leader>sw` - Search current word project-wide
- `<leader>sf` - Search & replace in current file
- **`<leader>sg`** - Live grep search
- `<leader>s/` - Search in open files only

## 🔧 Development Tools

### LSP (Language Server)
- **`gd`** - Go to definition
- **`gr`** - Go to references
- **`K`** - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `[d/]d` - Previous/next diagnostic
- **`<leader>q`** - Open diagnostic quickfix list

### Debugging
- **`F5`** - Start/continue debugging
- **`F1`** - Step into
- **`F2`** - Step over
- **`F3`** - Step out
- **`<leader>b`** - Toggle breakpoint
- `<leader>B` - Set conditional breakpoint
- `F7` - Toggle debug UI

### Git Integration
- **`<leader>lg`** - Open LazyGit
- `]c/[c` - Next/previous git change
- `<leader>hp` - Preview git hunk
- `<leader>hs` - Stage git hunk
- `<leader>hr` - Reset git hunk
- `<leader>hb` - Show git blame

## 🖥️ Terminal & Workflow

### Terminal
- **`Ctrl+\`** - Toggle floating terminal
- `<Esc><Esc>` - Exit terminal mode
- **`<leader>gg`** - Toggle LazyGit terminal
- `<leader>tp` - Toggle Python REPL

### Session Management
- **`<leader>qs`** - Restore session
- `<leader>ql` - Restore last session
- `<leader>qd` - Don't save current session

## 🎨 UI & Windows

### Window Management
- **`Ctrl+h/j/k/l`** - Navigate between windows
- `Ctrl+w +/-` - Resize windows vertically
- `Ctrl+w </>` - Resize windows horizontally
- `Ctrl+w =` - Equalize window sizes

### Folding
- **`zR`** - Open all folds
- **`zM`** - Close all folds
- `za` - Toggle fold under cursor
- `zo/zc` - Open/close fold under cursor

### File Explorer (Oil)
- **`-`** - Open parent directory
- `<CR>` - Open file/directory
- `g?` - Show help in Oil
- `-` - Go up one directory level

## 🔍 Telescope (Fuzzy Finder)

### File Operations
- **`<leader>sf`** - Find files
- **`<leader>sg`** - Live grep (search in files)
- `<leader>sr` - Resume last search
- `<leader>s.` - Recent files
- `<leader>sn` - Search Neovim config files

### Code Navigation
- `<leader>ss` - Search Telescope commands
- `<leader>sk` - Search keymaps
- `<leader>sh` - Search help
- `<leader>sd` - Search diagnostics
- **`<leader>/`** - Search in current buffer

## 💡 Productivity Tips

### Most Important Combos to Master:
1. **`s + letters`** - Flash navigation (fastest way to move anywhere)
2. **`<leader>sf → type → Enter`** - Open any file instantly
3. **`<leader>sg → type`** - Find any text across your project
4. **`Ctrl+n → edit → Esc`** - Multi-cursor editing
5. **`gd`** - Jump to function/variable definition
6. **`F5`** - Start debugging your code
7. **`Ctrl+\`** - Quick terminal access
8. **`<leader>lg`** - Git operations with LazyGit

### Workflow Suggestions:
- Use **Flash (`s`)** instead of arrow keys for navigation
- Use **`<leader>sf`** instead of manual file browsing
- Use **multi-cursor (`Ctrl+n`)** for repetitive edits
- Use **`<leader>sg`** to find functions/variables across files
- Use **debugging (`F5`)** instead of print statements
- Use **system clipboard (`<leader>y`)** to copy between applications

## 🎯 Quick Reference Card

| Action | Shortcut | Action | Shortcut |
|--------|----------|--------|----------|
| **Jump anywhere** | `s + letters` | **Find files** | `<leader>sf` |
| **Search in files** | `<leader>sg` | **Multi-cursor** | `Ctrl+n` |
| **Go to definition** | `gd` | **Debug start** | `F5` |
| **Toggle terminal** | `Ctrl+\` | **Git interface** | `<leader>lg` |
| **Next buffer** | `Shift+l` | **File explorer** | `-` |
| **Copy to clipboard** | `<leader>y` | **Search & replace** | `<leader>sr` |

---

💡 **Pro Tip**: Start by mastering the **bold shortcuts** - they'll cover 80% of your daily workflow!