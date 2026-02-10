# Fast-Run

A powerful Neovim plugin for compiling and running code directly in the editor. Supports 30+ programming languages with smart project detection.

## ✨ Features

- 🚀 **30+ Languages**: C, C++, Python, Java, Rust, Go, JavaScript, TypeScript, and more
- 🎯 **Smart Detection**: Auto-detects project structures (Cargo.toml, go.mod, src/)
- 🖥️ **Cross-Platform**: Works on Windows, Linux, and macOS
- 🌐 **Live Server**: Built-in browser-sync for HTML/CSS development
- ⚡ **Fast Execution**: Compile and run with a single keypress
- 🎨 **Terminal Management**: Smart terminal reuse and navigation

## 📦 Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    "xuaantruongfw1612/fast-run",
    config = function()
        require("fast-run").setup({
            enable = { "c", "cpp", "python", "java", "rust", "go" },
        })
    end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)
```lua
use {
    "xuaantruongfw1612/fast-run",
    config = function()
        require("fast-run").setup({
            enable = { "c", "cpp", "python", "java", "rust", "go" },
        })
    end
}
```

## ⌨️ Default Keymaps

| Keymap | Action |
|--------|--------|
| `<leader>t` | Run current file |
| `<leader>ts` | Stop HTML server |
| `<leader>ti` | Show server info |
| `<leader>tj` | Create Java project |
| `<leader>tr` | Create Rust project |
| `<leader>tc` | Clear terminal |
| `<leader>tt` | Toggle terminal mode |

## 🎯 Quick Start

1. Open any supported file (e.g., `main.py`)
2. Press `<leader>t` to run
3. View output in the terminal window
4. Press `Enter` or `q` to close terminal

## 🛠️ Custom Configuration
```lua
require("fast-run").setup({
    enable = { "c", "cpp", "python", "java", "rust" },
    keymaps = {
        run_file = "<F5>",
        stop_server = "<F6>",
        -- ... customize other keymaps
    }
})
```

## 📚 Supported Languages

**Compiled**: C, C++, Rust, Go, Java, Kotlin, Swift, Zig, Nim, C#

**Scripting**: Python, JavaScript, TypeScript, Ruby, PHP, Lua, Perl, Shell

**Functional**: Haskell, Elixir, Clojure, OCaml, F#, Racket, Scala

**Data Science**: R, Julia

**Mobile**: Dart

**Web**: HTML (with live server), CSS

For detailed documentation, see [DOCUMENTATION.md](./DOCUMENTATION.md)

## 📋 Requirements

- Neovim 0.8+
- Appropriate compilers/interpreters for your languages
- `browser-sync` for HTML development (optional)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License - see [LICENSE](./LICENSE) for details

## 👤 Author

Created by [xuaantruongfw1612](https://github.com/xuaantruongfw1612)

## ⭐ Support

If you find this plugin helpful, please give it a star on GitHub!
