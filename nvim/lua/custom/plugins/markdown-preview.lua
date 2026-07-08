local function gh(repo) return 'https://github.com/' .. repo end

-- Live markdown preview in the browser.
--
-- Provides `:MarkdownPreview`, `:MarkdownPreviewStop` and
-- `:MarkdownPreviewToggle`. The browser build is installed by the
-- `PackChanged` handler in `lua/pack.lua`.
--
-- See `:help mkdp` for all options.
vim.pack.add { gh 'iamcco/markdown-preview.nvim' }

-- Only start the preview server for markdown files.
vim.g.mkdp_filetypes = { 'markdown' }

vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<cr>', { desc = '[M]arkdown [P]review toggle' })

-- vim: ts=2 sts=2 sw=2 et
