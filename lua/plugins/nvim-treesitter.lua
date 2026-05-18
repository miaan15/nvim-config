return {
  "nvim-treesitter/nvim-treesitter",

  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").cpp = {
          install_info = {
            url = "https://github.com/tree-sitter/tree-sitter-cpp",
            branch = "master",
            generate = false,
          },
        }
      end,
    })

    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    local langs = { "c", "cpp", "lua", "vim", "vimdoc" }

    require("nvim-treesitter").install(langs)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = langs,
      callback = function(args)
        vim.treesitter.start(args.buf)
      end,
    })
  end,
}
