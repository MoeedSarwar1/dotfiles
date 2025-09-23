-- Create augroup for better organization and to avoid duplicate autocommands
local augroup = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })

-- Turn off paste mode when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  pattern = "*",
  callback = function()
    if vim.o.paste then
      vim.o.paste = false
    end
  end,
  desc = "Disable paste mode when leaving insert mode",
})

-- Disable concealing in specific file formats for better readability
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "json", "jsonc", "markdown", "help", "tex" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
  desc = "Disable concealing for better readability in certain filetypes",
})

-- Optional: Also disable conceal cursor to prevent flickering
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "json", "jsonc", "markdown", "help", "tex" },
  callback = function()
    vim.opt_local.concealcursor = ""
  end,
  desc = "Disable conceal cursor behavior in certain filetypes",
})
