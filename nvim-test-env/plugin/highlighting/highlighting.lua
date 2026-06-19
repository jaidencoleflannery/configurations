-- highlight yank.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'highlight when yanking.',
  callback = function()
    vim.hl.on_yank()
  end,
})
