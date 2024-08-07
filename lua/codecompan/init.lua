require("codecompanion").setup({
    adapters = {
        anthropic = function()
            return require("codecompanion.adapters").use("anthropic", {
                env = {
                    api_key = "cmd:echo $ANTHROPIC_API_KEY",
                },
                schema = {
                    model = {
                        default = "claude-3-sonnet-20240229"
                    }
                }
            })
        end,
    },

    strategies = {
        chat = {
            adapter = "anthropic",
        },
        inline = {
            adapter = "anthropic",
        },
        agent = {
            adapter = "anthropic",
        },
    },
})

vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<LocalLeader>a", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<LocalLeader>a", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionAdd<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
