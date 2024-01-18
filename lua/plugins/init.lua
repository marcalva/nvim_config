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
    -- autopairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {move_right = false, map_c_h = true, map_c_w = false} -- this is equalent to setup({}) function
    },
    {
        'abecodes/tabout.nvim',
        config = function()
            require('tabout').setup {
                tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
                backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
                act_as_tab = true, -- shift content if tab out is not possible
                act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
                default_tab = '<C-t>', -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
                default_shift_tab = '<C-d>', -- reverse shift default action,
                enable_backwards = true, -- well ...
                completion = true, -- if the tabkey is used in a completion pum
                tabouts = {
                    {open = "'", close = "'"},
                    {open = '"', close = '"'},
                    {open = '`', close = '`'},
                    {open = '(', close = ')'},
                    {open = '[', close = ']'},
                    {open = '{', close = '}'}
                },
                ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
                exclude = {} -- tabout will ignore these filetypes
	}
	end
    },
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
    { "robitx/gp.nvim", },
})
