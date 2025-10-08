-- ========================================
-- LEADER KEY
-- ========================================
-- Set leader key (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ========================================
-- WINDOW & SPLIT BEHAVIOR
-- ========================================
-- Window splitting behavior
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor" -- Keep cursor position when splitting

-- Window management
vim.opt.winminheight = 0 -- Allow windows to be squashed
vim.opt.winminwidth = 0 -- Allow windows to be squashed
vim.opt.equalalways = false -- Don't automatically resize windows

-- ========================================
-- INPUT & INTERACTION
-- ========================================
-- Disable mouse (encourage keyboard usage)
vim.opt.mouse = ""

-- Command line behavior
vim.opt.cmdheight = 1 -- Command line height
vim.opt.showcmd = true -- Show partial commands
vim.opt.wildmode = "longest:full,full" -- Command completion mode
vim.opt.wildoptions = "pum" -- Use popup menu for completion

-- ========================================
-- UI & VISUAL ELEMENTS
-- ========================================
-- Window bar configuration (shows modification status and filename)
vim.opt.winbar = " "
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
  end,
})

-- Also set it immediately
vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })

-- Tab line behavior
vim.opt.showtabline = 0 -- Never show tab line (using bufferline instead)

-- Line numbers and cursor
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Highlight current line
vim.opt.signcolumn = "yes" -- Always show sign column to prevent shift

-- Visual guides
vim.opt.list = true -- Show invisible characters
vim.opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "›",
  precedes = "‹",
  nbsp = "·",
}

-- ========================================
-- FILE HANDLING & BACKUP
-- ========================================
-- Disable file backups and swaps (use git instead)
vim.opt.swapfile = false -- Don't create swap files
vim.opt.backup = false -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup before overwriting

-- Persistent undo (much better than swap files)
vim.opt.undofile = true -- Enable persistent undo
vim.opt.undolevels = 10000 -- Maximum number of undos
vim.opt.undoreload = 10000 -- Maximum lines to save for undo on buffer reload

-- File handling
vim.opt.autowrite = true -- Auto write when switching buffers
vim.opt.autoread = true -- Auto read when file is changed outside vim
vim.opt.confirm = true -- Confirm before closing unsaved files

-- ========================================
-- SEARCH & NAVIGATION
-- ========================================
-- Scrolling behavior
vim.opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns visible left/right of cursor
vim.opt.smoothscroll = true -- Enable smooth scrolling

-- Search behavior
vim.opt.ignorecase = true -- Ignore case in search
vim.opt.smartcase = true -- Override ignorecase if search has uppercase
vim.opt.incsearch = true -- Show search matches as you type
vim.opt.hlsearch = true -- Highlight search matches

-- ========================================
-- EDITING BEHAVIOR
-- ========================================
-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.softtabstop = 2 -- Number of spaces a tab counts for in editing
vim.opt.tabstop = 2 -- Number of spaces a tab counts for
vim.opt.smartindent = true -- Smart autoindenting
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth

-- Text formatting
vim.opt.wrap = false -- Don't wrap lines
vim.opt.linebreak = true -- Break lines at word boundaries
vim.opt.breakindent = true -- Maintain indent when wrapping
vim.opt.showbreak = "↪ " -- Character to show at start of wrapped lines

-- Completion behavior
vim.opt.completeopt = "menu,menuone,noselect" -- Completion options
vim.opt.pumheight = 10 -- Maximum height of popup menu

-- ========================================
-- PERFORMANCE & TIMING
-- ========================================
-- Timing settings
vim.opt.updatetime = 250 -- Faster completion and diagnostics
vim.opt.timeoutlen = 500 -- Time to wait for mapped sequence
vim.opt.ttimeoutlen = 10 -- Time to wait for key code sequence

-- Redraw settings
vim.opt.lazyredraw = false -- Don't skip redraws (false for better experience)
vim.opt.ttyfast = true -- Assume fast terminal connection

-- ========================================
-- FILE PATTERNS & WILDCARDS
-- ========================================
-- Ignore patterns for file operations
vim.opt.wildignore:append({
  -- Version control
  "*/.git/*",
  "*/.svn/*",
  "*/.hg/*",

  -- Node.js
  "*/node_modules/*",
  "*/npm-debug.log*",
  "*/yarn-debug.log*",
  "*/yarn-error.log*",

  -- Build directories
  "*/dist/*",
  "*/build/*",
  "*/target/*",
  "*/.next/*",
  "*/.nuxt/*",

  -- Temporary files
  "*.tmp",
  "*.temp",
  "*~",
  "*.swp",
  "*.swo",

  -- OS specific
  "*/.DS_Store",
  "*/Thumbs.db",

  -- IDE files
  "*/.vscode/*",
  "*/.idea/*",

  -- Logs
  "*.log",

  -- Archives
  "*.zip",
  "*.tar.gz",
  "*.rar",

  -- Images (optional)
  "*.jpg",
  "*.jpeg",
  "*.png",
  "*.gif",
  "*.ico",

  -- Fonts
  "*.ttf",
  "*.woff",
  "*.woff2",
})

-- ========================================
-- ADDITIONAL ENHANCEMENTS
-- ========================================
-- Better diff algorithm
vim.opt.diffopt:append("linematch:60")

-- Session options
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Format options (control auto-formatting behavior)
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Don't auto-comment on new lines

-- Clipboard integration (if you want system clipboard)
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = "unnamedplus" -- Use system clipboard
end

-- Virtual edit (allow cursor beyond end of line in visual block mode)
vim.opt.virtualedit = "block"

-- Fold settings
vim.opt.foldenable = true -- Enable folding
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.foldlevelstart = 99 -- Start with all folds open
vim.opt.foldcolumn = "1" -- Show fold column
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use treesitter for folding

-- Spell checking
vim.opt.spelllang = { "en_us" } -- Spell check language
vim.opt.spelloptions = "camel" -- Spell check camelCase words

-- Title
vim.opt.title = true -- Set window title
vim.opt.titlestring = "%<%F%=%l/%L - nvim" -- Title format

-- Status line (if not using lualine)
vim.opt.laststatus = 3 -- Global statusline

-- ========================================
-- FILETYPE SPECIFIC SETTINGS
-- ========================================
-- Auto commands for specific file types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "Enable wrap and spell for git commits and markdown",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "lazyterm",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
  desc = "Disable indent scope for certain filetypes",
})

-- ========================================
-- DIAGNOSTIC CONFIGURATION
-- ========================================
-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- ========================================
-- CUSTOM COMMANDS
-- ========================================
-- Command to toggle between absolute and relative line numbers
vim.api.nvim_create_user_command("ToggleNumber", function()
  if vim.opt.relativenumber:get() then
    vim.opt.relativenumber = false
    vim.notify("Relative numbers OFF", vim.log.levels.INFO)
  else
    vim.opt.relativenumber = true
    vim.notify("Relative numbers ON", vim.log.levels.INFO)
  end
end, { desc = "Toggle relative line numbers" })

-- Command to clean up trailing whitespace
vim.api.nvim_create_user_command("CleanWhitespace", function()
  local save_cursor = vim.fn.getpos(".")
  vim.cmd([[%s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
  vim.notify("Trailing whitespace cleaned", vim.log.levels.INFO)
end, { desc = "Remove trailing whitespace" })
