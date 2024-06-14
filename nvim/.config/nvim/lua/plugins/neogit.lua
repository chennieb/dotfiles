return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
    },
    opts = {
        mappings = {
            popup = {
                ["F"] = "PullPopup",
                ["p"] = "PushPopup",
                ["P"] = false,
            }
        }
    }
}
