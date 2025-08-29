return {
  "folke/which-key.nvim",
  opts = {
    icons = {
      mappings = vim.g.have_nerd_font,
    },
    spec = {
      { "<leader>s", group = "[S]earch" },
      { "gb", group = "[B]uffer" },
    },
  },
}
