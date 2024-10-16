local core_plugins = {
{
    "neovim/nvim-lspconfig",
    dependencies = {"williamboman/mason.nvim", "hrsh7th/nvim-cmp"},
    config = function() require("wvim.core.lspconfig").setup() end
},
{
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function() require("wvim.core.catppuccin").setup() end
},
{
    "nvim-telescope/telescope.nvim",
    dependencies = {"telescope-fzf-native.nvim", "nvim-telescope/telescope-file-browser.nvim", "nvim-lua/plenary.nvim"},
    config = function() require("wvim.core.telescope").setup() end
},
{
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
},
{
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function() require("wvim.core.treesitter").setup() end,
},
{
    "williamboman/mason.nvim",
    dependencies = {"williamboman/mason-lspconfig.nvim"},
    lazy = false,
    config = function() require("wvim.core.mason").setup() end
},
{
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    event = "VeryLazy",
    config = true
},
{
    "romgrk/barbar.nvim",
    dependencies = {"lewis6991/gitsigns.nvim", "nvim-tree/nvim-web-devicons"},
    event = "VeryLazy",
    config = function() require("wvim.core.barbar").setup() end
},
{
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip"
    },
    lazy = false,
    config = function() require("wvim.core.cmp").setup() end
},
{
    "folke/noice.nvim",
    event = "VeryLazy",
    version = "4.4.7",
    dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"},
    config = function() require("wvim.core.noice").setup() end
},
{
    "rcarriga/nvim-notify",
    config = function() require("wvim.core.notify").setup() end
}
}
return core_plugins
