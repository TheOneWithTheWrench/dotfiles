return {
    {
		url = "https://github.com/ray-x/go.nvim",
		ft = { "go", "gomod" },
        keys = {
            { lhs = "<leader>cs", rhs = function() vim.cmd("GoFillStruct") end, desc = "Go fill struct" },
            { lhs = "<leader>ce", rhs = function() vim.cmd("GoIfErr") end,      desc = "Go if err" },
        },
        dependencies = {
            { url = "https://github.com/ray-x/guihua.lua" },
            { url ="https://github.com/neovim/nvim-lspconfig" },
            { url ="https://github.com/nvim-treesitter/nvim-treesitter" },
        },
		config = function()
			local opts = {
				run_in_floaterm = true,
				floaterm = {
					posititon = "bottom",
					height = 0.4,
				},
			}

			require("go").setup(opts)

			local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").goimport()
				end,
				group = format_sync_grp,
			})
		end,
	},
	{
		url = "https://github.com/fredrikaverpil/neotest-golang",
		ft = { "go", "gomod" },
		tag = "v2.5.1",
        config = function() end,
	},
}

-- Let's wait with dap for now until we need it... It's a struggle to setup
