return {
    "stevearc/overseer.nvim",
    opts = {},
    config = function (_, opts)
        require('overseer').setup(opts)
    end
}
