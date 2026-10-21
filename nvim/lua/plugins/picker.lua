-- One picker: LazyVim's default (snacks.picker). Its keys are the documented LazyVim ones:
--   <leader><space> files   <leader>/ grep   <leader>,  buffers   <leader>fr recent
--   <leader>sw word         <leader>sk keymaps   <leader>sh help   <leader>sR resume
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- dotfiles like .env.example and .github/ show up; .gitignore'd paths stay hidden
        files = { hidden = true },
        grep = { hidden = true },
      },
    },
  },
}
