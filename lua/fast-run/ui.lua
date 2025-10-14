local M = {}

local config = require("fast-run.config")
local keymap = require("fast-run.keymap")
local runner = require("fast-run.runner")

M.html_server_running = false

function M.setup_keymap()
	vim.keymap.set("n", "<leader>t", function()
		vim.cmd("w")

		local filetype = vim.bo.filetype
		local fullpath = vim.fn.expand("%:p")
		local dir = vim.fn.expand("%:p:h")
		local filename_noext = vim.fn.expand("%:t:r")

		local cmd = runner.get_run_command(filetype, fullpath, dir, filename_noext)

		if not cmd then
			print("No support file =))")
			return
		end

		-- Xử lý đặc biệt cho HTML - chạy nền không mở terminal
		if filetype == "html" then
			if not M.html_server_running then
				-- Chạy live-server ở background
				vim.fn.jobstart(cmd, {
					detach = true,
					on_exit = function()
						M.html_server_running = false
					end,
				})
				M.html_server_running = true
				print("Live server started at http://localhost:8080")
			else
				print("Live server running. File saved, browser will auto-reload.")
			end
		else
			-- Các ngôn ngữ khác 
			vim.cmd("vertical rightbelow vsplit")
			vim.cmd("vertical resize 50")
			vim.cmd(cmd)
			vim.cmd("startinsert")
			keymap.set_terminal_keymaps()
		end
	end, { noremap = true, silent = true, buffer = true })
end

function M.register()
	vim.api.nvim_create_augroup("FastRunGroup", { clear = true })

	for lang, _ in pairs(config.supported_languages) do
		vim.api.nvim_create_autocmd("FileType", {
			group = "FastRunGroup",
			pattern = lang,
			callback = function()
				M.setup_keymap()
			end,
		})
	end
end

return M

