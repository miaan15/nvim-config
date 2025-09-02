return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Installer
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",

    -- Format
    "stevearc/conform.nvim",

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
    -- Mason setup
    require("mason").setup({})
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "jsonls",
        "cssls",
        "clangd",
        "csharp_ls",
        "omnisharp",
      },
      automatic_installation = true,
    })

    local lspconfig = require("lspconfig")

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local clangd_capabilities = vim.tbl_deep_extend("force", capabilities, {
      offsetEncoding = { "utf-16" },
    })

    -- LSP
    -- lua_ls
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = { format = { enable = false }, diagnostics = { globals = { "vim" } } },
      },
    })

    -- json
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      settings = { json = { validate = { enable = true } } },
    })

    -- css
    lspconfig.cssls.setup({
      capabilities = capabilities,
      settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
      },
    })

    -- C++
    lspconfig.clangd.setup({
      capabilities = clangd_capabilities,
    })

    -- C#
    lspconfig.csharp_ls.setup({
      capabilities = capabilities,
      flags = { debounce_text_changes = 150 },
    })
    lspconfig.omnisharp.setup({
      capabilities = capabilities,
      cmd = { "omnisharp" },
      flags = { debounce_text_changes = 150 },
    })

    -- Formatting
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        objc = { "clang-format" },
        objcpp = { "clang-format" },
      },
      format_on_save = {
        lsp_fallback = false,
        timeout_ms = 500,
      },
    })
  end,
}
