return {
    url = "https://github.com/neovim/nvim-lspconfig",
    branch = "master",
    dependencies = {
        { url = "https://github.com/folke/trouble.nvim" },
    },
    config = function()

        -- Disable default LSP keymaps globally
        pcall(vim.keymap.del, 'n', 'grr')
        pcall(vim.keymap.del, 'n', 'gra')
        pcall(vim.keymap.del, 'n', 'grn')
        pcall(vim.keymap.del, 'n', 'gri')
        pcall(vim.keymap.del, 'n', 'grt')
        pcall(vim.keymap.del, 'x', 'gra')
        pcall(vim.keymap.del, 'n', 'gO')

        -- LspAttach autocommand for keymaps
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
            callback = function(args)
                local opts = { buffer = args.buf }
                vim.keymap.set("n",             "gd",           vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                vim.keymap.set("n",             "gD",           vim.lsp.buf.type_definition, vim.tbl_deep_extend("force", opts, { desc = "Go to type definition" }))
                vim.keymap.set("n",             "K",            vim.lsp.buf.hover, vim.tbl_extend("force", opts, {desc = "Show hover" }))
                vim.keymap.set("n",             "<leader>cr",   vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                vim.keymap.set({ "n", "v" },    "<leader>ca",   vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
                vim.keymap.set("n",             "<leader>cf",   function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
                vim.keymap.set("n",             "<leader>cl",   vim.lsp.codelens.run, vim.tbl_deep_extend("force", opts, { desc = "Run code lens" }))
                vim.keymap.set("n",             "gr",           function()
                    local trouble = require("trouble")
                    trouble.open({ mode = "lsp_references" })
                    vim.defer_fn(function()
                        local items = trouble.get_items()
                        if items and #items > 1 then
                            trouble.fold_close_all()
                        end
                    end, 50)
                end, vim.tbl_extend("force", opts, { desc = "Show references" }))
            end,
        })

        -- Enable LSP servers (requires lsp/*.lua config files)
        vim.lsp.enable({
            "lua_ls",
            "gopls",
        })
    end,
}
