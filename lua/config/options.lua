-- Ensure a working `tree-sitter` CLI before nvim-treesitter builds parsers.
-- This must run before lazy.nvim setup (LazyVim may otherwise auto-install a
-- tree-sitter-cli release that cannot run on bookworm's glibc). See
-- config/treesitter-cli.lua for details.
require("config.treesitter-cli")

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
