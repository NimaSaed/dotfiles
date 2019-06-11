"""""""""""""""""""""""""""
" Plugins 
"""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'wellle/targets.vim'
Plug 'davidhalter/jedi-vim'
"Plug 'plasticboy/vim-markdown'
Plug 'w0ng/vim-hybrid'
Plug 'iamcco/markdown-preview.vim'
Plug 'junegunn/goyo.vim'
Plug 'WolfgangMehner/bash-support'

call plug#end()
"""""""""""""""""""""""""""

let mapleader =" "
set nocompatible
filetype plugin on 
set path=~/**
set wildmenu

"set laststatus=2
set encoding=utf-8

"fine a way to turn spelling on only when the file is not .txt or .md
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

" Toggle paste mode
set pastetoggle=<F12>

"noremap <Up> <Nop>
"noremap <Down> <Nop>
"noremap <Left> <Nop>
"noremap <Right> <Nop>
"inoremap <Up> <Nop>
"inoremap <Down> <Nop>
"inoremap <Left> <Nop>
"inoremap <Right> <Nop>


" enable search to jump to word
set incsearch

" enable syntax highlighting
syntax enable
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 0 " Remove this line if using the default palette.
set background=dark
colorscheme hybrid
" I dont line the line number color in hybrid
highlight LineNr ctermfg=gray
highlight CursorLineNr ctermfg=red
highlight Visual ctermbg=gray
" turn on/off syntax color 
map <Leader>h :if exists("syntax_on")<BAR>syntax off<BAR>else<BAR>syntax enable <BAR>endif<CR>

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
let g:mkdp_path_to_chrome = 'firefox'
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
    highlight LineNr ctermfg=gray
    highlight CursorLineNr ctermfg=red
    highlight Visual ctermbg=gray
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
