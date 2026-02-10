local M = {}

-- Set keymaps for terminal buffer
function M.set_terminal_keymaps()
	local opts = { noremap = true, silent = true }
	
	-- Normal mode keymaps
	vim.api.nvim_buf_set_keymap(0, "n", "<CR>", ":q<CR>", opts)
	vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", opts)
	vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":q<CR>", opts)
	
	-- Terminal mode navigation
	vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", "<C-\\><C-n>", opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>h", "<C-\\><C-n><C-w>h", opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>j", "<C-\\><C-n><C-w>j", opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>k", "<C-\\><C-n><C-w>k", opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<C-w>l", "<C-\\><C-n><C-w>l", opts)
	
	-- Terminal mode scrolling
	vim.api.nvim_buf_set_keymap(0, "t", "<Up>", "<C-\\><C-n><Up>", opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<Down>", "<C-\\><C-n><Down>", opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<PageUp>", "<C-\\><C-n><PageUp>", opts)
	vim.api.nvim_buf_set_keymap(0, "t", "<PageDown>", "<C-\\><C-n><PageDown>", opts)
	
	-- Terminal mode copy/paste
	vim.api.nvim_buf_set_keymap(0, "t", "<C-v>", '<C-\\><C-n>"+pi', opts)
	
	-- Quick exit from terminal mode
	vim.api.nvim_buf_set_keymap(0, "t", "<C-q>", "<C-\\><C-n>:q<CR>", opts)
end

-- Set custom keymaps with user preferences
function M.set_terminal_keymaps_custom(user_keymaps)
	M.set_terminal_keymaps()
	
	if user_keymaps and type(user_keymaps) == "table" then
		local opts = { noremap = true, silent = true }
		for mode, mappings in pairs(user_keymaps) do
			for lhs, rhs in pairs(mappings) do
				vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
			end
		end
	end
end

-- Clear terminal scrollback
function M.clear_terminal()
	vim.cmd("startinsert")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n", false)
end

-- Toggle terminal between insert and normal mode
function M.toggle_terminal_mode()
	local mode = vim.api.nvim_get_mode().mode
	if mode == "t" then
		vim.cmd("stopinsert")
	else
		vim.cmd("startinsert")
	end
end

-- ============================================================================
-- MAIN PLUGIN KEYMAPS
-- ============================================================================

-- Get default keymap configuration
function M.get_default_keymaps()
	return {
		run_file = "<leader>t",           -- Execute current file
		stop_server = "<leader>ts",       -- Stop HTML server
		server_info = "<leader>ti",       -- Show server info
		create_java_project = "<leader>tj", -- Create Java project
		create_rust_project = "<leader>tr", -- Create Rust project
		clear_terminal = "<leader>tc",    -- Clear terminal
		toggle_terminal = "<leader>tt",   -- Toggle terminal mode
	}
end

-- Setup all plugin keymaps
function M.setup_plugin_keymaps(ui_module, custom_keys)
	local opts_base = { noremap = true, silent = true }
	
	-- Get keymaps (custom or default)
	local keymaps = custom_keys or M.get_default_keymaps()
	
	-- <leader>t - Run current file
	if keymaps.run_file and keymaps.run_file ~= "" then
		vim.keymap.set("n", keymaps.run_file, function()
			ui_module.run_current_file()
		end, vim.tbl_extend("force", opts_base, { desc = "Fast Run: Execute current file" }))
	end
	
	-- <leader>ts - Stop HTML server
	if keymaps.stop_server and keymaps.stop_server ~= "" then
		vim.keymap.set("n", keymaps.stop_server, function()
			ui_module.stop_server()
		end, vim.tbl_extend("force", opts_base, { desc = "Fast Run: Stop HTML server" }))
	end
	
	-- <leader>ti - Server info
	if keymaps.server_info and keymaps.server_info ~= "" then
		vim.keymap.set("n", keymaps.server_info, function()
			ui_module.show_server_info()
		end, vim.tbl_extend("force", opts_base, { desc = "Fast Run: Server info" }))
	end
	
	-- <leader>tj - Create Java project structure
	if keymaps.create_java_project and keymaps.create_java_project ~= "" then
		vim.keymap.set("n", keymaps.create_java_project, function()
			ui_module.create_java_project()
		end, vim.tbl_extend("force", opts_base, { desc = "Fast Run: Create Java project" }))
	end
	
	-- <leader>tr - Create Rust project structure
	if keymaps.create_rust_project and keymaps.create_rust_project ~= "" then
		vim.keymap.set("n", keymaps.create_rust_project, function()
			ui_module.create_rust_project()
		end, vim.tbl_extend("force", opts_base, { desc = "Fast Run: Create Rust project" }))
	end
	
	-- <leader>tc - Clear terminal
	if keymaps.clear_terminal and keymaps.clear_terminal ~= "" then
		vim.keymap.set("n", keymaps.clear_terminal, function()
			M.clear_terminal()
		end, vim.tbl_extend("force", opts_base, { desc = "Fast Run: Clear terminal" }))
	end
	
	-- <leader>tt - Toggle terminal mode
	if keymaps.toggle_terminal and keymaps.toggle_terminal ~= "" then
		vim.keymap.set("n", keymaps.toggle_terminal, function()
			M.toggle_terminal_mode()
		end, vim.tbl_extend("force", opts_base, { desc = "Fast Run: Toggle terminal mode" }))
	end
end

return M
