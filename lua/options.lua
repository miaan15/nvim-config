-- <space> as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Look
vim.g.have_nerd_font = true
vim.opt.termguicolors = false

-- Line numbers
vim.o.number = true
vim.o.relativenumber = true

-- Sync clipboard
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Wrap text have the same indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Disable case sensitive (use \C)
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable signcolumn for plugins
vim.o.signcolumn = "yes"

--
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Split dir
vim.o.splitright = true
vim.o.splitbelow = true

--
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show window when lookup
vim.o.inccommand = "split"

-- Hightlight
vim.o.cursorline = true

--
vim.o.scrolloff = 7

-- Need to confirm save changes
vim.o.confirm = true

-- Indents
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Automatically reload the file if it is changed outside
vim.o.autoread = true
vim.cmd("autocmd FocusGained,BufEnter * :silent! checktime")

-- Keymaps
vim.keymap.set("n", "<C-d>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlights" })
vim.keymap.set("t", "<C-d>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<leader>q", "<C-\\><C-n><cmd>bd!<CR>", { desc = "Close terminal" })
vim.keymap.set("n", "<leader>q", "<cmd>bd<CR>", { desc = "Close" })

-- Buffer
vim.keymap.set("n", "gbn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "gbm", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "gbx", ":bdelete<CR>", { desc = "Closes buffer" })
vim.keymap.set("n", "gbb", "<C-^>", { desc = "Switch to last buffer" })

-- Format
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

-- Move
vim.keymap.set('n', '<M-Down>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<M-Up>', ':m .-2<CR>==', { desc = 'Move line up' })

vim.keymap.set('v', '<M-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<M-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
