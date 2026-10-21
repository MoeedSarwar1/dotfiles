return {
  -- Inline git blame, off until toggled (<leader>gb)
  -- LazyGit: LazyVim's <leader>gg (root) / <leader>gG (cwd)
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = false,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%m-%d-%Y %H:%M:%S",
      virtual_text_column = 1,
      display_virtual_text = true,
      ignored_filetypes = { "gitcommit", "gitrebase", "gitconfig" },
      delay = 1000,
    },
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Toggle Git Blame" },
      { "<leader>gB", "<cmd>GitBlameCopySHA<cr>", desc = "Copy Git SHA" },
    },
  },
}
