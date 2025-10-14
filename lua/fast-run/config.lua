local M = {}

M.supported_languages = {}

function M.setup(opts)
	opts = opts or {}
	M.supported_languages = {}

	if opts.enable and type(opts.enable) == "table" then
		for _, lang in ipairs(opts.enable) do
			M.supported_languages[lang] = true
		end
	end
end

return M
