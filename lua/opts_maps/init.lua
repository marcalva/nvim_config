-- vim.cmd([[set statusline=%!v:lua.require'statusline'.statusline()]])

--- options
vim.opt.mouse = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "auto"

vim.opt.syntax = "ON"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cindent = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- buffer navigation
vim.keymap.set('n', '<leader>bb', ':buffers<CR>:buffer ', {noremap = true})
vim.keymap.set('n', '<leader>bd', ':buffers<CR>:bdelete ', {noremap = true})
vim.keymap.set('n', '<leader>n', ':bnext<CR>', {noremap = true})
vim.keymap.set('n', '<leader>N', ':bprevious<CR>', {noremap = true})
vim.keymap.set('n', '<leader>bf', ':bfirst<CR>', {noremap = true})
vim.keymap.set('n', '<leader>bl', ':blast<CR>', {noremap = true})

--- remove highlighting
vim.keymap.set('n', '<leader>h', ':noh<CR>', {noremap = true})
--- quit everything without saving
vim.keymap.set('n', '<leader>q', ':qa!<CR>', {noremap = true})
--- insert empty line below or above (with count)
vim.keymap.set('n', '<leader>o', ':<C-u>call append(line("."), repeat([""], v:count1))<CR>', defaults)
vim.keymap.set('n', '<leader>O', ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', defaults)
