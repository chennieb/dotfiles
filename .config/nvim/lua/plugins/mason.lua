return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig",
        "L3MON4D3/LuaSnip"
    },
    config = function()
        local lsp_zero = require("lsp-zero")

        lsp_zero.extend_lspconfig()
        lsp_zero.on_attach(function(client, bufnr)
            lsp_zero.default_keymaps({buffer = bufnr})
        end)

        -- import mason
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        -- enable mason and configure icons
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "html",
                "cssls",
                "jsonls",
                "lua_ls",
                "emmet_ls",
                "pyright",
                "gopls",
                "clangd",
            },
            -- auto-install configured servers (with lspconfig)
            automatic_installation = true, -- not the same as ensure_installed
            handlers = {
                lsp_zero.default_setup,
            },
        })
    end,
}
