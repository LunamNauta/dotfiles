local pid = vim.fn.getpid()
local omnisharp_bin = "/opt/omnisharp-roslyn/OmniSharp"

Wvim = {}
Wvim.colorscheme = 'catppuccin'
Wvim.keymaps = {
    {m = 'n', k = '<LEADER>tn',   c = '<CMD>tabnew<CR>'},
    {m = 'n', k = '<LEADER>tk',   c = '<CMD>bdelete<CR>'},
    {m = 'n', k = 'gt',           c = function() vim.cmd('BufferGoto ' .. vim.v.count) end},
    {m = 'n', k = '<LEADER>ff',   c = '<CMD>Telescope file_browser<CR>'},
    {m = 'n', k = '<LEADER>di',   c = vim.lsp.buf.hover},
    {m = 'n', k = '<LEADER>de',   c = function() vim.diagnostic.open_float({border = 'rounded'}) end},
    {m = 'n', k = '<LEADER>ddef', c = vim.lsp.buf.definition},
    {m = 'n', k = '<LEADER>dtyp', c = vim.lsp.buf.type_definition}
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
    },
    ['rust_analyzer'] = {
        langs = {'rust'},
        opts = {settings = {['rust-analyzer'] = {diagnostics = {enable = true}}}}
    },
    ['ts_ls'] = {
        langs = {'javascript', 'typescript', 'tsx'}
    },
    ['omnisharp'] = {
        langs = {'c_sharp'},
        opts = {cmd = {omnisharp_bin, '--languageserver', '--hostPID', tostring(pid)}}
    },
    ['jdtls'] = {
        langs = {'java'}
    },
    ['qmlls'] = {
        langs = {'qmljs'}
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
vim.g.c_syntax_for_h = true

vim.api.nvim_set_option("clipboard", "unnamedplus")
