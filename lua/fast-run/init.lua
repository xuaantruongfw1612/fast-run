local M = {}

function M.setup(opts)
	local config = require("fast-run.config")
	config.setup(opts)
	
	local ui = require("fast-run.ui")
	ui.register()
end

return M
