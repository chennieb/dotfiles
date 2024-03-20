return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter.configs")
        treesitter.setup({
            ensure_installed = {"c", "lua", "python", "go", "cpp", "json","html", "xml"},
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            rainbow = {
                enable = true,
            }
        })
    end,
}
