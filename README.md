# 💤 nvim-config

Personal Neovim configuration based on [LazyVim](https://github.com/LazyVim/LazyVim).

## Requirements

- Neovim **>= 0.12**
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal (icons)
- Git

## Install

```bash
git clone https://github.com/artieeez/nvim-config.git ~/.config/nvim
```

Then launch `nvim` — plugins install automatically on first start (LazyVim v16).

## What's configured

Based on the [LazyVim Starter](https://github.com/LazyVim/starter) with:

- **Language extras** enabled (see `lazyvim.json`):
  - `lang.ruby` (Ruby/Rails)
  - `lang.clangd` (C/C++)
  - `lang.terraform`
  - `lang.yaml`
  - `lang.markdown`
- **Snacks picker UX fix** (`lua/plugins/snacks.lua`): `<Esc>` closes the picker
  (instead of dropping to Normal mode, which made mouse-click typing trigger
  normal-mode commands like `n` → `E35`).

## Notes

- `lazy-lock.json` pins plugin versions — run `:Lazy update` to upgrade.
- LSP servers install on demand via Mason when you open a matching file.

## Resources

- [LazyVim](https://www.lazyvim.org) — configuration reference & extras
- [Snacks.nvim](https://github.com/folke/snacks.nvim)
