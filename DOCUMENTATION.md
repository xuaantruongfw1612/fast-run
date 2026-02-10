# Fast-Run - Complete Documentation

**Version**: 1.0.0  
**Author**: xuaantruongfw1612  
**License**: MIT

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Installation](#installation)
4. [Configuration](#configuration)
5. [Supported Languages](#supported-languages)
6. [Usage Guide](#usage-guide)
7. [Keymaps Reference](#keymaps-reference)
8. [Advanced Features](#advanced-features)
9. [Troubleshooting](#troubleshooting)
10. [Contributing](#contributing)

---

## Introduction

**fast-run** is a comprehensive Neovim plugin designed to streamline the development workflow by allowing developers to compile and execute code directly within the editor. With support for over 30 programming languages and intelligent project detection, fast-run eliminates the need to switch between terminal and editor windows.

### Key Highlights

- **Zero Configuration**: Works out of the box with sensible defaults
- **Language Agnostic**: Supports everything from C to web development
- **Smart Detection**: Automatically detects project structures and build tools
- **Developer Friendly**: Customizable keymaps and extensive configuration options

---

## Features

### Core Features

#### 1. Multi-Language Support
- **30+ Programming Languages** including:
  - Systems programming: C, C++, Rust, Zig
  - Application development: Java, C#, Go, Swift, Kotlin
  - Scripting: Python, JavaScript, TypeScript, Ruby, PHP, Lua
  - Functional: Haskell, Elixir, Clojure, OCaml, F#, Scala
  - Scientific computing: R, Julia
  - Mobile development: Dart
  - Web development: HTML, CSS with live reload

#### 2. Smart Project Detection
- **Rust**: Detects `Cargo.toml` and uses `cargo run`
- **Go**: Detects `go.mod` and uses `go run .`
- **Java**: Detects `src/` directory and compiles all files to `bin/`
- **C#**: Detects `.csproj` files and uses `dotnet run`
- **Fallback**: Runs single files when project structure isn't found

#### 3. Terminal Management
- **Intelligent Reuse**: Reuses existing terminal windows
- **Navigation**: Full window navigation support with `<C-w>hjkl`
- **Scrolling**: Scroll through output with arrow keys and PageUp/PageDown
- **Quick Exit**: Multiple ways to close terminal (`Enter`, `q`, `Esc`)

#### 4. Web Development
- **Live Server**: Integrated browser-sync for HTML/CSS/JS
- **Auto Reload**: Changes trigger automatic browser refresh
- **CSS Injection**: CSS changes inject without page reload
- **Browser Detection**: Auto-detects and launches available browsers

#### 5. Cross-Platform Support
- **Windows**: Full support with PowerShell integration
- **Linux**: Works with both X11 and Wayland
- **macOS**: Native support with optimized commands

---

## Installation

### Prerequisites

- **Neovim** 0.8.0 or higher
- **Git** for plugin installation
- Language-specific compilers/interpreters (see [Requirements](#requirements))

### Method 1: lazy.nvim (Recommended)
```lua
{
    "xuaantruongfw1612/fast-run",
    config = function()
        require("fast-run").setup({
            enable = {
                "c", "cpp", "python", "java", "javascript", 
                "typescript", "go", "rust", "html", "css"
            },
        })
    end,
}
```

### Method 2: packer.nvim
```lua
use {
    "xuaantruongfw1612/fast-run",
    config = function()
        require("fast-run").setup({
            enable = {
                "c", "cpp", "python", "java", "javascript", 
                "typescript", "go", "rust", "html", "css"
            },
        })
    end
}
```

### Method 3: Manual Installation
```bash
# Clone the repository
cd ~/.config/nvim
mkdir -p lua
cd lua
git clone https://github.com/xuaantruongfw1612/fast-run.git

# Add to init.lua
require("fast-run").setup()
```

---

## Configuration

### Basic Configuration
```lua
require("fast-run").setup({
    -- Specify languages to enable
    enable = { "c", "cpp", "python", "java" },
})
```

### Advanced Configuration
```lua
require("fast-run").setup({
    -- Enable multiple languages
    enable = {
        -- Compiled languages
        "c", "cpp", "rust", "go", "java", "kotlin",
        
        -- Scripting languages
        "python", "javascript", "typescript", "ruby", "lua",
        
        -- Web development
        "html", "css",
        
        -- Others
        "php", "perl", "sh", "dart", "swift"
    },
    
    -- Custom keymaps (optional)
    keymaps = {
        run_file = "<F5>",              -- Change from <leader>t
        stop_server = "<F6>",           -- Change from <leader>ts
        server_info = "<leader>si",     -- Change from <leader>ti
        create_java_project = "<leader>pj",
        create_rust_project = "<leader>pr",
        clear_terminal = "<leader>cl",
        toggle_terminal = "<C-t>",
    }
})
```

### Enable All Languages
```lua
require("fast-run").setup({
    enable = {
        "c", "cpp", "python", "java", "javascript", "typescript",
        "go", "rust", "ruby", "php", "lua", "kotlin", "swift",
        "perl", "sh", "bash", "r", "scala", "dart", "haskell",
        "elixir", "clojure", "ocaml", "fsharp", "zig", "nim",
        "julia", "racket", "cs", "html", "css"
    }
})
```

### Disable Specific Keymaps
```lua
require("fast-run").setup({
    enable = { "python", "javascript" },
    keymaps = {
        run_file = "<F5>",
        create_java_project = "",  -- Disable this keymap
        create_rust_project = "",  -- Disable this keymap
    }
})
```

---

## Supported Languages

### Compiled Languages

#### C
- **Compiler**: `gcc` (Linux/Windows), `clang` (macOS)
- **Libraries**: Includes `-lm -lpthread -ldl -lrt` on Linux
- **Example**:
```c
  // hello.c
  #include <stdio.h>
  int main() {
      printf("Hello, World!\n");
      return 0;
  }
```
- **Usage**: Press `<leader>t` → Compiles and runs

#### C++
- **Compiler**: `g++`
- **Example**:
```cpp
  // hello.cpp
  #include <iostream>
  int main() {
      std::cout << "Hello, World!" << std::endl;
      return 0;
  }
```

#### Rust
- **Priority**: `Cargo.toml` → Single file
- **Project Mode**: Uses `cargo run`
- **Single File**: Uses `rustc`
- **Example**:
```rust
  // main.rs
  fn main() {
      println!("Hello, World!");
  }
```
- **Create Project**: Press `<leader>tr` to initialize Cargo project

#### Go
- **Priority**: `go.mod` → Single file
- **Project Mode**: Uses `go run .`
- **Single File**: Uses `go run filename.go`
- **Example**:
```go
  // main.go
  package main
  import "fmt"
  func main() {
      fmt.Println("Hello, World!")
  }
```

#### Java
- **Priority**: `src/` → Package file → Single file
- **Project Mode**: Compiles all `.java` files to `bin/`
- **Package Support**: Handles package declarations
- **Example**:
```java
  // Main.java
  public class Main {
      public static void main(String[] args) {
          System.out.println("Hello, World!");
      }
  }
```
- **Create Project**: Press `<leader>tj` to create `src/` and `bin/` structure

### Scripting Languages

#### Python
- **Interpreter**: `python3` (Linux/macOS), `python` (Windows)
- **Example**:
```python
  # hello.py
  def main():
      print("Hello, World!")
  
  if __name__ == "__main__":
      main()
```

#### JavaScript
- **Runtime**: `node`
- **Example**:
```javascript
  // hello.js
  console.log("Hello, World!");
```

#### TypeScript
- **Runtime**: `ts-node`
- **Installation**: `npm install -g ts-node typescript`
- **Example**:
```typescript
  // hello.ts
  const message: string = "Hello, World!";
  console.log(message);
```

#### Ruby
- **Interpreter**: `ruby`
- **Example**:
```ruby
  # hello.rb
  puts "Hello, World!"
```

#### PHP
- **Interpreter**: `php`
- **Example**:
```php
  <?php
  // hello.php
  echo "Hello, World!\n";
  ?>
```

#### Lua
- **Interpreter**: `lua`
- **Example**:
```lua
  -- hello.lua
  print("Hello, World!")
```

### Web Development

#### HTML
- **Server**: `browser-sync`
- **Features**: Live reload, CSS injection
- **Installation**: `npm install -g browser-sync`
- **Example**:
```html
  <!-- index.html -->
  <!DOCTYPE html>
  <html>
  <head>
      <title>Hello</title>
      <link rel="stylesheet" href="style.css">
  </head>
  <body>
      <h1>Hello, World!</h1>
      <script src="script.js"></script>
  </body>
  </html>
```
- **Usage**: Press `<leader>t` → Starts server at `http://localhost:3000`

#### CSS
- **Integration**: Works with HTML live server
- **Hot Reload**: Changes inject without page reload
- **Usage**: Press `<leader>t` in CSS file (requires HTML server running)

### Functional Languages

#### Haskell
- **Runner**: `runhaskell`
- **Example**:
```haskell
  -- hello.hs
  main :: IO ()
  main = putStrLn "Hello, World!"
```

#### Elixir
- **Runner**: `elixir`
- **Example**:
```elixir
  # hello.exs
  IO.puts "Hello, World!"
```

#### Scala
- **Runner**: `scala`
- **Example**:
```scala
  // hello.scala
  object Hello extends App {
      println("Hello, World!")
  }
```

### Data Science

#### R
- **Runner**: `Rscript`
- **Example**:
```r
  # hello.R
  print("Hello, World!")
```

#### Julia
- **Runner**: `julia`
- **Example**:
```julia
  # hello.jl
  println("Hello, World!")
```

### Mobile Development

#### Dart
- **Runner**: `dart`
- **Example**:
```dart
  // hello.dart
  void main() {
      print('Hello, World!');
  }
```

#### Swift
- **Runner**: `swift`
- **Example**:
```swift
  // hello.swift
  print("Hello, World!")
```

#### Kotlin
- **Compiler**: `kotlinc`
- **Example**:
```kotlin
  // hello.kt
  fun main() {
      println("Hello, World!")
  }
```

---

## Usage Guide

### Basic Workflow

1. **Open a file** in any supported language
2. **Press `<leader>t`** to execute
3. **View output** in terminal window
4. **Close terminal** with `Enter`, `q`, or `Esc`

### Working with Projects

#### Java Project
```bash
# Initial structure
myproject/
└── Main.java

# Press <leader>tj to create project structure
myproject/
├── src/
│   └── Main.java
└── bin/

# Press <leader>t to compile and run
```

#### Rust Project
```bash
# Initial file
main.rs

# Press <leader>tr to create Cargo project
# Enter project name: my_app

my_app/
├── Cargo.toml
├── src/
│   └── main.rs
└── target/

# Press <leader>t to cargo run
```

### HTML Development

1. **Create HTML file**:
```html
   <!-- index.html -->
   <!DOCTYPE html>
   <html>
   <head>
       <title>My Page</title>
       <link rel="stylesheet" href="style.css">
   </head>
   <body>
       <h1>Hello, World!</h1>
   </body>
   </html>
```

2. **Press `<leader>t`**:
   - Starts browser-sync server
   - Opens browser at `http://localhost:3000`
   - Watches for file changes

3. **Edit CSS**:
```css
   /* style.css */
   h1 {
       color: blue;
   }
```
   - Press `<leader>t` in CSS file
   - Changes inject without reload

4. **Stop server**: Press `<leader>ts`

5. **Check status**: Press `<leader>ti`

---

## Keymaps Reference

### Default Keymaps

| Keymap | Mode | Action | Description |
|--------|------|--------|-------------|
| `<leader>t` | Normal | Run file | Execute current file |
| `<leader>ts` | Normal | Stop server | Stop HTML development server |
| `<leader>ti` | Normal | Server info | Show server status |
| `<leader>tj` | Normal | Java project | Create Java project structure |
| `<leader>tr` | Normal | Rust project | Create Rust Cargo project |
| `<leader>tc` | Normal | Clear terminal | Clear terminal scrollback |
| `<leader>tt` | Normal | Toggle mode | Toggle terminal insert/normal mode |

### Terminal Window Keymaps

| Keymap | Mode | Action |
|--------|------|--------|
| `Enter` | Normal | Close terminal |
| `q` | Normal | Close terminal |
| `Esc` | Normal | Close terminal |
| `Esc` | Terminal | Exit to normal mode |
| `<C-w>h/j/k/l` | Terminal | Navigate windows |
| `<Up>/<Down>` | Terminal | Scroll output |
| `<PageUp>/<PageDown>` | Terminal | Fast scroll |
| `<C-v>` | Terminal | Paste from clipboard |
| `<C-q>` | Terminal | Quick close |

### Customizing Keymaps
```lua
require("fast-run").setup({
    keymaps = {
        -- F5 to run (like VS Code)
        run_file = "<F5>",
        
        -- F6 to stop server
        stop_server = "<F6>",
        
        -- Custom project creation shortcuts
        create_java_project = "<leader>pj",
        create_rust_project = "<leader>pr",
        
        -- Clear terminal with Ctrl+L
        clear_terminal = "<C-l>",
        
        -- Disable a keymap by setting to empty string
        toggle_terminal = "",
    }
})
```

---

## Advanced Features

### 1. Terminal Management

#### Reusing Terminal Windows

fast-run automatically reuses existing terminal windows instead of creating new ones:
```lua
-- First run: Creates new terminal window
-- Press <leader>t in main.py
-- Terminal opens and shows output

-- Second run: Reuses existing terminal
-- Press <leader>t in another file
-- Same terminal window shows new output
```

#### Terminal Navigation

Navigate between editor and terminal seamlessly:
```
<C-w>h  -- Move to left window
<C-w>j  -- Move to below window
<C-w>k  -- Move to above window
<C-w>l  -- Move to right window
```

#### Scrolling Output

View long outputs easily:
```
<Up>/<Down>      -- Scroll one line
<PageUp>/<PageDown>  -- Scroll one page
gg               -- Go to top
G                -- Go to bottom
```

### 2. Project Detection

#### Java Project Detection
```bash
# Without src/ directory
project/
└── Main.java

# Press <leader>t
# Warning: "File có package nhưng không nằm trong src/"
# Runs with temporary bin/ directory

# Press <leader>tj to create proper structure
project/
├── src/
│   └── Main.java
└── bin/

# Press <leader>t again
# Compiles all .java files in src/ to bin/
```

#### Rust Project Detection
```bash
# Single file mode
hello.rs

# Press <leader>t
# Uses: rustc hello.rs -o hello && ./hello

# Press <leader>tr to create Cargo project
# Enter name: hello_world

hello_world/
├── Cargo.toml
├── src/
│   └── main.rs
└── target/

# Press <leader>t again
# Uses: cargo run
```

### 3. HTML Live Server

#### Features

- **Live Reload**: Auto-refresh on HTML/JS changes
- **CSS Injection**: Inject CSS without reload
- **Multi-file Watch**: Watches `**/*.{html,css,js}`
- **Directory Awareness**: Switches context when changing directories

#### Usage Patterns

**Single Page Development**:
```bash
project/
├── index.html
├── style.css
└── script.js

# Press <leader>t in index.html
# Server starts, browser opens
# Edit any file and save
# Browser auto-updates
```

**Multi-page Development**:
```bash
project/
├── index.html
├── about.html
└── css/
    └── style.css

# Press <leader>t in index.html
# Server starts at index.html

# Switch to about.html
# Press <leader>t
# Browser navigates to about.html
```

**Stopping Server**:
```bash
# Press <leader>ts
# Output: "Browser-sync server stopped"

# Or press <leader>ti to check status
# Output: "Server running at http://localhost:3000 (Dir: /path/to/project)"
```

### 4. Cross-Platform Differences

#### Windows Specifics
```lua
-- Uses PowerShell for advanced operations
-- Python command: python (not python3)
-- Browser launching: start command
-- Process killing: taskkill
```

#### Linux Specifics
```lua
-- Supports both X11 and Wayland
-- Chrome flags for Wayland: --ozone-platform=wayland
-- Process killing: pkill
-- Python command: python3
```

#### macOS Specifics
```lua
-- Uses clang instead of gcc for C
-- Browser launching: open command
-- Native command line tools
```

---

## Troubleshooting

### Common Issues

#### 1. "Command not found" Error

**Problem**: Compiler/interpreter not installed

**Solution**:
```bash
# Check if tool is installed
which gcc      # For C
which python3  # For Python
which node     # For JavaScript

# Install missing tools
# Ubuntu/Debian
sudo apt install gcc g++ python3 nodejs

# macOS
brew install gcc python node

# Windows
# Download from official websites or use chocolatey
choco install gcc python nodejs
```

#### 2. Java Compilation Errors

**Problem**: Package structure issues

**Solution**:
```bash
# Ensure proper structure
project/
├── src/
│   └── com/
│       └── example/
│           └── Main.java
└── bin/

# Press <leader>tj to auto-create structure
# Or manually create directories
```

#### 3. HTML Server Not Starting

**Problem**: browser-sync not installed

**Solution**:
```bash
# Install browser-sync globally
npm install -g browser-sync

# Verify installation
browser-sync --version

# If npm not found
# Install Node.js from https://nodejs.org
```

#### 4. Browser Not Opening

**Problem**: No supported browser found

**Solution**:
```bash
# Install a supported browser
# Linux
sudo apt install firefox
# or
sudo apt install chromium-browser

# macOS
brew install --cask firefox

# Verify browser
which firefox
```

#### 5. TypeScript "ts-node not found"

**Problem**: ts-node not installed

**Solution**:
```bash
# Install ts-node globally
npm install -g ts-node typescript

# Verify installation
ts-node --version
```

#### 6. Terminal Window Doesn't Close

**Problem**: Process still running

**Solution**:
```bash
# In terminal, press:
<C-c>     # Stop process
<Enter>   # Then close window

# Or force close
<C-q>     # Quick close
```

#### 7. Rust Cargo Commands Fail

**Problem**: Cargo not in PATH

**Solution**:
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH="$HOME/.cargo/bin:$PATH"

# Reload shell
source ~/.bashrc

# Verify
cargo --version
```

### Debug Mode

Enable verbose output for troubleshooting:
```lua
-- In your Neovim config
vim.g.fast_run_debug = true

-- Then check messages
:messages
```

---

## Requirements

### Core Requirements

- **Neovim**: 0.8.0 or higher
- **Git**: For plugin installation

### Language-Specific Requirements

#### Compiled Languages

| Language | Requirement | Installation |
|----------|-------------|--------------|
| C | `gcc` or `clang` | `apt install gcc` / `brew install gcc` |
| C++ | `g++` | `apt install g++` / `brew install gcc` |
| Rust | `rustc`, `cargo` | [rustup.rs](https://rustup.rs) |
| Go | `go` | [golang.org](https://golang.org/dl/) |
| Java | `javac`, `java` | `apt install default-jdk` |
| Kotlin | `kotlinc` | [kotlinlang.org](https://kotlinlang.org) |
| Swift | `swift` | macOS: Xcode / Linux: [swift.org](https://swift.org) |
| C# | `dotnet` | [dotnet.microsoft.com](https://dotnet.microsoft.com) |
| Zig | `zig` | [ziglang.org](https://ziglang.org) |
| Nim | `nim` | [nim-lang.org](https://nim-lang.org) |

#### Scripting Languages

| Language | Requirement | Installation |
|----------|-------------|--------------|
| Python | `python3` | `apt install python3` / `brew install python` |
| JavaScript | `node` | [nodejs.org](https://nodejs.org) |
| TypeScript | `ts-node` | `npm install -g ts-node typescript` |
| Ruby | `ruby` | `apt install ruby` / `brew install ruby` |
| PHP | `php` | `apt install php` / `brew install php` |
| Lua | `lua` | `apt install lua5.4` / `brew install lua` |
| Perl | `perl` | Usually pre-installed |
| Shell | `bash` | Usually pre-installed |

#### Functional Languages

| Language | Requirement | Installation |
|----------|-------------|--------------|
| Haskell | `ghc`, `runhaskell` | `apt install haskell-platform` |
| Elixir | `elixir` | [elixir-lang.org](https://elixir-lang.org) |
| Scala | `scala` | [scala-lang.org](https://scala-lang.org) |
| Clojure | `clojure` | [clojure.org](https://clojure.org) |
| OCaml | `ocaml` | [ocaml.org](https://ocaml.org) |
| F# | `dotnet` | [dotnet.microsoft.com](https://dotnet.microsoft.com) |
| Racket | `racket` | [racket-lang.org](https://racket-lang.org) |

#### Data Science

| Language | Requirement | Installation |
|----------|-------------|--------------|
| R | `Rscript` | [r-project.org](https://www.r-project.org) |
| Julia | `julia` | [julialang.org](https://julialang.org) |

#### Mobile Development

| Language | Requirement | Installation |
|----------|-------------|--------------|
| Dart | `dart` | [dart.dev](https://dart.dev) |

#### Web Development

| Tool | Requirement | Installation |
|------|-------------|--------------|
| Live Server | `browser-sync` | `npm install -g browser-sync` |
| Browsers | Chrome/Firefox/Edge | System package manager |

---

## Contributing

We welcome contributions! Here's how you can help:

### Reporting Bugs

1. Check if the issue already exists
2. Include Neovim version: `:version`
3. Include fast-run config
4. Provide minimal reproduction steps
5. Include error messages

### Suggesting Features

1. Describe the feature clearly
2. Explain the use case
3. Provide examples if possible

### Pull Requests

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit PR with description

### Adding Language Support

To add a new language:

1. Edit `lua/fast-run/runner.lua`
2. Add a new `elseif` block:
```lua
-- Your Language
elseif filetype == "yourlang" then
    return string.format('term your-compiler "%s"', fullpath)
```

3. Update `lua/fast-run/config.lua` default languages
4. Test on multiple platforms
5. Update documentation

### Code Style

- Use 4 spaces for indentation
- Follow existing code patterns
- Comment complex logic
- Keep functions focused and small

---

## FAQ

### Q: Can I use custom compiler flags?

A: Currently, compiler flags are hardcoded. To customize, edit `runner.lua` for your language.

### Q: How do I change the terminal window size?

A: Edit `ui.lua`, find `vertical resize 50` and change the number.

### Q: Can I use this with tmux/screen?

A: Yes, but terminal keymaps may need adjustment.

### Q: Does it support remote development?

A: Yes, if your remote environment has the required tools.

### Q: Can I run with command-line arguments?

A: Not directly. Use a wrapper script or modify `runner.lua`.

### Q: How do I debug my programs?

A: fast-run is for quick execution. Use DAP plugins for debugging.

### Q: Can I customize the HTML server port?

A: Currently fixed to 3000. Future versions may add customization.

### Q: Does it support multi-file projects?

A: Yes for Java, Rust, Go, C#. Others run current file.

---

## Changelog

### Version 1.0.0 (2024)

- Initial release
- Support for 30+ programming languages
- Smart project detection
- HTML live server
- Cross-platform support
- Customizable keymaps
- Terminal management

---

## License

MIT License

Copyright (c) 2024 xuaantruongfw1612

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

## Acknowledgments

- Thanks to the Neovim community
- Inspired by various code runner plugins
- Built with ❤️ for developers

---

## Support

- **Issues**: [GitHub Issues](https://github.com/xuaantruongfw1612/fast-run/issues)
- **Discussions**: [GitHub Discussions](https://github.com/xuaantruongfw1612/fast-run/discussions)
- **Star**: If you find this useful, please star the repo!

---

**Made with ❤️ by [xuaantruongfw1612](https://github.com/xuaantruongfw1612)**
