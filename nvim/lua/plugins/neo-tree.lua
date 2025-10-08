return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle Explorer" },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function on_attach(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
      end

      -- Load default mappings first
      api.config.mappings.default_on_attach(bufnr)

      -- Custom keymaps
      vim.keymap.set("n", "s", function()
        api.node.open.vertical()
        api.tree.close()
      end, opts("Open: Vertical Split and Close Tree"))

      vim.keymap.set("n", "<CR>", function()
        api.node.open.edit()
      end, opts("Open File and Close Tree"))

      vim.keymap.set("n", "o", function()
        local node = api.tree.get_node_under_cursor()
        if node and node.absolute_path then
          vim.fn.jobstart({ "open", node.absolute_path }, { detach = true })
        end
      end, opts("Open in Finder"))

      vim.keymap.set("n", "c", api.tree.collapse_all, opts("Collapse All"))
    end

    require("nvim-tree").setup({
      on_attach = on_attach,
      sort_by = "case_sensitive",
      view = { width = 35, side = "right" },
      renderer = {
        group_empty = true,
        highlight_git = false,
        highlight_opened_files = "all",
        root_folder_label = function(path)
          return vim.fn.fnamemodify(path, ":p:h:t")
        end,
        full_name = false,
        special_files = { ".env", ".env.example", ".gitignore" },
      },
      filters = {
        dotfiles = true,
        custom = {
          "node_modules", ".git", ".cache", "dist", "build",
        },
      },
      git = { enable = false },
      actions = {
        open_file = { quit_on_open = false, resize_window = true },
      },
    })

    -- Transparent background
    local function set_nvimtree_transparent()
      for _, hl in ipairs({
        "NvimTreeNormal",
        "NvimTreeNormalNC",
        "NvimTreeEndOfBuffer",
        "NvimTreeWinSeparator",
        "NvimTreeCursorLine",
      }) do
        vim.api.nvim_set_hl(0, hl, { bg = "NONE" })
      end
    end

    set_nvimtree_transparent()
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_nvimtree_transparent,
    })
  end,
}





