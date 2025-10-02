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

-- Delete/change/cut without affecting default register
keymap({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
keymap({ "n", "v" }, "<leader>c", '"_c', { desc = "Change without yanking" })
keymap({ "n", "v" }, "<leader>x", '"_x', { desc = "Cut without yanking" })

-- ========================================
-- EDITING ENHANCEMENTS
-- ========================================
-- Increment/decrement numbers
keymap("n", "+", "<C-a>", { desc = "Increment number" })
keymap("n", "-", "<C-x>", { desc = "Decrement number" })

-- Better word deletion
keymap("n", "dw", 'vb"_d', { desc = "Delete word backwards without yanking" })

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", { desc = "Select all text" })

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
keymap("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })

-- Close buffer
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
keymap("n", "<leader>bD", ":bdelete!<CR>", { desc = "Force delete buffer" })

-- Navigate to specific buffer with fzf
keymap("n", "<leader>bb", ":FzfLua buffers<CR>", { desc = "Find buffers" })

-- ========================================
-- WINDOW MANAGEMENT
-- ========================================
-- Split windows
keymap("n", "ss", "<C-w>s", { desc = "Horizontal split" })
keymap("n", "sv", "<C-w>v", { desc = "Vertical split" })

-- Navigate windows
keymap("n", "sh", "<C-w>h", { desc = "Move to left window" })
keymap("n", "sj", "<C-w>j", { desc = "Move to bottom window" })
keymap("n", "sk", "<C-w>k", { desc = "Move to top window" })
keymap("n", "sl", "<C-w>l", { desc = "Move to right window" })

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

-- Close window
keymap("n", "sq", "<C-w>q", { desc = "Close window" })

-- ========================================
-- PLUGIN-SPECIFIC KEYMAPS
-- ========================================
-- Copilot Chat
keymap("n", "<leader>cQ", function()
  require("CopilotChat").open()
end, { desc = "Open Copilot Chat" })

keymap("n", "<leader>cq", function()
  require("CopilotChat").close()
end, { desc = "Close Copilot Chat" })

-- Zen mode
keymap("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })

-- ========================================
-- DIAGNOSTICS & LSP
-- ========================================
-- Diagnostic navigation
keymap("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, { desc = "Next diagnostic" })

keymap("n", "<C-k>", function()
  vim.diagnostic.goto_prev()
end, { desc = "Previous diagnostic" })

-- Show diagnostic information
keymap("n", "<leader>dd", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostic" })

-- ========================================
-- UTILITY KEYMAPS
-- ========================================
-- Clear search highlighting
keymap("n", "<leader>/", ":nohlsearch<CR>", { desc = "Clear search highlighting" })

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

-- ========================================
-- DISABLED/COMMENTED FEATURES
-- ========================================
-- Save with root permission (commented out as noted)
-- vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})
