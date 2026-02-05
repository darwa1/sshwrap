" ================================
" Ops note helpers (F5 / F6)
" ================================

set foldmethod=manual

let g:fold_line = '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'

" Highlight group for timestamp line
highlight ShrapTimestamp ctermbg=yellow ctermfg=black guibg=yellow guifg=black

function! ShrapTimestampBlock()
  let l:ts = strftime('%Y-%m-%d %H:%M:%S %Z')

  " Insert lines
  call append(line('.'), g:fold_line)
  call append(line('.')+1, l:ts)
  call append(line('.')+2, g:fold_line)

  " Create fold
  execute (line('.')+1).','.(line('.')+3).'fold'

  " Highlight timestamp line
  call matchaddpos('ShrapTimestamp', [[line('.')+2]])

endfunction

function! ShrapTargetBlock()
  call append(line('.'), 'ip      -      hostname      -      entityid')
  call append(line('.')+1, '===================================================')
  call append(line('.')+2, g:fold_line)
  call append(line('.')+3, g:fold_line)

  " Create fold
  execute (line('.')+1).','.(line('.')+4).'fold'
endfunction

" Normal mode bindings
nnoremap <F5> :call ShrapTimestampBlock()<CR>
nnoremap <F6> :call ShrapTargetBlock()<CR>

" Insert mode bindings
inoremap <F5> <Esc>:call ShrapTimestampBlock()<CR>a
inoremap <F6> <Esc>:call ShrapTargetBlock()<CR>a
