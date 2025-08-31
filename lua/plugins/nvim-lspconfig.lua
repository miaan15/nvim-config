return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Format
    "stevearc/conform.nvim",

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
  },
  config = function()
    local lspconfig = require("lspconfig")

    -- Setup nvim-cmp
    local cmp = require("cmp")
    cmp.setup({
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-Y>"] = cmp.mapping.confirm({ select = false }),
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local clangd_capabilities = vim.tbl_deep_extend("force", capabilities, {
      offsetEncoding = { "utf-16" },
    })

    -- LSP
    -- lua_ls
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          format = { enable = false },
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    -- json
    lspconfig.jsonls.setup({
      capabilities = capabilities,
      settings = {
        json = {
          validate = { enable = true },
        },
      },
    })

    -- C++
    lspconfig.clangd.setup({
      capabilities = clangd_capabilities,
      -- cmd = {
      --   "clangd",
      --   "--background-index",
      --   "--clang-tidy",
      --   "--completion-style=detailed",
      --   "--header-insertion=never",
      -- },
      -- init_options = { clangdFileStatus = true },
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
