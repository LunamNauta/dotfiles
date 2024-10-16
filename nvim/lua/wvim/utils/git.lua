wvim = wvim or {}
wvim.git = wvim.git or {}

function wvim.git.UploadConfig()
    local git_dir = vim.fn.stdpath("config")
    local git_command = "!git -C " .. git_dir
    local commit_msg = "Upload from 'UploadConfig' (" .. vim.fn.strftime("%c") .. ")"
    vim.cmd(git_command .. " add -A")
    vim.cmd(git_command .. " commit -m \"" .. commit_msg .. "\"")
    vim.cmd(git_command .. " push origin main")
end
function wvim.git.DownloadConfig()
    local git_dir = vim.fn.stdpath("config")
    local git_command = "!git -C " .. git_dir
    vim.cmd(git_command .. " fetch origin")
    vim.cmd(git_command .. " reset --hard origin/main")
end
