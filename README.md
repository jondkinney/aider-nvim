# Aider.nvim

Aider.nvim is a Neovim plugin that integrates the Aider AI assistant into your Neovim environment.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
if true then return {} end
return {
  "jondkinney/aider-nvim",
  lazy = false,
  config = function()
    require("aider").setup(
      -- your config here
    )
  end,

  opts = {
    auto_manage_context = false,
    default_bindings = false,
  },

  keys = function()
    return {
      {
        "<leader>A",
        desc = "Aider AI Actions",
      },
      {
        "<leader>Ao",
        "<cmd>lua AiderOpen()<cr>i",
        desc = "Aider Open",
      },
      {
        "<leader>Ab",
        "<cmd>lua AiderBackground()<cr>",
        desc = "Aider Background",
      },
    }
  end,
}
```

## Configuration

You can customize the Aider.nvim plugin by modifying the setup function in your Neovim configuration. Here's an example of how you might configure it:

```lua
require("aider").setup({
  -- Your custom configuration options here
})
```

For more detailed configuration options, please refer to the documentation.

## Usage

After installation and configuration, you can use the following default keybindings:

- `<leader>A`: Aider AI Actions
- `<leader>Ao`: Open Aider
- `<leader>Ab`: Run Aider in the background

You can customize these keybindings in your configuration.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License.
