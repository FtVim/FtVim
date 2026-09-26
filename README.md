# FtVim

```
 ███████████ ███████████ █████   █████ █████ ██████   ██████
░░███░░░░░░█░█░░░███░░░█░░███   ░░███ ░░███ ░░██████ ██████ 
 ░███   █ ░ ░   ░███  ░  ░███    ░███  ░███  ░███░█████░███ 
 ░███████       ░███     ░███    ░███  ░███  ░███░░███ ░███ 
 ░███░░░█       ░███     ░░███   ███   ░███  ░███ ░░░  ░███ 
 ░███  ░        ░███      ░░░█████░    ░███  ░███      ░███ 
 █████          █████       ░░███      █████ █████     █████
░░░░░          ░░░░░         ░░░      ░░░░░ ░░░░░     ░░░░░ 
```

A modern Neovim distribution for developers.

Originally created for 42 Barcelona students, FtVim provides a complete IDE experience out of the box with sensible defaults, easy customization and tools for the 42 curriculum.

## Links

- **Documentation**: https://ftvim.github.io
- **Quick Start**: https://ftvim.github.io/docs/installation
- **Discord**: https://discord.gg/75kvFwyxpe

## Quick Install

On a 42 campus machine (no root needed) this installs Neovim, ripgrep, a Nerd Font,
norminette, c_formatter_42, compiledb and the starter config:

```bash
curl -fsSL https://raw.githubusercontent.com/FtVim/FtVim/main/scripts/install.sh | bash
```

Short on home quota? Keep plugins in your sgoinfre:

```bash
curl -fsSL https://raw.githubusercontent.com/FtVim/FtVim/main/scripts/install.sh | bash -s -- --data-dir /sgoinfre/$USER/ftvim
```

Or install the starter by hand:

```bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone the starter template
git clone https://github.com/FtVim/starter ~/.config/nvim

# Start Neovim
nvim
```

Then run `:checkhealth ftvim` to see if anything is missing.

## Requirements

- Neovim >= 0.11.0
- Git >= 2.19.0
- A Nerd Font (for icons)
- ripgrep (for searching)
- A C compiler (for treesitter parsers)

## Features

- Modern plugin management with lazy.nvim
- Fast fuzzy finding, dashboard, notifications and terminal with snacks.nvim
- LSP support with auto-completion (blink.cmp)
- Linting (nvim-lint) and formatting (conform.nvim, `<leader>uf` toggles format on save)
- Git integration with gitsigns
- Beautiful UI with catppuccin colorscheme
- Optional extras, enabled with `:FtVimExtras`

## 42 tools

The `lang.42` extra (`:FtVimExtras`) adds:

- **Norminette while you type**: errors as diagnostics, no need to save, and a `Norm ✓` counter in the statusline
- **42 header** on new files (with a header guard for `.h`), updated on save
- **Exam mode** (`:FtVimExam`): no LSP, completion, diagnostics or Copilot, to practice in exam conditions
- **Pre-submission check** (`:FtVimCheck malloc free write`): norminette, Makefile rules and flags, `make re`, relink and forbidden functions
- **Smart clangd**: `compile_commands.json` generated automatically with compiledb (from a make dry-run, nothing is compiled), so clangd knows your flags and headers. Git ignores it locally, so it's never submitted
- `:FtVimMake`, `:FtVimValgrind` (errors and leaks in the quickfix list) and `:FtVimClass` (Orthodox Canonical Form)
- c_formatter_42, function line counter, 42 snippets (`hguard`, `42make`, `ocf`...) and C/C++ debugging with gdb

## Extras

| Extra | For |
| --- | --- |
| `lang.42` | 42 tools (includes `lang.python` and `dap`) |
| `lang.cpp` | CPP Modules, ft_irc |
| `lang.docker` | Inception |
| `lang.web` | ft_transcendence |
| `lang.python` | Python piscine |
| `lang.rails` | Ruby on Rails |
| `dap` | Debugging |
| `copilot` | GitHub Copilot |

## Documentation

- `:help ftvim` inside Neovim
- [Keymaps](docs/KEYMAPS.md) (also `:help ftvim-keymaps.txt` and `<leader>Fk`)

## Development

```bash
nvim --headless -u tests/minimal_init.lua "+Lazy! sync" +qa   # install plugins in .tests/
nvim --headless -u tests/minimal_init.lua "+luafile tests/smoke.lua"
nvim --headless -u tests/minimal_init.lua "+luafile tests/ft42.lua"
nvim --headless -u tests/minimal_init.lua "+luafile tests/keymaps.lua"
nvim --headless -u tests/minimal_init.lua "+luafile scripts/gen-docs.lua"  # regenerate docs/KEYMAPS.md
```

## License

MIT
