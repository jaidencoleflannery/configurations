local attached_buffers = {}
local current_buffer = vim.api.nvim_get_current_buf()

local function sync_output(ev)		
	local available_character_count = vim.api.nvim_win_get_width(0)
	local character_count = 0

	local output_prefix_buffer = ""
	local output_suffix_buffer = ""
	local output_buffer = ""
	local output_padding = " "

	local current_file = vim.bo.filetype
	local current_file_output = ""
	local has_file_open = true

	local relative_path = ""

	if current_file ~= "" then
		current_file_output = current_file
		has_file_open = true
	else
		current_file_output = "nvim"
		has_file_open = false
	end

	--prefix display.

	-- filetype.
	output_prefix_buffer = output_padding .. "[" .. current_file_output .. "]" .. output_padding
	
	if has_file_open == true and vim.bo.modified then
		output_prefix_buffer = output_prefix_buffer .. "[+]" .. output_padding -- has changes.
	elseif vim.bo.readonly == true then
		output_prefix_buffer = output_prefix_buffer .. "[-]" .. output_padding -- readonly.
	end

	-- filepath.
	relative_path = vim.fn.expand('%')
	if relative_path == "." then
		relative_path = "./"
	end
	output_prefix_buffer = output_prefix_buffer .. relative_path .. output_padding

	available_character_count = available_character_count - #output_prefix_buffer

	--suffix display.

	-- get user opened buffers.
	local buffer_quantity = vim.fn.getbufinfo({ buflisted = 1 })	
	if current_buffer == nil then
		current_buffer = 0
	end
	output_suffix_buffer = output_suffix_buffer .. tostring(current_buffer) .. ":" .. tostring(#buffer_quantity) .. output_padding

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
	callback = function()
		current_buffer = vim.api.nvim_get_current_buf()
		if not attached_buffers[current_buffer] then
			attached_buffers[current_buffer] = true
			vim.api.nvim_buf_attach(current_buffer, false, {
				on_lines = function()
					sync_output()
				end,
				on_detach = function(_, detached_buffer)
					attached_buffers(detached_buffer) = nil
				end
			})
		end
		sync_output()
	end,
})

