return {
  "neovim/nvim-lspconfig",
    opts = {
    inlay_hints = { enabled = false }, -- Disables inlay hints globally
    servers = {
      clangd = {
        mason = false, -- Skip Mason; use system-wide clangd
      },
    },
  },
}