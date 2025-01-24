Wvim = {}
Wvim.colorscheme = "catppuccin"
Wvim.languages = {
    ['clangd'] = {
        lang = {'cpp', 'c'}
    },
    ['lua_ls'] = {
        lang = {'lua'},
        opts = {settings = {Lua = {diagnostics = {globals = {'vim'}}}}}
    }
}
Wvim.keymaps = {
    find_files     = {modes = "n", keys = "<LEADER>ff",   cmd = "<CMD>Telescope file_browser<CR>"},
    go_to_tab      = {modes = "n", keys = "gt",           cmd = function() vim.cmd("BufferGoto " .. vim.v.count) end},
    del_tab        = {modes = "n", keys = "<LEADER>tk",   cmd = "<CMD>bdelete<CR>"},
    new_tab        = {modes = "n", keys = "<LEADER>tn",   cmd = "<CMD>tabnew<CR>"},
    describe_error = {modes = "n", keys = "<LEADER>de",   cmd = function() vim.diagnostic.open_float({border = "rounded"}) end},
    describe_item  = {modes = "n", keys = "<LEADER>di",   cmd = vim.lsp.buf.hover},
    go_to_type_def = {modes = "n", keys = "<LEADER>dtyp", cmd = vim.lsp.buf.type_definition},
    go_to_def      = {modes = "n", keys = "<LEADER>ddef", cmd = vim.lsp.buf.definition}
}

-- Basic settings
vim.opt.autochdir = true
vim.opt.number = true
vim.opt.cmdheight = 1
vim.opt.wrap = false

-- Tab settings
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

-- Fold settings
vim.opt.foldenable = false
vim.opt.foldlevel = 999

-- Keybind settings
vim.g.localmapleader = '\\'
vim.g.mapleader = ' '

return Wvim
