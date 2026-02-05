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
  execute (line('.')+1
