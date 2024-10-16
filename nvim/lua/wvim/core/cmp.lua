local cmp = require("cmp")
local luasnip = require("luasnip")

local module = {}
module.opts = {
    expand = function(args)
        luasnip.lsp_expand(args.body)
    end,
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
	mapping = cmp.mapping.preset.insert({
		["<TAB>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, {"i", "s"}),
		["<C-SPACE>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({select = false, behavior = cmp.ConfirmBehavior.Replace})
	}),
    sources = cmp.config.sources({
        {name = "nvim_lsp"},
        {name = "luasnip"},
        {name = "buffer"}
    })
}
function module.setup()
    cmp.setup(module.opts)
    cmp.setup.cmdline({"/", "?"}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {name = "buffer"}
    })
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            {name = "path"},
            {name = "cmdline"}
        },
        matching = {disallow_symbol_nonprefix_matching = false}
    })
end
return module
