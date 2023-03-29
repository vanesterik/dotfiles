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

local status_packer, lazy = pcall(require, "lazy")
if not status_packer then
  print("Lazy is not installed")
  return
end

lazy.setup({
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
  { "folke/which-key.nvim", lazy = true, opts = {} },
  { "numToStr/Comment.nvim", event = "BufRead" },
  { 
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        float = {
          enable = true,
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            local window_w = screen_w * 0.5 
            local window_h = screen_h * 0.8 
            local window_w_int = math.floor(window_w)
            local window_h_int = math.floor(window_h)
            local center_x = (screen_w - window_w) / 2
            local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
            return {
              border = 'rounded',
              relative = 'editor',
              row = center_y,
              col = center_x,
              width = window_w_int,
              height = window_h_int,
            }
          end,
        },
        width = function()
          return math.floor(vim.opt.columns:get() * 0.5)
        end,
      }
    }
  },
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  { 
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "tokyonight",
      },
      tabline = {
        lualine_a = {'buffers'},
        lualine_b = {'filename'},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'tabs'}  
      }
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = { "telescope-fzf-native.nvim", "telescope-ui-select.nvim" },
    lazy = true,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
  { "nvim-telescope/telescope-ui-select.nvim", lazy = true },
  { "rcarriga/nvim-notify" }
})
