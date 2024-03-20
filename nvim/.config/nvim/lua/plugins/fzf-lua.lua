return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        fzf.setup({
            winopts = {
                preview = {
                    layout = "horizontal",
                    horizontal = "up"
                }
            }
        })

        local keymap = vim.keymap

        keymap.set('n', '<C-p>', function() fzf.files() end, {})
        keymap.set('n', '<C-b>', function() fzf.buffers() end, {})
        keymap.set('n', '<C-j>', function() fzf.lsp_definitions({ jump_to_single_result = true }) end, {})
        keymap.set('n', '<C-h>', function() fzf.lsp_references() end, {})
        keymap.set('n', '<C-k>', function() fzf.lsp_workspace_symbols() end, {})
        -- keymap.set('n', '<C-k>', function() fzf.lsp_document_symbols() end, {})
        keymap.set('n', '<C-s>', function() fzf.blines() end, {})
        keymap.set('n', '<C-l>', function() fzf.live_grep() end, {})

    end,
    opts = {
    }
}
