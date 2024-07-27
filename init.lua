require("aider").setup({
    -- Optionally override default settings
    window_type = "vsplit",  -- Can be "vsplit", "hsplit", or "float"
    float_config = {
        width = 0.8,
        height = 0.8,
    }
})

-- Optional: Add a keymap to open Aider
vim.api.nvim_set_keymap('n', '<leader>a', ':Aider<CR>', { noremap = true, silent = true })
