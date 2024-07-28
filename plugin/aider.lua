if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("Aider requires at least nvim-0.7.0.")
	return
end

-- Prevent loading the plugin multiple times
if vim.g.loaded_aider == 1 then
	return
end
vim.g.loaded_aider = 1

vim.api.nvim_create_user_command("Aider", function()
	require("aider").open_aider()
end, {})
