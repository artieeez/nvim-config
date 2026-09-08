-- Snacks picker UX fixes.
--
-- Why: Snacks' default <Esc> in the picker input goes to Normal mode instead of
-- closing the picker. If you then click the input and type, your letters run as
-- Normal-mode commands (e.g. "n" = repeat search -> E35 "No previous regular
-- expression"). Mapping a click to insert mode does NOT work here: the input is
-- a buftype=prompt buffer and Neovim's internal mouse handling consumes
-- <LeftMouse> before any mapping runs. The supported fix (per Snacks' own
-- defaults) is to make <Esc> close the picker, like Telescope/fzf users expect.
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts.picker = opts.picker or {}
    opts.picker.win = opts.picker.win or {}
    opts.picker.win.input = opts.picker.win.input or {}
    opts.picker.win.input.keys = vim.tbl_deep_extend("force", opts.picker.win.input.keys or {}, {
      ["<Esc>"] = { "close", mode = { "n", "i" } },
    })
    return opts
  end,
}
