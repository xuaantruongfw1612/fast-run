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

	-- Rust (Prioritize Cargo project, then single file)
	elseif filetype == "rust" then
		local cargo_toml_path = findfile("Cargo.toml", ".;")
		if cargo_toml_path ~= "" then
			local cargo_dir = fnamemodify(cargo_toml_path, ":h")
			return "term cd " .. shellescape(cargo_dir) .. " && cargo run"
		else
			-- Single Rust file
			if is_windows then
				return string.format('term rustc "%s" -o "%s" && "%s"', fullpath, output_path, output_path)
			else
				return string.format("term rustc %s -o %s && %s", shellescape(fullpath), shellescape(output_path), shellescape(output_path))
			end
		end

	-- Java (Prioritize src/, then file with package, finally single file)
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
		
		-- Case 1: src directory exists (Java project structure)
		if src_path ~= "" then
			local src_abs = fnamemodify(src_path, ":p")
			local project_root = fnamemodify(src_abs, ":h")
			local bin_path = project_root .. "/bin"

			if is_windows then
				return string.format(
					[[term mkdir "%s" 2>nul & powershell -Command "Get-ChildItem -Recurse -Filter *.java -Path '%s' | ForEach-Object { $_.FullName }" | javac -d "%s" @- && java -cp "%s" "%s"]],
					bin_path, src_abs, bin_path, bin_path, classname
				)
			else
				return string.format(
					[[term mkdir -p "%s" && find "%s" -name "*.java" | xargs javac -d "%s" && java -cp "%s" "%s"]],
					bin_path, src_abs, bin_path, bin_path, classname
				)
			end
		
		-- Case 2: Java file has a package (but not inside src/)
		elseif pkg ~= "" then
			vim.notify("Warning: File có package nhưng không nằm trong src/. Khuyến nghị tạo cấu trúc project (sử dụng <leader>tj).", vim.log.levels.WARN)
			
			-- Create temporary directory for compilation
			local temp_bin = dir .. "/bin"
			
			if is_windows then
				return string.format(
					[[term mkdir "%s" 2>nul & javac -d "%s" "%s" && java -cp "%s" "%s"]],
					temp_bin, temp_bin, fullpath, temp_bin, classname
				)
			else
				return string.format(
					[[term mkdir -p "%s" && javac -d "%s" "%s" && java -cp "%s" "%s"]],
					temp_bin, temp_bin, fullpath, temp_bin, classname
				)
			end
		
		-- Case 3: Simple Java file without package
		else
			if is_windows then
				return string.format(
					[[term javac "%s" && java -cp "%s" "%s"]],
					fullpath, dir, file
				)
			else
				return string.format(
					[[term javac "%s" && java -cp "%s" "%s"]],
					fullpath, dir, file
				)
			end
		end

	-- JavaScript
	elseif filetype == "javascript" then
		return string.format('term node "%s"', fullpath)

	-- TypeScript
	elseif filetype == "typescript" then
		return string.format('term ts-node "%s"', fullpath)

	-- Go (Prioritize go.mod, then single file)
	elseif filetype == "go" then
		local go_mod_path = findfile("go.mod", ".;")
		if go_mod_path ~= "" then
			local go_dir = fnamemodify(go_mod_path, ":h")
			return "term cd " .. shellescape(go_dir) .. " && go run ."
		else
			-- Single Go file
			return string.format('term go run "%s"', fullpath)
		end

	-- Ruby
	elseif filetype == "ruby" then
		return string.format('term ruby "%s"', fullpath)

	-- PHP
	elseif filetype == "php" then
		return string.format('term php "%s"', fullpath)

	-- Lua
	elseif filetype == "lua" then
		return string.format('term lua "%s"', fullpath)

	-- Perl
	elseif filetype == "perl" then
		return string.format('term perl "%s"', fullpath)

	-- Shell Script
	elseif filetype == "sh" or filetype == "bash" then
		return string.format('term bash "%s"', fullpath)

	-- Kotlin
	elseif filetype == "kotlin" then
		local jar_path = output_path .. ".jar"
		return string.format('term kotlinc "%s" -include-runtime -d "%s" && java -jar "%s"', fullpath, jar_path, jar_path)

	-- Swift
	elseif filetype == "swift" then
		return string.format('term swift "%s"', fullpath)

	-- R
	elseif filetype == "r" then
		return string.format('term Rscript "%s"', fullpath)

	-- Scala
	elseif filetype == "scala" then
		return string.format('term scala "%s"', fullpath)

	-- Dart
	elseif filetype == "dart" then
		return string.format('term dart "%s"', fullpath)

	-- Haskell
	elseif filetype == "haskell" then
		return string.format('term runhaskell "%s"', fullpath)

	-- Elixir
	elseif filetype == "elixir" then
		return string.format('term elixir "%s"', fullpath)

	-- Clojure
	elseif filetype == "clojure" then
		return string.format('term clojure "%s"', fullpath)

	-- OCaml
	elseif filetype == "ocaml" then
		return string.format('term ocaml "%s"', fullpath)

	-- F#
	elseif filetype == "fsharp" then
		return string.format('term dotnet fsi "%s"', fullpath)

	-- C# (Prioritize .csproj, then dotnet script)
	elseif filetype == "cs" then
		local csproj = findfile("*.csproj", ".;")
		if csproj ~= "" then
			local proj_dir = fnamemodify(csproj, ":h")
			return "term cd " .. shellescape(proj_dir) .. " && dotnet run"
		else
			-- Single C# file
			return string.format('term dotnet script "%s"', fullpath)
		end

	-- Zig
	elseif filetype == "zig" then
		return string.format('term zig run "%s"', fullpath)

	-- Nim
	elseif filetype == "nim" then
		return string.format('term nim c -r "%s"', fullpath)

	-- Julia
	elseif filetype == "julia" then
		return string.format('term julia "%s"', fullpath)

	-- Racket
	elseif filetype == "racket" then
		return string.format('term racket "%s"', fullpath)

	-- HTML
	elseif filetype == "html" then
		local filename = expand("%:t")
		local base_cmd = 'browser-sync start --server --files "**/*.css,**/*.html,**/*.js" --no-open --startPath="/' .. filename .. '"'
		
		local function get_browser_cmd(browser_path, url)
			if is_windows then
				return string.format('start /B %s & timeout /t 3 & start %s "%s"', base_cmd, browser_path, url)
			elseif is_macos then
				return string.format('%s & sleep 3 && open -a "%s" "%s"', base_cmd, browser_path, url)
			elseif is_linux then
				return string.format('%s & sleep 3 && %s "%s" &', base_cmd, browser_path, url)
			end
		end
		
		local function check_browser_exists(cmd)
			if is_windows then
				return os.execute(string.format('where %s > nul 2>&1', cmd)) == 0
			else
				return os.execute(string.format('which %s > /dev/null 2>&1', cmd)) == 0
			end
		end
		
		local url = "http://localhost:3000/" .. filename
		local browser_list = {
			{ cmd = "google-chrome-stable", args = "--enable-features=UseOzonePlatform --ozone-platform=wayland", name = "Google Chrome" },
			{ cmd = "microsoft-edge", args = "", name = "Edge" },
			{ cmd = "microsoft-edge-stable", args = "", name = "Edge" },
			{ cmd = "chromium", args = "", name = "Chromium" },
			{ cmd = "firefox", args = "", name = "Firefox" }
		}
		
		for _, browser in ipairs(browser_list) do
			if check_browser_exists(browser.cmd) then
				local browser_path = browser.cmd
				if browser.args ~= "" then
					browser_path = browser_path .. " " .. browser.args
				end
				return get_browser_cmd(browser_path, url)
			end
		end
		
		return "echo 'Browser not found'"
	end

	return nil
end

return M
