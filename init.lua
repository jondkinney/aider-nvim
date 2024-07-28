require("aider").setup({
    -- Window settings
    window = {
        type = "vsplit", -- Can be "vsplit", "hsplit", or "float"
        float = {
            width = 0.8,
            height = 0.8,
            border = "rounded",
        },
        split = {
            width = 0.4, -- Width of the window when using vsplit (40% of screen width)
            height = 0.4, -- Height of the window when using hsplit (40% of screen height)
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
        refresh = "<leader>ar", -- Refresh aider window
    },

    -- Appearance
    highlight = {
        enable = true, -- Enable syntax highlighting in aider window
        group = "Comment", -- Use Comment highlight group
        custom_color = "#7C3AED", -- Custom highlight color (violet)
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

    -- AI Model Configuration
    ai_model = {
        name = "gpt-3.5-turbo", -- Default model to use
        temperature = 0.7, -- Controls randomness (0.0 to 1.0)
        max_tokens = 1000, -- Maximum number of tokens per response
        prompt_prefix = "AI: ", -- Prefix for AI responses in the chat window
    },

    -- Aider Command Configuration
    aider_command = {
        path = "aider", -- Path to the aider executable
        args = {}, -- Additional command-line arguments for aider
    },

    -- API Configuration
    api = {
        endpoint = nil, -- Custom API endpoint (nil for default)
    },

    -- Output Formatting
    output = {
        use_markdown = true, -- Use markdown formatting in output
        code_block_lang = "lua", -- Default language for code blocks
        max_lines = 1000, -- Maximum number of lines to display in output
    },
})
