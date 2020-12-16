" FileType specifications
let s:lsp_ft = ['c', 'cpp', 'python']
let s:formatprg_ft = {
			\ 'fish': 'fish_indent',
			\ 'markdown': 'pandoc -s -t markdown-fenced_code_attributes',
			\ 'tex': 'latexindent -c=/tmp/'
			\ }

" Run formatters with perfect undo history
function! functions#Format() abort
	" LSP provided formatting
	if index(s:lsp_ft, &ft) >= 0
		lua vim.lsp.buf.formatting_sync(nil, 1000)

	else
		let original_lines = getbufline(bufname(), 1, '$')
		if has_key(s:formatprg_ft, &ft)
			" Format using CLI tools via stdin
			let formatted_lines = split(system(s:formatprg_ft[&ft], original_lines), '\n')
		else
			" Trim trailing whitespace and leading blank lines
			let formatted_lines = split(system("sed 's/[ \t]*$//'", original_lines), '\n')
		endif
		if v:shell_error > 0
			echomsg 'formatprg exited with status ' . v:shell_error
		elseif formatted_lines !=# original_lines
			let view = winsaveview()
			lua vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.api.nvim_eval('formatted_lines'))
			call winrestview(view)
		endif
	endif
endfunction


" Clear blame text on InsertEnter
function! functions#Blame() abort
	lua require'gitlens'.blameVirtText()
	autocmd InsertEnter * ++once lua require'gitlens'.clearBlameVirtText()
endfunction


" Statusline Functions
function! functions#LspErrors() abort
	if index(s:lsp_ft, &ft) >= 0
		let e = luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Error]])")
		return e != 'null' ? 'E:' .. e : ''
	endif
	return ''
endfunction


function! functions#LspWarnings() abort
	if index(s:lsp_ft, &ft) >= 0
		let w = luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Warning]])")
		return w != 'null' ? 'W:' .. w : ''
	endif
	return ''
endfunction

function! functions#LightlineGitGutter() abort
	let status = get(b:, 'gitsigns_status', '0')
	return status != '0' ? ' ' . b:gitsigns_head . ' ' . status : ''
endfunction
