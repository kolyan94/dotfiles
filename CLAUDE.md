# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files and shell scripts for optimizing a development environment. The repository uses **GNU Stow** as the primary tool for managing and deploying configuration files via symbolic links.

## Installation and Management

### Primary Installation Command
```bash
# Deploy all configuration files using Stow
stow .
```

### Dependencies
Core dependencies that must be installed before using this configuration:
- Git
- FZF (fuzzy finder)
- GNU Stow (for managing dotfiles)
- Zsh (shell)

Optional dependencies mentioned in the configuration:
- zoxide (smart directory navigation)
- tmuxifier (tmux session management)

## Configuration Architecture

### Shell Configuration (.zshrc)
The main shell configuration is built around several key components:

1. **Zinit Plugin Manager**: Manages zsh plugins and themes
   - Location: `${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git`
   - Auto-installs if not present

2. **Key Plugins Loaded**:
   - romkatv/powerlevel10k (theme)
   - zsh-users/zsh-syntax-highlighting
   - zsh-users/zsh-completions
   - zsh-users/zsh-autosuggestions
   - Aloxaf/fzf-tab
   - jeffreytse/zsh-vi-mode

3. **Powerlevel10k Configuration**: Uses `.p10k.zsh` for prompt customization

### Application Configurations

#### Neovim (.config/nvim/)
- **Architecture**: Based on Kickstart.nvim template
- **Language**: Lua-based configuration
- **Formatting**: Uses StyLua with configuration in `.config/nvim/.stylua.toml`
- **Key Settings**: 160 column width, 2-space indents, single quotes preferred

#### LazyGit (.config/lazygit/)
- **Theme**: Tokyo Night color scheme
- **Features**: Custom branch colors (main/master in red)

#### Yazi File Manager (.config/yazi/)
- **Configuration**: Multiple TOML files for different aspects
- **Plugins**: Includes mount, what-size, full-border, and git plugins
- **Theme**: Tokyo Night Night flavor

### Shell Integration Functions

#### Path Management
- `pathappend()`: Safely adds directories to end of PATH
- `pathprepend()`: Safely adds directories to beginning of PATH
- Common paths: ~/.cargo/bin, /opt/homebrew/bin, ~/.local/bin

#### Utility Functions
- `y()`: Yazi wrapper that changes directory when exiting
- `runfree()`: Starts programs detached from terminal
- `cpp()`: File copy with progress bar using rsync
- `cpg()`, `mvg()`: Copy/move and navigate to directory
- `mkdirg()`: Create and navigate to directory

## Environment Variables

### Editor Configuration
```bash
export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export FCEDIT=nvim
```

### Terminal Applications
```bash
export TERMINAL=alacritty
export BROWSER=com.brave.Browser
```

### Tool-Specific Settings
- **FZF**: Extensive theming with Tokyo Night colors
- **Pager**: Uses bat when available
- **Manual Pages**: Formatted with bat for syntax highlighting

## Aliases and Commands

### Common Aliases
- Navigation: `..` for `cd ..`
- Safety: `cp -iv`, `mv -iv`, `rm -iv` (interactive/verbose)
- Modern replacements: `ls` → `lsd`, `cat` → `bat`, `top` → `btop`
- Editor: `vi`/`vim` → `nvim`

### Conditional Tool Aliases
The configuration intelligently detects installed tools and creates aliases:
- lsd for enhanced ls functionality
- bat for syntax-highlighted file viewing
- btop for system monitoring
- lazygit (`lg` alias)
- fzf with bat preview integration

## Development Workflow

### Tool Installation Requirements
While most tools are auto-installed via Mason, some require manual installation:

**Auto-installed by Mason** (no action needed):
- LSP servers: `clangd`, `pylsp`, `lua_ls`
- Formatters: `black`, `isort`, `clang-format`, `prettier`, `stylua`
- Linter: `swiftlint`

**Manual Installation Required**:
```bash
# Swift formatter (not available in Mason)
brew install swiftformat

# Enable Swift formatting in Neovim by uncommenting this line in init.lua:
# swift = { 'swiftformat' },
```

### No Build Commands
This repository contains configuration files only - no compilation or build steps are required.

### Making Changes
1. Edit configuration files directly in the repository
2. Use `stow .` to deploy changes (creates/updates symlinks)
3. Restart relevant applications or source shell configuration

### Key Configuration Files to Modify
- `.zshrc`: Main shell configuration
- `.config/nvim/init.lua`: Main Neovim entry point (43 lines)
- `.config/nvim/lua/config/`: Core settings (options, keymaps, autocmds)
- `.config/nvim/lua/plugins/`: Plugin configurations by category
- `.config/lazygit/config.yml`: Git UI theme and settings
- `.p10k.zsh`: Prompt appearance (run `p10k configure` to modify)

### Neovim Configuration Structure
```
nvim/
├── init.lua              # Main entry (43 lines)
├── lua/
│   ├── config/           # Core settings
│   │   ├── options.lua   # All vim options
│   │   ├── keymaps.lua   # Key mappings
│   │   └── autocmds.lua  # Autocommands
│   └── plugins/          # Plugin configurations
│       ├── editor.lua    # Core editing (autopairs, surround, etc.)
│       ├── ui.lua        # UI plugins (lualine, oil, colorscheme)
│       ├── lsp.lua       # Language servers & completion
│       ├── telescope.lua # Fuzzy finder
│       ├── git.lua       # Git integration
│       └── markdown.lua  # Markdown & documentation tools
```

## Shell Features

### Vi Mode
- Enabled with custom cursor styles for different modes
- Insert mode: blinking beam cursor
- Normal mode: blinking block cursor
- Operator pending: blinking underline cursor

### History Configuration
- 20,000 command history
- Duplicate removal and space-prefixed command ignoring
- Shared history across sessions

### FZF Integration
- Directory preview with `ls --color`
- File preview with bat syntax highlighting
- Custom Tokyo Night theme colors