local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


-- Keymaps

-- General
--
-- Map <Esc> to exit insert mode in terminal.
map('t', '<Esc>', "<C-\\><C-n>", opts)

-- LSP
--
map('n', '<space>li', ":LspInfo<CR>", opts)

-- NvimTree
--
map('n', '<space>o', ":NvimTreeToggle<CR>", opts)
map('n', '<space>p', ":NvimTreeFocus<CR>", opts)


-- Custom Commands
vim.cmd("command! ShowRtp lua ShowRtp()")
vim.cmd("command! MdTOC lua require('ghmdtoc').process()")
