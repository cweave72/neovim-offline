-- [[
-- A NVIM plugin for inserting a table-of-contents into a github markdown file.
--
-- Usage in a markdown file:
--      :lua require('ghmdtoc').process()
-- ]]
local utils = require('user.utils')
local ghmdtoc = {}

-- Function which gets all the lines in the current buffer.
-- Returns a table (list) of strings.
local function getBufLines()
    -- Get current buffer handle (number)
    local buf = vim.api.nvim_get_current_buf()
    -- Get all lines in buffer.
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    return lines
end


local function matchSection(line)
    -- Match a section header
    -- "## Section title"
    local patt = "^([#]+)%s(.+)"
    local depth
    local s, title = string.match(line, patt)
    --print(string.format("line: %s; s = %s, title = %s", line, s, title))

    if s ~= nil then
        -- Save the section depth.
        depth = string.len(s)
    else
        return nil, nil
    end

    --print(string.format("line: %s; depth: %s; title = %s", line, depth, title))
    return depth, title
end

-- Function which finds the toc start/end tag "tocstart" or "tocend"
local function findTocTag(lines, tag)
    local patt = "^%[//%]: " .. tag
    for i, line in pairs(lines) do
        if string.match(line, patt) ~= nil then
            return i
        end
    end
    return nil
end

local function getSections(lines)
    local sections = {}
    for _, line in pairs(lines) do
        local depth, title = matchSection(line)

        if depth ~= nil then
            --print(string.format("Adding: depth=%d; title=%s", depth, title))
            table.insert(sections, { depth = depth-1, title = title })
        end
    end
    return sections
end

local function tocEntry(title, depth, indent)
    indent = indent or 4
    -- Create the link text.
    local link = string.lower(title)
    link = string.gsub(link, "%s", "-")

    local line = string.format("%s* [%s](#%s)",
        string.rep(" ", depth*indent),
        title, link)
    return line
end

-- Deletes a range of buffer lines.
local function deleteLines(start, stop)
    print(string.format("Deleting lines %d to %d", start, stop))
    vim.api.nvim_buf_set_lines(0, start, stop, true, {})
end

local function insertLines(start, lines)
    print(string.format("Inserting starting at line %d", start))
    vim.api.nvim_buf_set_lines(0, start, start, true, lines)
end

function ghmdtoc.process()
    -- Get lines from buffer.
    local lines = getBufLines()
    -- Get current tags
    local tocstart = findTocTag(lines, "tocstart")
    local tocend = findTocTag(lines, "tocend")
    -- Get document sections.
    local sections = getSections(lines)

    --utils.debug_print({tocstart = tocstart, tocend = tocend})
    --utils.debug_print(sections)

    if #sections ~= 0 then
        local toctext = {}
        table.insert(toctext, "[//]: tocstart")
        table.insert(toctext, "Table of Contents")
        table.insert(toctext, "-----------------")
        for _, s in pairs(sections) do
            table.insert(toctext, tocEntry(s.title, s.depth, 2))
        end
        table.insert(toctext, "")
        table.insert(toctext, "[//]: tocend")

        --utils.debug_print(toctext)

        if tocstart ~= nil and tocend ~= nil then
            -- Delete current toc line range.
            -- Note: must adjust index by -1 because vim buffers are zero-based.
            deleteLines(tocstart-1, tocend)
            -- Insert new toc into the buffer.
            insertLines(tocstart-1, toctext)
        elseif tocstart == nil and tocend == nil then
            --utils.debug_print(sections)
            insertLines(0, toctext)
        else
            print("Error with toc tags.")
            return
        end

    else
        print("No sections found in document.")
    end
end

return ghmdtoc
