-- Treesitter, `main` branch (the rewrite for Neovim 0.12). It has no setup modules any more:
-- parsers are installed with install(), highlighting and indent are started per buffer below.
-- Incremental selection is built into 0.12 (visual `an` / `in`), mapped to <M-space> / <BS>.
local parsers = {
  'bash',
  'c',
  'cpp',
  'diff',
  'html',
  'javascript',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'php',
  'python',
  'query',
  'regex',
  'requirements',
  'rst',
  'rust',
  'swift',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
}

-- start highlighting (and treesitter indent, except where it is worse than Vim's) in one buffer
local function start(buf, lang)
  if not pcall(vim.treesitter.start, buf, lang) then
    return false
  end
  if lang ~= 'ruby' then
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
  return true
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- the main branch does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      local ts = require 'nvim-treesitter'
      ts.install(parsers) -- async; already installed parsers are skipped

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('dotfiles-treesitter', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or start(args.buf, lang) then
            return
          end
          -- what auto_install did: fetch a missing parser once, then start it
          if vim.tbl_contains(ts.get_available(), lang) then
            ts.install(lang):await(function()
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(args.buf) then
                  start(args.buf, lang)
                end
              end)
            end)
          end
        end,
      })

      vim.keymap.set('n', '<M-space>', 'van', { remap = true, desc = 'Select treesitter node' })
      vim.keymap.set('x', '<M-space>', 'an', { remap = true, desc = 'Grow selection to parent node' })
      vim.keymap.set('x', '<BS>', 'in', { remap = true, desc = 'Shrink selection to child node' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter-textobjects').setup { select = { lookahead = true } }
      local select = require 'nvim-treesitter-textobjects.select'
      local swap = require 'nvim-treesitter-textobjects.swap'
      local objects = {
        af = { '@function.outer', 'outer part of a function' },
        ['if'] = { '@function.inner', 'inner part of a function' },
        ac = { '@class.outer', 'outer part of a class' },
        ic = { '@class.inner', 'inner part of a class' },
        as = { '@local.scope', 'language scope', 'locals' },
      }
      for key, o in pairs(objects) do
        vim.keymap.set({ 'x', 'o' }, key, function()
          select.select_textobject(o[1], o[3] or 'textobjects')
        end, { desc = 'Select ' .. o[2] })
      end
      vim.keymap.set('n', '<leader>xs', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap parameter with the next' })
      vim.keymap.set('n', '<leader>xS', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap parameter with the previous' })
    end,
  },
}
