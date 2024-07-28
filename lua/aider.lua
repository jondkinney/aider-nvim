local M = {}

-- Default configuration
M.config = {
	window_type = "vsplit", -- Can be "vsplit", "hsplit", or "float"
	float_config = {
		width = 0.8,
		height = 0.8,
	},
	debug = true, -- Enable debug option
}

-- Store the current list of file names
local current_file_names = {}

-- Store the Aider terminal buffer number
local aider_bufnr = nil

-- Flag to check if Aider has been initialized
local aider_initialized = false

-- Debug print function
local function debug_print(msg)
	if M.config.debug then
		print("Aider Debug: " .. msg)
	end
end

-- Function to calculate floating window size and position
local function get_float_config()
	local width = math.floor(vim.o.columns * M.config.float_config.width)
	local height = math.floor(vim.o.lines * M.config.float_config.height)
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	return {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}
end

-- Function to get list of open buffer file names
local function get_buffer_file_names()
	local file_names = {}
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			local name = vim.api.nvim_buf_get_name(bufnr)
			if name ~= "" and vim.fn.filereadable(name) == 1 and not name:match("^term://") then
				local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
				if buftype == "" then -- Only include normal buffers
					local relative_path = vim.fn.fnamemodify(name, ":.")
					table.insert(file_names, relative_path)
				end
			end
		end
	end
	return file_names
end

-- Function to send a command to the terminal buffer
local function send_command_to_terminal(command)
	if aider_bufnr and vim.api.nvim_buf_is_valid(aider_bufnr) then
		local chan_id = vim.api.nvim_buf_get_var(aider_bufnr, "terminal_job_id")
		if chan_id then
			vim.api.nvim_chan_send(chan_id, command .. "\n")
			debug_print("Sent command: " .. command)
		else
			debug_print("No channel ID found for Aider buffer")
		end
	else
		debug_print("Aider buffer not found or invalid")
	end
end

-- Function to update Aider with the current file list
local function update_aider()
	if not aider_initialized then
		debug_print("Aider not initialized, skipping update")
		return
	end

	local new_file_names = get_buffer_file_names()
	local add_files = {}
	local drop_files = {}

	-- Find files to add
	for _, file in ipairs(new_file_names) do
		if not vim.tbl_contains(current_file_names, file) then
			table.insert(add_files, file)
		end
	end

	-- Find files to drop
	for _, file in ipairs(current_file_names) do
		if not vim.tbl_contains(new_file_names, file) then
			table.insert(drop_files, file)
		end
	end

	-- Update current file names
	current_file_names = new_file_names

	-- Send commands to terminal only if there are changes and after a short delay
	if #add_files > 0 or #drop_files > 0 then
		vim.defer_fn(function()
			if #add_files > 0 then
				send_command_to_terminal("/add " .. table.concat(add_files, " "))
			end
			if #drop_files > 0 then
				send_command_to_terminal("/drop " .. table.concat(drop_files, " "))
			end
		end, 1000) -- 1 second delay
	end
end

-- Function to open Aider
function M.open_aider()
	local window_type = M.config.window_type

	if window_type == "vsplit" then
		vim.cmd("vsplit")
	elseif window_type == "hsplit" then
		vim.cmd("split")
	elseif window_type == "float" then
		local buf = vim.api.nvim_create_buf(false, true)
		local float_config = get_float_config()
		vim.api.nvim_open_win(buf, true, float_config)
	else
		print("Invalid window type. Using default (vsplit).")
		vim.cmd("vsplit")
	end

	vim.cmd("terminal")

	-- Get the buffer number of the newly created terminal
	aider_bufnr = vim.api.nvim_get_current_buf()

	-- Function to send the initial list of file names to Aider
	local function send_initial_aider_command()
		local chan_id = vim.b.terminal_job_id
		if chan_id then
			current_file_names = get_buffer_file_names() -- Update current_file_names
			local command = "aider " .. table.concat(current_file_names, " ") .. "\n"
			vim.api.nvim_chan_send(chan_id, command)
			debug_print("Initial Aider command sent")
			aider_initialized = true
			return true
		end
		debug_print("Failed to send initial Aider command")
		return false
	end

	-- Set up a timer to check if the terminal is ready
	local timer = vim.loop.new_timer()
	local start_time = vim.loop.now()
	local timeout = 5000 -- 5 seconds timeout

	timer:start(
		0,
		100,
		vim.schedule_wrap(function()
			if not aider_initialized and send_initial_aider_command() then
				timer:stop()
			elseif vim.loop.now() - start_time > timeout then
				print("Timeout: Unable to start aider. Please try again.")
				timer:stop()
			end
		end)
	)

	vim.cmd("startinsert")
end

-- Set up autocommands for dynamic file list updates
local function setup_autocommands()
	local group = vim.api.nvim_create_augroup("AiderFileUpdates", { clear = true })
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
		group = group,
		pattern = "*",
		callback = function(ev)
			if aider_bufnr and vim.api.nvim_buf_is_valid(aider_bufnr) then
				debug_print("Autocommand triggered for event: " .. ev.event .. " with buffer: " .. ev.buf)
				if vim.bo[ev.buf].buftype == "" and vim.fn.filereadable(ev.file) == 1 then -- Only for normal buffers with files
					debug_print("BufNewFile/BufRead/BufEnter triggered for " .. ev.file)
					update_aider()
				end
			end
		end,
	})
	vim.api.nvim_create_autocmd({ "BufDelete" }, {
		group = group,
		pattern = "*",
		callback = function(ev)
			if aider_bufnr and vim.api.nvim_buf_is_valid(aider_bufnr) then
				debug_print("Autocommand triggered for event: " .. ev.event .. " with buffer: " .. ev.buf)
				if vim.bo[ev.buf].buftype == "" and vim.fn.filereadable(ev.file) == 1 then -- Only for normal buffers with files
					debug_print("BufDelete triggered for " .. ev.file)
					update_aider()
				end
			end
		end,
	})
end

-- Function to setup the plugin
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	setup_autocommands()
end

return M
