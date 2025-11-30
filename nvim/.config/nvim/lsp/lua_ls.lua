return {
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
                disable = {
                    "duplicate-doc-field", -- Haven't figured out how to fix this yet. I fear I might be loading to lua_ls or something... 
                    "duplicate-doc-alias",
                }
            },
		},
	},
}
