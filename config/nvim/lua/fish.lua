-- Add fish omnifunc to completion-nvim

local M = {}

function M.getCompletionItems(prefix)
    local items = vim.api.nvim_call_function('fish#Complete',{0, prefix})
    return items
end

M.complete_item = {
    item = M.getCompletionItems
}

return M
