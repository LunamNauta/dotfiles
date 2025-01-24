require("settings.basic")

vim.cmd.colorscheme(Wvim.colorscheme)
for _, v in ipairs(Wvim.keymaps) do
    vim.keymap.set(v.m, v.k, v.c, v.o or {})
end
for _, v in pairs(Wvim.usercmds) do
    vim.api.nvim_create_user_command(v.n, v.c, v.a or {})
end
