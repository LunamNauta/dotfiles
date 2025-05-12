return{{
    'saghen/blink.cmp',
    --dependencies = {'rafamadriz/friendly-snippets'},
    version = '*',
    opts = {
        keymap = {
            ['<C-ENTER>'] = {'select_and_accept'},
            ['<UP>'] = {'select_prev', 'fallback'},
            ['<DOWN>'] = {'select_next', 'fallback'},
        },
        completion = {
            menu = {
                border = 'rounded',
                winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                window = {border = 'rounded'}
            },
            ghost_text = {enabled = true}
        },
        signature = {window = {border = 'rounded'}},
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        }
    },
    opts_extend = {'sources.default'}
}}
