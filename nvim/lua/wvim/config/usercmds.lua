local module = {}
module.usercmds = {
    {
        name = "UploadConfig",
        command = wvim.git.UploadConfig
    },
    {
        name = "DownloadConfig",
        command = wvim.git.DownloadConfig
    }
}
function module.load_defaults()
    for _, v in ipairs(module.usercmds) do
        vim.api.nvim_create_user_command(v.name, v.command, v.args or {})
    end
end
return module

