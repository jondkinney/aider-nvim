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

    -- Use autocmd to run 'aider' command after the terminal is opened
    vim.cmd([[
        augroup AiderAutoCmd
            autocmd!
            autocmd TermOpen * ++once lua vim.api.nvim_chan_send(vim.b.terminal_job_id, "aider\n")
        augroup END
    ]])

    vim.cmd("startinsert")
end

return M
