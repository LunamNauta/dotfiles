return{{
    "folke/noice.nvim",
    event="VeryLazy",
    dependencies={
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify"
    },
    opts={
        presets={
            bottom_search=false,
            command_palette={
                views={
                    cmdline_popup={
                        position={row = "2", col = "50%"},
                        size={min_width = 60, width = "auto", height = "auto"}
                    }
                }
            }
        }
    },
    config=function(_, opts)
        require("noice").setup(opts)
        require("notify").setup({
            top_down=false,
            background_colour="#000000"
        })
    end
}}
