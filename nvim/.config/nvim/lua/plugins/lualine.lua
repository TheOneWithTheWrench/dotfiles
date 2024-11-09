local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	else
		return "Recording @" .. recording_register
	end
end

return {
	{
		"nvim-lualine/lualine.nvim",
		-- event = "UIEnter",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
			},
			sections = {
				lualine_b = {
					{ "branch" },
					{ "filename", file_status = true, path = 1 },
				},
				lualine_c = {
					{ "diagnostics" },
					{ "diff" },
					{ "gitsigns" },
				},
				lualine_x = {
					{ "filetype" },
					{ "fileformat" },
					{ show_macro_recording },
				},
			},
		},
		config = function(_, opts)
			local custom_gruvbox = require("lualine.themes.gruvbox")
            --We want transparency
			custom_gruvbox.normal.c.bg = nil
			custom_gruvbox.insert.c.bg = nil
            custom_gruvbox.visual.c.bg = nil
            custom_gruvbox.replace.c.bg = nil

            opts.theme = custom_gruvbox
            require("lualine").setup(opts)
		end,
	},
}
