return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "bottom_pane",
        layout_config = { height = 0.7, prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        border = true,
        previewer = true,
      },
    })
  end,
}
