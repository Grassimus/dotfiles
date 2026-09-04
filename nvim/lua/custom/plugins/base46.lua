local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Colorscheme ]]
-- base46 is NvChad's theme engine as a standalone plugin. Its DMS integration
-- ships a matugen template that writes `colors/dms.lua`, so the Neovim theme
-- tracks the DankMaterialShell palette and hot-reloads when the wallpaper,
-- source color or light/dark mode changes.
vim.pack.add { gh 'AvengeMedia/base46' }

require('base46').setup {
  transparency = true,
}

-- Fall back to tokyonight until the DMS template has been generated, so a fresh
-- machine still gets a theme instead of an error at startup.
if vim.uv.fs_stat(vim.fn.stdpath 'config' .. '/colors/dms.lua') then
  vim.cmd.colorscheme 'dms'
else
  vim.cmd.colorscheme 'tokyonight-night'
end

-- vim: ts=2 sts=2 sw=2 et
