local M = {}

local config = require("fast-run.config")
local keymap = require("fast-run.keymap")
local runner = require("fast-run.runner")

M.html_server_running = false
M.server_job_id = nil

local jobstart = vim.fn.jobstart
local jobstop = vim.fn.jobstop
local expand = vim.fn.expand

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
			if not M.html_server_running then
				M.server_job_id = jobstart(cmd, {
					detach = true,
					on_exit = function()
						M.html_server_running = false
						M.server_job_id = nil
					end,
				})
				M.html_server_running = true
				print("Browser-sync started at http://localhost:3000")
			else
				print("Server running. File saved, browser will auto-reload.")
			end
		else
			vim.cmd("vertical rightbelow vsplit | vertical resize 50 | " .. cmd .. " | startinsert")
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

