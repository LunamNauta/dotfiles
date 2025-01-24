require('wvim_core')

vim.cmd.colorscheme(Wvim.colorscheme)
for _, map in pairs(Wvim.keymaps) do
    vim.keymap.set(map.modes, map.keys, map.cmd, map.opts)
end

vim.api.nvim_create_autocmd({"FileType"}, {
    callback = function()
        if require("nvim-treesitter.parsers").has_parser() then
            vim.opt.foldmethod="expr"
            vim.opt.foldexpr="nvim_treesitter#foldexpr()"
        else vim.opt.foldmethod = "syntax" end
    end,
})
vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {command="set foldmethod=expr"})

