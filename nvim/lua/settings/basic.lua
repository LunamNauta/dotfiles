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
        langs = {'qmljs'},
        opts = {cmd = {'qmlls6', '-E'}}
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

local function set_background()
    local hl = vim.api.nvim_set_hl

    -- Core editor
    hl(0, "Normal", { bg = "none" })
    hl(0, "NormalNC", { bg = "none" })
    hl(0, "EndOfBuffer", { bg = "none" })
    hl(0, "SignColumn", { bg = "none" })
    hl(0, "FoldColumn", { bg = "none" })
    hl(0, "LineNr", { bg = "none" })
    hl(0, "CursorLineNr", { bg = "none" })

    -- Floating windows
    hl(0, "NormalFloat", { bg = "none" })
    hl(0, "FloatBorder", { bg = "none" })
    hl(0, "WinSeparator", { bg = "none" })

    -- Statusline / tabline
    hl(0, "StatusLine", { bg = "none" })
    hl(0, "StatusLineNC", { bg = "none" })
    hl(0, "TabLine", { bg = "none" })
    hl(0, "TabLineFill", { bg = "none" })
    hl(0, "TabLineSel", { bg = "none" })

    -- Popup menu (completion)
    hl(0, "Pmenu", { bg = "none" })
    hl(0, "PmenuSel", { bg = "none" })
    hl(0, "PmenuBorder", { bg = "none" })

    -- Diagnostics
    hl(0, "DiagnosticVirtualTextError", { bg = "none" })
    hl(0, "DiagnosticVirtualTextWarn", { bg = "none" })
    hl(0, "DiagnosticVirtualTextInfo", { bg = "none" })
    hl(0, "DiagnosticVirtualTextHint", { bg = "none" })

    -- Telescope (explicit, just in case)
    hl(0, "TelescopeNormal", { bg = "none" })
    hl(0, "TelescopeBorder", { bg = "none" })
    hl(0, "TelescopePromptNormal", { bg = "none" })
    hl(0, "TelescopeResultsNormal", { bg = "none" })
    hl(0, "TelescopePreviewNormal", { bg = "none" })

    -- Selected item
    hl(0, "TelescopeSelection", {
        bg = "#11111b",
        fg = "#cdd6f4",
        bold = true
    })

    -- Optional: caret (`>` on the left)
    hl(0, "TelescopeSelectionCaret", {
        fg = "#b4befe",
        bg = "NONE",
    })

    -- Barbar: selected buffer
    hl(0, "BufferCurrent", { bg = "#11111b", fg = "#cdd6f4", bold = true })
    hl(0, "BufferCurrentIndex", { bg = "#11111b", fg = "#b4befe" })
    hl(0, "BufferCurrentIcon", { bg = "#11111b", fg = "#b4befe" })
    hl(0, "BufferCurrentSign", { bg = "#11111b", fg = "#b4befe" })
    hl(0, "BufferCurrentMod", { bg = "#11111b", fg = "#f38ba8" })
end
local function set_borders()
    local hl = vim.api.nvim_set_hl
    local border_color = "#b4befe"

    -- Core UI borders
    hl(0, "FloatBorder", { fg = border_color, bg = "none" })
    hl(0, "WinSeparator", { fg = border_color, bg = "none" })

    -- Floating window titles (0.11+)
    hl(0, "FloatTitle", { fg = border_color, bg = "none" })

    -- Telescope
    hl(0, "TelescopeBorder", { fg = border_color, bg = "none" })
    hl(0, "TelescopePromptBorder", { fg = border_color, bg = "none" })
    hl(0, "TelescopeResultsBorder", { fg = border_color, bg = "none" })
    hl(0, "TelescopePreviewBorder", { fg = border_color, bg = "none" })

    -- Completion / popups
    hl(0, "PmenuBorder", { fg = border_color, bg = "none" })

    -- LSP UI
    hl(0, "LspInfoBorder", { fg = border_color, bg = "none" })
end
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        set_background()
        set_borders()
    end
})
vim.opt.fillchars = { eob = " " }
