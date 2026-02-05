" ================================
" Ops note helpers (F5 / F6)
" ================================

" Highlight group for timestamp only
highlight ShrapTimestamp ctermbg=yellow ctermfg=black guibg=yellow guifg=black

function! ShrapInsertTimestamp()
  " Timestamp text (without the trailing separator)
  let l:ts_only = strftime('%Y-%m-%d %H:%M:%S %Z')
  let l:full = l:ts_only . ' -- '

  " Append on a new line below current line
  call append(line('.'), l:full)

  " New line number
  let l:newln = line('.') + 1

  " Highlight ONLY the timestamp portion
  " matchaddpos format: [ [line, col, length] ]
  call matchaddpos('ShrapTimestamp', [[l:newln, 1, len(l:ts_only)]])

  " Move cursor to end of line (1-based column)
  call cursor(l:newln, len(l:full) + 1)

  " Enter insert mode
  startinsert
endfunction

" Exact fold line as requested
let g:fold_line = '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'

set foldmethod=manual
function! ShrapTargetBlock()
  call append(line('.'), 'ip      -      hostname      -      entityid')
  call append(line('.')+1, '===================================================')
  call append(line('.')+2, g:fold_line)
  call append(line('.')+3, g:fold_line)

  " Create a manual fold over the block
  execute (line('.')+1).','.(line('.')+4).'fold'

  " Put cursor on the header line
  call cursor(line('.')+1, 1)
endfunction

" Normal mode bindings
nnoremap <F5> :call ShrapInsertTimestamp()<CR>
nnoremap <F6> :call ShrapTargetBlock()<CR>

" Insert mode bindings
inoremap <F5> <Esc>:call ShrapInsertTimestamp()<CR>
inoremap <F6> <Esc>:call ShrapTargetBlock()<CR>a
