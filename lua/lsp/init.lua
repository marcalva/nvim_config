-- automatic language server install
require("mason").setup()
require("mason-lspconfig").setup{
    ensure_installed = {
        "pyright",
        "bashls",
        "yamlls",
    }
}
-- need to install r language server separately, fails install with Mason
-- need to install clangd separately, depends on local libraries
-- install shellcheck binary and put in path so can be used by bashls
-- texlab should be installed separately (glib doesn't match)

-- null-ls
require("mason-null-ls").setup {
    ensure_installed = {
        "flake8", -- extra diagnostics for python
        "black", -- formatter for python
        "shellharden", -- formatter for bash
    },
    automatic_installation = false,
    handlers = {},
}

local null_ls = require("null-ls")
null_ls.setup({})
-- R lsp already comes with styler and lintr
-- clangd lsp already covers diagnostics and formatting
-- bashls lsp already comes with shellcheck diagnostics

-- Set up lspconfig.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.clangd.setup{capabilities = capabilities}
lspconfig.r_language_server.setup{capabilities = capabilities}
lspconfig.pyright.setup{capabilities = capabilitie}
lspconfig.bashls.setup{capabilities = capabilities}
lspconfig.yamlls.setup{capabilities = capabilities}
lspconfig.texlab.setup{capabilities = capabilities}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set({'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        max_width = 120,
        border = 'rounded',
    })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        max_width = 120,
        border = 'rounded',
    })

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
    float = {
        source = 'always',
        border = 'rounded',
    },
})

-- ray-x lsp_signature
local signature_config = {
    log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log",
    bind = true,
    debug = false,
    hint_enable = false,
    handler_opts = { border = "rounded" },
    hi_parameter = "IncSearch",
    max_width = 80,
}

require("lsp_signature").setup(signature_config)
