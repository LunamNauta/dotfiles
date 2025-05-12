return{{
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        cmdline = {
            enabled = true,
            view = "cmdline_popup",
            format = {
                cmdline = { title = "cmd", pattern = "^:", icon = "", lang = "vim" },
                search_down = { title = "search", kind = "search", pattern = "^/", icon = " ", lang = "regex" },
                search_up = { title = "search", kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
            }
        },
        views = {
            cmdline_popup = {
                position = {
                    row = "5%",
                    col = "50%",
                },
                size = {
                    width = "20%",
                    height = "auto",
                }
            }
        }
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify"
    }
}}
