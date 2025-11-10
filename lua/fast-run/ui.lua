local M = {}

local config = require("fast-run.config")
local keymap = require("fast-run.keymap")
local runner = require("fast-run.runner")

M.html_server_running = false
M.server_job_id = nil
M.current_html_dir = nil

local jobstart = vim.fn.jobstart
local jobstop = vim.fn.jobstop
local expand = vim.fn.expand

local function kill_all_browsersync()
	vim.fn.system("pkill -f 'browser-sync'")
	vim.fn.system("pkill -f 'node.*browser-sync'")
	vim.loop.sleep(300)
end

function M.setup_keymap()
	vim.keymap.set("n", "<leader>t", function()
		vim.cmd("w")

		local filetype = vim.bo.filetype
		
		if filetype == "css" then
			print(M.html_server_running 
				and "CSS saved. Browser will auto-inject (no reload)." 
				or "No server running. Start from an HTML file first.")
			return
		end

		local cmd = runner.get_run_command(filetype, expand("%:p"), expand("%:p:h"), expand("%:t:r"))

		if not cmd then
			print("No support file =))")
			return
		end

		if filetype == "html" then
			local current_dir = expand("%:p:h")
			
			if M.html_server_running and M.server_job_id then
				if M.current_html_dir ~= current_dir then
					print("Switching directory... killing all browser-sync processes")
					
					jobstop(M.server_job_id)
					kill_all_browsersync()
					
					M.html_server_running = false
					M.server_job_id = nil
					
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
						print("Browser-sync restarted at http://localhost:3000")
					end, 1000)
				else
					print("Server running. File saved, browser will auto-reload.")
				end
			else
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
		else
			vim.cmd("vertical rightbelow vsplit | vertical resize 50")
			vim.cmd(cmd)
			vim.cmd("startinsert")
			keymap.set_terminal_keymaps()
		end
	end, { noremap = true, silent = true })
end

function M.register()
	local group = vim.api.nvim_create_augroup("FastRunGroup", { clear = true })

	for lang in pairs(config.supported_languages) do
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = lang,
			callback = M.setup_keymap,
		})
	end
end

return M

