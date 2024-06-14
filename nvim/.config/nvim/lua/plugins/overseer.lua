return {
    "stevearc/overseer.nvim",
    event = "VeryLazy",
    config = function ()
        require('overseer').setup({
            dap = true,
            templates = {
                { "builtin", "user.build" },
            },
        })
    end
}
