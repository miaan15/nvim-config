return {
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Installer
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Format
    "stevearc/conform.nvim",
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
    -- Keymaps
    ---------------------------------------------------------------------
    local builtin = require("telescope.builtin")
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or "n"
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end
        map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
        map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
        map("grt", builtin.lsp_type_definitions, "[G]oto [T]ype Definition")
        map("grr", builtin.lsp_references, "[G]oto [R]eferences")
        map("K", vim.lsp.buf.hover, "")
        map("<C-k>", vim.lsp.buf.signature_help, "")

        map("<leader>ss", builtin.lsp_document_symbols, "[S]earch Document [S]ymbols")
        map("<leader>sS", builtin.lsp_dynamic_workspace_symbols, "[S]earch Workspace [S]ymbols")

        if vim.lsp.inlay_hint then
          map("<leader>th", function()
            local enabled = false
            if vim.lsp.inlay_hint.is_enabled then
              enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
            end
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
          end, "[T]oggle Inlay [H]ints")
        end
      end,
    })
  end,
}
