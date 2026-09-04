-- [[ Transparency ]]
-- A terminal cell background is either "default", which kitty punches through
-- at background_opacity, or a solid color drawn opaque. Selections and the
-- cursor line are painted in sentinel colors registered in kitty's
-- transparent_background_colors, which renders those exact RGB values at a
-- chosen alpha. Keep them in sync with kitty/kitty.conf.
--
-- Colorscheme-agnostic: the ColorScheme autocmd re-applies these last, which is
-- also what keeps them alive across a base46/DMS hot-reload.
local SEL = '#3b4261' -- selection   @ 0.80
local LINE = '#2a3048' -- cursor line @ 0.76

local function theme()
  -- Rewrite only the background, so each group keeps its own fg and attributes.
  local function bg(group, color)
    local h = vim.api.nvim_get_hl(0, { name = group, link = false })
    h.bg, h.ctermbg = color, nil
    vim.api.nvim_set_hl(0, group, h)
  end

  -- Popups, borders, titles and the statusline are left to the colorscheme.
  -- base46's `transparency` option already clears them, and forcing the titles
  -- transparent leaves them unreadable against the DMS palette. Uncomment if a
  -- theme without its own transparency support is ever loaded.
  --[[
  for _, g in ipairs {
    'NormalFloat',
    'FloatBorder',
    'FloatTitle',
    'FloatFooter',
    'Pmenu',
    'PmenuSbar',
    'BlinkCmpMenu',
    'BlinkCmpMenuBorder',
    'BlinkCmpDoc',
    'BlinkCmpDocBorder',
    'BlinkCmpSignatureHelp',
    'TelescopeNormal',
    'TelescopePromptNormal',
    'TelescopeResultsNormal',
    'TelescopePreviewNormal',
    'TelescopeBorder',
    'TelescopePromptBorder',
    'TelescopeResultsBorder',
    'TelescopePreviewBorder',
    'TelescopeTitle',
    'TelescopePromptTitle',
    'TelescopeResultsTitle',
    'TelescopePreviewTitle',
    'NeoTreeNormal',
    'NeoTreeNormalNC',
    'WhichKeyNormal',
  } do
    bg(g, nil)
  end
  --]]

  -- Statusline. The mode chunk (MiniStatuslineMode*) keeps its accent: those
  -- foregrounds are picked to contrast with it and go unreadable without it.
  for _, g in ipairs {
    'StatusLine',
    'StatusLineNC',
    'MiniStatuslineFilename',
    'MiniStatuslineDevinfo',
    'MiniStatuslineFileinfo',
    'MiniStatuslineInactive',
  } do
    bg(g, nil)
  end

  for _, g in ipairs { 'Visual', 'PmenuSel', 'BlinkCmpMenuSelection', 'TelescopeSelection', 'NeoTreeCursorLine' } do
    bg(g, SEL)
  end

  for _, g in ipairs { 'CursorLine', 'CursorColumn' } do
    bg(g, LINE)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', { callback = theme })
theme()

-- vim: ts=2 sts=2 sw=2 et
