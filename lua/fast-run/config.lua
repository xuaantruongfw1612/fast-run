local M = {}

M.supported_languages = {}
M.custom_keymaps = nil
M.terminal_position = "right"
M.terminal_size = 50

function M.setup(opts)
	opts = opts or {}
	
	-- Default languages
	local default_languages = {
		"c", "cpp", "python", "java", "javascript", "typescript",
		"go", "rust", "ruby", "php", "lua", "kotlin", "swift",
		"perl", "sh", "bash", "r", "scala", "dart", "haskell",
		"elixir", "clojure", "ocaml", "fsharp", "zig", "nim",
		"julia", "racket", "cs", "html", "css"
	}
	
	local enabled = opts.enable or default_languages
	
	-- Build supported languages table
	M.supported_languages = {}
	for _, lang in ipairs(enabled) do
		M.supported_languages[lang] = true
	end
	
	-- Store custom keymaps if provided
	M.custom_keymaps = opts.keymaps or nil
	
	M.terminal_position = opts.terminal_position or "right"
	M.terminal_size = opts.terminal_size or 50
end

return M
