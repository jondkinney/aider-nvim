require("aider").setup({
    -- Window settings
    window = {
        type = "vsplit", -- Can be "vsplit", "hsplit", or "float"
        float = {
            width = 0.8,
            height = 0.8,
            border = "rounded",
        },
        auto_open = false, -- Don't open aider window automatically on startup
    },

    -- Keymaps
    keymaps = {
        toggle = "<leader>at", -- Toggle aider window
        send = "<leader>as", -- Send text to aider
        scroll_up = "<C-u>", -- Scroll up in aider window
        scroll_down = "<C-d>", -- Scroll down in aider window
    },

    -- Appearance
    highlight = {
        enable = true, -- Enable syntax highlighting in aider window
        group = "Comment", -- Use Comment highlight group
    },

    -- Behavior
    auto_focus = true, -- Automatically focus aider window when opened
    preserve_cursor = true, -- Preserve cursor position when toggling window

    -- Debugging
    debug = true, -- Enable debug messages
})
