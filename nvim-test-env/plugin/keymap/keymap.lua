-- buffers.
vim.keymap.set('n', '<leader>gg', ':bnext<CR>')
vim.keymap.set('n', '<leader>ss', ':bprev<CR>')
-- list all buffers.
vim.keymap.set('n', '<leader>ls', ':ls<CR>')
-- close current buffer.
vim.keymap.set('n', '<leader>ww', ':bdelete<CR>')

-- telescope
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Diagnostic float" })
vim.keymap.set("n", "ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

-- DAP.
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "DAP step over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

