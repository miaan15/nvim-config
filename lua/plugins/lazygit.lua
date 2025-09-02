return {
  "kdheepak/lazygit.nvim",
  cmd = "LazyGit",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.g.lazygit_floating_window_scaling_factor = 1.0
  end,
}
