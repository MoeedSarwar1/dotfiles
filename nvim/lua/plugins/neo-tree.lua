return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    {
      -- Better window picker for opening files in specific windows
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            bo = {
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  cmd = "Neotree",
  keys = {
    { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
    { "<leader>E", "<cmd>Neotree filesystem reveal left focus<cr>", desc = "Focus Explorer" },
    { "<leader>be", "<cmd>Neotree buffers reveal float<cr>", desc = "Buffer Explorer" },
    { "<leader>ge", "<cmd>Neotree git_status float<cr>", desc = "Git Explorer" },
    { "<leader>fe", "<cmd>Neotree filesystem current<cr>", desc = "Explorer (Current Dir)" },
    { "<leader>x", "<cmd>Neotree close<cr>", desc = "Close Neo-tree" },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    -- Disable netrw to avoid conflicts
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Auto-open neo-tree if nvim is opened on a directory
    if vim.fn.argc(-1) == 1 then
      local stat = vim.uv.fs_stat(vim.fn.argv(0))
      if stat and stat.type == "directory" then
        require("neo-tree")
        vim.cmd("Neotree show")
      end
    end

    -- Refresh git status after lazygit closes
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = false, -- Changed to false to avoid accidentally closing vim
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    enable_normal_mode_for_inputs = false,
    open_files_do_not_replace_types = { "terminal", "trouble", "qf", "Outline", "edgy" },
    sort_case_insensitive = false,

    -- Source selector (tabs for different sources)
    source_selector = {
      winbar = false,
      statusline = false,
      show_scrolled_off_parent_node = false,
      sources = {
        { source = "filesystem" },
        { source = "buffers" },
        { source = "git_status" },
      },
      content_layout = "start",
      tabs_layout = "equal",
      separator = { left = "▏", right = "▕" },
    },

    -- Default component configs
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      indent = {
        indent_size = 2,
        padding = 1,
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        with_expanders = nil,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "", -- nf-fa-folder
        folder_open = "", -- nf-fa-folder_open
        folder_empty = "󰜌", -- nf-md-folder_outline
        folder_empty_open = "󰜌",
        default = "󰈚", -- nf-md-file
        highlight = "NeoTreeFileIcon",
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
      file_size = {
        enabled = true,
        required_width = 64, -- min width of window required to show this column
      },
      type = {
        enabled = true,
        required_width = 122, -- min width of window required to show this column
      },
      last_modified = {
        enabled = true,
        required_width = 88, -- min width of window required to show this column
      },
      created = {
        enabled = true,
        required_width = 110, -- min width of window required to show this column
      },
      symlink_target = {
        enabled = false,
      },
    },

    -- Custom commands
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        -- Cross-platform system open
        local cmd
        if vim.fn.has("mac") == 1 then
          cmd = { "open", path }
        elseif vim.fn.has("win32") == 1 then
          cmd = { "cmd", "/c", "start", '""', path }
        else
          cmd = { "xdg-open", path }
        end
        vim.fn.jobstart(cmd, { detach = true })
      end,

      parent_or_close = function(state)
        local node = state.tree:get_node()
        if node:has_children() and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,

      child_or_open = function(state)
        local node = state.tree:get_node()
        if node:has_children() then
          if not node:is_expanded() then
            state.commands.toggle_node(state)
          else
            if node.type == "file" then
              state.commands.open(state)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          end
        else
          state.commands.open(state)
        end
      end,

      copy_selector = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local vals = {
          ["BASENAME"] = modify(filename, ":r"),
          ["EXTENSION"] = modify(filename, ":e"),
          ["FILENAME"] = filename,
          ["PATH (CWD)"] = modify(filepath, ":."),
          ["PATH (HOME)"] = modify(filepath, ":~"),
          ["PATH"] = filepath,
          ["URI"] = vim.uri_from_fname(filepath),
        }

        local options = vim.tbl_filter(function(val)
          return vals[val] ~= ""
        end, vim.tbl_keys(vals))

        if vim.tbl_isempty(options) then
          vim.notify("No values to copy", vim.log.levels.WARN)
          return
        end

        table.sort(options)
        vim.ui.select(options, {
          prompt = "Choose to copy to clipboard:",
          format_item = function(item)
            return ("%s: %s"):format(item, vals[item])
          end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.notify(("Copied: `%s`"):format(result))
            vim.fn.setreg("+", result)
          end
        end)
      end,

      find_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local search_dir = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h")

        -- Use FZF if available, otherwise fallback to Telescope
        if pcall(require, "fzf-lua") then
          require("fzf-lua").files({ cwd = search_dir })
        elseif pcall(require, "telescope.builtin") then
          require("telescope.builtin").find_files({ cwd = search_dir })
        else
          vim.notify("No file finder available (FZF-Lua or Telescope)", vim.log.levels.WARN)
        end
      end,

      grep_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local search_dir = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h")

        -- Use FZF if available, otherwise fallback to Telescope
        if pcall(require, "fzf-lua") then
          require("fzf-lua").live_grep({ cwd = search_dir })
        elseif pcall(require, "telescope.builtin") then
          require("telescope.builtin").live_grep({ cwd = search_dir })
        else
          vim.notify("No grep tool available (FZF-Lua or Telescope)", vim.log.levels.WARN)
        end
      end,
    },

    -- Window configuration
    window = {
      position = "right",
      width = 40, -- Slightly wider for better visibility
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<space>"] = {
          "toggle_node",
          nowait = false,
        },
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["<esc>"] = "cancel",
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        ["l"] = "child_or_open", -- Vim-style navigation
        ["h"] = "parent_or_close", -- Vim-style navigation
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["w"] = "open_with_window_picker",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["a"] = {
          "add",
          config = {
            show_path = "none",
          },
        },
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
        ["i"] = "show_file_details",

        -- Enhanced mappings
        ["O"] = "system_open", -- Open in system default application
        ["Y"] = "copy_selector", -- Smart copy to clipboard
        ["<C-f>"] = "find_in_dir", -- Find files in directory
        ["<C-g>"] = "grep_in_dir", -- Grep in directory
        ["<C-s>"] = "open_split", -- Alternative split mapping
        ["<C-v>"] = "open_vsplit", -- Alternative vsplit mapping
      },
    },

    -- Filesystem configuration
    filesystem = {
      filtered_items = {
        visible = false,
        show_hidden_count = true,
        hide_dotfiles = true, -- Changed back to true for cleaner view
        hide_gitignored = true, -- Changed back to true for performance
        hide_hidden = true,
        hide_by_name = {
          "node_modules",
          ".git",
          ".DS_Store",
          "thumbs.db",
          ".cache",
          "__pycache__",
          ".pytest_cache",
          ".coverage",
          "coverage",
          "dist",
          "build",
          ".vscode",
          ".idea",
          ".next",
          ".nuxt",
          ".svelte-kit",
          "target", -- Rust
          "bin", -- Various
          "obj", -- C#/.NET
        },
        hide_by_pattern = {
          "*.tmp",
          "*.temp",
          "*.log",
          "*.swp",
          "*.swo",
          "*~",
          "*.bak",
          "*.orig",
        },
        always_show = {
          ".gitignored",
          ".env.example",
          ".env.local",
          ".env"
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
          ".git",
        },
        never_show_by_pattern = {
          ".null-ls_*",
        },
      },
      follow_current_file = {
        enabled = false, -- Changed to false to avoid constant jumping
        leave_dirs_open = false,
      },
      group_empty_dirs = false,
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = false, -- Changed to false for better performance
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["<C-h>"] = "toggle_hidden",
          ["zh"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["og"] = { "order_by_git_status", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
        },
      },
      commands = {},
    },

    -- Buffers configuration
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      group_empty_dirs = true,
      show_unloaded = true,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },

    -- Git status configuration
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
          ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
  },
  config = function(_, opts)
    -- Setup event handlers for file operations
    local function on_move(data)
      -- Integrate with Snacks rename if available
      if pcall(require, "snacks") then
        require("snacks").rename.on_rename_file(data.source, data.destination)
      end
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })

    require("neo-tree").setup(opts)

    -- Auto-commands for better integration
    vim.api.nvim_create_autocmd({ "TermClose" }, {
      pattern = "*",
      callback = function()
        -- Refresh neo-tree when terminal closes (useful for git operations)
        if vim.bo.filetype == "neo-tree" then
          vim.cmd("Neotree refresh")
        end
      end,
    })
  end,
}
