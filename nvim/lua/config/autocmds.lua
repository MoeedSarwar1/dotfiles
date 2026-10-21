-- Create augroup for better organization and to avoid duplicate autocommands
local augroup = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })

-- Disable concealing in specific file formats for better readability
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "json", "jsonc", "markdown", "help", "tex" },
  callback = function()
    vim.opt_local.conceallevel = 0
    vim.opt_local.concealcursor = ""
  end,
  desc = "Disable concealing for better readability in certain filetypes",
})

-- Autosave 1 second after leaving insert mode (cancelled if you go back into insert mode first)
local autosave_timers = {}

local function cancel_autosave(buf)
  local timer = autosave_timers[buf]
  if timer then
    timer:stop()
    timer:close()
    autosave_timers[buf] = nil
  end
end

vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  callback = function(args)
    local buf = args.buf
    cancel_autosave(buf)
    local timer = assert(vim.uv.new_timer())
    autosave_timers[buf] = timer
    timer:start(
      1000,
      0,
      vim.schedule_wrap(function()
        cancel_autosave(buf)
        if
          vim.api.nvim_buf_is_valid(buf)
          and vim.bo[buf].modified
          and vim.bo[buf].modifiable
          and not vim.bo[buf].readonly
          and vim.bo[buf].buftype == ""
          and vim.api.nvim_buf_get_name(buf) ~= ""
          and vim.fn.mode() ~= "i"
        then
          vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! update")
          end)
        end
      end)
    )
  end,
  desc = "Autosave 1s after leaving insert mode",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "BufDelete" }, {
  group = augroup,
  callback = function(args)
    cancel_autosave(args.buf)
  end,
  desc = "Cancel a pending autosave",
})
