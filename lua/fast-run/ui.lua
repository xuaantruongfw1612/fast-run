local M = {}
local config = require("fast-run.config")
local keymap = require("fast-run.keymap")
local runner = require("fast-run.runner")

-- Server state management
M.html_server_running = false
M.server_job_id = nil
M.current_html_dir = nil

local jobstart = vim.fn.jobstart
local jobstop = vim.fn.jobstop
local expand = vim.fn.expand
local finddir = vim.fn.finddir
local fnamemodify = vim.fn.fnamemodify

-- Utility function to kill all browser-sync processes
local function kill_all_browsersync()
	local is_windows = vim.loop.os_uname().sysname:lower():find("windows") ~= nil
	
	if is_windows then
		vim.fn.system("taskkill /F /IM node.exe /FI \"WINDOWTITLE eq browser-sync\" 2>nul")
		vim.fn.system("taskkill /F /IM browser-sync.cmd /FI \"*browser-sync*\" 2>nul")
	else
		vim.fn.system("pkill -f 'browser-sync'")
		vim.fn.system("pkill -f 'node.*browser-sync'")
	end
	
	vim.loop.sleep(300)
end

-- Stop the HTML server
function M.stop_server()
	if M.html_server_running and M.server_job_id then
		jobstop(M.server_job_id)
		kill_all_browsersync()
		M.html_server_running = false
		M.server_job_id = nil
		M.current_html_dir = nil
		print("Browser-sync server stopped")
		return true
	end
	print("No server is running")
	return false
end

-- Show server info
function M.show_server_info()
	if M.html_server_running then
		print(string.format("Server running at http://localhost:3000 (Dir: %s)", M.current_html_dir))
	else
		print("No server is running")
	end
end

-- Restart the HTML server
local function restart_server(cmd, current_dir)
	kill_all_browsersync()
	
	vim.defer_fn(function()
		M.server_job_id = jobstart(cmd, {
			detach = true,
			cwd = current_dir,
			on_exit = function()
				M.html_server_running = false
				M.server_job_id = nil
				M.current_html_dir = nil
			end,
		})
		M.html_server_running = true
		M.current_html_dir = current_dir
		print("Browser-sync started at http://localhost:3000")
	end, 500)
end

-- Handle HTML file execution
local function handle_html_run(cmd)
	local current_dir = expand("%:p:h")
	
	if M.html_server_running and M.server_job_id then
		if M.current_html_dir ~= current_dir then
			print("Switching directory... killing all browser-sync processes")
			jobstop(M.server_job_id)
			kill_all_browsersync()
			M.html_server_running = false
			M.server_job_id = nil
			
			vim.defer_fn(function()
				restart_server(cmd, current_dir)
			end, 1000)
		else
			print("Server running. File saved, browser will auto-reload.")
		end
	else
		restart_server(cmd, current_dir)
	end
end

-- Handle regular program execution
local function handle_regular_run(cmd)
	-- Check if there's already a terminal window open
	local found_term = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
			vim.api.nvim_set_current_win(win)
			found_term = true
			break
		end
	end
	
	if not found_term then
		if config.terminal_position == "bottom" then
			vim.cmd("rightbelow split | resize " .. config.terminal_size)
		else
			vim.cmd("vertical rightbelow vsplit | vertical resize " .. config.terminal_size)
		end
	end
	
	vim.cmd(cmd)
	vim.cmd("startinsert")
	keymap.set_terminal_keymaps()
end

-- Create Java project structure
function M.create_java_project()
	local filetype = vim.bo.filetype
	if filetype ~= "java" then
		vim.notify("This command only works for Java files", vim.log.levels.WARN)
		return
	end
	
	local current_file = expand("%:p")
	local current_dir = expand("%:p:h")
	local src_path = finddir("src", ".;")
	
	if src_path ~= "" then
		vim.notify("src/ directory already exists", vim.log.levels.INFO)
		return
	end
	
	-- Tạo cấu trúc project
	local project_root = current_dir
	vim.fn.mkdir(project_root .. "/src", "p")
	vim.fn.mkdir(project_root .. "/bin", "p")
	
	-- Di chuyển file vào src/
	local filename = expand("%:t")
	local new_path = project_root .. "/src/" .. filename
	
	vim.cmd("saveas " .. new_path)
	vim.cmd("bdelete " .. vim.fn.bufnr(current_file))
	
	vim.notify("Created Java project structure and moved file to src/", vim.log.levels.INFO)
end

-- Create Rust project structure
function M.create_rust_project()
	local filetype = vim.bo.filetype
	if filetype ~= "rust" then
		vim.notify("This command only works for Rust files", vim.log.levels.WARN)
		return
	end
	
	local current_file = expand("%:p")
	local current_dir = expand("%:p:h")
	local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
	
	if cargo_toml ~= "" then
		vim.notify("Cargo.toml already exists", vim.log.levels.INFO)
		return
	end
	
	-- Hỏi tên project
	local project_name = vim.fn.input("Enter project name: ", "my_project")
	if project_name == "" then
		vim.notify("Project creation cancelled", vim.log.levels.WARN)
		return
	end
	
	-- Tạo Cargo project
	local cmd = string.format("cd %s && cargo init --name %s", vim.fn.shellescape(current_dir), project_name)
	local result = vim.fn.system(cmd)
	
	if vim.v.shell_error == 0 then
		-- Di chuyển file hiện tại vào src/main.rs nếu cần
		local main_rs = current_dir .. "/src/main.rs"
		if vim.fn.filereadable(main_rs) == 0 then
			vim.cmd("saveas " .. main_rs)
			vim.cmd("bdelete " .. vim.fn.bufnr(current_file))
		else
			vim.cmd("edit " .. main_rs)
		end
		vim.notify("Created Cargo project: " .. project_name, vim.log.levels.INFO)
	else
		vim.notify("Failed to create Cargo project: " .. result, vim.log.levels.ERROR)
	end
end

-- Main run function
function M.run_current_file()
	vim.cmd("w")
	local filetype = vim.bo.filetype
	
	if not config.supported_languages[filetype] then
		vim.notify(
			string.format(
				"Filetype '%s' is not enabled in fast-run config.\nAdd it to setup: require('fast-run').setup({ enable = { '%s' } })",
				filetype,
				filetype
			),
			vim.log.levels.WARN
		)
		return
	end
	
	-- Handle CSS files
	if filetype == "css" then
		if M.html_server_running then
			print("CSS saved. Browser will auto-inject (no reload).")
		else
			print("No server running. Start from an HTML file first.")
		end
		return
	end
	
	-- Get run command for the current filetype
	local cmd = runner.get_run_command(filetype, expand("%:p"), expand("%:p:h"), expand("%:t:r"))
	
	if not cmd then
		vim.notify("Filetype '" .. filetype .. "' is not supported by fast-run", vim.log.levels.WARN)
		return
	end
	
	-- Handle HTML differently (development server)
	if filetype == "html" then
		handle_html_run(cmd)
	else
		handle_regular_run(cmd)
	end
end

-- Register autocmds for supported languages
function M.register()
	local group = vim.api.nvim_create_augroup("FastRunGroup", { clear = true })
	
	keymap.setup_plugin_keymaps(M, config.custom_keymaps)
	
	-- Auto-stop server when Neovim exits
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			if M.html_server_running and M.server_job_id then
				jobstop(M.server_job_id)
				kill_all_browsersync()
			end
		end,
	})
end

return M
