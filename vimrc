" ==========================================
" ~/.vimrc — shrap ops helpers + fold persistence
" ==========================================

" --- FOLD PERSISTENCE (so manual folds survive reopen) ---
set viewoptions=folds,cursor,curdir
set viewdir=~/.vim/view
silent! call mkdir(&viewdir, "p")

augroup ShrapViews
  autocmd!
  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview
augroup END

" --- Folding style used by our mappings ---
set foldmethod=manual

" --- Visual helpers ---
" Highlight group for timestamp only (before ' -- ')
highlight ShrapTimestamp ctermbg=yellow ctermfg=black guibg=yellow guifg=black

" Track only OUR timestamp match so we don't clobber other matches/plugins
let g:shrap_ts_matchid = -1

" Exact fold line as requested
let g:fold_line = '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'

" ==========================================
" F5 — Insert timestamp line (no folds)
"  - Appends: "<timestamp> -- "
"  - Highlights ONLY the timestamp portion
"  - Moves cursor to end of line
"  - Enters insert mode
" ==========================================
function! ShrapInsertTimestamp()
  let l:ts_only = strftime('%Y-%m-%d %H:%M:%S %Z')
  let l:full    = l:ts_only . ' -- '

  let l:start = line('.')
  call append(l:start, l:full)
  let l:newln = l:start + 1

  " Remove prior timestamp highlight (only ours)
  if g:shrap_ts_matchid != -1
    call matchdelete(g:shrap_ts_matchid)
    let g:shrap_ts_matchid = -1
  endif

  " Highlight ONLY timestamp part
  let g:shrap_ts_matchid = matchaddpos('ShrapTimestamp', [[l:newln, 1, len(l:ts_only)]])

  " Cursor to end + insert mode
  call cursor(l:newln, len(l:full) + 1)
  startinsert
endfunction

" ==========================================
" F6 — Insert target section (with fold lines)
" Format:
"   ip      -      hostname      -      entityid
"   ===================================================
"   <fold_line>
"   <fold_line>
"
" Creates a manual fold over the inserted block.
" ==========================================
function! ShrapTargetBlock()
  let l:start = line('.')

  call append(l:start + 0, 'ip      -      hostname      -      entityid')
  call append(l:start + 1, '===================================================')
  call append(l:start + 2, g:fold_line)
  call append(l:start + 3, g:fold_line)

  " Fold exactly the block we inserted: 4 lines total
  execute (l:start + 1) . ',' . (l:start + 4) . 'fold'

  " Put cursor on header line (so you can fill it)
  call cursor(l:start + 1, 1)
endfunction

" --- Keybindings ---
" Normal mode
nnoremap <F5> :call ShrapInsertTimestamp()<CR>
nnoremap <F6> :call ShrapTargetBlock()<CR>

" Insert mode
inoremap <F5> <Esc>:call ShrapInsertTimestamp()<CR>
inoremap <F6> <Esc>:call ShrapTargetBlock()<CR>a
