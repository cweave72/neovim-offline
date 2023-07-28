-- nvim-tree setup
--
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    -- Custom keymaps
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Dir Up'))
end


require("nvim-tree").setup({
    on_attach = on_attach,
    sort_by = "extension",
    view = {
        side                        = "left",
        adaptive_size               = false,
        preserve_window_proportions = true,
        number                      = false,
        relativenumber              = false,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
        exclude = {".venv.*"},
        exclude = {"plugged/*"},
    },
})

