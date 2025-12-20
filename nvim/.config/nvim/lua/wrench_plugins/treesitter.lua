local ensure_installed = {
	"c",
	"lua",
	"vim",
	"vimdoc",
	"markdown",
	"go",
	"javascript",
	"yaml",
	"gomod",
	"gosum",
}

return {
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		dependencies = {
			{ url = "https://github.com/stevearc/oil.nvim" }, -- We have to load OIL before treesitter... Annoying...
		},
		config = function()
			pcall(vim.treesitter.start)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
				callback = function(args)
					local bufnr = args.buf
					local filetype = vim.bo[bufnr].filetype

					-- Check if filetype is in ensure_installed list
					local should_install = false
					for _, lang in ipairs(ensure_installed) do
						if lang == filetype then
							should_install = true
							break
						end
					end

					if should_install then
						local treesitter = require("nvim-treesitter")
						local installed = treesitter.get_installed()

						-- Check if already installed
						local is_installed = false
						for _, lang in ipairs(installed) do
							if lang == filetype then
								is_installed = true
								break
							end
						end

						if not is_installed then
							treesitter.install({ filetype })
						end
					end

					-- Start treesitter for this buffer
					local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
					if not ok or not parser then
						return
					end
					pcall(vim.treesitter.start)
					vim.bo[bufnr].syntax = "on"
				end,
			})
		end,
	},
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			{ url = "https://github.com/nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("treesitter-context").setup()
		end,
	},
}
