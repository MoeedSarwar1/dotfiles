return  {
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  version = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    debug = false,
    provider = "cursor",
    mode = "agentic",
    acp_providers = {
      cursor = {
        command = vim.fn.expand("~/.local/bin/agent"), -- path to cursor's agent binary
        args = { "acp" },
        auth_method = "cursor_login",
        env = {
          HOME = os.getenv("HOME"),
          PATH = os.getenv("PATH"),
        },
      },
    },
    selection = {
      hint_display = "none",
    },
    behaviour = {
      auto_set_keymaps = false,
    },
  },
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteChat",
    "AvanteChatNew",
    "AvanteClear",
    "AvanteEdit",
    "AvanteFocus",
    "AvanteHistory",
    "AvanteModels",
    "AvanteRefresh",
    "AvanteShowRepoMap",
    "AvanteStop",
    "AvanteSwitchProvider",
    "AvanteToggle",
  },
  keys = {
    { "<leader>aa", "<cmd>AvanteAsk<CR>", desc = "Ask Avante" },
    { "<leader>ac", "<cmd>AvanteChat<CR>", desc = "Chat with Avante" },
    { "<leader>ae", "<cmd>AvanteEdit<CR>", desc = "Edit Avante" },
    { "<leader>af", "<cmd>AvanteFocus<CR>", desc = "Focus Avante" },
    { "<leader>ah", "<cmd>AvanteHistory<CR>", desc = "Avante History" },
    { "<leader>am", "<cmd>AvanteModels<CR>", desc = "Select Avante Model" },
    { "<leader>an", "<cmd>AvanteChatNew<CR>", desc = "New Avante Chat" },
    { "<leader>ap", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
    { "<leader>ar", "<cmd>AvanteRefresh<CR>", desc = "Refresh Avante" },
    { "<leader>as", "<cmd>AvanteStop<CR>", desc = "Stop Avante" },
    { "<leader>at", "<cmd>AvanteToggle<CR>", desc = "Toggle Avante" },
  },
}
