-- Radxa deck: the rotary knobs send arrow keys, so undo the macOS config's "arrows disabled" keymaps.
for _, mode in ipairs { 'n', 'i', 'v', 'x', 's', 'o', 'c' } do
  for _, key in ipairs { '<Up>', '<Down>', '<Left>', '<Right>' } do
    pcall(vim.keymap.del, mode, key)
  end
end
