local M = {}

-- Function for debug printing.
function M.debug_print(...)
    local objects = {}
    for i = 1, select('#', ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, '\n'))
    return ...
end

function M.split (inputstr, sep)
   if sep == nil then
      sep = "%s"
   end
   local t = {}
   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      table.insert(t, str)
   end
   return t
end

-- Creates a floating scratch window for quickly viewing information and then
-- discarding.
-- Args:
--      contents:  buffer contents (table)
--      opts (optional): options for nvim_open_win (table)
--            see :h nvim_open_win
function M.floatwin(contents, opts)
    -- Create a new scratch buffer.
    local buf = vim.api.nvim_create_buf(false, true)
    -- Get the current ui.
    local ui = vim.api.nvim_list_uis()[1]

    -- Options for floating window
    -- See :h nvim_open_win
    opts = opts or {
        relative = 'editor',
        width = .75*ui.width,
        height = ui.height - 8,
        anchor = "NW",
        col = 2,
        row = 2,
    }

    -- Load contens into buffer.
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, contents)
    -- Open floating window.
    vim.api.nvim_open_win(buf, true, opts)
end

return M
