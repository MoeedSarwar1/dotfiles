-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/config/keymaps.lua

-- Load discipline plugin
local discipline = require("shaggy.discipline")
discipline.cowboy()

-- Set up keymap helper
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ========================================
-- ARROW KEYS DISCIPLINE
-- ========================================
-- Disable arrow keys in normal and insert mode to encourage hjkl usage
local arrow_keys = { "<Up>", "<Down>", "<Left>", "<Right>" }
for _, key in ipairs(arrow_keys) do
  keymap("n", key, "<nop>", opts)
  keymap("i", key, "<nop>", opts)
end

-- ========================================
-- INSERT MODE IMPROVEMENTS
-- ========================================
-- Quick escape from insert mode
keymap("i", "jj", "<Esc>", opts)
keymap("i", "jk", "<Esc>", opts) -- Alternative escape

-- ========================================
-- REGISTER-FRIENDLY OPERATIONS
-- ========================================
-- Operations that don't affect default register
keymap("n", "x", '"_x', { desc = "Delete character without yanking" })

-- Paste from yank register (register 0)
keymap({ "n", "v" }, "<leader>p", '"0p', { desc = "Paste from yank register" })

-- Delete without affecting default register
-- (<leader>c and <leader>x are LazyVim's code/diagnostics groups, so they stay free)
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- ========================================
-- EDITING ENHANCEMENTS
-- ========================================
-- Increment/decrement numbers
keymap("n", "+", "<C-a>", { desc = "Increment number" })
keymap("n", "-", "<C-x>", { desc = "Decrement number" })

-- Select all: ggVG (<C-a> is the tmux prefix, so a mapping on it never reaches nvim)

-- Insert blank lines without entering insert mode
keymap("n", "<leader>o", "o<Esc>", { desc = "Insert line below" })
keymap("n", "<leader>O", "O<Esc>", { desc = "Insert line above" })

-- ========================================
-- NAVIGATION
-- ========================================
-- Better jumplist navigation
keymap("n", "<C-m>", "<C-i>", opts)

-- ========================================
-- BUFFER MANAGEMENT
-- ========================================
-- Buffer navigation
keymap("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- <leader>bd / <leader>bD come from LazyVim (Snacks.bufdelete keeps the window layout)

-- ========================================
-- WINDOW MANAGEMENT
-- ========================================
-- Splits: LazyVim's <leader>- and <leader>| (s stays free for flash)
-- Move between splits and tmux panes: <C-h/j/k/l> (see plugins/navigation.lua)
-- Close a split: <leader>wd

-- Resize windows
keymap("n", "<C-w><Left>", "<C-w><", { desc = "Decrease window width" })
keymap("n", "<C-w><Right>", "<C-w>>", { desc = "Increase window width" })
keymap("n", "<C-w><Up>", "<C-w>+", { desc = "Increase window height" })
keymap("n", "<C-w><Down>", "<C-w>-", { desc = "Decrease window height" })

-- Alternative resize with arrow keys for consistency
keymap("n", "<C-Left>", "<C-w><", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<C-w>>", { desc = "Increase window width" })
keymap("n", "<C-Up>", "<C-w>+", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<C-w>-", { desc = "Decrease window height" })

-- ========================================
-- DIAGNOSTICS & LSP
-- ========================================
-- Diagnostic navigation: LazyVim's ]d / [d (errors only: ]e / [e)
-- Line diagnostics float: LazyVim's <leader>cd

-- ========================================
-- UTILITY KEYMAPS
-- ========================================
-- Clear search highlighting: <Esc> (LazyVim); <leader>/ is grep

-- Better indenting (keeps selection)
keymap("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up/down
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centered when jumping
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
