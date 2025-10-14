local M = {}

local uname = vim.loop.os_uname()
local os_name = uname.sysname:lower()

local is_windows = os_name:find("windows") ~= nil
local is_linux = os_name:find("linux") ~= nil
local is_macos = os_name:find("darwin") ~= nil

function M.get_run_command(filetype, fullpath, dir, filename_noext)
	local output_path = string.format("%s/%s", dir, filename_noext)

	---------------------------------------------------------
	if filetype == "c" then
		if is_windows then
			return string.format('term gcc -o "%s" "%s" -lm -lpthread && "%s"', output_path, fullpath, output_path)
		elseif is_linux then
			return string.format(
				'term gcc -o "%s" "%s" -lm -lpthread -ldl -lrt && "%s"',
				output_path,
				fullpath,
				output_path
			)
		elseif is_macos then
			return string.format('term clang -o "%s" "%s" -lm && "%s"', output_path, fullpath, output_path)
		end

	---------------------------------------------------------
	elseif filetype == "cpp" then
		return string.format('term g++ -o "%s" "%s" && "%s"', output_path, fullpath, output_path)

	---------------------------------------------------------
	elseif filetype == "python" then
		local py = is_windows and "python" or "python3"
		return string.format('term %s "%s"', py, fullpath)

	---------------------------------------------------------
	elseif filetype == "rust" then
		local cargo_toml_path = vim.fn.findfile("Cargo.toml", ".;")
		if cargo_toml_path ~= "" then
			local cargo_dir = vim.fn.fnamemodify(cargo_toml_path, ":h")
			return string.format("term cd %s && cargo run", vim.fn.shellescape(cargo_dir))
		else
			if is_windows then
				return string.format('term rustc "%s" -o "%s" && "%s"', fullpath, output_path, output_path)
			else
				return string.format(
					"term rustc %s -o %s && %s",
					vim.fn.shellescape(fullpath),
					vim.fn.shellescape(output_path),
					vim.fn.shellescape(output_path)
				)
			end
		end

	---------------------------------------------------------
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

		local file = vim.fn.expand("%:t:r")
		local classname = pkg ~= "" and (pkg .. "." .. file) or file
		local src_path = vim.fn.finddir("src", ".;")
		if src_path == "" then
			vim.notify("Không tìm thấy thư mục src/", vim.log.levels.ERROR)
			return ""
		end

		local src_abs = vim.fn.fnamemodify(src_path, ":p")
		local project_root = vim.fn.fnamemodify(src_abs, ":h")
		local bin_path = project_root .. "/bin"

		if is_windows then
			return string.format(
				[[term mkdir "%s" && powershell -Command "Get-ChildItem -Recurse -Filter *.java -Path '%s' | ForEach-Object { $_.FullName } | javac -d '%s' -" && java -cp "%s" "%s"]],
				bin_path,
				src_abs,
				bin_path,
				bin_path,
				classname
			)
		else
			return string.format(
				[[term mkdir -p "%s" && find "%s" -name "*.java" | xargs javac -d "%s" && java -cp "%s" "%s"]],
				bin_path,
				src_abs,
				bin_path,
				bin_path,
				classname
			)
		end

	---------------------------------------------------------
	elseif filetype == "javascript" or filetype == "js" then
		return string.format('term node "%s"', fullpath)

	---------------------------------------------------------
	elseif filetype == "html" then
		local filename = vim.fn.expand("%:t")
		
		if is_windows then
			return 'cd "' .. dir .. '" && start /B live-server --port=8080 --no-browser --open=' .. filename .. ' & timeout /t 3 & start chrome "http://localhost:8080/' .. filename .. '"'
		elseif is_macos then
			return 'cd "' .. dir .. '" && live-server --port=8080 --no-browser --open=' .. filename .. ' & sleep 3 && open -a "Google Chrome" "http://localhost:8080/' .. filename .. '"'
		elseif is_linux then
			return 'cd "' .. dir .. '" && live-server --port=8080 --no-browser --open=' .. filename .. ' & sleep 3 && google-chrome-stable --enable-features=UseOzonePlatform --ozone-platform=wayland "http://localhost:8080/' .. filename .. '" > /dev/null 2>&1 &'
		end
	end

	return nil
end

return M

