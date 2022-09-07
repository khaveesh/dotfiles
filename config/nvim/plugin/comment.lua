-- MIT License Copyright (c) 2021 Evgeni Chasnovski

-- Documentation ==============================================================
--- Minimal and fast Lua module for code commenting. This is basically a
--- reimplementation of "tpope/vim-commentary". Commenting in Normal mode
--- respects |count| and is dot-repeatable. Comment structure is inferred
--- from 'commentstring'. Handles both tab and space indenting (but not when
--- they are mixed).
---
--- What it doesn't do:
--- - Block and sub-line comments. This will only support per-line commenting.
--- - Configurable (from module) comment structure. Modify |commentstring|
---   instead. To enhance support for commenting in multi-language files, see
---   "JoosepAlviste/nvim-ts-context-commentstring" plugin along with `hooks`
---   option of this module (see |MiniComment.config|).
--- - Handle indentation with mixed tab and space.
--- - Preserve trailing white space in empty lines.
---
---@tag mini.comment
---@tag MiniComment
---@toc_entry Comment

-- Module definition ==========================================================
local MiniComment = {}
local H = {}

--- Module config
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
MiniComment.config = {
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = 'gc',
    comment_yank = 'yc',

    -- Toggle comment on current line
    line_textobject = 'c',

    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    comment_textobject = 'gc',
  },
}
--minidoc_afterlines_end

-- Module functionality =======================================================
--- Main function to be mapped
---
--- It is meant to be used in expression mappings (see |map-<expr>|) to enable
--- dot-repeatability and commenting on range. There is no need to do this
--- manually, everything is done inside |MiniComment.setup()|.
---
--- It has a somewhat unintuitive logic (because of how expression mapping with
--- dot-repeatability works): it should be called without arguments inside
--- expression mapping and with argument when action should be performed.
---
---@param mode string Optional string with 'operatorfunc' mode (see |g@|).
---
---@return string 'g@' if called without argument, '' otherwise (but after
---   performing action).
MiniComment.operator = function(mode)
  -- If used without arguments inside expression mapping:
  -- - Set itself as `operatorfunc` to be called later to perform action.
  -- - Return 'g@' which will then be executed resulting into waiting for a
  --   motion or text object. This textobject will then be recorded using `'[`
  --   and `']` marks. After that, `operatorfunc` is called with `mode` equal
  --   to one of "line", "char", or "block".
  -- NOTE: setting `operatorfunc` inside this function enables usage of 'count'
  -- like `10gc_` toggles comments of 10 lines below (starting with current).
  if mode == nil then
    vim.o.operatorfunc = 'v:lua.MiniComment.operator'
    return 'g@'
  end

  -- If called with non-nil `mode`, get target region and perform comment
  -- toggling over it.
  local mark_left, mark_right = '[', ']'
  if mode == 'visual' then
    mark_left, mark_right = '<', '>'
  end

  local line_left, col_left = unpack(vim.api.nvim_buf_get_mark(0, mark_left))
  local line_right, col_right = unpack(vim.api.nvim_buf_get_mark(0, mark_right))

  -- Do nothing if "left" mark is not on the left (earlier in text) of "right"
  -- mark (indicating that there is nothing to do, like in comment textobject).
  if (line_left > line_right) or (line_left == line_right and col_left > col_right) then return end

  -- Using `vim.cmd()` wrapper to allow usage of `lockmarks` command, because
  -- raw execution will delete marks inside region (due to
  -- `vim.api.nvim_buf_set_lines()`).
  vim.cmd(string.format('lockmarks lua MiniComment.toggle_lines(%d, %d)', line_left, line_right))
  return ''
end

MiniComment.operator_yank = function(mode)
  -- If used without arguments inside expression mapping:
  -- - Set itself as `operatorfunc` to be called later to perform action.
  -- - Return 'g@' which will then be executed resulting into waiting for a
  --   motion or text object. This textobject will then be recorded using `'[`
  --   and `']` marks. After that, `operatorfunc` is called with `mode` equal
  --   to one of "line", "char", or "block".
  -- NOTE: setting `operatorfunc` inside this function enables usage of 'count'
  -- like `10gc_` toggles comments of 10 lines below (starting with current).
  if mode == nil then
    vim.o.operatorfunc = 'v:lua.MiniComment.operator_yank'
    return 'g@'
  end

  -- If called with non-nil `mode`, get target region and perform comment
  -- toggling over it.
  local mark_left, mark_right = '[', ']'
  if mode == 'visual' then
    mark_left, mark_right = '<', '>'
  end

  local line_left, col_left = unpack(vim.api.nvim_buf_get_mark(0, mark_left))
  local line_right, col_right = unpack(vim.api.nvim_buf_get_mark(0, mark_right))

  -- Do nothing if "left" mark is not on the left (earlier in text) of "right"
  -- mark (indicating that there is nothing to do, like in comment textobject).
  if (line_left > line_right) or (line_left == line_right and col_left > col_right) then return end

  local content = vim.api.nvim_buf_get_lines(0, line_left - 1, line_right, true)
  vim.fn.setreg(vim.v.register, content)

  -- Using `vim.cmd()` wrapper to allow usage of `lockmarks` command, because
  -- raw execution will delete marks inside region (due to
  -- `vim.api.nvim_buf_set_lines()`).
  vim.cmd(string.format('lockmarks lua MiniComment.toggle_lines(%d, %d)', line_left, line_right))
  return ''
end

--- Toggle comments between two line numbers
---
--- It uncomments if lines are comment (every line is a comment) and comments
--- otherwise. It respects indentation and doesn't insert trailing
--- white space. Toggle commenting not in visual mode is also dot-repeatable
--- and respects |count|.
---
--- # Notes~
---
--- 1. Currently call to this function will remove marks inside written range.
---    Use |lockmarks| to preserve marks.
---
---@param line_start number Start line number (inclusive from 1 to number of lines).
---@param line_end number End line number (inclusive from 1 to number of lines).
MiniComment.toggle_lines = function(line_start, line_end)
  local n_lines = vim.api.nvim_buf_line_count(0)
  if not (1 <= line_start and line_start <= n_lines and 1 <= line_end and line_end <= n_lines) then
    error(
      ('(mini.comment) `line_start` and `line_end` should be within range [1; %s].'):format(n_lines)
    )
  end
  if not (line_start <= line_end) then
    error('(mini.comment) `line_start` should be less than or equal to `line_end`.')
  end

  local comment_parts = H.make_comment_parts()
  local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
  local indent, is_comment = H.get_lines_info(lines, comment_parts)

  local f
  if is_comment then
    f = H.make_uncomment_function(comment_parts)
  else
    f = H.make_comment_function(comment_parts, indent)
  end

  for n, l in pairs(lines) do
    lines[n] = f(l)
  end

  -- NOTE: This function call removes marks inside written range. To write
  -- lines in a way that saves marks, use one of:
  -- - `lockmarks` command when doing mapping (current approach).
  -- - `vim.fn.setline(line_start, lines)`, but this is **considerably**
  --   slower: on 10000 lines 280ms compared to 40ms currently.
  vim.api.nvim_buf_set_lines(0, line_start - 1, line_end, false, lines)
end

--- Comment textobject
---
--- This selects all commented lines adjacent to cursor line (if it itself is
--- commented). Designed to be used with operator mode mappings (see |mapmode-o|).
MiniComment.textobject = function()
  local comment_parts = H.make_comment_parts()
  local comment_check = H.make_comment_check(comment_parts)
  local line_cur = vim.api.nvim_win_get_cursor(0)[1]

  if comment_check(vim.api.nvim_get_current_line()) then
    local line_start = line_cur
    while (line_start >= 2) and comment_check(H.getline(line_start - 1)) do
      line_start = line_start - 1
    end

    local line_end = line_cur
    local n_lines = vim.api.nvim_buf_line_count(0)
    while (line_end <= n_lines - 1) and comment_check(H.getline(line_end + 1)) do
      line_end = line_end + 1
    end

    -- This visual selection doesn't seem to change `'<` and `'>` marks when
    -- executed as `onoremap` mapping
    vim.cmd(string.format('normal! %dGV%dG', line_start, line_end))
  end
end

-- Helper data ================================================================
-- Module default config
H.default_config = MiniComment.config

-- Helper functionality =======================================================
-- Settings -------------------------------------------------------------------
H.setup_config = function(config)
  -- General idea: if some table elements are not present in user-supplied
  -- `config`, take them from default config
  vim.validate({ config = { config, 'table', true } })
  config = vim.tbl_deep_extend('force', H.default_config, config or {})

  -- Validate per nesting level to produce correct error message
  vim.validate({
    mappings = { config.mappings, 'table' },
  })

  vim.validate({
    ['mappings.comment'] = { config.mappings.comment, 'string' },
    ['mappings.comment_yank'] = { config.mappings.comment_yank, 'string' },
    ['mappings.line_textobject'] = { config.mappings.line_textobject, 'string' },
    ['mappings.comment_textobject'] = { config.mappings.comment_textobject, 'string' },
  })

  return config
end

H.apply_config = function(config)
  MiniComment.config = config

  -- Make mappings
  vim.keymap.set(
    'n',
    config.mappings.comment,
    MiniComment.operator,
    { expr = true, desc = 'Comment' }
  )
  vim.keymap.set(
    'x',
    config.mappings.comment,
    -- Using `:<c-u>` instead of `<cmd>` as latter results into executing before
    -- proper update of `'<` and `'>` marks which is needed to work correctly.
    [[:<c-u>lua MiniComment.operator('visual')<cr>]],
    { desc = 'Comment selection' }
  )

  vim.keymap.set(
    'n',
    config.mappings.comment_yank,
    MiniComment.operator_yank,
    { expr = true, desc = 'Yank and Comment' }
  )
  vim.keymap.set(
    'x',
    config.mappings.comment_yank,
    -- Using `:<c-u>` instead of `<cmd>` as latter results into executing before
    -- proper update of `'<` and `'>` marks which is needed to work correctly.
    [[:<c-u>lua MiniComment.operator_yank('visual')<cr>]],
    { desc = 'Yank and Comment selection' }
  )

  vim.keymap.set('o', config.mappings.line_textobject, '_', { desc = 'Line textobject' })
  vim.keymap.set(
    'o',
    config.mappings.comment_textobject,
    MiniComment.textobject,
    { desc = 'Comment textobject' }
  )
end

-- Core implementations -------------------------------------------------------
H.make_comment_parts = function()
  local cs = vim.bo.commentstring

  if cs == '' then
    print([[(mini.comment) Option 'commentstring' is empty.]])
    return { left = '', right = '' }
  end

  -- Assumed structure of 'commentstring':
  -- <space> <left> <space> <'%s'> <space> <right> <space>
  -- So this extracts parts without surrounding white space
  local left, right = cs:match('^%s*(.-)%s*%%s%s*(.-)%s*$')
  return { left = left, right = right }
end

H.make_comment_check = function(comment_parts)
  local l, r = comment_parts.left, comment_parts.right
  -- String is commented if it has structure:
  -- <space> <left> <anything> <right> <space>
  local regex = string.format('^%%s-%s.*%s%%s-$', vim.pesc(l), vim.pesc(r))

  return function(line) return line:find(regex) ~= nil end
end

H.get_lines_info = function(lines, comment_parts)
  local n_indent, n_indent_cur = math.huge, math.huge
  local indent, indent_cur

  local is_comment = true
  local comment_check = H.make_comment_check(comment_parts)

  for _, l in pairs(lines) do
    -- Update lines indent: minimum of all indents except empty lines
    if n_indent > 0 then
      _, n_indent_cur, indent_cur = l:find('^(%s*)')
      -- Condition "current n-indent equals line length" detects empty line
      if (n_indent_cur < n_indent) and (n_indent_cur < l:len()) then
        -- NOTE: Copy of actual indent instead of recreating it with `n_indent`
        -- allows to handle both tabs and spaces
        n_indent = n_indent_cur
        indent = indent_cur
      end
    end

    -- Update comment info: lines are comment if every single line is comment
    if l ~= '' and is_comment then is_comment = comment_check(l) end
  end

  -- `indent` can still be `nil` in case all `lines` are empty
  return indent or '', is_comment
end

H.make_comment_function = function(comment_parts, indent)
  -- NOTE: this assumes that indent doesn't mix tabs with spaces
  local nonindent_start = indent:len() + 1

  local l, r = comment_parts.left, comment_parts.right
  local lpad = (l == '') and '' or ' '
  local rpad = (r == '') and '' or ' '

  local empty_comment = ''
  -- Escape literal '%' symbols in comment parts (like in LaTeX) to be '%%'
  -- because they have special meaning in `string.format` input. NOTE: don't
  -- use `vim.pesc()` here because it also escapes other special characters
  -- (like '-', '*', etc.).
  local nonempty_format = indent
    .. l:gsub('%%', '%%%%')
    .. lpad
    .. '%s'
    .. rpad
    .. r:gsub('%%', '%%%%')

  return function(line)
    -- Line is empty if it doesn't have anything except white space
    if line:find('^%s*$') ~= nil then
      -- If doesn't want to comment empty lines, return `line` here
      return empty_comment
    else
      return string.format(nonempty_format, line:sub(nonindent_start))
    end
  end
end

H.make_uncomment_function = function(comment_parts)
  local l, r = comment_parts.left, comment_parts.right
  local lpad = (l == '') and '' or '[ ]?'
  local rpad = (r == '') and '' or '[ ]?'

  -- Usage of `lpad` and `rpad` as possbile single space enables uncommenting
  -- of commented empty lines without trailing white space (like '  #').
  local uncomment_regex =
    string.format('^(%%s*)%s%s(.-)%s%s%%s-$', vim.pesc(l), lpad, rpad, vim.pesc(r))

  return function(line)
    local indent, new_line = string.match(line, uncomment_regex)
    -- Return original if line is not commented
    if new_line == nil then return line end
    -- Remove indent if line is a commented empty line
    if new_line == '' then indent = '' end
    return ('%s%s'):format(indent, new_line)
  end
end

-- Utilities ------------------------------------------------------------------
function H.getline(line_no) return vim.api.nvim_buf_get_lines(0, line_no - 1, line_no, true)[1] end

--- Module setup
-- Export module
_G.MiniComment = MiniComment

-- Setup config
config = H.setup_config(config)

-- Apply config
H.apply_config(config)

vim.api.nvim_create_user_command(
  'Comment',
  'lockmarks lua MiniComment.toggle_lines(<line1>, <line2>)',
  { range = true }
)
