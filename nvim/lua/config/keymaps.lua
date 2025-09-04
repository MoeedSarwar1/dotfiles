-- keymaps are automatically loaded on the verylazy event
-- default keymaps that are always set: https://github.com/lazyvim/lazyvim/blob/main/lua/lazyvim/config/keymaps.lua
-- add any additional keymaps here

local discipline = require("shaggy.discipline")

discipline.cowboy()

local keymap = vim.keymap
local opts = { noremap = true, silent = true }


--disable arrow keys in normal
vim.api.nvim_set_keymap("n", "<up>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<down>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<left>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<right>", "<nop>", { noremap = true, silent = true })

--disable arrow keys in insert
vim.api.nvim_set_keymap("i", "<up>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<down>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<left>", "<nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<right>", "<nop>", { noremap = true, silent = true })

--jj to exit insert mode
vim.api.nvim_set_keymap("i", "jj", "<esc>", { noremap = true, silent = true })

-- do things without affecting the registers
keymap.set("n", "x", '"_x')
keymap.set("n", "<leader>p", '"0p')
keymap.set("n", "<leader>p", '"0p')
keymap.set("v", "<leader>p", '"0p')
keymap.set("n", "<leader>c", '"_c')
keymap.set("n", "<leader>c", '"_c')
keymap.set("v", "<leader>c", '"_c')
keymap.set("v", "<leader>c", '"_c')
keymap.set("n", "<leader>d", '"_d')
keymap.set("n", "<leader>d", '"_d')
keymap.set("v", "<leader>d", '"_d')
keymap.set("v", "<leader>d", '"_d')

-- increment/decrement
keymap.set("n", "+", "<c-a>")
keymap.set("n", "-", "<c-x>")

-- delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- select all
keymap.set("n", "<c-a>", "gg<s-v>g")

-- save with root permission (not working for now)
--vim.api.nvim_create_user_command('w', 'w !sudo tee > /dev/null %', {})

-- disable continuations
keymap.set("n", "<leader>o", "o<esc>^da", opts)
keymap.set("n", "<leader>o", "o<esc>^da", opts)

-- jumplist
keymap.set("n", "<c-m>", "<c-i>", opts)

-- new tab
keymap.set("n", "te", ":tabedit")
keymap.set("n", "<tab>", ":tabnext<return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<return>", opts)
keymap.set("n", "tc", ":tabclose<CR>", { noremap = true, silent = true })

keymap.set("n", "<leader>cQ", function()
  require("CopilotChat").open() -- open chat
end, { desc = "Open Copilot Chat" })

keymap.set("n", "<leader>cq", function()
  require("CopilotChat").close() -- close chat
end, { desc = "Close Copilot Chat" })

-- split window
-- open horizontal split
vim.keymap.set("n", "ss", "<C-w>s", { noremap = true, silent = true })

-- open vertical split
vim.keymap.set("n", "sv", "<C-w>v", { noremap = true, silent = true })

-- open new tab
vim.keymap.set("n", "te", ":tabnew<CR>", { noremap = true, silent = true })


-- move window
keymap.set("n", "sh", "<c-w>h")
keymap.set("n", "sk", "<c-w>k")
keymap.set("n", "sj", "<c-w>j")
keymap.set("n", "sl", "<c-w>l")

-- resize window
keymap.set("n", "<c-w><left>", "<c-w><")
keymap.set("n", "<c-w><right>", "<c-w>>")
keymap.set("n", "<c-w><up>", "<c-w>+")
keymap.set("n", "<c-w><down>", "<c-w>-")

-- key binding to toggle zen mode
vim.api.nvim_set_keymap("n", "<leader>z", ":zenmode<cr>", { noremap = true, silent = true })

-- diagnostics
keymap.set("n", "<c-j>", function()
  vim.diagnostic.goto_next()
end, opts)
