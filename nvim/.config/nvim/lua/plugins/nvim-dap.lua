return {
    "mfussenegger/nvim-dap",
    config = function ()
        local keymap = vim.keymap

        keymap.set('n', '<F5>', function() require('dap').continue() end)
        keymap.set('n', '<F10>', function() require('dap').step_over() end)
        keymap.set('n', '<F11>', function() require('dap').step_into() end)
        keymap.set('n', '<F12>', function() require('dap').step_out() end)
        keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end)
    end
}
