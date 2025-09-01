-- Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Force use vim motions
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Move focus
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Move windows
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Buffer
vim.keymap.set("n", "gbn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "gbm", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "gbx", ":bdelete<CR>", { desc = "Closes buffer" })
vim.keymap.set("n", "gbb", "<C-^>", { desc = "Switch to last buffer" })

--
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- LSP
local builtin = require("telescope.builtin")
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
    map("grr", builtin.lsp_references, "[G]oto [R]eferences")
    map("gri", builtin.lsp_implementations, "[G]oto [I]mplementation")
    map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gO", builtin.lsp_document_symbols, "Open Document Symbols")
    map("gW", builtin.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
    map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
  end,
})

-- Format
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

-- Telescope
vim.keymap.set("n", "<leader>s.h", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>s.k", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>s.s", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sF", function()
  builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = "[S]earch [F]iles no hidden" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "[S]earch [O]ld Files" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Last [S]earch" })
vim.keymap.set("n", "<leader>s<leader>", function()
  builtin.buffers({
    sort_mru = true,
    ignore_current_buffer = true,
  })
end, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find()
end, { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })

-- Git
vim.keymap.set("n", "<leader>g<leader>", "<cmd>LazyGit<cr>", { desc = "Lazy[G]it" })
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle Git [B]lame line" })
vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { desc = "[G]it [P]review hunk" })
vim.keymap.set("n", "<leader>gd", gitsigns.diffthis, { desc = "[G]it [D]iffs" })
vim.keymap.set("n", "]c", function()
  if vim.wo.diff then
    return "]c"
  end
  gitsigns.nav_hunk("next")
end, { expr = true, desc = "Next hunk" })

vim.keymap.set("n", "[c", function()
  if vim.wo.diff then
    return "[c"
  end
  gitsigns.nav_hunk("prev")
end, { expr = true, desc = "Prev hunk" })

vim.api.nvim_set_keymap("n", "<leader>e", "", {
  noremap = true,
  callback = function()
    require("ranger-nvim").open(true)
  end,
})
