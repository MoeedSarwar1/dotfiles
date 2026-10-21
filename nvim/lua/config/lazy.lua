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
        colorscheme = "catppuccin-mocha",
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
    { import = "lazyvim.plugins.extras.lang.python" }, -- pyright + ruff

    -- Development Tools
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.test.core" },

    -- Editing
    { import = "lazyvim.plugins.extras.coding.mini-surround" }, -- gsa / gsd / gsr add, delete, replace surroundings
    { import = "lazyvim.plugins.extras.coding.yanky" }, -- yank history; [y / ]y cycle after a paste
    { import = "lazyvim.plugins.extras.editor.inc-rename" }, -- <leader>cr previews the rename live

    -- UI Enhancements
    { import = "lazyvim.plugins.extras.editor.mini-files" },

    -- ========================================
    -- CUSTOM PLUGINS (lua/plugins/*.lua)
    -- ========================================
    { import = "plugins" },
  },

  -- ========================================
  -- LAZY.NVIM CONFIGURATION
  -- ========================================
  defaults = {
    lazy = false,
    version = false, -- Always use latest git commit
  },

  install = {
    colorscheme = { "catppuccin-mocha", "tokyonight", "habamax" },
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
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin", -- nvim-tree replaces netrw
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
