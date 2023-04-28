-- Load mappings
require 'user.telescope.mappings'

local telescope = require('telescope')
local map = vim.api.nvim_set_keymap

telescope.setup({
    defaults = {
        layout_strategy = "vertical",
        results_title = false,
        sorting_strategy = "ascending",
        prompt_prefix = "> ",
        selection_caret = "> ",
        layout_config = {
            vertical = {
                width = 0.8,
                height = 0.8,
                preview_height = 0.6,
            },
        },
        vimgrep_arguments = {
            "rg",
             "--color=never",    -- until color codes are interpreted...
             "--no-heading",
             "--with-filename",
             "--line-number",
             "--column",
             "--smart-case",
             "--hidden",
             "--unrestricted",
             "--ignore-file",
             ".gitignore"
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                     -- false does exact matching
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",         -- or "ignore_case", "respect_case"
        },
    },
    ---pickers = {
    ---    find_files = {
    ---        theme = "dropdown",
    ---    },
    ---},
})

telescope.load_extension('fzf')


local M = {}

-- grep_string pre-filtered from grep_prompt
local function grep_filtered(opts)
  opts = opts or {}
  require("telescope.builtin").grep_string {
    path_display = { "smart" },
    search = opts.filter_word or "",
  }
end

-- open vim.ui.input dressing prompt for initial filter
function M.grep_prompt()
  vim.ui.input({ prompt = "Rg> " }, function(input)
    grep_filtered { filter_word = input }
  end)
end

-- This function allows us to find files in the search dirs regardless of where
-- we are in the filesystem.
function M.find_configs()
    require("telescope.builtin").find_files {
        prompt_title = "> (n)vim user configs find",
        results_title = "Config Files Results",
        no_ignore = true,
        --path_display = { "smart" },
        search_dirs = {
            "~/linuxconfig/vimlocal",
        },
    }
end

function M.word_grep()
    local cword = vim.fn.expand("<cword>")
    require("telescope.builtin").live_grep({
        default_text = cword
        })
end

return M
