return {
    "neovim/nvim-lspconfig",
    config = function ()
        local keymap = vim.keymap -- for conciseness
        local default_ops = { noremap = true, silent = true }

        keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, default_ops)
        keymap.set('n', '<F4>', function() vim.cmd('ClangdSwitchSourceHeader') end, default_ops)
        keymap.set({'n', 'v'}, '<C-\'>', function() vim.lsp.buf.format() end, default_ops)
    end,
}
