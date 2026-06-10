local output_padding = " "

local function sync_output(ev)
	vim.api.nvim_buf_attach(0, false, {
		on_lines = function(_, bufnr, changedtick, firstline, lastline, new_lastline)
		end,
	})

	local available_character_count = vim.api.nvim_win_get_width(0)
	local character_count = 0

	local output_prefix_buffer = ""
	local output_suffix_buffer = ""
	local output_buffer = ""

	local current_file = vim.bo.filetype
	local current_file_output = ""
	local has_file_open = true

	if current_file ~= "" then
		current_file_output = current_file
		has_file_open = true
	else
		current_file_output = "home"
		has_file_open = false
	end

	--prefix display.

	-- filetype.
	output_prefix_buffer = output_padding .. "[" .. current_file_output .. "]" .. output_padding
	
	if has_file_open == true and tostring(vim.bo.modified) == true then
		output_prefix_buffer = output_prefix_buffer .. "[+]" -- has changes.
	elseif vim.bo.readonly == true then
		output_prefix_buffer = output_prefix_buffer .. "[-]" -- readonly.
	end

	available_character_count = available_character_count - #output_prefix_buffer

	--suffix display.

	-- get user opened buffers.
	local buffer_quantity = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buffer = vim.api.nvim_get_current_buf()
	if current_buffer == nil then
		current_buffer = 999
	end
	output_suffix_buffer = output_suffix_buffer .. "[" .. tostring(current_buffer) .. ":" .. tostring(#buffer_quantity) .. "]" .. output_padding

	available_character_count = available_character_count - #output_suffix_buffer

	-- output buffers.

	output_buffer = output_buffer .. output_prefix_buffer

	while character_count < available_character_count do
		output_buffer = output_buffer .. " "
		character_count = character_count + 1
	end

	output_buffer = output_buffer .. output_suffix_buffer

	vim.o.statusline = (output_buffer)

end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = sync_output
	end,
})

