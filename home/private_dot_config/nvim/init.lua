if vim.g.vscode then
    -- VSCode extension
else
    -- ordinary Neovim
end

-- Reset terminal cursor on leave
vim.cmd [[
  autocmd VimLeave * set guicursor=a:ver25-blinkon1
]]

vim.cmd("colorscheme sorbet")

-- Lazy load system clipboard syncing
-- vim.opt.clipboard:append("unnamedplus")
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set('n', '<leader>a', 'ggVG', { desc = "select all" })
vim.keymap.set('n', '<leader>/', ':nohl<CR>')

vim.keymap.set({'n', 'x', 'o'}, 'H', '^')
vim.keymap.set({'n', 'x', 'o'}, 'L', '$')
vim.keymap.set({'n', 'x', 'o'}, 'J', '6j')
vim.keymap.set({'n', 'x', 'o'}, 'K', '6k')

