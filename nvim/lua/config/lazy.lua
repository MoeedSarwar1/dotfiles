-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    -- ========================================
    -- CORE LAZYVIM SETUP
    -- ========================================
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        colorscheme = "tokyonight", -- or your preferred colorscheme
      },
    },

    -- ========================================
    -- LAZYVIM EXTRAS
    -- ========================================
    -- Language Support
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.markdown" },

    -- Development Tools
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.test.core" },

    -- AI Integration
    { import = "lazyvim.plugins.extras.ai.copilot" },
    { import = "lazyvim.plugins.extras.ai.copilot-chat" },

    -- UI Enhancements
    { import = "lazyvim.plugins.extras.ui.alpha" },
    { import = "lazyvim.plugins.extras.editor.mini-files" },

    -- ========================================
    -- CUSTOM PLUGINS
    -- ========================================
    -- Import user plugins
    { import = "plugins" },

    -- Text Manipulation
    {
      "kylechui/nvim-surround",
      version = "*",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
            change_line = "cS",
          },
        })
      end,
    },

    -- Git Integration
    {
      "f-person/git-blame.nvim",
      event = "VeryLazy",
      opts = {
        enabled = true,
        message_template = " <summary> • <date> • <author> • <<sha>>",
        date_format = "%m-%d-%Y %H:%M:%S",
        virtual_text_column = 1,
        display_virtual_text = true,
        ignored_filetypes = { "gitcommit", "gitrebase", "gitconfig" },
        delay = 1000,
      },
      keys = {
        { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
        { "<leader>gB", "<cmd>GitBlameCopySHA<cr>", desc = "Copy Git SHA" },
      },
    },

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
        { "<leader>lf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit Current File" },
        { "<leader>lc", "<cmd>LazyGitConfig<cr>", desc = "LazyGit Config" },
      },
      config = function()
        vim.g.lazygit_floating_window_winblend = 0
        vim.g.lazygit_floating_window_scaling_factor = 0.9
        vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
        vim.g.lazygit_floating_window_use_plenary = 0
      end,
    },

    -- Modern Utilities (Snacks)
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        -- Core features
        bigfile = {
          enabled = true,
          size = 1.5 * 1024 * 1024, -- 1.5MB
        },
        dashboard = {
          enabled = true,
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
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
        zen = { enabled = false }, -- We use zen-mode.nvim instead
      },
    },

    -- Productivity Tools
{
  "okuuva/auto-save.nvim",
  cmd = "ASToggle",
  event = { "InsertLeave", "TextChanged" },
  opts = {
    enabled = true,
    trigger_events = { "InsertLeave", "TextChanged" },
    write_all_buffers = false, -- Save only current buffer
    debounce_delay = 1000,     -- 1 second debounce

    -- Save conditions
    condition = function(buf)
      local fn = vim.fn
      local utils = require("auto-save.utils.data")
      -- Don't save special buffer types
      if utils.not_in(fn.getbufvar(buf, "&filetype"), { "oil", "alpha" }) then
        return true
      end
      return false
    end,

    -- Callbacks for custom actions
    callbacks = {
      before_saving = function(buf)
        -- Organize imports for TypeScript/JavaScript
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(buf) },
          title = ""
        }
        local clients = vim.lsp.get_active_clients({buf = buf})
        for _, client in ipairs(clients) do
          if client.name == "tsserver" then
            client.request_sync("workspace/executeCommand", params, nil, buf)
          end
        end
      end,
    },
  },
  keys = {
    { "<leader>as", "<cmd>ASToggle<cr>", desc = "Toggle Auto Save" },
  },
},

    -- Focus Mode
    {
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
            treesitter = true,
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
          width = 0.8, -- Use percentage for responsiveness
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
          kitty = {
            enabled = false,
            font = "+4",
          },
        },
        on_open = function()
          vim.cmd("IBLDisable")
          vim.opt.showtabline = 0
        end,
        on_close = function()
          vim.cmd("IBLEnable")
          vim.opt.showtabline = 2
        end,
      },
    },
  },

  -- ========================================
  -- LAZY.NVIM CONFIGURATION
  -- ========================================
  defaults = {
    lazy = false,
    version = false, -- Always use latest git commit
  },

  install = {
    colorscheme = { "tokyonight", "habamax" },
    missing = true,
  },

  checker = {
    enabled = true,
    notify = false, -- Reduce notification noise
    frequency = 3600, -- Check every hour
    check_pinned = false,
  },

  change_detection = {
    enabled = true,
    notify = false, -- Reduce notification noise
  },

  ui = {
    wrap = true,
    size = {
      width = 0.8,
      height = 0.8,
    },
    border = "rounded",
    backdrop = 60,
  },

  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      paths = {},
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "matchit",
        "matchparen",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
      },
    },
  },

  debug = false,
})
