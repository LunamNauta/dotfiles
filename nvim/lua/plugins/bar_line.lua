return{{
    "romgrk/barbar.nvim",
    event="VeryLazy",
    dependencies={
        "lewis6991/gitsigns.nvim",
        "nvim-tree/nvim-web-devicons"
    },
    init=function() vim.g.barbar_auto_setup=false end,
    opts={
        animation = false,
        clickable=false,
        icons={button=""}
    },
    config=function(_, opts)
        require("barbar").setup(opts)
        vim.keymap.set("n", "gt", function() vim.cmd("BufferGoto " .. vim.v.count) end)
    end
}}
