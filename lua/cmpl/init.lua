-- Completion configuration
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Constants
local CONFIG = {
    ELLIPSIS_CHAR = '…',
    MAX_LABEL_WIDTH = 20,
}

-- Utility functions
local function get_cwd()
    return vim.fn.getcwd()
end

local function get_ws(max, len)
    return (' '):rep(max - len)
end

local function format(_, item)
    local content = item.abbr
    if #content > CONFIG.MAX_LABEL_WIDTH then
        item.abbr = vim.fn.strcharpart(content, 0, CONFIG.MAX_LABEL_WIDTH)
                   .. CONFIG.ELLIPSIS_CHAR
    else
        item.abbr = content .. get_ws(CONFIG.MAX_LABEL_WIDTH, #content)
    end
    return item
end

-- Main completion setup
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    formatting = {
        format = format,
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
        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),

    sources = cmp.config.sources({
        -- LSP completion should have highest priority
        {
            name = 'nvim_lsp',
            priority = 1000,
            keyword_length = 1,
            max_item_count = 50,
        },
        -- Snippets have high priority but below LSP
        {
            name = 'luasnip',
            priority = 750,
            keyword_length = 2,
        },
        -- Path completion for high relevance
        {
            name = 'path',
            priority = 500,
            option = { get_cwd = get_cwd },
        },
        -- Buffer source with lower priority and longer keyword length
        {
            name = 'buffer',
            priority = 250,
            keyword_length = 3,
            max_item_count = 20,
            option = {
                get_bufnrs = function()
                    -- Complete from all visible buffers
                    local bufs = {}
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        bufs[vim.api.nvim_win_get_buf(win)] = true
                    end
                    return vim.tbl_keys(bufs)
                end
            }
        },
        -- Add nvim_lua for neovim lua API completion when editing config files
        {
            name = 'nvim_lua',
            priority = 750,
            keyword_length = 2,
            option = {
                include_deprecated = false,
            },
        },
    }),
})

-- Search mode configuration
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Command mode configuration
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path', option = { get_cwd = get_cwd } },
        { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
    })
})
