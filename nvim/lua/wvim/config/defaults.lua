local wvim = {}
wvim.colorscheme = "catppuccin"
wvim.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1

wvim.languages = {}
wvim.languages.treesitter = {"cpp", "c", "lua", "python", "rust", "javascript", "html"}
wvim.languages.mason_lspconfig = {"clangd", "lua_ls", "pylsp", "rust_analyzer", "ts_ls", "html"}
wvim.languages.mason_lspconfig_opts = {
    --If on windows, mason-lspconfig's clangd cannot find MSYS2 headers
    --This 'cmd' is needed in order to locate headers in my build system
    ["clangd"] = {
        cmd = wvim.is_windows and {"C:\\msys64\\ucrt64\\bin\\clangd.exe"} or nil
    },
    ["lua_ls"] = {settings = {Lua = {diagnostics = {globals = {"vim"}}}}},
    ["pylsp"] = {},
    ["rust_analyzer"] = {},
    ["ts_ls"] = {}
}
return wvim
