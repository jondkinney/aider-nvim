require("aider").setup({
    -- Optionally override default settings
    window_type = "vsplit", -- Can be "vsplit", "hsplit", or "float"
    float_config = {
        width = 0.8,
        height = 0.8,
        border = "rounded", -- Add border style
    },
    debug = true, -- Enable debug messages
    keymaps = {
        toggle = "<leader>at", -- Toggle aider window
        send = "<leader>as", -- Send text to aider
    },
    highlight = {
        enable = true, -- Enable syntax highlighting in aider window
        group = "Comment", -- Use Comment highlight group
    },
    auto_open = false, -- Don't open aider window automatically on startup
})
