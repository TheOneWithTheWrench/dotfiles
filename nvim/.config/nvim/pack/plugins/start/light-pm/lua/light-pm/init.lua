-- light-pm/init.lua

local M = {}
local log = require("light-pm.log")

---@class PluginConfig
---@field url string The plugin specifier "owner/repo". This must be the first element, e.g., { "owner/repo" }.
---@field dependencies? PluginConfig (Optional) A list of other plugins that will be loaded first.
---@field branch? string (Optional) Specify a git branch to clone.
---@field tag? string (Optional) Specify a git tag to checkout.
---@field commit? string (Optional) Pin to a specific commit hash.
---@field config? function (Optional) A function to run after the plugin is loaded.

--- A list of plugins to be processed, each as a PluginConfig table.
---@alias PluginList PluginConfig[]

--- Adds and processes a list of plugins.
---@param plugins PluginList A list of PluginConfig tables.
function M.add(plugins)
	if not plugins or type(plugins) ~= "table" then
		log.error("add() requires a table of PluginConfigs.")
		return
	end

	for _, config in ipairs(plugins) do
		if type(config) ~= "table" then
			log.warn("Skipping invalid plugin entry. Expected a PluginConfig table.")
			goto continue
		end

		-- According to PluginConfig definition, spec is config[1]
		local url = config[1]
		if not url or type(url) ~= "string" then
			log.warn("Skipping invalid plugin entry. Missing spec at config[1] (owner/repo).")
			goto continue
		end

		-- TODO: Implement installation and loading logic using the structured config table.

		::continue::
	end
end

return M
