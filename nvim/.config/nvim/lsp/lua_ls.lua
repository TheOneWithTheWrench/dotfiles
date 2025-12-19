return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".git",
	},
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			diagnostics = {
				disable = {
					"duplicate-doc-field",
					"duplicate-doc-alias",
				}
			},
		},
	},
}
