-- Personal layer on top of Omarchy's LazyVim. Nothing Omarchy ships is edited, and
-- by default this only ADDS: new keymaps on keys LazyVim leaves free, new plugins,
-- extra language servers. It changes no existing option, key or plugin behavior.
--
-- The opt-in override layer (lua/dotfiles/overrides/*, extra specs in lua/plugins/)
-- only exists after `./install.sh --with-overrides`; it is loaded when present.
--
-- Keymaps wait for VeryLazy, which is when LazyVim registers its own, so ours are
-- defined last.

-- require a module only if it exists; real errors inside it still surface
local function optional(mod)
  local ok, err = pcall(require, mod)
  if not ok and not tostring(err):find("module '" .. mod .. "' not found", 1, true) then
    vim.notify(("dotfiles: %s failed:\n%s"):format(mod, err), vim.log.levels.ERROR)
  end
end

optional("dotfiles.overrides.options")

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  group = vim.api.nvim_create_augroup("dotfiles_layer", { clear = true }),
  callback = function()
    require("dotfiles.keymaps")
    optional("dotfiles.overrides.keymaps")
    optional("dotfiles.overrides.autocmds")
  end,
})
