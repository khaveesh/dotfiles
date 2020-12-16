" Add fish as a completion source to completion-nvim
lua require'completion'.addCompletionSource('fish', require'fish'.complete_item)
