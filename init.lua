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
        position = "right", -- Position of the window when using vsplit or hsplit
    },

    -- Keymaps
    keymaps = {
        toggle = "<leader>at", -- Toggle aider window
        send = "<leader>as", -- Send text to aider
        scroll_up = "<C-u>", -- Scroll up in aider window
        scroll_down = "<C-d>", -- Scroll down in aider window
        close = "<leader>aq", -- Close aider window
    },

    -- Appearance
    highlight = {
        enable = true, -- Enable syntax highlighting in aider window
        group = "Comment", -- Use Comment highlight group
    },
    theme = {
        background = "dark", -- or "light"
        transparency = 0.9, -- Value between 0 and 1
    },

    -- Behavior
    auto_focus = true, -- Automatically focus aider window when opened
    preserve_cursor = true, -- Preserve cursor position when toggling window
    auto_save = true, -- Automatically save changes made by aider

    -- Debugging
    debug = true, -- Enable debug messages
    log_file = vim.fn.stdpath("cache") .. "/aider.log", -- Path to log file

    -- Integration
    lsp = {
        enable = true, -- Enable LSP integration
        auto_attach = true, -- Automatically attach to LSP servers
    },
})
