local M = {}

local uname = vim.loop.os_uname()
local os_name = uname.sysname:lower()

local is_windows = os_name:find("windows") ~= nil
local is_linux = os_name:find("linux") ~= nil
local is_macos = os_name:find("darwin") ~= nil

local expand = vim.fn.expand
local findfile = vim.fn.findfile
local finddir = vim.fn.finddir
local fnamemodify = vim.fn.fnamemodify
local shellescape = vim.fn.shellescape

function M.get_run_command(filetype, fullpath, dir, filename_noext)
	local output_path = dir .. "/" .. filename_noext

	-- C language
	if filetype == "c" then
		if is_windows then
			return string.format('term gcc -o "%s" "%s" -lm -lpthread && "%s"', output_path, fullpath, output_path)
		elseif is_linux then
			return string.format('term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"', output_path, fullpath, output_path)
		elseif is_macos then
			return string.format('term clang -o "%s" "%s" -lm && "%s"', output_path, fullpath, output_path)
		end

	-- C++
	elseif filetype == "cpp" then
		return string.format('term g++ -o "%s" "%s" && "%s"', output_path, fullpath, output_path)

	-- Python
	elseif filetype == "python" then
		local py = is_windows and "python" or "python3"
		return string.format('term %s "%s"', py, fullpath)

	-- Rust
	elseif filetype == "rust" then
		local cargo_toml_path = findfile("Cargo.toml", ".;")
		if cargo_toml_path ~= "" then
			local cargo_dir = fnamemodify(cargo_toml_path, ":h")
			return "term cd " .. shellescape(cargo_dir) .. " && cargo run"
		else
			return is_windows 
				and string.format('term rustc "%s" -o "%s" && "%s"', fullpath, output_path, output_path)
				or string.format("term rustc %s -o %s && %s", shellescape(fullpath), shellescape(output_path), shellescape(output_path))
		end

	-- Java
	elseif filetype == "java" then
		local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
		local pkg = ""
		for _, line in ipairs(lines) do
			local m = line:match("^%s*package%s+([%w%.]+)%s*;")
			if m then
				pkg = m
				break
			end
		end

		local file = expand("%:t:r")
		local classname = pkg ~= "" and (pkg .. "." .. file) or file
		local src_path = finddir("src", ".;")
		
		if src_path == "" then
			vim.notify("Không tìm thấy thư mục src/", vim.log.levels.ERROR)
			return nil
		end

		local src_abs = fnamemodify(src_path, ":p")
		local project_root = fnamemodify(src_abs, ":h")
		local bin_path = project_root .. "/bin"

		if is_windows then
			return string.format(
				[[term mkdir "%s" && powershell -Command "Get-ChildItem -Recurse -Filter *.java -Path '%s' | ForEach-Object { $_.FullName } | javac -d '%s' -" && java -cp "%s" "%s"]],
				bin_path, src_abs, bin_path, bin_path, classname
			)
		else
			return string.format(
				[[term mkdir -p "%s" && find "%s" -name "*.java" | xargs javac -d "%s" && java -cp "%s" "%s"]],
				bin_path, src_abs, bin_path, bin_path, classname
			)
		end

	-- JavaScript
	elseif filetype == "javascript" or filetype == "js" then
		return string.format('term node "%s"', fullpath)

	-- HTML
	elseif filetype == "html" then
		local filename = expand("%:t")
		local base_cmd = 'browser-sync start --server --files "**/*.css,**/*.html,**/*.js" --no-open --startPath="/' .. filename .. '"'
		
		if is_windows then
			return string.format('cd "%s" && start /B %s & timeout /t 3 & start chrome "http://localhost:3000/%s"', dir, base_cmd, filename)
		elseif is_macos then
			return string.format('cd "%s" && %s & sleep 3 && open -a "Google Chrome" "http://localhost:3000/%s"', dir, base_cmd, filename)
		elseif is_linux then
			return string.format('cd "%s" && %s & sleep 3 && google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland "http://localhost:3000/%s" > /dev/null 2>&1 &', dir, base_cmd, filename)
		end
	end

	return nil
end

return M

