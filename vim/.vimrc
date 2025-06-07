" vim:foldmethod=marker:foldlevel=0

" Plugins {{{
call plug#begin('~/.vim/plugged')

" To align text using tabs automaticly.
Plug 'godlygeek/tabular'

" Do I really need this?
"Plug 'davidhalter/jedi-vim'

" my color baseline
Plug 'chriskempson/base16-vim'

" Syntax highlight for different languages
Plug 'sheerun/vim-polyglot'

" use gx to open links in browser
Plug 'tyru/open-browser.vim'

"Plug 'elzr/vim-json'

"Codeium AI
Plug 'exafunction/codeium.vim'

call plug#end()

" }}}

" General Setting {{{

let mapleader = " "

" Make backspace work
set bs=2

filetype plugin on
set path+=**
set wildmenu
"Set wildignore+=

"Set clipboard to be shared with middle click
"set clipboard=unnamedplus
set clipboard=unnamed


"set laststatus=2
set encoding=utf-8

" Toggle paste mode
set pastetoggle=<F12>

" Disable arrow keys
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

" set tabs to have 8 spaces
"set ts=2
set tabstop=2

" expand tabs into spaces
set expandtab

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=2

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

" Bacon ipsum

function Ipsum()
    execute 'read' . '!curl -s "https://baconipsum.com/api/?start-with-lorem=1&type=all-meat&format=text&paras='.v:count1.'"'
endfunction
map ipsum :<C-U>call Ipsum()<CR>o

" to auto save files on any changes
" autocmd TextChanged,TextChangedI <buffer> if &readonly == 0 && filereadable(bufname('%')) | silent write | endif

" check one time after 4s of inactivity in normal mode
" set autoread | au CursorHold * checktime | call feedkeys("lh")

" }}}

" Spelling {{{
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
map <leader>s :setlocal spell! spelllang=en <bar> call HighlighColor() <CR>

" Do not check url spelling (thanks to http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/)
autocmd BufRead * syn match UrlNoSpell '\w\+:\/\/[^[:space:]]\+' contains=@NoSpell

" }}}

" Colors {{{

autocmd VimEnter * call HighlighColor()

function! HighlighColor()
    " enable syntax highlighting
    syntax enable
    colorscheme base16-solarized-light
    highlight Normal guibg=NONE ctermbg=NONE

    " Numbers color
    highlight LineNr ctermfg=NONE ctermbg=NONE
    highlight CursorLineNr ctermfg=9 ctermbg=0

    " Menu color (auto complete)
    highlight Pmenu ctermfg=0 ctermbg=12
    highlight PmenuSel ctermfg=0 ctermbg=9

    " Status line and wild menu colots
    highlight StatusLine ctermbg=15 ctermfg=0
    highlight WildMenu ctermbg=12 ctermfg=0

    " Selected text in visual mode
    highlight Visual ctermbg=15

    " Folded Color
    highlight Folded ctermfg=0 ctermbg=12

    " Spelling Color
    highlight SpellBad term=reverse cterm=undercurl ctermbg=224 gui=undercurl guisp=#dc322f
    highlight SpellCap term=reverse cterm=undercurl ctermbg=81 gui=undercurl guisp=#268bd2
    highlight SpellLocal term=underline cterm=undercurl ctermbg=14 gui=undercurl guisp=#2aa198
    highlight SpellRare  term=reverse cterm=undercurl ctermbg=225 gui=undercurl guisp=#6c71c4

endfunction

" turn on/off syntax color
function! ToggleHighlighColor()
    if exists("g:syntax_on")
        syntax off
    else
        syntax enable
        call HighlighColor()
    endif
endfunction

map <Leader>h :call ToggleHighlighColor()<CR>

" }}}

" Markdown preview {{{

map <leader>v : ! ~/.scripts/md_convert.sh '%'<bar> xargs -I {} bash -c "open '{}'; sleep 1; rm '{}'"<CR><CR>
map <leader>p : ! ~/.scripts/makeslides '%'<bar> xargs -I {} bash -c "open '{}'; sleep 1; rm '{}'"<CR><CR>

" }}}

" Markdown Snippets {{{

" to enable folding in markdown.
let g:markdown_folding = 1
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

autocmd Filetype markdown inoremap ,sh ---<Enter>title: Title<++><Enter>subtitle: Subtitle<++><Enter>author: Author<++><enter>date: Date<++><Enter>theme: Boadilla<Enter>classoption: aspectratio=169<Enter>---<++><Esc>7k

autocmd Filetype markdown inoremap ,wh # Things to get done on week <ESC>:read !date '+\%V'<CR>I<backspace><ESC>o
autocmd Filetype markdown inoremap ,d <ESC>:read ! date '+\%A \%d \%B \%y'<CR>I<backspace><ESC>o
autocmd Filetype markdown inoremap ,D <ESC>:read ! date '+\%A \%d \%B \%y \%H:\%M'<CR>I<backspace><ESC>o

autocmd Filetype markdown inoremap ,gwr # Security Team Report Week <ESC>:read !date '+\%V'<CR>I<backspace><ESC>A, <ESC>:read !date '+\%Y'<CR>I<backspace><ESC>o<CR><CR>## Actions taken this week<CR><CR><++><CR><CR>## Actions planned for next week<CR><CR><++><CR><CR>## Progress of implementation of framework<CR><CR><++><CR><CR>## Security issues (high/medium) found this week<CR><CR><++><CR><CR>## Overview of actions + owners<CR><CR><++><ESC>18k^

" Mark task as done
map <leader>d ci[x<Esc>0
" Mark task as special
map <leader>o ci[o<Esc>0
" Mark task as move forward
map <leader>m 0f[dwdwi> <Esc>0

" }}}

" Save fold {{{
augroup saveFolding
    autocmd!
    autocmd BufWinLeave note_index.md mkview
    autocmd BufWinEnter note_index.md silent loadview
augroup END

" }}}

" Bash Snippets {{{
autocmd Filetype sh map <Space><Space> <Esc>/<++><Enter>"_c4l

autocmd Filetype sh inoremap \sh #!/usr/bin/env bash<CR>set -o nounset # Treat unset variables as an error
autocmd Filetype sh inoremap \for for i in $ ;<CR>do<CR><++><CR>done<Esc><<3kf$a

"================================================================================
" To add banner list this
"================================================================================
autocmd Filetype sh inoremap \ban <Esc>80i=<Esc>A<Enter><Enter><Esc>80i=<Esc>k^i<space>

" }}}

" show line numbers {{{
set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" }}}

" Openbrower Setting {{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" }}}

" Jedi Settings {{{

let g:jedi#completions_command = "<leader>c"

" }}}

" HTML Snippets {{{

autocmd Filetype html map <Space><Space> <Esc>/<++><Enter>"_c4l
autocmd Filetype html inoremap ,html <html><CR><head><CR><title><++></title><CR></head><CR><body><CR></body><CR></html><ESC>6k^
autocmd Filetype html inoremap ,script <script src="<++>"></script><Esc>^

" }}}
