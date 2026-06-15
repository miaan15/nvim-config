vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.opt.termguicolors = false
vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '?' }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 4
vim.o.confirm = true
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 1
vim.opt.path:append("**")
vim.opt.wildmenu = true

vim.schedule(function() vim.o.clipboard = "unnamedplus" end)
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set softtabstop=4")

vim.o.autoread = true
vim.cmd("autocmd FocusGained,BufEnter * :silent! checktime")

vim.opt.path:append("**")
vim.opt.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/vendor/*", "*/build/*" })
vim.opt.wildmode = "longest:full,full"

require("diagnostics")

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    group = vim.api.nvim_create_augroup("cpp-colorcolumn", { clear = true }),
    callback = function()
        vim.opt_local.colorcolumn = "81"
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_user_command('WhitespaceTrim', function()
    local save_cursor = vim.api.nvim_win_get_cursor(0)
    local last_search = vim.fn.getreg('/')
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, save_cursor)
    vim.fn.setreg('/', last_search)
    vim.cmd('nohlsearch')
end, {})

_G.tg_term_buf = nil
vim.api.nvim_create_user_command('ToggleTerminal', function()
    if _G.tg_term_buf and vim.api.nvim_get_current_buf() == _G.tg_term_buf then
        vim.cmd("buffer #")
        return
    end

    if _G.tg_term_buf and vim.api.nvim_buf_is_valid(_G.tg_term_buf) then
        vim.api.nvim_win_set_buf(0, _G.tg_term_buf)
    else
        vim.cmd("terminal")
        _G.tg_term_buf = vim.api.nvim_get_current_buf()
        pcall(vim.api.nvim_buf_set_name, _G.tg_term_buf, "term_tg_")
    end

    vim.cmd("startinsert")
end, {})

vim.api.nvim_create_user_command("SplitSmart", function()
    local windows = vim.api.nvim_tabpage_list_wins(0)
    local current_window_count = #windows

    if current_window_count % 2 ~= 0 then vim.cmd("vsplit")
    else vim.cmd("split") end
end, {})

vim.api.nvim_create_user_command("LastBuffer", function()
    local alt_buf = vim.fn.bufnr('#')
    if alt_buf ~= -1 and vim.fn.buflisted(alt_buf) == 1 then
        vim.cmd('buffer #')
    else
        pcall(vim.cmd, 'bprevious')
    end
end, {})

vim.api.nvim_create_user_command("BufferMenu", function()
    local buffers = {}
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
            table.insert(buffers, bufnr)
        end
    end

    if #buffers == 0 then
        print("No buffers open")
        return
    end

    local lines = {}
    local buf_map = {}

    for i, bufnr in ipairs(buffers) do
        local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
        if name == "" then name = "[]" end
        table.insert(lines, string.format("%d\t %s", i, name))
        buf_map[tostring(i)] = bufnr
    end

    local height = #lines + 1
    vim.cmd("botright " .. height .. "new")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "buffer_menu"
    vim.wo[win].number = false
    vim.wo[win].relativenumber = false
    vim.wo[win].cursorline = true

    for key, target_buf in pairs(buf_map) do
        vim.keymap.set('n', key, function()
            vim.cmd("bd!")
            vim.api.nvim_set_current_buf(target_buf)
        end, { buffer = buf, nowait = true })
    end

    vim.keymap.set('n', '<Esc>', '<cmd>bd!<CR>', { buffer = buf })
end, {})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set("n", "<M-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<M-Down>", "<cmd>m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<M-Up>", "<cmd>m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<M-Left>", "<<", { desc = "Shift left" })
vim.keymap.set("n", "<M-Right>", ">>", { desc = "Shift right" })
vim.keymap.set("v", "<M-Left>", "<gv", { desc = "Shift left" })
vim.keymap.set("v", "<M-Right>", ">gv", { desc = "Shift right" })

vim.keymap.set('n', '<leader>b', '<cmd>BufferMenu<CR>', { desc = 'List and select buffer' })
vim.keymap.set('n', "<leader>x", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>n", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>m", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>,", "<cmd>LastBuffer<CR>", { desc = "Previous buffer" })

vim.keymap.set('n', '<S-Up>', '{', { desc = "Jump to previous empty line" })
vim.keymap.set('n', '<S-Down>', '}', { desc = "Jump to next empty line" })

vim.keymap.set("n", "<leader>f", ":e <C-R>=expand('%:p:h') . '/'<CR>", { desc = "Find find" })
vim.keymap.set("n", "<leader>F", ":find ", { desc = "Find find fuzzy" })

vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerminal<CR>", { desc = "Toggle Terminal" })

vim.keymap.set("n", "<leader>/", "<cmd>SplitSmart<CR>", { desc = "Split window smart" })

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Show line diagnostics" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { -- Theme
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "auto",
                custom_highlights = function(colors)
                    return {
                        ["@variable.parameter"] = { fg = colors.green },
                        ["@function"] = { fg = colors.blue },
                        ["@module"] = { fg = colors.maroon },

                        ["@property"] = { fg = colors.sky },

                        ["Structure"] = { fg = colors.green },
                        ["Statement"] = { fg = colors.green },

                        ["String"] = { fg = colors.rosewater },
                    }
                end,
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    { -- which-key
        "folke/which-key.nvim",
    },
    { -- Treesitter
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local langs = { "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }

            require("nvim-treesitter").setup({
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                install_dir = vim.fn.stdpath('data') .. '/site',
            })

            require('nvim-treesitter').install(langs)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = langs,
                callback = function(args)
                    vim.treesitter.start()
                end,
            })
        end,
    },
    { -- LSP
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                },
            })
            vim.lsp.enable("clangd")
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
                callback = function(ev)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition", buffer = ev.buf })
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Go to References", buffer = ev.buf })
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover Documentation", buffer = ev.buf })
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol", buffer = ev.buf })
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action", buffer = ev.buf })
                end,
            })
        end,
    },
    { -- Indent Line
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPre",
        config = function()
            require("ibl").setup({
                indent = {
                    char = "▏",
                },
                scope = {
                    show_start = false,
                    show_end = false,
                },
            })
        end,
    },
    { -- Explore
        'stevearc/oil.nvim',
        config = function()
            require("oil").setup({
                default_file_explorer = true,
                columns = {
                    { "permissions" },
                    { "size", align = "right" },
                    { "mtime", format = "%Y-%m-%d [%H:%M]" },
                },
            })
            vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })
        end
    },
    { -- Virtual column
        "lukas-reineke/virt-column.nvim",
        opts = {
            char = "▏",
        },
    },
    { -- Git Sign
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "-" },
                changedelete = { text = "~" },
                untracked = { text = "#" },
            },
            signs_staged = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "-" },
                changedelete = { text = "~" },
                untracked = { text = "#" },
            },
            signcolumn = true,
            numhl = false,
            linehl = false,
            word_diff = false,
            current_line_blame = false,
            current_line_blame_opts = { delay = 100 },
        },
    },
})
