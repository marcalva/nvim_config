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

-- max number of items in popup window
vim.cmd([[set pumheight=40]])

vim.opt.colorcolumn = "80"
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- buffer navigation
vim.keymap.set('n', '<leader>l', ':buffers<CR>:buffer ', {noremap = true})
vim.keymap.set('n', '<leader>d', ':buffers<CR>:bdelete ', {noremap = true})
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
