
--- fzf
require "fzf-lua".setup{{'default', preview = {default="bat"}}}
vim.api.nvim_set_keymap("n", "<C-b>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {noremap = true})
vim.api.nvim_set_keymap("n", "<C-k>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], {noremap = true})
vim.api.nvim_set_keymap("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], {noremap = true})
vim.api.nvim_set_keymap("n", "<C-p><C-h>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {noremap = true})
