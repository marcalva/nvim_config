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
    {"hrsh7th/nvim-cmp"},
    {"onsails/lspkind.nvim"},
    {"ray-x/lsp_signature.nvim"},
    {"dstein64/vim-startuptime"},
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.2", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        -- build = "make install_jsregexp"
    },
    -- copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({})
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    -- chatGPT
    {
        "robitx/gp.nvim",
        config = function()
            require("gp").setup()

            -- or setup with your own config (see Install > Configuration in Readme)
            -- require("gp").setup(config)

            -- shortcuts might be setup here (see Usage > Shortcuts in Readme)
        end,
    },
})
