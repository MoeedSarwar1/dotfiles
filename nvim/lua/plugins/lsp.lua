return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- An older Mason install of python-lsp-server would otherwise start next to pyright + ruff (lang.python)
      pylsp = { enabled = false },
    },
  },
}
