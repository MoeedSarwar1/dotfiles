return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- required dependency
    },
    build = "make tiktoken", -- Only needed on MacOS/Linux
    event = "VeryLazy",

    opts = {
      -- ===========================
      -- GENERAL SETTINGS
      -- ===========================
      debug = false,
      proxy = nil,
      allow_insecure = false,

      -- Best model for coding (fast + smart)
      model = "gpt-5-mini",
      temperature = 0.2,

      question_header = "## User",
      answer_header = "## Copilot",
      error_header = "## Error",

      -- ===========================
      -- WINDOW CONFIGURATION
      -- ===========================
      window = {
        layout = "vertical",
        width = 0.4,
        height = 0.5,
        relative = "editor",
        border = "rounded",
        title = "Copilot Chat",
        zindex = 1,
      },

      -- ===========================
      -- CONTEXT & SELECTION
      -- ===========================
      show_help = true,
      show_folds = true,
      auto_follow_cursor = true,
      auto_insert_mode = false,
      insert_at_end = false,
      clear_chat_on_new_prompt = false,

      context = "buffers",
      history_path = vim.fn.stdpath("data") .. "/copilotchat_history",

      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
      end,

      -- ===========================
      -- PROMPTS
      -- ===========================
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN Explain the selected code in detail as paragraphs.",
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
        },
        Fix = {
          prompt = "/COPILOT_GENERATE Identify and fix any issues in this code.",
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code for performance and readability.",
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Add clear documentation comments to this code.",
        },
        Tests = {
          prompt = "/COPILOT_GENERATE Generate appropriate tests for this code.",
        },
        Commit = {
          prompt = "Write a commit message using conventional commits (max 50-char title, wrap body at 72 chars, use gitcommit block).",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source)
          end,
        },
        CommitStaged = {
          prompt = "Write a commit message for staged changes using conventional commits.",
          selection = function(source)
            return require("CopilotChat.select").gitdiff(source, true)
          end,
        },
        Refactor = {
          prompt = "/COPILOT_GENERATE Refactor this code for readability and maintainability.",
        },
        BetterNaming = {
          prompt = "/COPILOT_GENERATE Suggest better variable and function names.",
        },
        Simplify = {
          prompt = "/COPILOT_GENERATE Simplify this code while preserving functionality.",
        },
        FixDiagnostic = {
          prompt = "Assist with the following diagnostic issue:",
          selection = require("CopilotChat.select").diagnostics,
        },
        Custom = {
          prompt = "Please help me with: ",
        },
      },

      -- ===========================
      -- MAPPINGS (inside chat buffer)
      -- ===========================
      mappings = {
        complete = { detail = "Use @<Tab> or /<Tab> for options.", insert = "<Tab>" },
        close = { normal = "q", insert = "<C-c>" },
        reset = { normal = "<C-r>", insert = "<C-r>" },
        submit_prompt = { normal = "<CR>", insert = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
        yank_diff = { normal = "gy", register = '"' },
        show_diff = { normal = "gd" },
        show_system_prompt = { normal = "gp" },
        show_user_selection = { normal = "gs" },
      },
    },

    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")
      chat.setup(opts)

      -- ===========================
      -- KEYMAPS
      -- ===========================
      local map = vim.keymap.set
      local desc = function(d) return { desc = "CopilotChat: " .. d } end

      map({ "n", "v" }, "<leader>zz", chat.toggle, desc("Toggle Chat"))
      map("v", "<leader>ze", function() chat.open({ selection = select.visual }) end, desc("Explain Selection"))
      map({ "n", "v" }, "<leader>zq", function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then chat.ask(input, { selection = select.visual }) end
      end, desc("Quick Question"))
      map({ "n", "v" }, "<leader>zx", function() chat.ask("Explain this code.", { selection = select.visual }) end, desc("Explain Code"))
      map({ "n", "v" }, "<leader>zr", function() chat.ask("Review this code.", { selection = select.visual }) end, desc("Review"))
      map({ "n", "v" }, "<leader>zf", function() chat.ask("Fix issues in this code.", { selection = select.visual }) end, desc("Fix"))
      map({ "n", "v" }, "<leader>zo", function() chat.ask("Optimize this code.", { selection = select.visual }) end, desc("Optimize"))
      map({ "n", "v" }, "<leader>zd", function() chat.ask("Add documentation comments.", { selection = select.visual }) end, desc("Document"))
      map({ "n", "v" }, "<leader>zt", function() chat.ask("Generate tests.", { selection = select.visual }) end, desc("Tests"))
      map("n", "<leader>zm", function() chat.ask("Write commit message (conventional commits).", { selection = select.gitdiff }) end, desc("Commit Message"))
      map({ "n", "v" }, "<leader>zR", function() chat.ask("Refactor this code.", { selection = select.visual }) end, desc("Refactor"))
      map({ "n", "v" }, "<leader>zn", function() chat.ask("Suggest better names.", { selection = select.visual }) end, desc("Naming"))
      map("n", "<leader>zD", function() chat.ask("Fix diagnostics.", { selection = select.diagnostics }) end, desc("Fix Diagnostics"))
      map({ "n", "v" }, "<leader>zl", chat.reset, desc("Clear/Reset"))
      map({ "n", "v" }, "<leader>zS", chat.stop, desc("Stop"))

      -- Inline floating chat
      _G.copilot_inline_chat = function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
          chat.ask(input, {
            selection = select.buffer,
            window = {
              layout = "float",
              relative = "cursor",
              width = 0.8,
              height = 0.6,
              row = 1,
            },
          })
        end
      end
      map("n", "<leader>zi", _G.copilot_inline_chat, desc("Inline Chat"))

      -- Optional: Help actions (requires Telescope)
      pcall(function()
        map("n", "<leader>zh", function()
          require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").help_actions())
        end, desc("Help"))
      end)

      -- ===========================
      -- WHICH-KEY SUPPORT
      -- ===========================
      local ok, which_key = pcall(require, "which-key")
      if ok then
        which_key.add({
 { "<leader>z", group = "Copilot Chat" },
  { "<leader>zD", desc = "Fix Diagnostics" },
  { "<leader>zR", desc = "Refactor" },
  { "<leader>zS", desc = "Stop" },
  { "<leader>zd", desc = "Document" },
  { "<leader>ze", desc = "Explain Selection" },
  { "<leader>zf", desc = "Fix Code" },
  { "<leader>zh", desc = "Help" },
  { "<leader>zi", desc = "Inline Chat" },
  { "<leader>zl", desc = "Clear / Reset" },
  { "<leader>zm", desc = "Commit Message" },
  { "<leader>zn", desc = "Naming" },
  { "<leader>zo", desc = "Optimize" },
  { "<leader>zq", desc = "Quick Question" },
  { "<leader>zr", desc = "Review Code" },
  { "<leader>zt", desc = "Generate Tests" },
  { "<leader>zx", desc = "Explain Code" },
  { "<leader>zz", desc = "Toggle Chat" },
        }, { prefix = "<leader>" })
      end

      vim.defer_fn(function()
        vim.notify("✅ CopilotChat loaded — use <leader>zz to open chat.", vim.log.levels.INFO)
      end, 1000)
    end,
  },
}


