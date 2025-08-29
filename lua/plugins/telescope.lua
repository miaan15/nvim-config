return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "bottom_pane",
        layout_config = {
          height = 0.5,
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 0,
        border = false,
        previewer = false,
      },
    })
  end,
}
