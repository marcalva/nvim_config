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
    {"nvim-treesitter/nvim-treesitter"},
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        requires = "nvim-treesitter/nvim-treesitter",
    },
    {"kylechui/nvim-surround",
        version = "*",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
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
    {'nvim-lua/plenary.nvim'},
    {"nvim-lua/lsp-status.nvim"},
    -- completion
    {"hrsh7th/nvim-cmp"},
    {"hrsh7th/cmp-nvim-lsp"},
    {"hrsh7th/cmp-nvim-lsp-signature-help"},
    {"hrsh7th/cmp-buffer"},
    {"hrsh7th/cmp-path"},
    {"hrsh7th/cmp-cmdline"},
    {"amarakon/nvim-cmp-lua-latex-symbols"},
    {"onsails/lspkind.nvim"},
    {"ray-x/lsp_signature.nvim"},
    -- {"dstein64/vim-startuptime"},
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
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    -- code companion
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- Optional
            {
                "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
                opts = {},
            },
        },
        config = true
    },
    -- noice
    -- lazy.nvim
    --     {
    --         "folke/noice.nvim",
    --         event = "VeryLazy",
    --         opts = {
    --             -- add any options here
    --         },
    --         dependencies = {
    --             -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    --             "MunifTanjim/nui.nvim",
    --             -- OPTIONAL:
    --             --   `nvim-notify` is only needed, if you want to use the notification view.
    --             --   If not available, we use `mini` as the fallback
    --             "rcarriga/nvim-notify",
    --         }
    --     }
})

-- require("noice").setup({
--   lsp = {
--     -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
--     override = {
--       ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
--       ["vim.lsp.util.stylize_markdown"] = true,
--       ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
--     },
--   },
--   -- you can enable a preset for easier configuration
--   presets = {
--     bottom_search = true, -- use a classic bottom cmdline for search
--     command_palette = true, -- position the cmdline and popupmenu together
--     long_message_to_split = true, -- long messages will be sent to a split
--     inc_rename = false, -- enables an input dialog for inc-rename.nvim
--     lsp_doc_border = false, -- add a border to hover docs and signature help
--   },
-- })
--
