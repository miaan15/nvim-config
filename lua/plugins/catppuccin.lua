return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "frappe",
      transparent_background = true,
      integrations = {},
      custom_highlights = function(colors)
        return {
          -- Main
          Visual = { bg = colors.green, fg = colors.overlay0 },
          CursorLineNr = { fg = colors.green },

          -- Telescope
          TelescopeNormal = { bg = "NONE" },
          TelescopePromptNormal = { bg = "NONE" },
          TelescopeResultsNormal = { bg = "NONE" },
          TelescopePreviewNormal = { bg = "NONE" },
          TelescopePromptTitle = { bg = "NONE", fg = colors.text },
          TelescopeResultsTitle = { bg = "NONE", fg = colors.text },
          TelescopePreviewTitle = { bg = "NONE", fg = colors.text },
          TelescopeBorder = { fg = colors.green, bg = "NONE" },
          TelescopePromptBorder = { fg = colors.green, bg = "NONE" },
          TelescopeResultsBorder = { fg = colors.green, bg = "NONE" },
          TelescopePreviewBorder = { fg = colors.green, bg = "NONE" },

          -- Keyword
          ["@variable.parameter"] = { fg = colors.text },
          ["@property"] = { fg = colors.maroon },
          ["@module"] = { fg = colors.maroon },
          ["Structure"] = { fg = colors.green },
          ["Statement"] = { fg = colors.green },
          ["String"] = { fg = colors.rosewater },
        }
      end,
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
