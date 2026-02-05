" ================================
" Ops note helpers (F5 / F6)
" ================================

" Timestamp highlight group (yellow background, black text)
highlight ShrapTimestamp ctermbg=yellow ctermfg=black guibg=yellow guifg=black

" F5: append highlighted timestamp ending with " -- " and put cursor at end of line
function! ShrapInsertTimestamp()
  " Build timestamp like: 2026-02-05 09:41:12 EST -- 
  let l:ts = strftime('%Y-%m-%d %H:%M:%S %Z') . ' -- '

  " Append on a new line below current line
  call append(line('.'), l:ts)

  " Move cursor to end of the new line
  call cursor(line('.') + 1, len(l:ts) + 1)

  " Highlight the whole timestamp line
  call matchaddpos('ShrapTimestamp', [[line('.')]])
endfunction

" Exact fold line as requested
let g:fold_line = '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'

" F6: insert target section and wrap it with fold lines, then fold it
set foldmethod=manual
function! ShrapTargetBlock()
  call append(line('.'), 'ip      -      hostname      -      entityid')
  call append(line('.')+1, '===================================================')
  call append(line('.')+2, g:fold_line)
  call append(line('.')+3, g:fold_line)

  " Create a manual fold over the block we inserted
  execute (line('.')+1).','.(line('.')+4).'fold'

  " Put cursor on the header line (so you can start filling it)
  call cursor(line('.')+1, 1)
endfunction

" Normal mode bindings
nnoremap <F5> :call ShrapInsertTimestamp()<CR>
nnoremap <F6> :call ShrapTargetBlock()<CR>

" Insert mode bindings
inoremap <F5> <Esc>:call ShrapInsertTimestamp()<CR>a
inoremap <F6> <Esc>:call ShrapTargetBlock()<CR>a
