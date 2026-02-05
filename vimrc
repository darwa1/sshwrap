" ==========================================
" ~/.vimrc — shrap ops helpers + persistent folds + persistent timestamp highlight
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

" --- Visual: persistent timestamp highlight via syntax ---
" Highlights ONLY the timestamp portion at the start of a line, before ' -- '
highlight ShrapTimestamp ctermbg=yellow ctermfg=black guibg=yellow guifg=black

augroup ShrapSyntax
  autocmd!
  " Match: YYYY-MM-DD HH:MM:SS ZZZ -- (highlight only up to just before the space- - -)
  " This is intentionally a bit flexible on timezone: 2-6 letters (e.g., EST, UTC, PSTDT)
  autocmd BufRead,BufNewFile * syntax match ShrapTimestamp /^\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2} \u\{2,6}\ze -- /
  autocmd BufRead,BufNewFile * highlight link ShrapTimestamp ShrapTimestamp
augroup END

" Exact fold line as requested
let g:fold_line = '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'

" ==========================================
" F5 — Insert timestamp line (no folds)
"  - Appends: "<timestamp> -- "
"  - Cursor to end of line
"  - Enters insert mode
"  - Highlight is syntax-based and persists across sessions
" ==========================================
function! ShrapInsertTimestamp()
  let l:full = strftime('%Y-%m-%d %H:%M:%S %Z') . ' -- '
  let l:start = line('.')

  call append(l:start, l:full)
  let l:newln = l:start + 1

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
