local M = {}

-- Default configuration
M.config = {
    window_type = "vsplit",  -- Can be "vsplit", "hsplit", or "float"
    float_config = {
        width = 0.8,
        height = 0.8,
    }
}

-- Function to setup the plugin
function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
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
                local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
                if buftype == '' then  -- Only include normal buffers
                    local relative_path = vim.fn.fnamemodify(name, ":.")
                    table.insert(file_names, relative_path)
                end
            end
        end
    end
    return file_names
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
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Function to send the "aider" command with file names
    local function send_aider_command()
        local chan_id = vim.b.terminal_job_id
        if chan_id then
            local file_names = get_buffer_file_names()
            local command = "aider " .. table.concat(file_names, " ") .. "\n"
            vim.api.nvim_chan_send(chan_id, command)
            return true
        end
        return false
    end

    -- Set up a timer to check if the terminal is ready
    local timer = vim.loop.new_timer()
    local start_time = vim.loop.now()
    local timeout = 5000 -- 5 seconds timeout

    timer:start(0, 100, vim.schedule_wrap(function()
        if send_aider_command() then
            timer:stop()
        elseif vim.loop.now() - start_time > timeout then
            print("Timeout: Unable to start aider. Please try again.")
            timer:stop()
        end
    end))

    vim.cmd("startinsert")
end

return M
