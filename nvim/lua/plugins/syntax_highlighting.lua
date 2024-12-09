return{{
    "nvim-treesitter/nvim-treesitter",
    version="0.9.2",
    lazy=false,
    opts={
        ensure_installed = wvim.languages.treesitter,
        highlight={enable=true}
    },
    config=function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}}
