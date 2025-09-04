vim.g.mapleader = " "
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""
vim.opt.winbar = "%=%m %f"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.o.showtabline = 0
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.scrolloff = 10
