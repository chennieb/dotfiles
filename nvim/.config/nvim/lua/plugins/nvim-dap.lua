return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap, ui = require("dap"), require("dapui")
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "-i", "dap" }
        }

        dap.configurations.cpp = {
            {
                name = "Launch",
                type = "gdb",
                request = "launch",
                program = function()
                    -- return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    return vim.fn.input('Path to executable: ',
                        vim.fn.getcwd() .. '/../../builds/build-FRA-A-API-debug/bin/', 'file')
                end,
                cwd = "${workspaceFolder}",
                stopAtBeginningOfMainSubprogram = false,
            },
        }

        local keymap = vim.keymap

        --keymap.set('n', '<F5>', function() dap.continue() end)
        --keymap.set('n', '<F10>', function() dap.step_over() end)
        --keymap.set('n', '<F11>', function() dap.step_into() end)
        --keymap.set('n', '<F12>', function() dap.step_out() end)

        keymap.set('n', '<leader>db', dap.toggle_breakpoint)
        keymap.set('n', '<leader>dl', require("dap.ui.widgets").hover)
        keymap.set('n', '<leader>ds', function()
            dap.continue()
            ui.toggle({})
        end)
        keymap.set('n', '<leader>dc', dap.continue)
        keymap.set('n', '<leader>dn', dap.step_over)
        keymap.set('n', '<leader>di', dap.step_into)
        keymap.set('n', '<leader>do', dap.step_out)
        keymap.set('n', '<leader>de', function()
            dap.clear_breakpoints()
            ui.toggle({})
            dap.terminate()
            require("notify")("Debugger session ended", "warn")
        end)
        keymap.set('n', '<leader>dC', function()
            dap.clear_breakpoints()
            require("notify")("Breakpoints cleared", "warn")
        end)
    end
}
