# 🧠 libasm

**libasm** is a lightweight library of commonly used C functions reimplemented in **x86_64 NASM assembly**, written according to the **System V AMD64 ABI**.

This project is focused on learning low-level programming by rebuilding functions from scratch using NASM. It includes full documentation, thorough testing, and a Makefile for easy building and testing.

---

## 📌 Table of Contents

- [About](#about)
- [Features](#features)
- [Implemented Functions](#implemented-functions)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Testing](#testing)
- [License](#license)

---

## 📖 About

**libasm** is an educational project built to improve understanding of how core C library functions work at the lowest level. By implementing them in **NASM**, we explore:

- How function arguments are passed via registers (per ABI)
- How memory is managed manually
- System calls (like `read` and `write`)
- String manipulation without standard libraries

Each function is fully commented and tested.

---

## ✨ Features

- 🔧 Written in **x86_64 NASM** assembly
- 📚 Follows the **System V AMD64 ABI**
- ✅ Fully-commented source code
- 🧪 Includes a test suite
- 📦 Makefile for easy build & test
- 🧠 Educational and beginner-friendly

---

## 🧩 Implemented Functions

```c
size_t  ft_strlen(const char *str);
char    *ft_strcpy(char *dst, const char *src);
int     ft_strcmp(const char *s1, const char *s2);
ssize_t ft_write(int fd, const void *buf, size_t count);
ssize_t ft_read(int fd, void *buf, size_t count);
char    *ft_strdup(const char *s);
int     ft_atoi_base(const char *str, const char *base);
```

---

## ⚙️ Installation

Clone the repository:

```bash
git clone https://github.com/your-username/libasm.git
cd libasm
```

Build the project using the Makefile:

```bash
make all
```

---

## 🚀 Usage

### Build the library and tests

```bash
make all
```

### Clean object files

```bash
make clean
```

### Remove all binaries and libraries

```bash
make fclean
```

### Rebuild everything

```bash
make re
```

### Run tests manually

```bash
./test
```

---

## 🗂️ Project Structure

```
libasm/
├── src/              # NASM source files (*.s)
├── tests/            # C test suite
├── libasm.a          # Compiled static library (generated)
├── Makefile
└── README.md
```

---

## 🧪 Testing

The project includes a simple C-based test suite that validates each assembly function against its libc equivalent. It covers:

- Normal use cases
- Edge cases (empty strings, null bytes)
- Error handling (e.g., invalid file descriptors)

Tests are compiled and executed automatically with `make run`.

---

## 📄 License

This project is open for educational use. Fork it, study it, break it, and rebuild it.

---
