return {
	url = "https://github.com/nvim-treesitter/nvim-treesitter",
	branch = "master",
	dependencies = {
		{ url = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"go",
			},
		})
	end,
}
