local gopls_bin = vim.fn.expand("~/go/bin/gopls")

return {
	cmd = { vim.fn.executable(gopls_bin) == 1 and gopls_bin or "gopls", "-remote=auto" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	flags = {
		debounce_text_changes = 150,
	},
	settings = {
		gopls = {
			gofumpt = true,
			buildFlags = { "-tags=integration" },
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			analyses = {
				fieldalignment = false, -- I don't care about how many bits I can save in my structs
				copylocks = false, -- I don't care about copylocks. Fight me
			},
			completeUnimported = true,
		},
	},
}
