return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      opts.routes = opts.routes or {}

      local noise_filters = {
        { find = "No information available" },
        { find = "written" },
        { find = "^%d+L, %d+B$" },
        { find = "^--No lines in buffer--$" },
        { find = "^search hit" },
        { find = "^E486: Pattern not found" },
        { find = "^%d+ change" },
        { find = "^%d+ line" },
        { find = "^%d+ more line" },
        { find = "^%d+ fewer line" },
        { find = "^Already at" },
      }

      for _, filter in ipairs(noise_filters) do
        table.insert(opts.routes, {
          filter = {
            event = "msg_show",
            kind = "",
            find = filter.find,
          },
          opts = { skip = true },
        })
      end

      table.insert(opts.routes, {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = vim.tbl_get(message.opts, "progress", "client")
            return client == "lua_ls"
          end,
        },
        opts = { skip = true },
      })

      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("NoiceFocusGained", { clear = true }),
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        group = vim.api.nvim_create_augroup("NoiceFocusLost", { clear = true }),
        callback = function()
          focused = false
        end,
      })

      table.insert(opts.routes, 1, {
        filter = {
          event = "notify",
          level = vim.log.levels.INFO,
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          view = "split",
          opts = {
            enter = true,
            format = "details",
            buf_options = { filetype = "noice" },
          },
          filter = {},
        },
        history = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "echo", "echomsg" } },
            },
          },
        },
        last = {
          view = "popup",
          opts = { enter = true, format = "details" },
          filter = {
            any = {
              { event = "notify" },
              { error = true },
              { warning = true },
              { event = "msg_show", kind = { "echo", "echomsg" } },
            },
          },
          filter_opts = { count = 1 },
        },
        errors = {
          view = "popup",
          opts = { enter = true, format = "details" },
          filter = { error = true },
          filter_opts = { reverse = true },
        },
      }

      opts.presets = vim.tbl_deep_extend("force", opts.presets or {}, {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      })

      opts.views = opts.views or {}
      opts.views.cmdline_popup = {
        position = {
          row = "50%",
          col = "50%",
        },
        size = {
          width = 100,
          height = "auto",
        },
      }
      opts.views.popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        win_options = {
          winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        },
      }

      opts.lsp = opts.lsp or {}
      opts.lsp.override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      }
      opts.lsp.hover = {
        enabled = true,
        silent = false,
      }
      opts.lsp.signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
          throttle = 50,
        },
      }

      return opts
    end,
  },

  -- ========================================
  -- BUFFERLINE - Enhanced tab/buffer line
  -- ========================================
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    enabled = false,
    keys = {
      { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete Other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<leader>bd", "<Cmd>bdelete<CR>", desc = "Delete buffer" },
      { "<leader>bD", "<Cmd>bdelete!<CR>", desc = "Delete buffer (force)" },
      { "<leader>bs", "<Cmd>BufferLinePick<CR>", desc = "Pick buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = {
      options = {
        mode = "buffers", -- Changed from "tabs" to "buffers" for better workflow
        themable = true,
        numbers = function(opts)
          return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
        end,
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
            separator = true,
          },
          {
            filetype = "Outline",
            text = "Symbols Outline",
            highlight = "TSType",
            text_align = "left",
            separator = true,
          },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        separator_style = "slant",
        enforce_regular_tabs = false,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "insert_after_current",
        groups = {
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            {
              name = "Tests",
              highlight = { underline = true, sp = "blue" },
              priority = 2,
              icon = "",
              matcher = function(buf)
                return buf.name:match("%.test") or buf.name:match("%.spec")
              end,
            },
            {
              name = "Docs",
              highlight = { underline = true, sp = "green" },
              auto_close = false,
              matcher = function(buf)
                return buf.name:match("%.md") or buf.name:match("%.txt")
              end,
            },
          },
        },
      },
      highlights = {
        buffer_selected = {
          bold = true,
          italic = false,
        },
        numbers_selected = {
          bold = true,
          italic = false,
        },
        diagnostic_selected = {
          bold = true,
          italic = false,
        },
        hint_selected = {
          bold = true,
          italic = false,
        },
        pick_selected = {
          bold = true,
          italic = false,
        },
        pick_visible = {
          bold = true,
          italic = false,
        },
        pick = {
          bold = true,
          italic = false,
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)

      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },

  -- ========================================
  -- MINI.BUFREMOVE - Better buffer deletion
  -- ========================================
  {
    "nvim-mini/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },
}
