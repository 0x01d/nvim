-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- always set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "


vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	spec = {
		{
			'nvim-treesitter/nvim-treesitter-context',
			opts = {
				max_lines = 3,
				min_window_height = 0,
				line_numbers = true,
			}
		},
		-- Mason & LSP servers
		{
			"williamboman/mason.nvim",
			cmd = "Mason",
			opts = {
				ui = { border = "rounded" },
				ensure_installed = { 'stylua' },
			},
        },
        {
            'mfussenegger/nvim-jdtls',
            ft = 'java',
        },

        -- Telescope
        {
            "nvim-telescope/telescope.nvim",
            cmd = "Telescope",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-fzf-native.nvim",
            },
            build = "make",
            opts = {
                defaults = {
                    file_ignore_patterns = {
                        ".git/",
                        "node_modules/",
                        "%.lock",
                        "__pycache__/",
                        "%.sqlite3",
                        "%.ipynb",
                        "vendor/",
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                            ["<C-d>"] = false,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                },
            },
            config = function(_, opts)
                require("telescope").setup(opts)
                require("telescope").load_extension("fzf")
            end,
            keys = {
                {
                    '<leader>fb',
                    function() require("telescope.builtin").buffers({}) end,
                    desc = "Find buffers",
                },
                {
                    '<leader>ff',
                    function() require("telescope.builtin").find_files({}) end,
                    desc = "Find files",
                },
                {
                    '<leader>fg',
                    function() require("telescope.builtin").live_grep({}) end,
                    desc = "Live grep (ripgrep)",
                },
                {
                    '<leader>fw',
                    function() require("telescope.builtin").grep_string({}) end,
                    desc = "Grep word under cursor",
                },
                {
                    '<leader>fi',
                    function()
                        require("telescope.builtin").live_grep({
                            prompt_title = "Search Imports",
                            default_text = "import ",
                        })
                    end,
                    desc = "Search imports",
                },
                {
                    '<leader>fc',
                    function()
                        require("telescope.builtin").live_grep({
                            prompt_title = "Search Classes/Functions",
                            default_text = "(class |def |function |const |let |var )",
                            type_filter = "regex",
                        })
                    end,
                    desc = "Search classes/functions",
                },
                {
                    '<leader>fh',
                    function() require("telescope.builtin").help_tags({}) end,
                    desc = "Find help",
                },
                {
                    '<leader>fr',
                    function() require("telescope.builtin").resume({}) end,
                    desc = "Resume last search",
                },
            }
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end
        },
        { 'rebelot/kanagawa.nvim' },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
            },
            config = function()
                local cmp = require("cmp")
                cmp.setup({
                    sources = {
                        { name = "nvim_lsp" },
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<Tab>"] = cmp.mapping.select_next_item(),
                        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    }),
                })
            end,
        },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                local harpoon = require("harpoon")
                harpoon:setup()

                vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
                vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

                vim.keymap.set("n", "<leader>&", function() harpoon:list():select(1) end)
                vim.keymap.set("n", "<leader>é", function() harpoon:list():select(2) end)
                vim.keymap.set("n", "<leader>\"", function() harpoon:list():select(3) end)
                vim.keymap.set("n", "<leader>'", function() harpoon:list():select(4) end)           
                end,
            },

        } 
    })

    vim.cmd('colorscheme kanagawa')
    -- Preferences
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.foldenable = false
    vim.opt.foldmethod = 'manual'
    vim.opt.foldlevelstart = 99
    vim.opt.wrap = false
    vim.opt.cmdheight = 1

    vim.opt.shiftwidth = 4
    vim.opt.softtabstop = 4
    vim.opt.tabstop = 4
    vim.opt.expandtab = true
    vim.opt.smarttab = true
    vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

    vim.opt.scrolloff = 2
    -- more useful diffs (nvim -d)
    --- by ignoring whitespace
    vim.opt.diffopt:append('iwhite')
    --- and using a smarter algorithm
    --- https://vimways.org/2018/the-power-of-diff/
    --- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
    --- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
    vim.opt.diffopt:append('algorithm:histogram')
    vim.opt.diffopt:append('indent-heuristic')
    -- show a column at 80 characters as a guide for long lines
    vim.opt.colorcolumn = '80'

    vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•' 
    vim.keymap.set('n', '<leader>,', ':set invlist<cr>')

    -- case-insensitive search/replace
    vim.opt.ignorecase = true
    -- unless uppercase in search term
    vim.opt.smartcase = true

    --" Decent wildmenu
    -- in completion, when there is more than one match,
    -- list all matches, and only complete to longest common match
    vim.opt.wildmode = 'list:longest'

    vim.keymap.set('v', '<C-h>', '<cmd>nohlsearch<cr>')
    vim.keymap.set('n', '<C-h>', '<cmd>nohlsearch<cr>')
    -- Jump to start and end of line using the home row keys
    vim.keymap.set('', 'H', '^')
    vim.keymap.set('', 'L', '$')
    vim.keymap.set('', 'R', ':%s/')

    -- let the left and right arrows be useful: they can switch buffers
    vim.keymap.set('n', '<left>', ':bp<cr>')
    vim.keymap.set('n', '<right>', ':bn<cr>')

    -- handy keymap for replacing up to next _ (like in variable names)
    vim.keymap.set('n', '<leader>m', 'ct_')
    -- F1 is pretty close to Esc, so you probably meant Esc
    vim.keymap.set('', '<F1>', '<Esc>')
    vim.keymap.set('i', '<F1>', '<Esc>')
    vim.api.nvim_set_keymap('n', '<C-f>', ':sus<CR>', { noremap = true, silent = true })

    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
    vim.keymap.set("n", "K", vim.lsp.buf.hover)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
    vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next)

    vim.keymap.set('n', '<leader><leader>', function()
        local alt = vim.fn.bufnr('#')
        local alt_name = vim.fn.bufname(alt)

        if alt ~= -1 and vim.fn.buflisted(alt) == 1 and alt_name ~= '' and vim.fn.isdirectory(alt_name) == 0 then
            vim.cmd('buffer #')
            return
        end

        -- fallback: find most recent file buffer
        for _, buf in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
            if buf.bufnr ~= vim.fn.bufnr('%') and buf.name ~= '' and vim.fn.isdirectory(buf.name) == 0 then
                vim.cmd('buffer ' .. buf.bufnr)
                return
            end
        end

        vim.notify('No alternate file', vim.log.levels.INFO)
    end)



    -- Autocommands
    -- Load where you left off
    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        command = 'silent! normal! g`"'
    })


    vim.diagnostic.config({
        virtual_text = true,      -- inline text at end of line
        signs = true,             -- signs in gutter
        underline = true,         -- underline errors
        update_in_insert = false, -- don't update while typing
        float = { border = "rounded" },
    })

    -- Optional: faster CursorHold (default 4000ms)
    vim.opt.updatetime = 250
