return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  dependencies = {
    {
      "folke/twilight.nvim",
      opts = {
        dimming = {
          alpha = 0.25,
          color = { "Normal", "#ffffff" },
          term_bg = "#000000",
          inactive = false,
        },
        context = 10,
        treesitter = false, -- twilight crashes on nvim 0.12 when a buffer has no parser
        expand = {
          "function",
          "method",
          "table",
          "if_statement",
        },
        exclude = {},
      },
    },
  },
  keys = {
    { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    { "<leader>zt", "<cmd>Twilight<cr>", desc = "Toggle Twilight" },
  },
  opts = {
    window = {
      backdrop = 0.95,
      width = 0.8,
      height = 1,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
        wrap = false,
        linebreak = true,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 0,
      },
      twilight = { enabled = true },
      gitsigns = { enabled = false },
      tmux = { enabled = true },
    },
    on_open = function()
      Snacks.indent.disable()
    end,
    on_close = function()
      Snacks.indent.enable()
    end,
  },
}
