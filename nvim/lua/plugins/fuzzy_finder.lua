return{
    {
        "nvim-telescope/telescope.nvim",
        dependencies={"telescope-fzf-native.nvim", "nvim-telescope/telescope-file-browser.nvim", "nvim-lua/plenary.nvim"},
        opts={
            extensions={
                file_browser={hijack_netrw=true,},
                fzf={fuzzy = true, override_generic_sorter = true, override_file_sorter = true}
            }
        },
        config=function(_, opts)
            opts.extensions.file_browser.mappings={["i"]={["<ESC>"] = require("telescope.actions").close}}
            require("telescope").setup(opts)
            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("fzf")
            vim.keymap.set("n", "<LEADER>ff", "<CMD>Telescope file_browser<CR>")
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build="cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    }
}
