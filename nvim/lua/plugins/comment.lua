return {
  {
    "numToStr/Comment.nvim",
    event = "BufRead",
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
}
