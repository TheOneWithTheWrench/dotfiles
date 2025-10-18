return {
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
	settings = {
		javascript = {
			suggest = {
				diagnostics = true, -- Enable diagnostics for JavaScript
			},
			validate = true, -- Validate JavaScript files
		},
	},
}
