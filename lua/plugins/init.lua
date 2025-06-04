local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {"https://gitlab.com/ibhagwan/fzf-lua", lazy = true},
    {"lervag/vimtex"},
    -- formatting
    {"nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
	},
	-- colors
	{"sainnhe/gruvbox-material"},
    {"NLKNguyen/papercolor-theme"},
	-- REPL
	{"milanglacier/yarepl.nvim"},
	{"jpalardy/vim-slime"},
	-- LSP
	{"neovim/nvim-lspconfig"},
	-- completion
	{"hrsh7th/nvim-cmp"},
	{"hrsh7th/cmp-nvim-lsp"},
	{"hrsh7th/cmp-buffer"},
	{"hrsh7th/cmp-path"},
	{"hrsh7th/cmp-cmdline"},
	{"onsails/lspkind.nvim"},
	{"L3MON4D3/LuaSnip"},
})
