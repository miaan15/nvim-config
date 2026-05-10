return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  opts = {
    open_for_directories = false,
    open_multiple_files_in_tabs = false,
  },
  config = function(_, opts)
    require("yazi").setup(opts)

    vim.keymap.set("n", "<leader>e", "<cmd>Yazi<cr>", { desc = "File [E]xplorer" })
  end,
}