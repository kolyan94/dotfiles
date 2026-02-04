-- Better quickfix and location list
return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  opts = {
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      win_height = 12,
      win_vheight = 12,
      delay_syntax = 80,
      border_chars = { '┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█' },
      should_preview_cb = function(bufnr, qwinid)
        local ret = true
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local fsize = vim.fn.getfsize(bufname)
        if fsize > 100 * 1024 then
          ret = false
        end
        return ret
      end,
    },
  },
}
