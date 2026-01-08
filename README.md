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

Originally created for 42 Barcelona students, FtVim provides a complete IDE experience out of the box with sensible defaults and easy customization.

## Links

- **Documentation**: https://ftvim.github.io
- **Quick Start**: https://ftvim.github.io/docs/installation
- **Discord**: https://discord.gg/75kvFwyxpe

## Quick Install

```bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone the starter template
git clone https://github.com/FtVim/starter ~/.config/nvim

# Start Neovim
nvim
```

## Requirements

- Neovim >= 0.11.0
- Git >= 2.19.0
- A Nerd Font (for icons)
- ripgrep (for searching)

## Features

- Modern plugin management with lazy.nvim
- Fast fuzzy finding with snacks.nvim
- LSP support with auto-completion (blink.cmp)
- Git integration with gitsigns
- Beautiful UI with catppuccin colorscheme
- 42 School support (optional extra)
- GitHub Copilot support (optional extra)

## License

MIT
