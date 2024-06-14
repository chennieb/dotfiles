vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*.qml",
    command = "set filetype=qmljs",
})
