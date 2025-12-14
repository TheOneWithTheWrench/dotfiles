return {
	{
		url = "https://github.com/mason-org/mason.nvim",
		tag = "v2.1.0",
		config = function()
			require("mason").setup()
		end,
	},
	{
		url = "https://github.com/mason-org/mason-lspconfig.nvim",
		tag = "v2.1.0",
		ft = { "lua", "go", "graphql", "yaml", "yml", "json", "proto", "bash", "sh", "xml", "javascript", "js" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "gopls", "buf_ls", "bashls", "ts_ls" },
			})
		end,
	},
}
