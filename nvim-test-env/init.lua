
-- leader key, prefix for keymaps.
vim.g.mapleader = ' '

-- display
vim.opt.termguicolors = true

-- line number.
vim.o.number = true

-- relative line numbers.
vim.o.relativenumber = true

-- yank to clipboard,
-- delay is for startup time.
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- ignore case searching unless `\C` or >= 1 uppercase.
vim.o.ignorecase = true
vim.o.smartcase = true

-- highlight current line.
vim.o.cursorline = true

-- number of screen lines to keep around cursor.
vim.o.scrolloff = 10

-- show trailing whitespace.
vim.o.list = true

-- tab width.
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- confirm when quitting unsaved work.
vim.o.confirm = true

-- `:GitBlame` prints git blame.
vim.api.nvim_create_user_command('GitBlame', function()
  local line_number = vim.fn.line('.')
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'print the git blame for the current line.' })

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true
})

