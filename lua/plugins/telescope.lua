return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        layout_strategy = "bottom_pane",
        layout_config = { height = 0.7, prompt_position = "top", preview_width = 0.45 },
        sorting_strategy = "ascending",
        winblend = 0,
        border = true,
        previewer = true,
        path_display = { "truncate" },
        file_ignore_patterns = {
          "%.png$",
          "%.jpg$",
          "%.asset$",
          "%.meta$",
          "%.asmdef$",
          "%.unitypackage$",
          "%.mat$",
          "%.hdr$",
          "%.exr$",
          "%.shader$",
          "%.shadergraph$",
          "%.blend$",
          "%.tiff$",
          "%.controller$",
          "%.anim$",
          "%.fbx$",
          "^Library/",
          "^Temp/",
          "^obj/",
        },
      },
    })
  end,
}
