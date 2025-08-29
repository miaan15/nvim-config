return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
  },
  config = function()
    local lspconfig = require("lspconfig")

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- LSP
    -- lua_ls
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          format = { enable = false },
        },
      },
    })

    -- Formatting
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
      },
      format_on_save = {
        lsp_fallback = false,
        timeout_ms = 500,
      },
    })
  end,
}
