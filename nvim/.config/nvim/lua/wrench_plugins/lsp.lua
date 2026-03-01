-- Helper to open trouble and auto-fold if multiple items
local open_trouble = function(mode)
    return function()
        local trouble = require("trouble")
        trouble.open({ mode = mode })
        vim.defer_fn(function()
            local items = trouble.get_items()
            if items and #items > 1 then
                trouble.fold_close_all()
            end
        end, 50)
    end
end

local open_lsp_symbols = function()
    local ok, snacks = pcall(require, "snacks")
    if not ok then
        vim.notify("snacks.nvim is not available", vim.log.levels.WARN)
        return
    end

    snacks.picker.lsp_symbols({
        tree = true,
        filter = {
            default = true,
            markdown = true,
            help = true,
        },
    })
end

local open_type_methods = function()
    local ok, snacks = pcall(require, "snacks")
    if not ok then
        vim.notify("snacks.nvim is not available", vim.log.levels.WARN)
        return
    end

    local symbol = vim.fn.expand("<cword>")
    if not symbol or symbol == "" then
        open_lsp_symbols()
        return
    end

    local escaped = vim.pesc(symbol)
    snacks.picker.lsp_workspace_symbols({
        search = symbol .. ".",
        tree = false,
        filter = {
            default = { "Method" },
            markdown = true,
            help = true,
            filter = function(item)
                local name = item.name or item.text or ""
                return name:find("%(%*" .. escaped .. "%)%.") ~= nil or name:find("^" .. escaped .. "%.") ~= nil
            end,
        },
    })
end

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


                vim.keymap.set("n",             "gd",           open_trouble("lsp_definitions"), vim.tbl_extend("force", opts, { desc = "Go to definition" }))
                vim.keymap.set("n",             "gD",           vim.lsp.buf.type_definition, vim.tbl_deep_extend("force", opts, { desc = "Go to type definition" }))
                vim.keymap.set("n",             "K",            vim.lsp.buf.hover, vim.tbl_extend("force", opts, {desc = "Show hover" }))
                vim.keymap.set("n",             "gI",           open_trouble("lsp_implementations"), vim.tbl_deep_extend("force", opts, { desc = "Go to implementation" }))
                vim.keymap.set("n",             "gS",           open_lsp_symbols, vim.tbl_extend("force", opts, { desc = "Open document symbols" }))
                vim.keymap.set("n",             "gM",           open_type_methods, vim.tbl_extend("force", opts, { desc = "Open methods for type" }))
                vim.keymap.set("n",             "<leader>cr",   vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
                vim.keymap.set({ "n", "v" },    "<leader>ca",   vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
                vim.keymap.set("n",             "<leader>cf",   function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format buffer" }))
                vim.keymap.set("n",             "<leader>cl",   vim.lsp.codelens.run, vim.tbl_deep_extend("force", opts, { desc = "Run code lens" }))
                vim.keymap.set("n",             "gr",           open_trouble("lsp_references"), vim.tbl_extend("force", opts, { desc = "Show references" }))
            end,
        })

        -- Enable LSP servers (requires lsp/*.lua config files)
        -- NOTE: rust_analyzer is handled by rustaceanvim plugin
        vim.lsp.enable({
            "lua_ls",
            "gopls",
            "graphql",
            "buf_ls",
            "gh_actions_ls",
            "bashls",
            "jsonls",
            "ts_ls",
        })
    end,
}
