return {
    "cbochs/grapple.nvim",
    dependencies = {
        { "nvim-tree/nvim-web-devicons", lazy = true }
    },
    opts = {
        scope = "git", -- also try out "git_branch"
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
        { "m", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
        { "<C-T>", "<cmd>Grapple toggle_tags<cr>", desc = "Open tags window" },
        { "<C-N>", "<cmd>Grapple cycle backward<cr>", desc = "Go to previous tag" },
        { "<C-M>", "<cmd>Grapple cycle forward<cr>", desc = "Go to next tag" },
    },
}
