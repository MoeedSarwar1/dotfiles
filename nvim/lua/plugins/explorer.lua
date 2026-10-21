-- One file explorer: mini.files (column view, edit the listing like a buffer and :w to apply)
--   <leader>e   directory of the current file
--   <leader>E   cwd
--   inside it:  l open (closes explorer on files), L open and keep it, h go up, g. toggle dotfiles, = apply changes, go reveal in Finder
return {
  -- LazyVim's default snacks explorer stays out of the way
  {
    "folke/snacks.nvim",
    opts = { explorer = { replace_netrw = false } },
    keys = {
      { "<leader>e", false },
      { "<leader>E", false },
      { "<leader>fe", false },
      { "<leader>fE", false },
    },
  },

  {
    "nvim-mini/mini.files",
    opts = {
      options = {
        use_as_default_explorer = true, -- `nvim .` opens mini.files
      },
      mappings = {
        go_in = "L", -- open file but keep the explorer up
        go_in_plus = "l", -- open file and close the explorer (directories just expand)
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          local mf = require("mini.files")
          if not mf.close() then
            local path = vim.api.nvim_buf_get_name(0)
            mf.open(vim.uv.fs_stat(path) and path or vim.uv.cwd(), true)
          end
        end,
        desc = "Explorer (current file)",
      },
      {
        "<leader>E",
        function()
          local mf = require("mini.files")
          if not mf.close() then
            mf.open(vim.uv.cwd(), true)
          end
        end,
        desc = "Explorer (cwd)",
      },
    },
    init = function()
      -- `nvim .` / `nvim <dir>`: cd there and open mini.files (it is lazy-loaded, so it can't hijack on its own)
      local arg = vim.fn.argc() == 1 and vim.fn.argv(0) or nil
      if arg and vim.fn.isdirectory(arg) == 1 then
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          callback = function()
            local dir = vim.fn.fnamemodify(arg, ":p")
            vim.cmd.cd(dir)
            require("mini.files").open(dir, false)
          end,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "go", function()
            local entry = require("mini.files").get_fs_entry()
            if entry then
              vim.fn.jobstart({ "open", "-R", entry.path }, { detach = true })
            end
          end, { buffer = args.data.buf_id, desc = "Reveal in Finder" })
        end,
      })
    end,
  },
}
