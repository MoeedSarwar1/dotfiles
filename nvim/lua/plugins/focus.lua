-- focus.lua - Configuration for focus.nvim plugin
-- Place this file in ~/.config/nvim/lua/plugins/focus.lua

return {
  "nvim-focus/focus.nvim",
  version = "*",
  config = function()
    require("focus").setup({
      -- Enable focus.nvim on startup
      enable = true,
      
      -- Commands to create keymappings
      commands = true,
      
      -- Auto resize settings
      autoresize = {
        enable = true,
        width = 0,      -- Force width (0 = auto)
        height = 0,     -- Force height (0 = auto)
        minwidth = 30,   -- Minimum width
        minheight = 0,  -- Minimum height
        height_quickfix = 10, -- Height of quickfix window
      },
      
      -- Split settings
      split = {
        bufnew = false, -- Create splits for new buffers
        tmux = false,   -- Create tmux splits instead of Neovim splits
      },
      
      -- UI settings
      ui = {
        number = false,          -- Display line numbers in focused window only
        relativenumber = false,  -- Display relative line numbers in focused window
        hybridnumber = false,    -- Display hybrid line numbers in focused window
        absolutenumber_unfocussed = false, -- Preserve absolute numbers in unfocused windows
        cursorline = true,       -- Display cursorline in focused window only
        cursorcolumn = false,    -- Display cursorcolumn in focused window only
        colorcolumn = {
          enable = false,        -- Display colorcolumn in focused window only
          list = '+1',           -- Set list of colorcolumn
        },
        signcolumn = true,       -- Display signcolumn in focused window only
        winhighlight = false,    -- Auto highlighting of focused/unfocused windows
      },
    })

    -- Custom keybindings (compatible with your existing window keymaps)
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Toggle focus mode
    map('n', '<leader>tf', ':FocusToggle<CR>', { desc = "Toggle focus mode" })
    
    -- Your existing keymaps will work with focus.nvim:
    -- ss, sv - Create splits (focus will auto-adjust)
    -- sh, sj, sk, sl - Navigate splits (focus will follow)
    
    -- Additional focus-specific commands
    map('n', '<leader>sm', ':FocusMaximise<CR>', { desc = "Maximize current split" })
    map('n', '<leader>se', ':FocusEqualise<CR>', { desc = "Equalize all splits" })
    map('n', '<leader>sc', ':FocusSplitCycle<CR>', { desc = "Cycle split layout" })
    
    -- Enable/disable focus
    map('n', '<leader>fe', ':FocusEnable<CR>', { desc = "Enable focus mode" })
    map('n', '<leader>fd', ':FocusDisable<CR>', { desc = "Disable focus mode" })

    -- Auto commands for focus behavior
    local augroup = vim.api.nvim_create_augroup("FocusCustom", { clear = true })
    
    -- Disable focus for specific filetypes
    vim.api.nvim_create_autocmd("FileType", {
      group = augroup,
      pattern = { "neo-tree", "NvimTree", "toggleterm", "aerial" },
      callback = function()
        vim.b.focus_disable = true
      end,
    })
    
    -- Auto-disable in diff mode
    vim.api.nvim_create_autocmd("WinEnter", {
      group = augroup,
      callback = function()
        if vim.wo.diff then
          vim.b.focus_disable = true
        end
      end,
    })
    
    -- Highlight focused window
    vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
      group = augroup,
      callback = function()
        vim.wo.cursorline = true
      end,
    })
    
    vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
      group = augroup,
      callback = function()
        vim.wo.cursorline = false
      end,
    })

    -- Custom status message
    print("focus.nvim loaded - Use <leader>tf to toggle focus mode")
  end,
}
