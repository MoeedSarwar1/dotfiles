return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = {
      enabled = true,
      size = 1.5 * 1024 * 1024,
    },
    indent = {
      enabled = true,
      animate = {
        enabled = vim.g.snacks_animate ~= false,
      },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
    },
    quickfile = { enabled = true },
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 250 },
        easing = "linear",
      },
    },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = true,
        git_hl = true,
      },
      git = {
        patterns = { "GitSign", "MiniDiffSign" },
      },
    },
    words = {
      enabled = true,
      debounce = 200,
    },
    zen = { enabled = false },
    image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
        max_width = 80,
        max_height = 40,
      },
      img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
    },
    dashboard = {
      enabled = true,
      width = 60,
      row = nil,
      col = nil,
      pane_gap = 4,
      autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
      preset = {
        pick = nil,
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        header = [[
███████╗██╗  ██╗ █████╗  ██████╗  ██████╗██╗   ██╗
██╔════╝██║  ██║██╔══██╗██╔════╝ ██╔════╝╚██╗ ██╔╝
███████╗███████║███████║██║  ███╗██║  ███╗╚████╔╝ 
╚════██║██╔══██║██╔══██║██║   ██║██║   ██║ ╚██╔╝  
███████║██║  ██║██║  ██║╚██████╔╝╚██████╔╝  ██║   
╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝   ╚═╝   
        ]],
      },
      sections = {
        { section = "header" },
        {
          pane = 2,
          section = "terminal",
          cmd = "colorscript -e square",
          height = 5,
          padding = 1,
          enabled = function()
            return vim.fn.executable("colorscript") == 1
          end,
        },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
          ttl = 5 * 60,
          indent = 3,
        },
        { section = "startup" },
      },
    },
  },
}
