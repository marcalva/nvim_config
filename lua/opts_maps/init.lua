-- vim.cmd([[set statusline=%!v:lua.require'statusline'.statusline()]])

--- options
vim.cmd("syntax on")

vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.tabstop = 4        -- How many columns a \t char is rendered as (less relevant with expandtab)
vim.opt.softtabstop = 4    -- Number of spaces <Tab> inserts/deletes in insert mode
vim.opt.shiftwidth = 4     -- Number of spaces for auto/manual indentation (>>, <<)
vim.opt.expandtab = true     -- Use spaces instead of tabs
vim.opt.autoindent = true    -- Copy indent from current line when starting a new line
vim.opt.smartindent = true   -- Smarter autoindent for some languages (often good enough, or use filetype plugins)

vim.opt.mouse = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "auto"

-- max number of items in popup window
vim.cmd([[set pumheight=40]])

-- buffer navigation
vim.keymap.set('n', '<leader>l', ':buffers<CR>:buffer ', {noremap = true})
vim.keymap.set('n', '<leader>n', ':bnext<CR>', {noremap = true})
vim.keymap.set('n', '<leader>N', ':bprevious<CR>', {noremap = true})
vim.keymap.set('n', '<leader>bd', ':buffers<CR>:bdelete ', {noremap = true})
vim.keymap.set('n', '<leader>bf', ':bfirst<CR>', {noremap = true})
vim.keymap.set('n', '<leader>bl', ':blast<CR>', {noremap = true})

--- remove highlighting
vim.keymap.set('n', '<leader>h', ':noh<CR>', {noremap = true})
--- quit everything without saving
vim.keymap.set('n', '<leader>q', ':qa!<CR>', {noremap = true})
--- insert empty line below or above (with count)
vim.keymap.set('n', '<leader>o', ':<C-u>call append(line("."), repeat([""], v:count1))<CR>', defaults)
vim.keymap.set('n', '<leader>O', ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', defaults)

-- yank/delete to/from +register
vim.keymap.set({'n', 'v'}, '<leader>d', '"+d', {noremap = true})
vim.keymap.set({'n', 'v'}, '<leader>dd', '"+dd', {noremap = true})
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {noremap = true})
vim.keymap.set({'n', 'v'}, '<leader>yy', '"+yy', {noremap = true})
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y', {noremap = true})
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', {noremap = true})
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P', {noremap = true})
