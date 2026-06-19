return {
	cmd = {
		'clangd',
		'--clang-tidy',
		'--background-index',
		'--offset-encoding=utf-8',
	},
	filetypes = { 'c' },
	root_markers = { 'compile_commands.json', '.clangd', '.git' },
}
