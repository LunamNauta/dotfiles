wvim={}
wvim.languages={}
wvim.languages.treesitter={"cpp", "c", "lua", "python", "rust", "javascript", "html", "c_sharp", "vim"}
wvim.languages.mason_lspconfig={"clangd", "lua_ls", "pyright", "rust_analyzer", "ts_ls", "html", "omnisharp", "vimls"}
wvim.languages.mason_lspconfig_opts={
    --If on windows, mason-lspconfig's clangd cannot find MSYS2 headers. This 'cmd' is needed in order to locate headers in such a build system
    --["clangd"]={cmd=wvim.is_windows and {"C:\\msys64\\ucrt64\\bin\\clangd.exe"} or nil},
    ["lua_ls"]={settings={Lua={diagnostics={globals={"vim"}}}}},
    ["omnisharp"]={
        cmd={"dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll"},
        enable_import_completion=true,
        organize_imports_on_format=true,
        enable_roslyn_analyzers=true,
        root_dir=function() return vim.loop.cwd() end
    }
}

vim.opt.autochdir=true
vim.opt.number=true
vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true
vim.opt.cmdheight=0
vim.opt.wrap=false
vim.opt.foldlevel=999
vim.opt.foldenable=false

vim.g.mapleader=" "
vim.g.localmapleader="\\"

vim.keymap.set("n", "<LEADER>tn", "<CMD>tabnew<CR>")
vim.keymap.set("n", "<LEADER>tk", "<CMD>bdelete<CR>")
vim.keymap.set("n", "<LEADER>di", vim.lsp.buf.hover)
vim.keymap.set("n", "<LEADER>de", function() vim.diagnostic.open_float({border="rounded"}) end)
vim.keymap.set("n", "<LEADER>ddef", vim.lsp.buf.definition)
vim.keymap.set("n", "<LEADER>dtyp", vim.lsp.buf.type_definition)

vim.api.nvim_create_autocmd({"FileType"}, {
    callback = function()
        if require("nvim-treesitter.parsers").has_parser() then
            vim.opt.foldmethod="expr"
            vim.opt.foldexpr="nvim_treesitter#foldexpr()"
        else vim.opt.foldmethod = "syntax" end
    end,
})
vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged"}, {command="set foldmethod=expr"})

return wvim
