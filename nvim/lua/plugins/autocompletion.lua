return{
    {
        "neovim/nvim-lspconfig",
        dependencies={"williamboman/mason.nvim", "hrsh7th/nvim-cmp"},
        config=function(_, _)
            local default_capabilities=require("cmp_nvim_lsp").default_capabilities()
            local default_handlers={
                ["textDocument/hover"]=vim.lsp.with(vim.lsp.handlers.hover, {border="rounded"}),
                ["textDocument/signatureHelp"]=vim.lsp.with(vim.lsp.handlers.signature_help, {border="rounded"}),
            }
            vim.diagnostic.config({virtual_text = false})
            for _, v in ipairs(wvim.languages.mason_lspconfig) do
                local opts=vim.tbl_deep_extend("force", wvim.languages.mason_lspconfig_opts[v] or {}, {capabilities=default_capabilities, handlers=default_handlers})
                require("lspconfig")[v].setup(opts)
            end
        end
    },
    {
        "williamboman/mason.nvim",
        lazy=false,
        dependencies={"williamboman/mason-lspconfig.nvim"},
        opts={
            mason={},
            mason_lspconfig={
                ensure_installed=wvim.languages.mason_lspconfig,
                highlight={enable=true}
            }
        },
        config=function(_, opts)
            require("mason").setup(opts.mason)
            require("mason-lspconfig").setup(opts.mason_lspconfig)
        end
    },
    {
        "hrsh7th/nvim-cmp",
        lazy=false,
        dependencies={
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip"
        },
        config=function(_, _)
            local opts={
                expand=function(args) require("luasnip").lsp_expand(args.body) end,
                window={
                    completion=require("cmp").config.window.bordered(),
                    documentation=require("cmp").config.window.bordered()
                },
                mapping = require("cmp").mapping.preset.insert({
                    ["<TAB>"] = require("cmp").mapping(function(fallback)
                        if require("cmp").visible() then
                            require("cmp").select_next_item()
                        elseif require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        else
                            fallback()
                        end
                    end, {"i", "s"}),
                    ["<C-SPACE>"]=require("cmp").mapping.complete(),
                    ["<C-e>"]=require("cmp").mapping.abort(),
                    ["<CR>"]=require("cmp").mapping.confirm({select=false, behavior=require("cmp").ConfirmBehavior.Replace}),
                    ["<DOWN>"]=require("cmp").mapping(function(fallback)
                        require("cmp").close()
                        fallback()
                    end, {"i"}),
                    ["<UP>"]=require("cmp").mapping(function(fallback)
                        require("cmp").close()
                        fallback()
                    end, {"i"}),
                }),
                sources = require("cmp").config.sources({
                    {name="nvim_lsp"},
                    {name="luasnip"},
                    {name="buffer"}
                })
            }
            require("cmp").setup(opts)
            require("cmp").setup.cmdline({"/", "?"}, {mapping=require("cmp").mapping.preset.cmdline(), sources={name="buffer"}})
            require("cmp").setup.cmdline(":", {
                mapping=require("cmp").mapping.preset.cmdline(),
                sources={{name="path"}, {name="cmdline"}},
                matching={disallow_symbol_nonprefix_matching=false}
            })
        end
    }
}
