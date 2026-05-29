-- leader key
vim.g.mapleader = " "

-- basic display
vim.opt.termguicolors = true

-- plugin manager bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("options")

require("lazy").setup({
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	},
	{
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup({
                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = true,
                    },
                    live_grep = {
                        additional_args = { "--hidden", "--no-ignore" },
                    },
                },
            })
        end,
    },
	{ "williamboman/mason.nvim" },
})

-- mason (run :MasonInstall clangd codelldb)
require("mason").setup()

-- lsp (native 0.11+ api, no plugin needed).

-- c / c++.

vim.lsp.config("clangd", {
	cmd = { "clangd" },
	root_markers = { "compile_commands.json", "Makefile", ".git" },
	filetypes = { "c" },
})
vim.lsp.enable("clangd")

-- typescript.

vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	root_markers = { "tsconfig.json", "package.json", ".git" },
	filetypes = { "typescript", "typescriptreact" },
})
vim.lsp.enable("ts_ls")

vim.lsp.config("eslint", {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	root_markers = {
		".eslintrc",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.yaml",
		".eslintrc.yml",
		".eslintrc.json",
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		"eslint.config.ts",
		"eslint.config.mts",
		"eslint.config.cts",
	},
	filetypes = { "typescript", "typescriptreact" },
	settings = {
		validate = "on",
		packageManager = nil,
		useESLintClass = false,
		experimental = {
			useFlatConfig = true,
		},
		codeActionOnSave = {
			enable = false,
			mode = "all",
		},
		format = true,
		quiet = false,
		onIgnoredFiles = "off",
		rulesCustomizations = {},
		run = "onType",
		problems = {
			shortenToSingleLine = false,
		},
		nodePath = "",
		workingDirectory = { mode = "location" },
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
	},
	handlers = {
		["eslint/openDoc"] = function(_, result)
			if result then
				vim.ui.open(result.url)
			end
			return {}
		end,
		["eslint/confirmESLintExecution"] = function()
			return 4 -- approved
		end,
		["eslint/probeFailed"] = function()
			vim.notify("ESLint probe failed.", vim.log.levels.WARN)
			return {}
		end,
		["eslint/noLibrary"] = function()
			vim.notify("Unable to find ESLint library.", vim.log.levels.WARN)
			return {}
		end,
	},
})
vim.lsp.enable("eslint")

-- c / c++ debugger.

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

-- dap (debugger)
local dap = require("dap")
dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
		args = { "--port", "${port}" },
	},
}
dap.configurations.c = {
	{
		type = "codelldb",
		name = "Launch",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
	},
}

vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "DAP step over" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })

local dapui = require("dapui")
dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

-- theme
require("colors.terminal").setup()
vim.cmd.colorscheme("terminal")

vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

-- keymaps

-- telescope
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Diagnostic float" })
vim.keymap.set("n", "ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
vim.keymap.set("n", "fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
vim.keymap.set("n", "fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })

-- buffers
vim.keymap.set('n', '<leader>gg', ':bnext<CR>')
vim.keymap.set('n', '<leader>ss', ':bprev<CR>')
-- list all buffer
vim.keymap.set('n', '<leader>ls', ':ls<CR>')
-- close current buffer
vim.keymap.set('n', '<leader>ww', ':bdelete<CR>')

-- whitespace

-- tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

