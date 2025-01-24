Wvim = {}
Wvim.colorscheme = 'catppuccin'
Wvim.keymaps = {
    {m = 'n', k = '<LEADER>tn', c = '<CMD>tabnew<CR>'},
    {m = 'n', k = '<LEADER>tk', c = '<CMD>bdelete<CR>'},
    {m = 'n', k = 'gt',         c = function() vim.cmd('BufferGoto ' .. vim.v.count) end},
    {m = 'n', k = '<LEADER>ff', c = '<CMD>Telescope file_browser<CR>'}
}
Wvim.usercmds = {
    {n = 'W', c = 'w', a = {bang = true}},
    {n = 'Q', c = 'q', a = {bang = true}},
    {n = 'Wq', c = 'wq', a = {bang = true}},
}
Wvim.languages = {
    ['clangd'] = {
        langs = {'cpp', 'c'}
    },
    ['lua_ls'] = {
        langs = {'lua'},
        opts = {settings = {Lua = {diagnostics = {globals = {'vim'}}}}}
    }
}

vim.opt.autochdir = true
vim.opt.number = true
vim.opt.cmdheight = 1
vim.opt.wrap = false

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.foldenable = false
vim.opt.foldlevel = 999

vim.g.localmapleader = '\\'
vim.g.mapleader = ' '
