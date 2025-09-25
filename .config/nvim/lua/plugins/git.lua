-- Git integration plugins
return {
  -- Git signs in the gutter
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Git [h]unk [s]tage' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Git [h]unk [r]eset' })
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
        end, { desc = 'Git [h]unk [s]tage' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
        end, { desc = 'Git [h]unk [r]eset' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Git [h]unk [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Git [h]unk [u]ndo stage' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Git [h]unk [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Git [h]unk [p]review' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'Git [h]unk [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Git [h]unk [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis('@')
        end, { desc = 'Git [h]unk [D]iff against last commit' })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },

  -- LazyGit integration
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
}