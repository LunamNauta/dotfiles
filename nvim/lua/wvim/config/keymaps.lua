local module = {}
module.keymaps = {
    {mode = "n", key = "<LEADER>ff", fn = "<CMD>Telescope file_browser<CR>"},
    {mode = "n", key = "gt", fn = function() vim.cmd("BufferGoto " .. vim.v.count) end},
    {mode = "n", key = "<LEADER>tn", fn = "<CMD>tabnew<CR>"},
    {mode = "n", key = "<LEADER>tk", fn = "<CMD>bdelete<CR>"},
    {mode = "n", key = "<LEADER>di", fn = vim.lsp.buf.hover},
    {mode = "n", key = "<LEADER>de", fn = function() vim.diagnostic.open_float({border = "rounded"}) end},
    {mode = "n", key = "<LEADER>ddef", fn = vim.lsp.buf.definition},
    {mode = "n", key = "<LEADER>dtyp", fn = vim.lsp.buf.type_definition}
}
function module.load_defaults()
    for _, v in ipairs(module.keymaps) do
        vim.keymap.set(v.mode, v.key, v.fn)
    end
end
return module
