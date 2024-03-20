return {
    "RRethy/vim-illuminate",
    config = function ()
        require("illuminate").configure({
            provider = {
                'lsp',
                'treesitter',
                'regex',
            },

            filetypes_denylist = {
            },

            delay = 100,
            under_curser = true,
            large_file_cutoff = nil,
            min_count_to_highlight = 1,
        })
    end
}
