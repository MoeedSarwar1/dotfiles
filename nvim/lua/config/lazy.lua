local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- import extras modules
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.ai.copilot" },
    { import = "lazyvim.plugins.extras.ai.copilot-chat" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.test.core" },

    -- import/override with your plugins
    { import = "plugins" },

    -- Surround plugin
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end,
    },

    -- Git blame
    {
      "f-person/git-blame.nvim",
      event = "VeryLazy",
      opts = {
        enabled = true,
        message_template = " <summary> • <date> • <author> • <<sha>>",
        date_format = "%m-%d-%Y %H:%M:%S",
        virtual_text_column = 1,
      },
    },

    -- FZF Lua (better than default telescope for some use cases)
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (FZF)" },
        { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep (FZF)" },
        { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find Buffers (FZF)" },
      },
      opts = {},
    },

    -- LazyGit
    {
      "kdheepak/lazygit.nvim",
      cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
      },
    },

    -- Snacks (modern LazyVim utility collection)
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
      },
    },

    -- Auto-save
    {
      "okuuva/auto-save.nvim",
      cmd = "ASToggle",
      event = { "InsertLeave", "TextChanged" },
      opts = {
        enabled = true,
        delay = 3000,
        execution_message = {
          enabled = false, -- disable save notifications
        },
      },
    },

    -- Zen Mode
    {
      "folke/zen-mode.nvim",
      cmd = "ZenMode",
      keys = {
        { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
      },
      opts = {
        window = {
          backdrop = 0.95,
          width = 120,
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
          },
          twilight = { enabled = false },
          gitsigns = { enabled = false },
          tmux = { enabled = true },
        },
      },
    },
  },

  defaults = {
    lazy = false,
    version = false,
  },

  checker = {
    enabled = true,
    frequency = 3600, -- check every hour instead of constantly
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
