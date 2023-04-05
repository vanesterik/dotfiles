-- Set various options - ie. numbers, tabstop, updatetime, etc.
require("options")

-- Set various keymaps - ie. buffers, tabs, windows, etc.
require("keymaps")

-- Implement LazyVim as plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Set LazyVim config with plugins folder as import source
require("lazy").setup({
	checker = {
		enabled = true,
	},
	defaults = {
		lazy = false,
		version = false,
	},
	spec = {
		{
			import = "plugins",
		},
	},
})

-- Set colorscheme of theme which is imported as plugin
vim.cmd.colorscheme "catppuccin"
