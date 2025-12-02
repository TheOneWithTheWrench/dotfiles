return {
	cmd = { "graphql-lsp", "server", "-m", "stream", "-c" },
	filetypes = { "graphql", "typescriptreact", "javascriptreact" },
	root_markers = { ".graphqlrc*", ".graphql.config.*", "graphql.config.*" },
}
