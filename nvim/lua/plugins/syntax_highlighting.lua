return{{
    "nvim-treesitter/nvim-treesitter",
    lazy=false,
    opts={
        ensure_installed = wvim.languages.treesitter,
        highlight={enable=true}
    },
    config=function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}}
