--- terminal and REPL related

--- every time a terminal is opened
--- sets variable last_term_id to the job id of the last opened terminal
--- updates statusline to show job ID of local terminal
vim.api.nvim_create_autocmd({"TermOpen"}, {
    pattern = {"term://*"},
    callback = function()
        vim.g.last_term_id = vim.b.terminal_job_id
        vim.opt_local.statusline = string.format("terminal: %d", vim.b.terminal_job_id)
    end,
})

vim.g.get_jobid = function()
    vim.ui.input({prompt = 'Job ID (empty for last terminal):',
        default = ''},
        function(input) id = input end)

    if id == '' then
        return vim.g.last_term_id
    else
        return id
    end
end

--- terminal navigation keyamps
vim.keymap.set('n', '<C-t><C-n>', ":tabedit | terminal<CR>", {noremap = true})
vim.keymap.set('n', '<C-t><C-v>', ":vsplit | terminal<CR>", {noremap = true})
vim.keymap.set('n', '<C-t><C-s>', ":split | terminal<CR>", {noremap = true})
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], {noremap = true})
vim.keymap.set('t', '<C-w><C-l>', [[<C-\><C-n><C-w><C-l>]], {noremap = true})
vim.keymap.set('t', '<C-w><C-h>', [[<C-\><C-n><C-w><C-h>]], {noremap = true})
vim.keymap.set('t', '<C-w><C-j>', [[<C-\><C-n><C-w><C-j>]], {noremap = true})
vim.keymap.set('t', '<C-w><C-k>', [[<C-\><C-n><C-w><C-k>]], {noremap = true})

-- yarepl

-- below is the default configuration, there's no need to copy paste them if
-- you are satisfied with the default configuration, just calling
-- `require('yarepl').setup {}` is sufficient.
local yarepl = require 'yarepl'

yarepl.setup {
    -- see `:h buflisted`, whether the REPL buffer should be buflisted.
    buflisted = true,
    -- whether the REPL buffer should be a scratch buffer.
    scratch = true,
    -- the filetype of the REPL buffer created by `yarepl`
    ft = 'REPL',
    -- How yarepl open the REPL window, can be a string or a lua function.
    -- See below example for how to configure this option
    -- wincmd = 'vs',
    -- The available REPL palattes that `yarepl` can create REPL based on
    metas = {
        radian = { cmd = 'radian', formatter = yarepl.formatter.bracketed_pasting },
        ipython = { cmd = 'ipython', formatter = yarepl.formatter.bracketed_pasting },
        python = { cmd = 'python', formatter = yarepl.formatter.trim_empty_lines },
        R = { cmd = 'R', formatter = yarepl.formatter.trim_empty_lines },
        bash = { cmd = 'bash', formatter = yarepl.formatter.trim_empty_lines },
        zsh = { cmd = 'zsh', formatter = yarepl.formatter.bracketed_pasting },
    },
    -- when a REPL process exits, should the window associated with those REPLs closed?
    close_on_exit = false,
    -- whether automatically scroll to the bottom of the REPL window after sending
    -- text? This feature would be helpful if you want to ensure that your view
    -- stays updated with the latest REPL output.
    scroll_to_bottom_after_sending = true,
    os = {
        -- Some hacks for Windows. macOS and Linux users can simply ignore
        -- them. The default options are recommended for Windows user.
        windows = {
            -- Send a final `\r` to the REPL with delay,
            send_delayed_cr_after_sending = true,
        },
    },
}

-- The `run_cmd_with_count` function enables a user to execute a command with
-- count values in keymaps. This is particularly useful for `yarepl.nvim`,
-- which heavily uses count values as the identifier for REPL IDs.
local function run_cmd_with_count(cmd)
    return function()
        vim.cmd(string.format('%d%s', vim.v.count, cmd))
    end
end

-- The `partial_cmd_with_count_expr` function enables users to enter partially
-- complete commands with a count value, and specify where the cursor should be
-- placed. This function is mainly designed to bind `REPLExec` command into a
-- keymap.
local function partial_cmd_with_count_expr(cmd)
    return function()
        -- <C-U> is equivalent to \21, we want to clear the range before next input
        -- to ensure the count is recognized correctly.
        return ':\21' .. vim.v.count .. cmd
    end
end

local keymap = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap
local autocmd = vim.api.nvim_create_autocmd

local ft_to_repl = {
    r = 'radian',
    rmd = 'radian',
    quarto = 'radian',
    markdown = 'radian',
    ['markdown.pandoc'] = 'radian',
    python = 'ipython',
    sh = 'bash',
    REPL = '',
}

autocmd('FileType', {
    pattern = { 'r', 'markdown', 'markdown.pandoc', 'rmd', 'python', 'sh', 'REPL' },
    desc = 'set up REPL keymap',
    callback = function()
        local repl = ft_to_repl[vim.bo.filetype]
        bufmap(0, 'n', '<LocalLeader>rs', '', {
            callback = run_cmd_with_count('REPLStart ' .. repl),
            desc = 'Start an REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rf', '', {
            callback = run_cmd_with_count 'REPLFocus',
            desc = 'Focus on REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rv', '<CMD>Telescope REPLShow<CR>', {
            desc = 'View REPLs in telescope',
        })
        bufmap(0, 'n', '<LocalLeader>rh', '', {
            callback = run_cmd_with_count 'REPLHide',
            desc = 'Hide REPL',
        })
        bufmap(0, 'v', '<LocalLeader>s', '', {
            callback = run_cmd_with_count 'REPLSendVisual',
            desc = 'Send visual region to REPL',
        })
        bufmap(0, 'n', '<LocalLeader>ss', '', {
            callback = run_cmd_with_count 'REPLSendLine',
            desc = 'Send current line to REPL',
        })
        -- `<LocalLeader>sap` will send the current paragraph to the
        -- buffer-attached REPL, or REPL 1 if there is no REPL attached.
        -- `2<Leader>sap` will send the paragraph to REPL 2. Note that `ap` is
        -- just an example and can be replaced with any text object or motion.
        bufmap(0, 'n', '<LocalLeader>s', '', {
            callback = run_cmd_with_count 'REPLSendOperator',
            desc = 'Operator to send to REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rq', '', {
            callback = run_cmd_with_count 'REPLClose',
            desc = 'Quit REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rc', '<CMD>REPLCleanup<CR>', {
            desc = 'Clear REPLs.',
        })
        bufmap(0, 'n', '<LocalLeader>rS', '<CMD>REPLSwap<CR>', {
            desc = 'Swap REPLs.',
        })
        bufmap(0, 'n', '<LocalLeader>r?', '', {
            callback = run_cmd_with_count 'REPLStart',
            desc = 'Start an REPL from available REPL metas',
        })
        bufmap(0, 'n', '<LocalLeader>ra', '<CMD>REPLAttachBufferToREPL<CR>', {
            desc = 'Attach current buffer to a REPL',
        })
        bufmap(0, 'n', '<LocalLeader>rd', '<CMD>REPLDetachBufferToREPL<CR>', {
            desc = 'Detach current buffer to any REPL',
        })
        -- `3<LocalLeader>re df.describe()`: This keymap executes the specified
        -- command in REPL 3.
        bufmap(0, 'n', '<LocalLeader>re', '', {
            callback = partial_cmd_with_count_expr 'REPLExec ',
            desc = 'Execute command in REPL',
            expr = true,
        })
    end,
})
