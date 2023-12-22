-- Snippets
local ls = require("luasnip")

require("luasnip").config.set_config({ -- Setting LuaSnip config
  enable_autosnippets = true,   
  store_selection_keys = "<Tab>",
})

vim.keymap.set({"i", "s"}, "<C-f>", function() ls.expand_or_jump() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-b>", function() ls.jump(-1) end, {silent = true})

-- Load snippets from ~/.config/nvim/LuaSnip/
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/LuaSnip/"})
require("luasnip.loaders.from_vscode").lazy_load()
require'luasnip'.filetype_extend("latex", {"latex"})
