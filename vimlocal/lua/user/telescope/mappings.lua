-- Keymaps
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Builtins
map('n', '<space>ff', ":lua require('telescope.builtin').find_files {follow = true}<CR>", opts)
map('n', '<space>fb', ":lua require('telescope.builtin').file_browser()<CR>", opts)
map('n', '<space>fg', ":lua require('telescope.builtin').live_grep()<CR>", opts)
map('n', '<space>h', ":lua require('telescope.builtin').help_tags()<CR>", opts)
map('n', '<space>b', ":lua require('telescope.builtin').buffers()<CR>", opts)
map('n', '<space>k', ":lua require('telescope.builtin').keymaps()<CR>", opts)

-- Custom funcs
map('n', '<space>wg', ":lua require('user.telescope.init').word_grep()<CR>", opts)
map('n', '<space>g', ":lua require('user.telescope.init').grep_prompt()<CR>", opts)
map('n', '<space>c', ":lua require('user.telescope.init').find_configs()<CR>", opts)
