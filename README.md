# Fast-Run Plugin for Neovim

**fast-run** is a powerful Neovim plugin that allows you to compile and run programs directly from the editor without leaving Neovim. This plugin supports many popular programming languages such as C, C++, Python, Java, JavaScript, and more.

## Features

- **Support for multiple programming languages:** Includes C, C++, Python, Java, JavaScript (Node.js), Html, CSS ...
- **Separate terminal window:** Opens a new terminal window in Neovim to run the program without interrupting your workflow.
- **Easy-to-use shortcuts:** Use the `<leader>t` shortcut to compile and run the program in the terminal.
- **Flexible configuration:** You can easily configure the plugin to only support the languages you want.

## Installation

### Installation via Lazy.nvim (or Packer.nvim)

```lua
    return {
        "xuaantruongfw1612/fast-run",
        config = function()
            require("fast-run").setup({
                enable = { "c", "cpp", "python", "java", "javascript", "html", "css" },  -- Configure the languages you want to support
            })
        end,
    }
```

# Manual Installation

1. Clone the plugin into the `~/.config/nvim/lua/fast-run` directory.

    ```bash
    git clone https://github.com/xuaantruongfw1612/fast-run.git 
    ```

2. In your `init.lua`, call the following configuration:

    ```lua
    require("fast-run").setup({
        enable = { "c", "cpp", "python", "java", "javascript", "html", "css" },  -- Modify the list of languages if needed
    })
    ```

## Configuration

The plugin allows you to configure the languages you want to support via the `setup()` function.

### Example Configuration:

```lua
    require("fast-run").setup({
        enable = { "c", "cpp", "python", "java", "javascript", "html", "css" },  -- Languages you want to support
    })
```

You can easily add or remove languages by modifying the `enable` array.

## Keybindings

- `<leader>t`: Save the current file and run the program in a new terminal window.
- Press Enter in the terminal: Exit the terminal window after the program finishes running.

## Supported Languages

The plugin currently supports the following programming languages:

- **C**: Compile and run with `gcc`.
- **C++**: Compile and run with `g++`.
- **Python**: Run the program with `python3`.
- **Java**: Compile and run with `javac` and `java`.
- **JavaScript (Node.js)**: Run the program with `node`.
- **HTML, CSS**: `sudo npm install -g browser-sync`

## Adding New Language Support

You can easily add support for other languages by modifying the configuration in `runner.lua` and adding the necessary compile/run commands for the language you want to support.

## Contributing

If you would like to contribute to this plugin, you can create a pull request or open an issue to discuss new features.

## Note

To ensure the plugin works properly, you need to have the appropriate compilers/interpreters installed on your system:

- `gcc` for C
- `g++` for C++
- `python3` for Python
- `javac` and `java` for Java
- `node` for JavaScript
- `html` and `css`

## Usage Example

After installing the plugin, you can open any source file (e.g., a C or Python file), and use the `<leader>t` shortcut to compile and run the program directly in Neovim.
