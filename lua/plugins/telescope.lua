return {
  "nvim-telescope/telescope.nvim",

  dependencies = { "nvim-lua/plenary.nvim" },

  opts = {
    defaults = {
      layout_strategy = "bottom_pane",
      layout_config = { height = 0.7, prompt_position = "top", preview_width = 0.4 },
      sorting_strategy = "ascending",
      winblend = 0,
      border = true,
      previewer = true,
      path_display = { "truncate" },
      mappings = {
        i = {
          ["<leader>q"] = function(...)
            require("telescope.actions").close(...)
          end,
        },
      },
    },
  },

  config = function(_, opts)
    require("telescope").setup(opts)

    -- Keymap
    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "<leader>s.h", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>s.k", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>s.s", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })

    vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sF", function()
      builtin.find_files({ hidden = true, no_ignore = true })
    end, { desc = "[S]earch [F]iles no hidden" })

    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "[S]earch [O]ld Files" })

    vim.keymap.set("n", "<leader>s<leader>", function()
      builtin.buffers({
        sort_mru = true,
        ignore_current_buffer = true,
      })
    end, { desc = "[S]earch open buffers []" })

    vim.keymap.set("n", "<leader>s/", function()
      builtin.current_buffer_fuzzy_find()
    end, { desc = "[/] Search this current buffer" })

    vim.keymap.set("n", "<leader>s?", function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = "Live Grep in Open Buffers",
      })
    end, { desc = "[?] Search all open buffers" })
  end,
}
