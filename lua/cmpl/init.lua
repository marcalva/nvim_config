-- Set up nvim-cmp.

local cmp = require'cmp'
local lspkind = require('lspkind')

local function main_getcwd()
    return vim.fn.getcwd()
end

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'async_path',
            option = {get_cwd = main_getcwd},
        },
    }),
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50,
            ellipsis_char = '...',
        })
    },
})

-- autopairs
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- cmp.event:on(
--     'confirm_done',
--     cmp_autopairs.on_confirm_done()
-- )

-- max number of items in popup window
vim.cmd([[set pumheight=25]])

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
        { name = 'buffer' },
        })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        {name = 'async_path', option = {get_cwd = main_getcwd}},
        {name = 'cmdline', option = {ignore_cmds = { 'Man', '!' }}},
    })
})

-- Latex
cmp.setup.filetype({ "tex", "plaintex" }, {
    completion = { autocomplete = false },
    sources = {
        { name = "nvim_lsp" },
        -- { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'async_path',
            option = {get_cwd = main_getcwd},
        },
        { name = "lua-latex-symbols", option = {cache = true} },
    }
})

