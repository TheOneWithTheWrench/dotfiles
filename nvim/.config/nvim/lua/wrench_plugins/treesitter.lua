return {
    url = "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    dependencies = {
        { url = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
        { url = "https://github.com/stevearc/oil.nvim", }, -- We have to load OIL before treesitter... Annoying...
    },
    config = function()
        pcall(vim.treesitter.start)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
            callback = function(args)
                local bufnr = args.buf
                local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
                if not ok or not parser then
                    return
                end
                pcall(vim.treesitter.start)
                vim.bo[bufnr].syntax = "on"
            end,
        })
    end,
}
