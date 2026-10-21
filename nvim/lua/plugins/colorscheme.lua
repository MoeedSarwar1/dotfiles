return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    show_end_of_buffer = false,
    term_colors = true,
    dim_inactive = {
      enabled = false,
      shade = "transparent_background",
      percentage = 0.15,
    },
    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    -- THIS IS THE KEY PART - Custom highlights for transparency
    custom_highlights = function(colors)
      return {
        -- Float windows
        NormalFloat = { bg = colors.none },
        FloatBorder = { bg = colors.none },
        FloatTitle = { bg = colors.none },
        -- Pickers / explorer (snacks.picker, mini.files)
        SnacksPicker = { bg = colors.none },
        SnacksPickerBorder = { bg = colors.none },
        MiniFilesNormal = { bg = colors.none },
        MiniFilesBorder = { bg = colors.none },

        -- Completion menu
        Pmenu = { bg = colors.none },
        PmenuSel = { bg = colors.surface0, fg = colors.text },
        PmenuSbar = { bg = colors.none },
        PmenuThumb = { bg = colors.overlay0 },

        -- WhichKey
        WhichKeyFloat = { bg = colors.none },

        -- Lazy.nvim
        LazyNormal = { bg = colors.none },

        -- Mason
        MasonNormal = { bg = colors.none },
      }
    end,
    integrations = {
      blink_cmp = true,
      snacks = { enabled = true },
      gitsigns = true,
      treesitter = true,
      notify = true,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      which_key = true,
    },
  },
}
