" ==========================================
" ~/.vimrc — shrap ops helpers
"   - persistent manual folds (mkview/loadview)
"   - persistent timestamp highlight (syntax-based)
" ==========================================

" --- Ensure syntax highlighting is enabled ---
syntax enable

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

" --- Exact fold line as requested ---
let g:fold_line = '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/'

" ==========================================
" Persistent timestamp highlight (syntax-based)
" Highlights ONLY the timestamp portion before ' -- '
" Example line:
"   2026-02-05 10:07:31 EST -- something...
" ==========================================

" Define highlight appearance
highlight ShrapTimestamp ctermbg=yellow ctermfg=black guibg=yellow guifg=black

augroup ShrapSyntax
  autocmd!
  " Apply to every buffer window enter/open (so it survives reloads)
  autocmd BufRead,BufNewFile,BufWinEnter * call s:ShrapApplySyntax()
augroup END

function! s:ShrapApplySyntax() abort
  " Avoid duplicate definitions in the same buffer
  silent! syntax clear ShrapTimestamp

  " Robust match:
  " - starts with YYYY-MM-DD HH:MM:SS
  " - then ANYTHING (timezone or other token(s)) until ' -- '
  " - highlight ONLY up to just before ' -- '
  syntax match ShrapTimestamp /^\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2}.\{-}\ze -- /
endfunction

" ==========================================
" F5 — Insert timestamp line (no folds)
"  - Appends: "<timestamp> -- "
"  - Cursor to end of line
"  - Enters insert mode
"  - Highlight persists via syntax rule above
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
