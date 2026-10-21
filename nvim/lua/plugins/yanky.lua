-- Keep <leader>p as "paste last yank" (keymaps.lua); the yank history picker lives on <leader>sy
return {
  "gbprod/yanky.nvim",
  keys = {
    { "<leader>p", false, mode = { "n", "x" } },
    {
      "<leader>sy",
      function()
        Snacks.picker.yanky()
      end,
      mode = { "n", "x" },
      desc = "Yank History",
    },
  },
}
