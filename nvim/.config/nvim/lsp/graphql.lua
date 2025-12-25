-- Install globally (NOT via mason - v3.5.0 has a regression):
--   npm install -g graphql-language-service-cli@3.3.33
return {
	cmd = { "graphql-lsp", "server", "-m", "stream" },
	filetypes = { "graphql", "typescriptreact", "javascriptreact" },
	root_markers = { ".graphqlrc*", ".graphql.config.*", "graphql.config.*" },
}
