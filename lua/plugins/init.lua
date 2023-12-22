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
    {"ibhagwan/fzf-lua", lazy = true},
    {"lervag/vimtex"},
    -- formatting
    {"nvim-treesitter/nvim-treesitter"},
    {"kylechui/nvim-surround",
        version = "*",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    {"sainnhe/gruvbox-material", lazy = false},
    -- REPL
    {"milanglacier/yarepl.nvim"},
    -- LSP
    {"neovim/nvim-lspconfig"},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"jay-babu/mason-null-ls.nvim"},
    {'nvim-lua/plenary.nvim'},
    {"jose-elias-alvarez/null-ls.nvim"},
    {"nvim-lua/lsp-status.nvim"},
    -- completion
    {"hrsh7th/cmp-nvim-lsp"},
 -- {"hrsh7th/cmp-nvim-lsp-signature-help"},
    {"hrsh7th/cmp-buffer"},
    {"FelipeLema/cmp-async-path"},
    {"hrsh7th/cmp-cmdline"},
    {"amarakon/nvim-cmp-lua-latex-symbols"},
    {"saadparwaiz1/cmp_luasnip"},
    {"hrsh7th/nvim-cmp"},
    {"onsails/lspkind.nvim"},
    {"ray-x/lsp_signature.nvim"},
    -- Snippets
    {"L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    {"dstein64/vim-startuptime"}
})
