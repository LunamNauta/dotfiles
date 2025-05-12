require("settings.basic")

vim.cmd.colorscheme(Wvim.colorscheme)
for _, v in ipairs(Wvim.keymaps) do
    vim.keymap.set(v.m, v.k, v.c, v.o or {})
end
for _, v in pairs(Wvim.usercmds) do
    vim.api.nvim_create_user_command(v.n, v.c, v.a or {})
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

vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderCmdLine", { fg = "#b4befe" })
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorderSearch", { fg = "#b4befe" })
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = "#b4befe" })

vim.api.nvim_set_hl(0, "BlinkCmpDocCursorLine", { fg = "#b4befe" })
vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = "#b4befe" })
vim.api.nvim_set_hl(0, "BlinkCmpDoc", { fg = "#b4befe" })
