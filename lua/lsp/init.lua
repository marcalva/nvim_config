-- LSP Configuration
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Keybinding Configuration
local function setup_keymaps(ev)
    local opts = { buffer = ev.buf }
    
    -- Buffer-local mappings
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
end

-- Global diagnostic keymaps
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- LSP attach configuration
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        setup_keymaps(ev)
    end,
})

-- Server Configurations
local servers = {
    clangd = {},
    r_language_server = {},
    bashls = {},
    texlab = {},
    basedpyright = {
        settings = {
            basedpyright = {typeCheckingMode = "standard"},
        },
    },
    ruff = {}
}

-- Setup servers
for server, config in pairs(servers) do
    config.capabilities = capabilities
    config.handlers = config.handlers or vim.lsp.handlers
    vim.lsp.config(server, config)
    vim.lsp.enable({server})
end
