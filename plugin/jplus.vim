scriptencoding utf-8
if exists('g:loaded_jplus')
  finish
endif
let g:loaded_jplus = 1

let s:save_cpo = &cpo
set cpo&vim


function! s:config(base)
	return jplus#get_config(&filetype, a:base)
endfunction


function! s:input_config(input, base)
	return jplus#get_input_config(a:input, &filetype, a:base)
endfunction

function! s:jplus(config)
	let s:current_mode = mode(1)
	let s:current_config = a:config
	let &operatorfunc = 'Jplus'
	" second `g@` as a dummy motion
	return s:is_visual(s:current_mode) ? 'g@' : 'g@g@'
endfunction

" register to &operatorfunc
function! Jplus(motion_wiseness)
	let s:current_config = get(s:, 'current_config', s:config({}))
	let s:current_mode = get(s:, 'current_mode', mode(1))
	call jplus#join(s:current_config, s:current_mode)
endfunction

function! s:is_visual(mode)
	return (a:mode =~# "[vV\<C-v>]")
endfunction


noremap <silent><expr> <Plug>(jplus-getchar)
\	<SID>jplus(<SID>input_config(jplus#getchar(), {}))

noremap <silent><expr> <Plug>(jplus-getchar-with-space)
\	<SID>jplus(<SID>input_config(jplus#getchar(), { "delimiter_format" : " %d " }))

noremap <silent><expr> <Plug>(jplus-input)
\	<SID>jplus(<SID>input_config(input("Input joint delimiter : "), {}))

noremap <silent><expr> <Plug>(jplus-input-with-space)
\	<SID>jplus(<SID>input_config(input("Input joint delimiter :"), { "delimiter_format" : " %d " }))

noremap <silent><expr> <Plug>(jplus)
\	<SID>jplus(<SID>config({}))


let &cpo = s:save_cpo
unlet s:save_cpo
