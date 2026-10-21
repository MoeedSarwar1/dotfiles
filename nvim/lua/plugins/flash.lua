-- LazyVim already sets up flash (s / S / r / R / <c-s>); only the non-default behaviour lives here
return {
  "folke/flash.nvim",
  opts = {
    search = { wrap = false },
    modes = {
      search = { enabled = true }, -- flash labels during / and ? searches
    },
  },
}
