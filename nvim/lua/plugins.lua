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
			import = "plugins.coding",
		},
		{
			import = "plugins.colortheme",
		},
		{
			import = "plugins.core",
		},
		{
			import = "plugins.editor",
		},
		{
			import = "plugins.ui",
		},
		{
			import = "plugins.utils",
		},
	},
})
