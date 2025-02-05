return {
	{
		"neovim/nvim-lspconfig",
		ft = { "javascript", "js" },
		dependencies = {
			{
				"williamboman/mason.nvim",
			},
			{
				"williamboman/mason-lspconfig.nvim",
				ft = { "javascript", "js" },
				opts = {
					ensure_installed = { "ts_ls" },
				},
			},
		},
		opts = function(_, opts)
			local cap = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.ts_ls.setup({
				capabilities = cap,
				settings = {
					javascript = {
						suggest = {
							diagnostics = true, -- Enable diagnostics for JavaScript
						},
						validate = true, -- Validate JavaScript files
					},
				},
				on_attach = function(_, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"

					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local op = { buffer = bufnr }
					local ts_builtin = require("telescope.builtin")

                    -- stylua: ignore start
                    vim.keymap.set("n", "<space>cf", function() vim.lsp.buf.format({ async = false, }) end, vim.tbl_deep_extend("force", op,          { desc = "Format" }))
                    vim.keymap.set("n", "gd", function() ts_builtin.lsp_definitions({ reuse_win = true }) end, vim.tbl_deep_extend("force", op,       { desc = "Go to definition" }))
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_deep_extend("force", op,                                                      { desc = "Show hover" }))
                    vim.keymap.set("n", "gI", function() ts_builtin.lsp_implementations({ reuse_win = true }) end, vim.tbl_deep_extend("force", op,   { desc = "Go to implementation" }))
                    vim.keymap.set("n", "gr", function() ts_builtin.lsp_references({ reuse_win = true }) end, vim.tbl_deep_extend("force", op,        { desc = "Go to references" }))
                    -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_deep_extend("force", opts,                                         { desc = "Show signature help" }))
                    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, vim.tbl_deep_extend("force", op,                                           { desc = "Go to type definition" }))
                    vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, vim.tbl_deep_extend("force", op,                                             { desc = "Rename" }))
                    vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, vim.tbl_deep_extend("force", op,                               { desc = "Code action" }))
                    vim.keymap.set("n", "<space>cl", vim.lsp.codelens.run, vim.tbl_deep_extend("force", op,                                           { desc = "Run code lens" }))
					-- stylua: ignore end
				end,
			})

			return opts
		end,
	},
}
