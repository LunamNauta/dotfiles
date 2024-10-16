local module = {}
module.opt = {
	clipboard = "unnamedplus",
	cmdheight = 0,
	number = true,
	wrap = false,
	shiftwidth = 4,
	tabstop = 4,
	expandtab = true,
	autochdir = true,
	fileencoding = "utf-8",
	termguicolors = true
}
module.g = {
    mapleader = " ",
    maplocalloader = "\\"
}
if wvim.is_windows then module.opt = vim.tbl_deep_extend("force", module.opt, {
    shell = "pwsh",
    shellxquote = "",
    shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command",
    shellquote = "",
    shellpipe = "| Out-File -Encoding UTF8 %s",
    shellredir = "| Out-File -Encoding UTF8 %s"
}) else module.opt = vim.tbl_deep_extend("force", module.opt, {shell = "bash"}) end

function module.load_defaults()
	for k, v in pairs(module.opt) do
		vim.opt[k] = v
	end
    for k, v in pairs(module.g) do
        vim.g[k] = v
    end
    vim.diagnostic.config{float = {border = "rounded"}}
end
return module
