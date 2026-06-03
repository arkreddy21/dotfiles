return {
    -- Install catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000, -- Load this plugin first
    },

    -- Configure LazyVim to load the colorscheme
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin-mocha",
        },
    },
}
