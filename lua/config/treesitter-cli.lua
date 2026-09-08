-- Ensure a working `tree-sitter` CLI exists before nvim-treesitter builds
-- any parser.
--
-- Why: when `tree-sitter` is not on PATH, LazyVim auto-installs the LATEST
-- tree-sitter-cli through Mason. Releases >= 0.26.0 publish prebuilt binaries
-- that require glibc 2.39 (Ubuntu 24.04 CI). On Debian bookworm / Ubuntu
-- 22.04 (glibc 2.34-2.36) those cannot even start, so every parser build
-- fails with:
--
--   tree-sitter: /lib/.../libc.so.6: version `GLIBC_2.39' not found
--   (required by tree-sitter)
--
-- This module is loaded before lazy.nvim setup (from config/options.lua), so
-- it runs even on the very first nvim start on a fresh machine, before
-- LazyVim can install the broken latest release. On Linux it:
--   * does nothing when an existing `tree-sitter` runs fine
--     (brew/distro/image-provided binary, ...);
--   * otherwise downloads the pinned release into stdpath("data")/bin, puts it
--     first on PATH, and removes any broken copy Mason already installed
--     (Mason prepends its bin/ to PATH, which would otherwise shadow ours).
--
-- Keep TREE_SITTER_VERSION in sync with pi-cloud's base.Dockerfile.
local TREE_SITTER_VERSION = "0.25.6"

-- @return string|nil asset target for the current machine (Linux only)
local function linux_target()
  local uname = vim.loop.os_uname()
  if uname.sysname ~= "Linux" then
    return nil
  end
  local m = uname.machine
  if m == "x86_64" or m == "amd64" then
    return "linux-x64"
  elseif m == "aarch64" or m == "arm64" then
    return "linux-arm64"
  end
  return nil
end

-- @return boolean whether the first `tree-sitter` on PATH actually runs.
-- `vim.fn.executable` only checks the exec bit, so a binary with unmet glibc
-- requirements still "exists"; we must try to run it.
local function cli_works()
  local exe = vim.fn.exepath("tree-sitter")
  if exe == "" then
    return false
  end
  local out = vim.fn.system({ exe, "--version" })
  return vim.v.shell_error == 0 and out:match("tree%-sitter") ~= nil
end

local target = linux_target()
if target and not cli_works() then
  local dir = vim.fn.stdpath("data") .. "/bin"
  vim.fn.mkdir(dir, "p")
  local dest = dir .. "/tree-sitter"
  local url = ("https://github.com/tree-sitter/tree-sitter/releases/download/v%s/tree-sitter-%s.gz"):format(
    TREE_SITTER_VERSION,
    target
  )
  local tmp = dest .. ".gz"
  vim.fn.system({ "curl", "-fsSL", "-o", tmp, url })
  if vim.v.shell_error == 0 then
    vim.fn.system({ "gzip", "-df", tmp })
    vim.fn.system({ "chmod", "+x", dest })
  end
  if vim.fn.executable(dest) == 1 then
    -- Prepend ours so it wins over any (possibly broken) earlier PATH entry.
    vim.env.PATH = dir .. ":" .. vim.env.PATH
    -- Drop a broken copy installed by Mason: once Mason sets up it prepends its
    -- bin/ ahead of ours, which would resurrect the problem for later builds.
    local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/tree-sitter-cli"
    if vim.fn.isdirectory(mason_pkg) == 1 then
      vim.fn.delete(mason_pkg, "rf")
    end
    vim.fn.delete(vim.fn.stdpath("data") .. "/mason/bin/tree-sitter")
    vim.notify(
      ("Installed tree-sitter CLI v%s (Mason's latest requires glibc >= 2.39)"):format(TREE_SITTER_VERSION),
      vim.log.levels.INFO
    )
  end
end