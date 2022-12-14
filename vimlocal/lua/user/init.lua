local utils = require('user.utils')

-- Neovim-specific intializations
--
local map = vim.api.nvim_set_keymap

--require('nightfox').load('nightfox')
--require('nightfox').load('nordfox')

--vim.cmd("colorscheme iceberg")
--vim.cmd("colorscheme nordfox")
--vim.cmd("colorscheme nightfox")
vim.cmd("colorscheme sonokai")


-- Load Lua user initializations
require('user.lsp_config')
require('user.telescope.init')

-- nvim-tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})


-- Custom functions
--
function ShowRtp()
    local rtpList = utils.split(vim.o.runtimepath, ',')
    table.insert(rtpList, 1, "-- runtimepath --")
    utils.floatwin(rtpList)
end

-- Set Vim's notify function to use notify-nvim.
vim.notify = require('notify')

-- Keymaps
--
local opts = { noremap = true, silent = true }

map('n', '<space>li', ":LspInfo<CR>", opts)
-- Map <Esc> to exit insert mode in terminal.
map('t', '<Esc>', "<C-\\><C-n>", opts)

-- Custom Commands
vim.cmd("command! ShowRtp lua ShowRtp()")
vim.cmd("command! MdTOC lua require('ghmdtoc').process()")
