return {
  -- Flash integration (re-enabled with better config)
  {
    "folke/flash.nvim",
    enabled = true, -- Re-enabled for better navigation
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      search = {
        forward = true,
        multi_window = true,
        wrap = false,
        incremental = true,
        exclude = {
          "notify",
          "cmp_menu",
          "noice",
          "flash_prompt",
        },
      },
      jump = {
        jumplist = true,
        pos = "start", -- "start" | "end" | "range"
        history = false,
        register = false,
      },
      label = {
        uppercase = true,
        exclude = "",
        current = true,
        after = true,
        before = false,
        style = "overlay", -- "eol" | "overlay" | "right_align" | "inline"
        reuse = "lowercase", -- "lowercase" | "all" | "none"
        distance = true,
      },
      highlight = {
        backdrop = true,
        matches = true,
        priority = 5000,
        groups = {
          match = "FlashMatch",
          current = "FlashCurrent",
          backdrop = "FlashBackdrop",
          label = "FlashLabel",
        },
      },
      modes = {
        search = {
          enabled = true,
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
          search = {
            mode = "search",
            max_length = false,
            multi_window = true,
            forward = true,
            wrap = false,
          },
        },
        char = {
          enabled = true,
          config = function(opts)
            opts.autohide = vim.fn.mode(true):find("no") and vim.v.operator == "y"
            opts.jump_labels = opts.autohide and opts.jump_labels == true and "qwertyuiopzxcvbnmasdfghjkl"
              or opts.jump_labels
          end,
          autohide = false,
          jump_labels = false,
          multi_line = true,
          label = { exclude = "hjkliardc" },
          keys = { "f", "F", "t", "T", ";", "," },
        },
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
          jump = { pos = "range" },
          search = { incremental = false },
          label = {
            before = true,
            after = true,
            style = "inline",
          },
          highlight = {
            backdrop = false,
            matches = false,
          },
        },
        treesitter_search = {
          jump = { pos = "range" },
          search = { multi_window = true, wrap = true, incremental = false },
          remote_op = { restore = true },
          label = { before = true, after = true, style = "inline" },
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },

  -- Enhanced Telescope configuration
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
    },
    cmd = "Telescope",
    keys = {
      -- Core file operations
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({
            no_ignore = false,
            hidden = true,
            previewer = false,
          })
        end,
        desc = "Find Files",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({
            no_ignore = true,
            hidden = true,
            no_ignore_parent = true,
          })
        end,
        desc = "Find Files (no ignore)",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live Grep",
      },
      {
        "<leader>fG",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden", "--no-ignore" },
          })
        end,
        desc = "Live Grep (no ignore)",
      },
      {
        "<leader>fw",
        function()
          require("telescope.builtin").grep_string({
            additional_args = { "--hidden" },
            search = vim.fn.expand("<cword>"),
          })
        end,
        desc = "Grep Word",
      },
      {
        "<leader>fW",
        function()
          require("telescope.builtin").grep_string({
            additional_args = { "--hidden" },
            search = vim.fn.expand("<cWORD>"),
          })
        end,
        desc = "Grep WORD",
      },

      -- Buffer operations
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true,
            sort_lastused = true,
          })
        end,
        desc = "Buffers",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles({
            only_cwd = true,
          })
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fR",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Recent Files (All)",
      },

      -- Search operations
      {
        "<leader>s/",
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        desc = "Search in Buffer",
      },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,
        desc = "Search in Open Files",
      },

      -- Git operations
      {
        "<leader>gc",
        function()
          require("telescope.builtin").git_commits()
        end,
        desc = "Git Commits",
      },
      {
        "<leader>gs",
        function()
          require("telescope.builtin").git_status()
        end,
        desc = "Git Status",
      },
      {
        "<leader>gb",
        function()
          require("telescope.builtin").git_branches()
        end,
        desc = "Git Branches",
      },

      -- LSP operations
      {
        "<leader>ld",
        function()
          require("telescope.builtin").diagnostics({ bufnr = 0 })
        end,
        desc = "Document Diagnostics",
      },
      {
        "<leader>lD",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Workspace Diagnostics",
      },
      {
        "<leader>ls",
        function()
          require("telescope.builtin").lsp_document_symbols()
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>lS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols()
        end,
        desc = "Workspace Symbols",
      },

      -- Help and commands
      {
        "<leader>fh",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help Tags",
      },
      {
        "<leader>fc",
        function()
          require("telescope.builtin").commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>fk",
        function()
          require("telescope.builtin").keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fm",
        function()
          require("telescope.builtin").marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>fj",
        function()
          require("telescope.builtin").jumplist()
        end,
        desc = "Jumplist",
      },
      {
        "<leader>fq",
        function()
          require("telescope.builtin").quickfix()
        end,
        desc = "Quickfix",
      },
      {
        "<leader>fl",
        function()
          require("telescope.builtin").loclist()
        end,
        desc = "Location List",
      },

      -- Plugin files
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugin File",
      },

      -- Resume and utilities
      {
        "<leader>f;",
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Resume",
      },
      {
        "<leader>f:",
        function()
          require("telescope.builtin").command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>f/",
        function()
          require("telescope.builtin").search_history()
        end,
        desc = "Search History",
      },

      -- File browser
      {
        "<leader>fB",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = vim.fn.expand("%:p:h"),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "File Browser",
      },

      -- Frecency
      {
        "<leader>fz",
        function()
          require("telescope").extensions.frecency.frecency({
            workspace = "CWD",
          })
        end,
        desc = "Frequent Files",
      },

      -- Alternative shorter keymaps (keeping your original style)
      {
        ";f",
        function()
          require("telescope.builtin").find_files({
            no_ignore = false,
            hidden = true,
          })
        end,
        desc = "Find Files",
      },
      {
        ";r",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--hidden" },
          })
        end,
        desc = "Live Grep",
      },
      {
        "\\\\",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Buffers",
      },
      {
        ";t",
        function()
          require("telescope.builtin").help_tags()
        end,
        desc = "Help Tags",
      },
      {
        ";;",
        function()
          require("telescope.builtin").resume()
        end,
        desc = "Resume",
      },
      {
        ";e",
        function()
          require("telescope.builtin").diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        ";s",
        function()
          require("telescope.builtin").treesitter()
        end,
        desc = "Treesitter",
      },
      {
        "sf",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = vim.fn.expand("%:p:h"),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
        desc = "File Browser",
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local fb_actions = require("telescope").extensions.file_browser.actions

      -- Enhanced defaults
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
 prompt_prefix = " ",       -- or "🔍 " (anything you like)
  selection_caret = " ",     -- arrow instead of space
  entry_prefix = "",   
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        use_less = true,
        set_env = { ["COLORTERM"] = "truecolor" },
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            ["<C-w>"] = { "<c-s-w>", type = "command" },
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
          },
        },
      })

      -- Enhanced pickers
      opts.pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        grep_string = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
            n = {
              ["dd"] = actions.delete_buffer,
            },
          },
        },
        planets = {
          show_pluto = true,
          show_moon = true,
        },
        colorscheme = {
          enable_preview = true,
        },
        lsp_references = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_definitions = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_declarations = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_implementations = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }

      -- Extensions configuration
      opts.extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
            ["i"] = {
              ["<A-c>"] = fb_actions.create,
              ["<S-CR>"] = fb_actions.create_from_prompt,
              ["<A-r>"] = fb_actions.rename,
              ["<A-m>"] = fb_actions.move,
              ["<A-y>"] = fb_actions.copy,
              ["<A-d>"] = fb_actions.remove,
              ["<C-o>"] = fb_actions.open,
              ["<C-g>"] = fb_actions.goto_parent_dir,
              ["<C-e>"] = fb_actions.goto_home_dir,
              ["<C-w>"] = fb_actions.goto_cwd,
              ["<C-t>"] = fb_actions.change_cwd,
              ["<C-f>"] = fb_actions.toggle_browser,
              ["<C-h>"] = fb_actions.toggle_hidden,
              ["<C-s>"] = fb_actions.toggle_all,
              ["<bs>"] = fb_actions.backspace,
            },
            ["n"] = {
              ["c"] = fb_actions.create,
              ["r"] = fb_actions.rename,
              ["m"] = fb_actions.move,
              ["y"] = fb_actions.copy,
              ["d"] = fb_actions.remove,
              ["o"] = fb_actions.open,
              ["g"] = fb_actions.goto_parent_dir,
              ["e"] = fb_actions.goto_home_dir,
              ["w"] = fb_actions.goto_cwd,
              ["t"] = fb_actions.change_cwd,
              ["f"] = fb_actions.toggle_browser,
              ["h"] = fb_actions.toggle_hidden,
              ["s"] = fb_actions.toggle_all,
              ["N"] = fb_actions.create,
              ["h"] = fb_actions.goto_parent_dir,
              ["/"] = function()
                vim.cmd("startinsert")
              end,
              ["<C-u>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-d>"] = function(prompt_bufnr)
                for i = 1, 10 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
              ["<PageUp>"] = actions.preview_scrolling_up,
              ["<PageDown>"] = actions.preview_scrolling_down,
            },
          },
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          }),
        },
        frecency = {
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*" },
          disable_devicons = false,
          workspaces = {
            ["conf"] = vim.fn.expand("~/.config"),
            ["data"] = vim.fn.expand("~/.local/share"),
            ["project"] = vim.fn.expand("~/projects"),
            ["wiki"] = vim.fn.expand("~/wiki"),
          },
        },
      }

      telescope.setup(opts)

      -- Load extensions
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "file_browser")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "frecency")
    end,
  },
}
