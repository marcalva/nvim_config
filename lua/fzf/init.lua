local fzf = require('fzf-lua')

require('fzf-lua').setup({
    -- Global options
    global_resume = true,      -- Enable resume last search
    global_resume_query = true,
    winopts = {
        -- Window layout
        height     = 0.85,      -- Window height
        width      = 0.80,      -- Window width
        row        = 0.35,      -- Vertical position
        col        = 0.55,      -- Horizontal position
        border     = 'rounded', -- Border style
        fullscreen = false,     -- Start fullscreen?
        preview = {
            default     = 'builtin', -- Default previewer
            border      = 'border',  -- Border style
            wrap        = 'nowrap',  -- Wrap preview text?
            hidden      = 'nohidden',-- Hidden by default?
            vertical    = 'down:45%',-- Layout
            horizontal  = 'right:50%',
            layout      = 'flex',    -- Flex layout
            flip_columns= 120,       -- Flip layout if columns > this
            title       = true,      -- Show file title
            scrollbar   = 'float',   -- Show scrollbar?
            scrolloff   = '-2',      -- Float scrollbar offset
            -- Preview window options
            winopts = {
                number         = true,
                relativenumber = false,
                cursorline    = true,
                cursorlineopt = 'both',
                cursorcolumn  = false,
                signcolumn    = 'no',
                list          = false,
                foldenable    = false,
                foldmethod    = 'manual',
            },
        },
    },

    -- Searching
    files = {
        -- Provider (use `fd` if available, otherwise `find`)
        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
        find_opts = "-type f -not -path '*/\\.git/*'",
        -- Options
        prompt            = 'Files❯ ',
        multiprocess      = true,           -- Run asynchronously
        path_shorten     = false,           -- Shorten path?
        truncate_matches = true,            -- Truncate matches?
    },

    -- Grep
    grep = {
        -- Provider (use `rg` if available, otherwise `grep`)
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
        -- Options
        prompt            = 'Rg❯ ',
        input_prompt     = 'Grep For❯ ',
        multiprocess      = true,           -- Run asynchronously
        -- Ripgrep options
        rg_glob          = true,            -- Enable glob support
        glob_flag        = "--iglob",       -- Glob flag
        glob_separator   = "%s%-%-",        -- Glob separator
    },

    -- Git
    git = {
        status = {
            prompt     = 'Git Status❯ ',
            cmd       = "git status -s",
            previewer = "git_diff",
            actions = {
                -- Open file
                ["right"] = { fn = require('fzf-lua').actions.file_edit },
                -- Stage/unstage files
                ["ctrl-x"] = { fn = require('fzf-lua').actions.git_reset },
            },
        },
        commits = {
            prompt  = 'Commits❯ ',
            cmd    = "git log --pretty=oneline --abbrev-commit --color",
            preview_pager = "delta",        -- Use delta if available
        },
    },

    -- Performance
    fzf_opts = {
        -- Layout
        ['--info']     = 'inline',
        ['--layout']   = 'reverse',
        -- Performance
        ['--tiebreak'] = 'index',          -- Sort by index
        ['--cycle']    = false,            -- Enable cycling?
    },

    -- Actions configuration
    actions = {
        files = {
            -- Default action
            ["default"] = require('fzf-lua').actions.file_edit,
            -- Custom actions
            ["ctrl-s"]  = require('fzf-lua').actions.file_split,
            ["ctrl-v"]  = require('fzf-lua').actions.file_vsplit,
            ["ctrl-t"]  = require('fzf-lua').actions.file_tabedit,
            ["ctrl-q"]  = require('fzf-lua').actions.file_sel_to_qf,
        },
    },
    keymap = {
        builtin = {
            -- Scroll preview window
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
        },
    },
})

local map = vim.keymap.set

-- Files
map('n', '<leader>ff', fzf.files, { desc = 'Find files' })
map('n', '<leader>fr', fzf.resume, { desc = 'Resume last search' })
map('n', '<leader>fh', fzf.help_tags, { desc = 'Help tags' })

-- Search
map('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
map('n', '<leader>fw', fzf.grep_cword, { desc = 'Grep current word' })
map('n', '<leader>fW', fzf.grep_cWORD, { desc = 'Grep current WORD' })
map('n', '<leader>fs', fzf.grep_visual, { desc = 'Grep visual selection' })

-- Buffers
map('n', '<C-b>', fzf.buffers, { desc = 'Find buffers' })
map('n', '<leader>fb', fzf.buffers, { desc = 'Find buffers' })  -- Alternative
map('n', '<leader>fo', fzf.oldfiles, { desc = 'Recent files' })

-- Git
map('n', '<leader>gc', fzf.git_commits, { desc = 'Git commits' })
map('n', '<leader>gb', fzf.git_branches, { desc = 'Git branches' })
map('n', '<leader>gs', fzf.git_status, { desc = 'Git status' })

-- Diagnostics
map('n', '<leader>dd', fzf.diagnostics_document, { desc = 'Document diagnostics' })
map('n', '<leader>dw', fzf.diagnostics_workspace, { desc = 'Workspace diagnostics' })

-- Commands and Search History
map('n', '<leader>:', fzf.commands, { desc = 'Command history' })
map('n', '<leader>/', fzf.search_history, { desc = 'Search history' })

-- Builtin menu
map('n', '<leader>fa', fzf.builtin, { desc = 'Show all fzf commands' })
