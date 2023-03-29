local status, theme = pcall(require, 'tokyonight')
if not status then
	return
end

-- Set colorscheme with Vim cmd
vim.cmd('colorscheme tokyonight')
