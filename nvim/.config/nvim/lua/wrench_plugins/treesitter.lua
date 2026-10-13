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
	"rust",
}

return {
	{
		url = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		dependencies = {
			{ url = "https://github.com/stevearc/oil.nvim" }, -- We have to load OIL before treesitter... Annoying...
		},
		config = function()
			local treesitter = require("nvim-treesitter")

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
				callback = function(args)
					local bufnr = args.buf
					local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
					if not lang then
						return
					end

					local function start()
						if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
							return
						end
						if vim.treesitter.language.get_lang(vim.bo[bufnr].filetype) ~= lang then
							return
						end

						local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
						if ok and parser then
							vim.treesitter.start(bufnr, lang)
						end
					end

					if
						vim.list_contains(ensure_installed, lang)
						and not vim.list_contains(treesitter.get_installed(), lang)
					then
						treesitter.install({ lang }):await(vim.schedule_wrap(function(err, success)
							if not err and success then
								start()
							end
						end))
					end

					start()
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
