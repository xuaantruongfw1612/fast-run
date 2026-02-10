# Fast-Run - Tài Liệu Đầy Đủ

**Phiên bản**: 1.0.0  
**Tác giả**: xuaantruongfw1612  
**Giấy phép**: MIT

## Mục Lục

1. [Giới Thiệu](#giới-thiệu)
2. [Tính Năng](#tính-năng)
3. [Cài Đặt](#cài-đặt)
4. [Cấu Hình](#cấu-hình)
5. [Ngôn Ngữ Hỗ Trợ](#ngôn-ngữ-hỗ-trợ)
6. [Hướng Dẫn Sử Dụng](#hướng-dẫn-sử-dụng)
7. [Tham Chiếu Phím Tắt](#tham-chiếu-phím-tắt)
8. [Tính Năng Nâng Cao](#tính-năng-nâng-cao)
9. [Khắc Phục Sự Cố](#khắc-phục-sự-cố)
10. [Đóng Góp](#đóng-góp)

---

## Giới Thiệu

**fast-run** là một plugin Neovim toàn diện được thiết kế để tối ưu hóa quy trình phát triển bằng cách cho phép lập trình viên biên dịch và thực thi code trực tiếp trong editor. Với hỗ trợ hơn 30 ngôn ngữ lập trình và khả năng phát hiện project thông minh, fast-run loại bỏ nhu cầu chuyển đổi giữa terminal và editor.

### Điểm Nổi Bật

- **Không Cần Cấu Hình**: Hoạt động ngay lập tức với cài đặt mặc định hợp lý
- **Đa Ngôn Ngữ**: Hỗ trợ mọi thứ từ C đến phát triển web
- **Phát Hiện Thông Minh**: Tự động phát hiện cấu trúc project và build tools
- **Thân Thiện Với Developer**: Phím tắt tùy chỉnh và tùy chọn cấu hình mở rộng

---

## Tính Năng

### Tính Năng Cốt Lõi

#### 1. Hỗ Trợ Đa Ngôn Ngữ
- **Hơn 30 ngôn ngữ lập trình** bao gồm:
  - Lập trình hệ thống: C, C++, Rust, Zig
  - Phát triển ứng dụng: Java, C#, Go, Swift, Kotlin
  - Scripting: Python, JavaScript, TypeScript, Ruby, PHP, Lua
  - Functional: Haskell, Elixir, Clojure, OCaml, F#, Scala
  - Tính toán khoa học: R, Julia
  - Phát triển mobile: Dart
  - Phát triển web: HTML, CSS với live reload

#### 2. Phát Hiện Project Thông Minh
- **Rust**: Phát hiện `Cargo.toml` và sử dụng `cargo run`
- **Go**: Phát hiện `go.mod` và sử dụng `go run .`
- **Java**: Phát hiện thư mục `src/` và biên dịch tất cả file vào `bin/`
- **C#**: Phát hiện file `.csproj` và sử dụng `dotnet run`
- **Fallback**: Chạy file đơn lẻ khi không tìm thấy cấu trúc project

#### 3. Quản Lý Terminal
- **Tái Sử Dụng Thông Minh**: Tái sử dụng cửa sổ terminal hiện có
- **Điều Hướng**: Hỗ trợ điều hướng cửa sổ đầy đủ với `<C-w>hjkl`
- **Cuộn**: Cuộn qua output với phím mũi tên và PageUp/PageDown
- **Thoát Nhanh**: Nhiều cách để đóng terminal (`Enter`, `q`, `Esc`)

#### 4. Phát Triển Web
- **Live Server**: Tích hợp browser-sync cho HTML/CSS/JS
- **Tự Động Reload**: Thay đổi kích hoạt làm mới trình duyệt tự động
- **CSS Injection**: Thay đổi CSS inject mà không cần reload trang
- **Phát Hiện Trình Duyệt**: Tự động phát hiện và khởi động trình duyệt có sẵn

#### 5. Hỗ Trợ Đa Nền Tảng
- **Windows**: Hỗ trợ đầy đủ với tích hợp PowerShell
- **Linux**: Hoạt động với cả X11 và Wayland
- **macOS**: Hỗ trợ native với lệnh được tối ưu hóa

---

## Cài Đặt

### Yêu Cầu Tiên Quyết

- **Neovim** 0.8.0 trở lên
- **Git** để cài đặt plugin
- Trình biên dịch/thông dịch cho từng ngôn ngữ (xem [Yêu Cầu](#yêu-cầu))

### Phương Pháp 1: lazy.nvim (Khuyến Nghị)
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

### Phương Pháp 2: packer.nvim
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

### Phương Pháp 3: Cài Đặt Thủ Công
```bash
# Clone repository
cd ~/.config/nvim
mkdir -p lua
cd lua
git clone https://github.com/xuaantruongfw1612/fast-run.git

# Thêm vào init.lua
require("fast-run").setup()
```

---

## Cấu Hình

### Cấu Hình Cơ Bản
```lua
require("fast-run").setup({
    -- Chỉ định ngôn ngữ muốn kích hoạt
    enable = { "c", "cpp", "python", "java" },
})
```

### Cấu Hình Nâng Cao
```lua
require("fast-run").setup({
    -- Kích hoạt nhiều ngôn ngữ
    enable = {
        -- Ngôn ngữ biên dịch
        "c", "cpp", "rust", "go", "java", "kotlin",
        
        -- Ngôn ngữ scripting
        "python", "javascript", "typescript", "ruby", "lua",
        
        -- Phát triển web
        "html", "css",
        
        -- Khác
        "php", "perl", "sh", "dart", "swift"
    },
    
    -- Phím tắt tùy chỉnh (tùy chọn)
    keymaps = {
        run_file = "<F5>",              -- Thay đổi từ <leader>t
        stop_server = "<F6>",           -- Thay đổi từ <leader>ts
        server_info = "<leader>si",     -- Thay đổi từ <leader>ti
        create_java_project = "<leader>pj",
        create_rust_project = "<leader>pr",
        clear_terminal = "<leader>cl",
        toggle_terminal = "<C-t>",
    }
})
```

### Kích Hoạt Tất Cả Ngôn Ngữ
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

### Vô Hiệu Hóa Phím Tắt Cụ Thể
```lua
require("fast-run").setup({
    enable = { "python", "javascript" },
    keymaps = {
        run_file = "<F5>",
        create_java_project = "",  -- Vô hiệu hóa phím tắt này
        create_rust_project = "",  -- Vô hiệu hóa phím tắt này
    }
})
```

---

## Ngôn Ngữ Hỗ Trợ

### Ngôn Ngữ Biên Dịch

#### C
- **Trình biên dịch**: `gcc` (Linux/Windows), `clang` (macOS)
- **Thư viện**: Bao gồm `-lm -lpthread -ldl -lrt` trên Linux
- **Ví dụ**:
```c
  // hello.c
  #include <stdio.h>
  int main() {
      printf("Xin chào, Thế giới!\n");
      return 0;
  }
```
- **Sử dụng**: Nhấn `<leader>t` → Biên dịch và chạy

#### C++
- **Trình biên dịch**: `g++`
- **Ví dụ**:
```cpp
  // hello.cpp
  #include <iostream>
  int main() {
      std::cout << "Xin chào, Thế giới!" << std::endl;
      return 0;
  }
```

#### Rust
- **Ưu tiên**: `Cargo.toml` → File đơn lẻ
- **Chế độ Project**: Sử dụng `cargo run`
- **File đơn**: Sử dụng `rustc`
- **Ví dụ**:
```rust
  // main.rs
  fn main() {
      println!("Xin chào, Thế giới!");
  }
```
- **Tạo Project**: Nhấn `<leader>tr` để khởi tạo Cargo project

#### Go
- **Ưu tiên**: `go.mod` → File đơn lẻ
- **Chế độ Project**: Sử dụng `go run .`
- **File đơn**: Sử dụng `go run filename.go`
- **Ví dụ**:
```go
  // main.go
  package main
  import "fmt"
  func main() {
      fmt.Println("Xin chào, Thế giới!")
  }
```

#### Java
- **Ưu tiên**: `src/` → File có package → File đơn lẻ
- **Chế độ Project**: Biên dịch tất cả file `.java` vào `bin/`
- **Hỗ trợ Package**: Xử lý khai báo package
- **Ví dụ**:
```java
  // Main.java
  public class Main {
      public static void main(String[] args) {
          System.out.println("Xin chào, Thế giới!");
      }
  }
```
- **Tạo Project**: Nhấn `<leader>tj` để tạo cấu trúc `src/` và `bin/`

### Ngôn Ngữ Scripting

#### Python
- **Trình thông dịch**: `python3` (Linux/macOS), `python` (Windows)
- **Ví dụ**:
```python
  # hello.py
  def main():
      print("Xin chào, Thế giới!")
  
  if __name__ == "__main__":
      main()
```

#### JavaScript
- **Runtime**: `node`
- **Ví dụ**:
```javascript
  // hello.js
  console.log("Xin chào, Thế giới!");
```

#### TypeScript
- **Runtime**: `ts-node`
- **Cài đặt**: `npm install -g ts-node typescript`
- **Ví dụ**:
```typescript
  // hello.ts
  const message: string = "Xin chào, Thế giới!";
  console.log(message);
```

#### Ruby
- **Trình thông dịch**: `ruby`
- **Ví dụ**:
```ruby
  # hello.rb
  puts "Xin chào, Thế giới!"
```

#### PHP
- **Trình thông dịch**: `php`
- **Ví dụ**:
```php
  <?php
  // hello.php
  echo "Xin chào, Thế giới!\n";
  ?>
```

#### Lua
- **Trình thông dịch**: `lua`
- **Ví dụ**:
```lua
  -- hello.lua
  print("Xin chào, Thế giới!")
```

### Phát Triển Web

#### HTML
- **Server**: `browser-sync`
- **Tính năng**: Live reload, CSS injection
- **Cài đặt**: `npm install -g browser-sync`
- **Ví dụ**:
```html
  <!-- index.html -->
  <!DOCTYPE html>
  <html>
  <head>
      <title>Xin chào</title>
      <link rel="stylesheet" href="style.css">
  </head>
  <body>
      <h1>Xin chào, Thế giới!</h1>
      <script src="script.js"></script>
  </body>
  </html>
```
- **Sử dụng**: Nhấn `<leader>t` → Khởi động server tại `http://localhost:3000`

#### CSS
- **Tích hợp**: Hoạt động với HTML live server
- **Hot Reload**: Thay đổi inject mà không cần reload trang
- **Sử dụng**: Nhấn `<leader>t` trong file CSS (yêu cầu HTML server đang chạy)

### Ngôn Ngữ Functional

#### Haskell
- **Chạy**: `runhaskell`
- **Ví dụ**:
```haskell
  -- hello.hs
  main :: IO ()
  main = putStrLn "Xin chào, Thế giới!"
```

#### Elixir
- **Chạy**: `elixir`
- **Ví dụ**:
```elixir
  # hello.exs
  IO.puts "Xin chào, Thế giới!"
```

#### Scala
- **Chạy**: `scala`
- **Ví dụ**:
```scala
  // hello.scala
  object Hello extends App {
      println("Xin chào, Thế giới!")
  }
```

### Khoa Học Dữ Liệu

#### R
- **Chạy**: `Rscript`
- **Ví dụ**:
```r
  # hello.R
  print("Xin chào, Thế giới!")
```

#### Julia
- **Chạy**: `julia`
- **Ví dụ**:
```julia
  # hello.jl
  println("Xin chào, Thế giới!")
```

### Phát Triển Mobile

#### Dart
- **Chạy**: `dart`
- **Ví dụ**:
```dart
  // hello.dart
  void main() {
      print('Xin chào, Thế giới!');
  }
```

#### Swift
- **Chạy**: `swift`
- **Ví dụ**:
```swift
  // hello.swift
  print("Xin chào, Thế giới!")
```

#### Kotlin
- **Trình biên dịch**: `kotlinc`
- **Ví dụ**:
```kotlin
  // hello.kt
  fun main() {
      println("Xin chào, Thế giới!")
  }
```

---

## Hướng Dẫn Sử Dụng

### Quy Trình Cơ Bản

1. **Mở file** bằng bất kỳ ngôn ngữ được hỗ trợ
2. **Nhấn `<leader>t`** để thực thi
3. **Xem output** trong cửa sổ terminal
4. **Đóng terminal** bằng `Enter`, `q`, hoặc `Esc`

### Làm Việc Với Project

#### Java Project
```bash
# Cấu trúc ban đầu
myproject/
└── Main.java

# Nhấn <leader>tj để tạo cấu trúc project
myproject/
├── src/
│   └── Main.java
└── bin/

# Nhấn <leader>t để biên dịch và chạy
```

#### Rust Project
```bash
# File ban đầu
main.rs

# Nhấn <leader>tr để tạo Cargo project
# Nhập tên project: my_app

my_app/
├── Cargo.toml
├── src/
│   └── main.rs
└── target/

# Nhấn <leader>t để cargo run
```

### Phát Triển HTML

1. **Tạo file HTML**:
```html
   <!-- index.html -->
   <!DOCTYPE html>
   <html>
   <head>
       <title>Trang của tôi</title>
       <link rel="stylesheet" href="style.css">
   </head>
   <body>
       <h1>Xin chào, Thế giới!</h1>
   </body>
   </html>
```

2. **Nhấn `<leader>t`**:
   - Khởi động browser-sync server
   - Mở trình duyệt tại `http://localhost:3000`
   - Theo dõi thay đổi file

3. **Chỉnh sửa CSS**:
```css
   /* style.css */
   h1 {
       color: blue;
   }
```
   - Nhấn `<leader>t` trong file CSS
   - Thay đổi inject mà không reload

4. **Dừng server**: Nhấn `<leader>ts`

5. **Kiểm tra trạng thái**: Nhấn `<leader>ti`

---

## Tham Chiếu Phím Tắt

### Phím Tắt Mặc Định

| Phím Tắt | Chế Độ | Hành Động | Mô Tả |
|----------|--------|-----------|-------|
| `<leader>t` | Normal | Chạy file | Thực thi file hiện tại |
| `<leader>ts` | Normal | Dừng server | Dừng HTML development server |
| `<leader>ti` | Normal | Thông tin server | Hiển thị trạng thái server |
| `<leader>tj` | Normal | Java project | Tạo cấu trúc Java project |
| `<leader>tr` | Normal | Rust project | Tạo Rust Cargo project |
| `<leader>tc` | Normal | Xóa terminal | Xóa scrollback terminal |
| `<leader>tt` | Normal | Chuyển chế độ | Chuyển terminal insert/normal |

### Phím Tắt Cửa Sổ Terminal

| Phím Tắt | Chế Độ | Hành Động |
|----------|--------|-----------|
| `Enter` | Normal | Đóng terminal |
| `q` | Normal | Đóng terminal |
| `Esc` | Normal | Đóng terminal |
| `Esc` | Terminal | Thoát sang normal mode |
| `<C-w>h/j/k/l` | Terminal | Điều hướng cửa sổ |
| `<Up>/<Down>` | Terminal | Cuộn output |
| `<PageUp>/<PageDown>` | Terminal | Cuộn nhanh |
| `<C-v>` | Terminal | Dán từ clipboard |
| `<C-q>` | Terminal | Đóng nhanh |

### Tùy Chỉnh Phím Tắt
```lua
require("fast-run").setup({
    keymaps = {
        -- F5 để chạy (giống VS Code)
        run_file = "<F5>",
        
        -- F6 để dừng server
        stop_server = "<F6>",
        
        -- Phím tắt tạo project tùy chỉnh
        create_java_project = "<leader>pj",
        create_rust_project = "<leader>pr",
        
        -- Xóa terminal bằng Ctrl+L
        clear_terminal = "<C-l>",
        
        -- Vô hiệu hóa phím tắt bằng cách đặt chuỗi rỗng
        toggle_terminal = "",
    }
})
```

---

## Tính Năng Nâng Cao

### 1. Quản Lý Terminal

#### Tái Sử Dụng Cửa Sổ Terminal

fast-run tự động tái sử dụng cửa sổ terminal hiện có thay vì tạo mới:
```lua
-- Lần chạy đầu: Tạo cửa sổ terminal mới
-- Nhấn <leader>t trong main.py
-- Terminal mở và hiển thị output

-- Lần chạy thứ hai: Tái sử dụng terminal hiện có
-- Nhấn <leader>t trong file khác
-- Cùng cửa sổ terminal hiển thị output mới
```

#### Điều Hướng Terminal

Điều hướng giữa editor và terminal một cách liền mạch:
```
<C-w>h  -- Di chuyển sang cửa sổ bên trái
<C-w>j  -- Di chuyển sang cửa sổ bên dưới
<C-w>k  -- Di chuyển sang cửa sổ bên trên
<C-w>l  -- Di chuyển sang cửa sổ bên phải
```

#### Cuộn Output

Xem output dài một cách dễ dàng:
```
<Up>/<Down>      -- Cuộn một dòng
<PageUp>/<PageDown>  -- Cuộn một trang
gg               -- Đi đến đầu
G                -- Đi đến cuối
```

### 2. Phát Hiện Project

#### Phát Hiện Java Project
```bash
# Không có thư mục src/
project/
└── Main.java

# Nhấn <leader>t
# Cảnh báo: "File có package nhưng không nằm trong src/"
# Chạy với thư mục bin/ tạm thời

# Nhấn <leader>tj để tạo cấu trúc đúng
project/
├── src/
│   └── Main.java
└── bin/

# Nhấn <leader>t lại
# Biên dịch tất cả file .java trong src/ vào bin/
```

#### Phát Hiện Rust Project
```bash
# Chế độ file đơn
hello.rs

# Nhấn <leader>t
# Sử dụng: rustc hello.rs -o hello && ./hello

# Nhấn <leader>tr để tạo Cargo project
# Nhập tên: hello_world

hello_world/
├── Cargo.toml
├── src/
│   └── main.rs
└── target/

# Nhấn <leader>t lại
# Sử dụng: cargo run
```

### 3. HTML Live Server

#### Tính Năng

- **Live Reload**: Tự động làm mới khi thay đổi HTML/JS
- **CSS Injection**: Inject CSS mà không reload
- **Theo dõi nhiều file**: Theo dõi `**/*.{html,css,js}`
- **Nhận biết thư mục**: Chuyển context khi thay đổi thư mục

#### Mẫu Sử Dụng

**Phát triển Single Page**:
```bash
project/
├── index.html
├── style.css
└── script.js

# Nhấn <leader>t trong index.html
# Server khởi động, trình duyệt mở
# Chỉnh sửa bất kỳ file nào và lưu
# Trình duyệt tự động cập nhật
```

**Phát triển Multi-page**:
```bash
project/
├── index.html
├── about.html
└── css/
    └── style.css

# Nhấn <leader>t trong index.html
# Server khởi động tại index.html

# Chuyển sang about.html
# Nhấn <leader>t
# Trình duyệt điều hướng đến about.html
```

**Dừng Server**:
```bash
# Nhấn <leader>ts
# Output: "Browser-sync server stopped"

# Hoặc nhấn <leader>ti để kiểm tra trạng thái
# Output: "Server running at http://localhost:3000 (Dir: /path/to/project)"
```

### 4. Khác Biệt Đa Nền Tảng

#### Windows Cụ Thể
```lua
-- Sử dụng PowerShell cho các thao tác nâng cao
-- Lệnh Python: python (không phải python3)
-- Khởi động trình duyệt: lệnh start
-- Dừng process: taskkill
```

#### Linux Cụ Thể
```lua
-- Hỗ trợ cả X11 và Wayland
-- Flag Chrome cho Wayland: --ozone-platform=wayland
-- Dừng process: pkill
-- Lệnh Python: python3
```

#### macOS Cụ Thể
```lua
-- Sử dụng clang thay vì gcc cho C
-- Khởi động trình duyệt: lệnh open
-- Command line tools native
```

---

## Khắc Phục Sự Cố

### Vấn Đề Thường Gặp

#### 1. Lỗi "Command not found"

**Vấn đề**: Trình biên dịch/thông dịch chưa được cài đặt

**Giải pháp**:
```bash
# Kiểm tra xem công cụ đã cài chưa
which gcc      # Cho C
which python3  # Cho Python
which node     # Cho JavaScript

# Cài đặt công cụ còn thiếu
# Ubuntu/Debian
sudo apt install gcc g++ python3 nodejs

# macOS
brew install gcc python node

# Windows
# Tải từ trang web chính thức hoặc dùng chocolatey
choco install gcc python nodejs
```

#### 2. Lỗi Biên Dịch Java

**Vấn đề**: Vấn đề cấu trúc package

**Giải pháp**:
```bash
# Đảm bảo cấu trúc đúng
project/
├── src/
│   └── com/
│       └── example/
│           └── Main.java
└── bin/

# Nhấn <leader>tj để tự động tạo cấu trúc
# Hoặc tạo thư mục thủ công
```

#### 3. HTML Server Không Khởi Động

**Vấn đề**: browser-sync chưa được cài đặt

**Giải pháp**:
```bash
# Cài đặt browser-sync globally
npm install -g browser-sync

# Xác nhận cài đặt
browser-sync --version

# Nếu không tìm thấy npm
# Cài đặt Node.js từ https://nodejs.org
```

#### 4. Trình Duyệt Không Mở

**Vấn đề**: Không tìm thấy trình duyệt được hỗ trợ

**Giải pháp**:
```bash
# Cài đặt trình duyệt được hỗ trợ
# Linux
sudo apt install firefox
# hoặc
sudo apt install chromium-browser

# macOS
brew install --cask firefox

# Xác nhận trình duyệt
which firefox
```

#### 5. TypeScript "ts-node not found"

**Vấn đề**: ts-node chưa được cài đặt

**Giải pháp**:
```bash
# Cài đặt ts-node globally
npm install -g ts-node typescript

# Xác nhận cài đặt
ts-node --version
```

#### 6. Cửa Sổ Terminal Không Đóng

**Vấn đề**: Process vẫn đang chạy

**Giải pháp**:
```bash
# Trong terminal, nhấn:
<C-c>     # Dừng process
<Enter>   # Sau đó đóng cửa sổ

# Hoặc đóng bắt buộc
<C-q>     # Đóng nhanh
```

#### 7. Lệnh Cargo Rust Thất Bại

**Vấn đề**: Cargo không có trong PATH

**Giải pháp**:
```bash
# Thêm vào ~/.bashrc hoặc ~/.zshrc
export PATH="$HOME/.cargo/bin:$PATH"

# Reload shell
source ~/.bashrc

# Xác nhận
cargo --version
```

### Chế Độ Debug

Kích hoạt output verbose để khắc phục sự cố:
```lua
-- Trong cấu hình Neovim của bạn
vim.g.fast_run_debug = true

-- Sau đó kiểm tra messages
:messages
```

---

## Yêu Cầu

### Yêu Cầu Cốt Lõi

- **Neovim**: 0.8.0 trở lên
- **Git**: Để cài đặt plugin

### Yêu Cầu Theo Ngôn Ngữ

#### Ngôn Ngữ Biên Dịch

| Ngôn Ngữ | Yêu Cầu | Cài Đặt |
|----------|---------|---------|
| C | `gcc` hoặc `clang` | `apt install gcc` / `brew install gcc` |
| C++ | `g++` | `apt install g++` / `brew install gcc` |
| Rust | `rustc`, `cargo` | [rustup.rs](https://rustup.rs) |
| Go | `go` | [golang.org](https://golang.org/dl/) |
| Java | `javac`, `java` | `apt install default-jdk` |
| Kotlin | `kotlinc` | [kotlinlang.org](https://kotlinlang.org) |
| Swift | `swift` | macOS: Xcode / Linux: [swift.org](https://swift.org) |
| C# | `dotnet` | [dotnet.microsoft.com](https://dotnet.microsoft.com) |
| Zig | `zig` | [ziglang.org](https://ziglang.org) |
| Nim | `nim` | [nim-lang.org](https://nim-lang.org) |

#### Ngôn Ngữ Scripting

| Ngôn Ngữ | Yêu Cầu | Cài Đặt |
|----------|---------|---------|
| Python | `python3` | `apt install python3` / `brew install python` |
| JavaScript | `node` | [nodejs.org](https://nodejs.org) |
| TypeScript | `ts-node` | `npm install -g ts-node typescript` |
| Ruby | `ruby` | `apt install ruby` / `brew install ruby` |
| PHP | `php` | `apt install php` / `brew install php` |
| Lua | `lua` | `apt install lua5.4` / `brew install lua` |
| Perl | `perl` | Thường đã được cài sẵn |
| Shell | `bash` | Thường đã được cài sẵn |

#### Ngôn Ngữ Functional

| Ngôn Ngữ | Yêu Cầu | Cài Đặt |
|----------|---------|---------|
| Haskell | `ghc`, `runhaskell` | `apt install haskell-platform` |
| Elixir | `elixir` | [elixir-lang.org](https://elixir-lang.org) |
| Scala | `scala` | [scala-lang.org](https://scala-lang.org) |
| Clojure | `clojure` | [clojure.org](https://clojure.org) |
| OCaml | `ocaml` | [ocaml.org](https://ocaml.org) |
| F# | `dotnet` | [dotnet.microsoft.com](https://dotnet.microsoft.com) |
| Racket | `racket` | [racket-lang.org](https://racket-lang.org) |

#### Khoa Học Dữ Liệu

| Ngôn Ngữ | Yêu Cầu | Cài Đặt |
|----------|---------|---------|
| R | `Rscript` | [r-project.org](https://www.r-project.org) |
| Julia | `julia` | [julialang.org](https://julialang.org) |

#### Phát Triển Mobile

| Ngôn Ngữ | Yêu Cầu | Cài Đặt |
|----------|---------|---------|
| Dart | `dart` | [dart.dev](https://dart.dev) |

#### Phát Triển Web

| Công Cụ | Yêu Cầu | Cài Đặt |
|---------|---------|---------|
| Live Server | `browser-sync` | `npm install -g browser-sync` |
| Trình duyệt | Chrome/Firefox/Edge | Trình quản lý package hệ thống |

---

## Đóng Góp

Chúng tôi hoan nghênh đóng góp! Đây là cách bạn có thể giúp đỡ:

### Báo Cáo Lỗi

1. Kiểm tra xem vấn đề đã tồn tại chưa
2. Bao gồm phiên bản Neovim: `:version`
3. Bao gồm cấu hình fast-run
4. Cung cấp các bước tái tạo tối thiểu
5. Bao gồm thông báo lỗi

### Đề Xuất Tính Năng

1. Mô tả tính năng rõ ràng
2. Giải thích use case
3. Cung cấp ví dụ nếu có thể

### Pull Request

1. Fork repository
2. Tạo feature branch
3. Thực hiện thay đổi
4. Test kỹ lưỡng
5. Submit PR với mô tả

### Thêm Hỗ Trợ Ngôn Ngữ

Để thêm ngôn ngữ mới:

1. Chỉnh sửa `lua/fast-run/runner.lua`
2. Thêm khối `elseif` mới:
```lua
-- Ngôn Ngữ Của Bạn
elseif filetype == "ngonngunguaban" then
    return string.format('term trinh-bien-dich-cua-ban "%s"', fullpath)
```

3. Cập nhật ngôn ngữ mặc định trong `lua/fast-run/config.lua`
4. Test trên nhiều nền tảng
5. Cập nhật tài liệu

### Phong Cách Code

- Sử dụng 4 spaces cho indentation
- Tuân theo mẫu code hiện có
- Comment logic phức tạp
- Giữ function tập trung và nhỏ gọn

---

## Câu Hỏi Thường Gặp

### Q: Tôi có thể sử dụng flag trình biên dịch tùy chỉnh không?

A: Hiện tại, flag trình biên dịch được hardcode. Để tùy chỉnh, chỉnh sửa `runner.lua` cho ngôn ngữ của bạn.

### Q: Làm thế nào để thay đổi kích thước cửa sổ terminal?

A: Chỉnh sửa `ui.lua`, tìm `vertical resize 50` và thay đổi số.

### Q: Tôi có thể sử dụng với tmux/screen không?

A: Có, nhưng phím tắt terminal có thể cần điều chỉnh.

### Q: Nó có hỗ trợ phát triển remote không?

A: Có, nếu môi trường remote của bạn có các công cụ yêu cầu.

### Q: Tôi có thể chạy với tham số dòng lệnh không?

A: Không trực tiếp. Sử dụng wrapper script hoặc sửa `runner.lua`.

### Q: Làm thế nào để debug chương trình của tôi?

A: fast-run dành cho thực thi nhanh. Sử dụng DAP plugin để debug.

### Q: Tôi có thể tùy chỉnh port HTML server không?

A: Hiện tại cố định ở 3000. Phiên bản tương lai có thể thêm tùy chỉnh.

### Q: Nó có hỗ trợ project nhiều file không?

A: Có cho Java, Rust, Go, C#. Các ngôn ngữ khác chạy file hiện tại.

---

## Lịch Sử Thay Đổi

### Phiên Bản 1.0.0 (2024)

- Phát hành ban đầu
- Hỗ trợ hơn 30 ngôn ngữ lập trình
- Phát hiện project thông minh
- HTML live server
- Hỗ trợ đa nền tảng
- Phím tắt tùy chỉnh
- Quản lý terminal

---

## Giấy Phép

Giấy phép MIT

Bản quyền (c) 2024 xuaantruongfw1612

Được cấp phép miễn phí cho bất kỳ ai có được bản sao
của phần mềm này và các file tài liệu liên quan ("Phần mềm"), để
xử lý Phần mềm mà không bị hạn chế, bao gồm không giới hạn quyền
sử dụng, sao chép, sửa đổi, hợp nhất, xuất bản, phân phối, cấp phép con và/hoặc bán
các bản sao của Phần mềm, và cho phép những người được cung cấp
Phần mềm làm như vậy, với các điều kiện sau:

Thông báo bản quyền trên và thông báo cấp phép này phải được bao gồm trong tất cả
các bản sao hoặc phần đáng kể của Phần mềm.

PHẦN MỀM ĐƯỢC CUNG CẤP "NGUYÊN TRẠNG", KHÔNG CÓ BẢO HÀNH DƯỚI BẤT KỲ HÌNH THỨC NÀO, RÕ RÀNG
HOẶC NGỤ Ý, BAO GỒM NHƯNG KHÔNG GIỚI HẠN BẢO HÀNH VỀ KHẢ NĂNG THƯƠNG MẠI HÓA,
PHÙ HỢP CHO MỤC ĐÍCH CỤ THỂ VÀ KHÔNG VI PHẠM. TRONG MỌI TRƯỜNG HỢP, CÁC TÁC GIẢ
HOẶC NGƯỜI NẮM GIỮ BẢN QUYỀN KHÔNG CHỊU TRÁCH NHIỆM ĐỐI VỚI BẤT KỲ YÊU CẦU, THIỆT HẠI HOẶC TRÁCH NHIỆM
KHÁC, DÙ TRONG HÀNH ĐỘNG HỢP ĐỒNG, VI PHẠM HOẶC CÁCH KHÁC, PHÁT SINH TỪ,
NGOÀI HOẶC LIÊN QUAN ĐẾN PHẦN MỀM HOẶC VIỆC SỬ DỤNG HOẶC CÁC GIAO DỊCH KHÁC TRONG
PHẦN MỀM.

---

## Lời Cảm Ơn

- Cảm ơn cộng đồng Neovim
- Lấy cảm hứng từ nhiều plugin code runner khác nhau
- Được xây dựng với ❤️ dành cho các developer

---

## Hỗ Trợ

- **Issues**: [GitHub Issues](https://github.com/xuaantruongfw1612/fast-run/issues)
- **Thảo luận**: [GitHub Discussions](https://github.com/xuaantruongfw1612/fast-run/discussions)
- **Star**: Nếu bạn thấy hữu ích, xin hãy star repo!

---

**Được tạo với ❤️ bởi [xuaantruongfw1612](https://github.com/xuaantruongfw1612)**
