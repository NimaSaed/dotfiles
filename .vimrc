"""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'wellle/targets.vim'
Plug 'davidhalter/jedi-vim'
Plug 'chriskempson/base16-vim'
Plug 'iamcco/markdown-preview.vim'
Plug 'junegunn/goyo.vim'

call plug#end()
"""""""""""""""""""""""""""
let mapleader = " "
filetype plugin on
set path=/home/nima/**
set wildmenu

"Set clipboard to be shared with middle click
set clipboard=unnamed

"set laststatus=2
set encoding=utf-8

"Turn spelling on only when the file is .txt, .md or gitcommit
augroup markdownSpell
    autocmd!
    autocmd FileType markdown setlocal spell
    autocmd BufRead,BufNewFile *.md setlocal spell
    autocmd FileType text setlocal spell
    autocmd BufRead,BufNewFile *.txt setlocal spell
    autocmd FileType gitcommit setlocal spell
augroup END
set spelllang=en

" Turn on spelling on/off
map <leader>s :setlocal spell! spelllang=en_us<CR>

" Do not check url spelling (thanks to http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/)
autocmd BufRead * syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

" Toggle paste mode
set pastetoggle=<F12>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

" remove all white spaces at the end of lines when I save the file
autocmd BufWritePre * %s/\s\+$//e

" enable search to jump to word
set incsearch

" enable search highlight
set hlsearch

" enable syntax highlighting
syntax enable
colorscheme base16-solarized-light
highlight LineNr ctermfg=none ctermbg=none
highlight CursorLineNr ctermbg=none ctermfg=red

" turn on/off syntax color
function! HighlighColor()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
        highlight LineNr ctermfg=none ctermbg=none
        highlight CursorLineNr ctermbg=none ctermfg=red
    endif
endfunction

map <Leader>h :call HighlighColor()<CR>

" show line numbers
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" set tabs to have 4 spaces
set ts=4
set tabstop=4

" expand tabs into spaces
set expandtab

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

" indent when moving to the next line while writing code
" set autoindent

" wrap indentation
set breakindent

" show a visual line under the cursor's current line
" set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" enable all Python syntax highlighting features
let python_highlight_all = 1

" Turn off the beep sounds
set visualbell

" Using mouse for Vim
" To Disable mouse hold down shift key
" set mouse=a

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""" Markdown preview
""""""""""""""""""""""""""""""""""""""
let g:mkdp_path_to_chrome = 'firefox --profile ~/.mozilla/firefox/5d4xorxm.frameless/'
map <leader>v :MarkdownPreview<CR>
map <leader>b :MarkdownPreviewStop<CR>

""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""" Save fold
""""""""""""""""""""""""""""""""""""""
augroup saveFolding
    autocmd!
    autocmd BufWinLeave note_index.md mkview
    autocmd BufWinEnter note_index.md silent loadview
augroup END

""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""" Markdown Syntax
""""""""""""""""""""""""""""""""""""""
"let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_new_list_item_indent = 0
""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""" Goyo
""""""""""""""""""""""""""""""""""""""
let g:goyo_width = 75
let g:goyo_height = 35
map <leader>r :Goyo<CR>

function! s:goyo_enter()
    augroup numbertoggle
      set nonumber norelativenumber
      autocmd!
      autocmd BufEnter,FocusGained,InsertLeave * set norelativenumber
      autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END
endfunction

function! s:goyo_leave()
    augroup numbertoggle
      set number relativenumber
      autocmd!
      autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
      autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END
        highlight LineNr ctermfg=none ctermbg=none
        highlight CursorLineNr ctermbg=none ctermfg=red
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""" Markdown Snippets
""""""""""""""""""""""""""""""""""""""
autocmd Filetype markdown map <Space><Space> <Esc>/<++><Enter>"_c4l

autocmd Filetype markdown inoremap ,1 #<Space>
autocmd Filetype markdown inoremap ,2 ##<Space>
autocmd Filetype markdown inoremap ,3 ###<Space>
autocmd Filetype markdown inoremap ,4 ####<Space>
autocmd Filetype markdown inoremap ,5 #####<Space>
autocmd Filetype markdown inoremap ,6 ######<Space>

autocmd Filetype markdown inoremap ,s ~~~~<++><Esc>F~hi
autocmd Filetype markdown inoremap ,b ****<++><Esc>F*hi
autocmd Filetype markdown inoremap ,e **<++><Esc>F*i

autocmd Filetype markdown inoremap ,h ---<Enter>

autocmd Filetype markdown inoremap ,i ![](<++>)<++><Esc>F[a
autocmd Filetype markdown inoremap ,l [](<++>)<++><Esc>F[a
autocmd Filetype markdown inoremap ,c ```<Enter><Enter>```<++><Esc>ki

autocmd Filetype markdown inoremap ,q ><Space>
autocmd Filetype markdown inoremap ,t -<Space>[<Space>]<Space>

autocmd Filetype markdown inoremap ,at !!!<space>info "Attendees:"
autocmd Filetype markdown inoremap ,an !!!<space>note "Note:"
autocmd Filetype markdown inoremap ,ac !!!<space>example "Action Items:"

" Mark task as done
map <leader>d ci[x<Esc>0
" Mark task as special
map <leader>o ci[o<Esc>0
" Mark task as move forward
map <leader>m 0f[dwdwi> <Esc>0

"================================================================================
" To add banner list this
"================================================================================
autocmd Filetype * inoremap \ban <Esc>80i=<Esc>A<Enter><Enter><Esc>80i=<Esc>k^i<space>
