-- Neogit: a magit-style git interface living in Neovim buffers.
--
-- <leader>gg and <leader>gG both open Neogit for the current repo
-- (they mirror LazyVim's lazygit key slots; lazygit itself is no longer
-- bound inside the editor and stays available from a terminal).
--
-- Inside the Neogit Status buffer, press `?` for the full help. The
-- essentials: `s`/`u` stage/unstage, `c c` commit, `P p` push, `q` close.

return {
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit (Root Dir)" },
      { "<leader>gG", "<cmd>Neogit<CR>", desc = "Neogit (cwd)" },
    },
    opts = {
      -- disable_commit_confirmation = true, -- commit immediately, no prompt
      -- commit = { editor = "nano" },      -- commit message editor
    },
  },
}