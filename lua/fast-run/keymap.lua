local M = {}

function M.set_terminal_keymaps()
	vim.api.nvim_buf_set_keymap(0, "n", "<CR>", ":q<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, "t", "<Up>", "<C-\\><C-n><Up>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, "t", "<Down>", "<C-\\><C-n><Down>", { noremap = true, silent = true })
end

return M

