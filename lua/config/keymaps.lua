-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- gx with markdown-aware path resolution: the builtin hands the raw link
-- text to the system opener, which resolves it against Neovim's cwd — so
-- relative file links (e.g. `Efforts/INDEX.md`) fail unless cwd happens to
-- be right. Resolve local targets against the current file's directory
-- (like gf) so the opener always gets an absolute path.
vim.keymap.set("n", "gx", function()
  local target = require("vim.ui")._get_urls()[1]
  if not target then
    target = vim.fn.expand("<cfile>")
  end
  if not target:match("^%a+:") then -- not a URL scheme (http, mailto, …)
    target = target:gsub("#.*$", "") -- drop anchors on local files
    if not vim.startswith(target, "/") then
      target = vim.fs.joinpath(vim.fn.expand("%:p:h"), target)
    end
  end
  vim.ui.open(target)
end, { desc = "Open filepath or URI under cursor with system handler" })
