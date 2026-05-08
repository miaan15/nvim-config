return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Installer
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

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
    local util = require("lspconfig.util")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    ---------------------------------------------------------------------
    -- Servers/LSP
    ---------------------------------------------------------------------
    require("mason").setup({})

    local servers = {}

    local ensure_installed = vim.tbl_keys(servers or {})
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    require("mason-lspconfig").setup({
      ensure_installed = {},
      automatic_installation = true,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          lspconfig[server_name].setup(server)
        end,
      },
    })

    vim.lsp.config("clangd", {
      install = {
        cmd = { "/usr/sbin/clangd" },
      },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      setup = {
        cmd = {
          "/usr/sbin/clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        root_dir = vim.fs.root(0, { "compile_commands.json", ".clangd", ".git" }),
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
      },
    })

    vim.lsp.enable("clangd")

    ---------------------------------------------------------------------
    -- Diagnostic
    ---------------------------------------------------------------------
    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    })

    ---------------------------------------------------------------------
    -- Format
    ---------------------------------------------------------------------
    -- require("conform").setup({
    --   format_on_save = {
    --     timeout_ms = 500,
    --     lsp_format = "fallback",
    --   },
    -- })
  end,
}
