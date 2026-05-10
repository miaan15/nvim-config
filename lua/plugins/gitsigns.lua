return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "-" },
      changedelete = { text = "~" },
      untracked = { text = '#' },
    },
    signs_staged = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '-' },
      changedelete = { text = '~' },
      untracked = { text = '#' },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    current_line_blame = false,
    current_line_blame_opts = { delay = 100 },
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)

    local gitsigns = require("gitsigns")

    vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle Git [B]lame line" })

    vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[G]it [P]review hunk" })
    vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "[G]it [D]iffs" })

    vim.keymap.set("n", "]c", function()
      if vim.wo.diff then  return "]c" end
      gitsigns.nav_hunk("next")
    end, { expr = true, desc = "Next hunk" })

    vim.keymap.set("n", "[c", function()
      if vim.wo.diff then return "[c" end
      gitsigns.nav_hunk("prev")
    end, { expr = true, desc = "Prev hunk" })
  end,
}
