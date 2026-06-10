vim.print('Booted.')

-- <Plug> is a special sequence that is never typeable by the user, it is for internal mapping within a script.

-- (mode, key sequence, action).
vim.keymap.set('n', '<Plug>(SayHello)', function()
	print('Prompted via n.')
end)

-- (mode, key sequence, action).
vim.keymap.set('v', '<Plug>(SayHello)', function()
	print('Prompted via v.')
end)
