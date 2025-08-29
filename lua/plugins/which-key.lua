return {
  "folke/which-key.nvim",
  opts = {
    icons = {
      mappings = vim.g.have_nerd_font,
    },
    spec = {
      { "<leader>s", group = "[S]earch" },
      { "<leader>t", group = "[T]oggle" },
      { "<leader>g", group = "[G]it" },
      { "gb", group = "[B]uffer" },
    },
  },
}
