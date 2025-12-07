-- Due to Lua's amazing non-function hoisting... We need to declare these
-- functions at the top of file first to then later fill them out...
-- God bless Lua
local custom_goto_definition_spectral_func
local on_attach_func

local to_return = {
    {
        "mason-org/mason.nvim",
        version = "^1.0.0",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        version = "^1.0.0",
        ft = { "lua", "go", "graphql", "yaml", "yml", "json", "proto", "bash", "sh", "xml", "javascript", "js" },
        opts = {
            ensure_installed = { "lua_ls", "gopls", "spectral", "buf_ls", "bashls", "ts_ls" },
        },
    },
    {
        "neovim/nvim-lspconfig",
        enabled = true,
        ft = { "lua", "go", "graphql", "yaml", "yml", "json", "proto", "bash", "sh", "xml", "javascript", "js" },
        config = function()
            -- lazydev.nvim is loaded automatically via lazy.nvim
            local cap = require("cmp_nvim_lsp").default_capabilities()

            -- Disable default LSP keymaps globally
            pcall(vim.keymap.del, 'n', 'grr')
            pcall(vim.keymap.del, 'n', 'gra')
            pcall(vim.keymap.del, 'n', 'grn')
            pcall(vim.keymap.del, 'n', 'gri')
            pcall(vim.keymap.del, 'n', 'grt')
            pcall(vim.keymap.del, 'x', 'gra')
            pcall(vim.keymap.del, 'n', 'gO')

            -- Setup default capabilities for all servers
            vim.lsp.config("*", {
                capabilities = cap,
            })

            -- LspAttach autocommand to setup keymaps
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not client then return end

                    -- Attach shared keymaps
                    on_attach_func(client, args.buf)

                    -- Spectral needs custom on_attach behavior (override gd)
                    if client.name == "spectral" then
                        vim.keymap.set(
                            "n",
                            "gd",
                            custom_goto_definition_spectral_func,
                            { buffer = args.buf, desc = "Go to definition" }
                        )
                    end
                end,
            })

            -- gh_actions_ls needs custom handlers
            vim.lsp.config("gh_actions_ls", {
                handlers = {
                    -- Github action gives a crazy "context access might be invalid" for every env key one setup if you are not logged in.
                    -- This handler supresses that warning
                    ["textDocument/publishDiagnostics"] = function(_, result, ctx)
                        if not result or not result.diagnostics then
                            return
                        end

                        -- Filter out the specific warning
                        result.diagnostics = vim.tbl_filter(function(diagnostic)
                            return not diagnostic.message:match("^Context access might be invalid:")
                        end, result.diagnostics)

                        -- Call the default handler with the filtered diagnostics
                        vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
                    end,
                },
            })

            -- Enable all LSP servers
            vim.lsp.enable({
                "gopls",
                "lua_ls",
                "graphql",
                "spectral",
                "buf_ls",
                "gh_actions_ls",
                "bashls",
                "jsonls",
                "ts_ls",
            })

            -- manually setup format for xml files... This should definitely be rethought when I redo my LSP config
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "xml",
                callback = function()
                    vim.keymap.set("n", "<space>cf", function()
                        vim.lsp.buf.format({ async = true })
                    end, { buffer = true, desc = "Format XML file" })
                end,
            })
        end,
    },
}

-- custom_goto_definition_spectral is a custom function to go to definition in Spectral
-- Since spectral didn't have it's own LSP we need to make our own. God bless Neovim
-- Need your own LSP? No worries.... Sometimes I miss Jetbrains
custom_goto_definition_spectral_func = function()
    -- Get current line text
    local line = vim.api.nvim_get_current_line()
    if not line:find("$ref:") then
        vim.print("No definition found 1")
        return nil,
            { message = "No definition found", code = -32600 }   -- -32600 is the JSON RPC error code for "Invalid request"
    end

    --Find content on line inside ""
    local content = line:match('"([^"]+)"')
    if not content then
        --Find content on line inside ''
        content = line:match("'([^']+)'")
        if not content then
            vim.print("No definition found 2")
            return nil, { message = "No definition found", code = -32600 }
        end
    end

    -- Split content by / and get the last part
    local parts = vim.split(content, "/")
    local last = parts[#parts]

    -- Find the <last>: in the file. Get line_nr and col_nr.
    local line_nr = vim.fn.search(last .. ":", "nbw")
    if line_nr == 0 then
        vim.print("No definition found 3")
        return nil, { message = "No definition found", code = -32600 }
    end

    -- Find the column number of the <last>: part using the line_nr
    local col_nr = vim.fn.stridx(vim.fn.getline(line_nr), last .. ":", 0)

    -- Set mark to jump back to. So we can ctrl-o back if we want
    vim.cmd("normal! m'")

    -- Set cursor to line_nr and col_nr
    vim.api.nvim_win_set_cursor(0, { line_nr, col_nr })
end

-- On_Attach function so we can attach all our keybinds to the differnt LSPs
on_attach_func = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = bufnr }
    local ts_builtin = require("telescope.builtin")
    local trouble = require("trouble")

    -- stylua: ignore start
    vim.keymap.set("n", "<space>cf", function() vim.lsp.buf.format({ async = false, }) end,
        vim.tbl_deep_extend("force", opts, { desc = "Format" }))
    vim.keymap.set("n", "gd", function() ts_builtin.lsp_definitions({ reuse_win = true }) end,
        vim.tbl_deep_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_deep_extend("force", opts, { desc = "Show hover" }))
    vim.keymap.set("n", "gI", function() ts_builtin.lsp_implementations({ reuse_win = true }) end,
        vim.tbl_deep_extend("force", opts, { desc = "Go to implementation" }))
    vim.keymap.set("n", "gr", function()
        trouble.open({ mode = "lsp_references" })
        vim.defer_fn(function()
            local items = trouble.get_items()
            if items and #items > 1 then
                trouble.fold_close_all()
            end
        end, 50)
    end,
        vim.tbl_deep_extend("force", opts, { desc = "Show references" }))
    -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_deep_extend("force", opts,                                         { desc = "Show signature help" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition,
        vim.tbl_deep_extend("force", opts, { desc = "Go to type definition" }))
    vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, vim.tbl_deep_extend("force", opts, { desc = "Rename" }))
    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action,
        vim.tbl_deep_extend("force", opts, { desc = "Code action" }))
    vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, vim.tbl_deep_extend("force", opts, { desc = "Run code lens" }))
    -- stylua: ignore end
end

return to_return
