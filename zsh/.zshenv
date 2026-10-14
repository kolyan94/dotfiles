# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# Swift toolchains managed by swiftly (iOS dev via xtool). In .zshenv so every zsh,
# including non-interactive ones and editors started from it, finds swift / sourcekit-lsp
[[ -r ~/.local/share/swiftly/env.sh ]] && source ~/.local/share/swiftly/env.sh
