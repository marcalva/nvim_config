local cmp = require'cmp'
local luasnip = require("luasnip")
local lspkind = require('lspkind')

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "copilot", priority = 2},
        { name = 'nvim_lsp', priority = 2},
        -- { name = 'nvim_lsp_signature_help', priority = 2},
        { name = 'buffer', priority = 1},
        { name = 'luasnip', priority = 1},
        { name = 'path',
            option = {get_cwd = main_getcwd},
            priority = 1,
        },
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = 'text',
            maxwidth = 30,
            ellipsis_char = '...',
        })
    },
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
        { name = 'buffer' },
        })
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        {name = 'path', option = {get_cwd = main_getcwd}},
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
        { name = 'path',
            option = {get_cwd = main_getcwd},
        },
        { name = "lua-latex-symbols", option = {cache = true} },
    }
})

