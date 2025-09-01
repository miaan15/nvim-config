return {
  "kelly-lin/ranger.nvim",
  config = function()
    local ranger_nvim = require("ranger-nvim")
    require("ranger-nvim").setup({
      enable_cmds = true,
      replace_netrw = true,
      keybinds = {
        ["ov"] = ranger_nvim.OPEN_MODE.vsplit,
        ["oh"] = ranger_nvim.OPEN_MODE.split,
        ["ot"] = ranger_nvim.OPEN_MODE.tabedit,
        ["or"] = ranger_nvim.OPEN_MODE.rifle,
      },
    })
  end,
}
