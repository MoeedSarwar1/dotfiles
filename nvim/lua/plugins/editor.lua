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
          throttle = 50,
        },
      }

      return opts
    end,
  },
}
