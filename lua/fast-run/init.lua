local M = {}

local config = require("fast-run.config")

function M.setup(opts)
	config.setup(opts)
	require("fast-run.ui").register()
end

return M

