-- Same as Omarchy's options.lua; personal changes (relative numbers, format on save...) are in
-- common-overrides/.config/nvim/lua/dotfiles/overrides/options.lua, loaded on every machine that uses overrides
vim.opt.relativenumber = false
vim.g.autoformat = false
-- Compose files get their own filetype so the compose language server attaches (yamlls still does too)
vim.filetype.add({
  pattern = {
    [".*/?compose%.ya?ml"] = "yaml.docker-compose",
    [".*/?docker%-compose[%w.-]*%.ya?ml"] = "yaml.docker-compose",
  },
})
