" ============================================================================
" 1. GENERAL SETTINGS & SYSTEM INTEGRATION
" ============================================================================
set nocompatible                " Use Vim defaults instead of Vi compatibility
set encoding=utf-8              " Set internal character encoding to UTF-8
set history=1000                " Store a large command/search history
set clipboard=unnamedplus       " Integrate Vim with the system clipboard
packadd editorconfig            " Automatically respect .editorconfig project rules
packadd termdebug               " Load the built-in GDB debugger interface

" --- Backup and Undo Management ---
set noswapfile                  " Do not create .swp files
set nobackup                    " Do not create backup files
set undofile                    " Enable persistent undo (saves history across sessions)
set undodir=~/.vim/undodir      " Directory to store undo files (must exist)

" ============================================================================
" 2. USER INTERFACE & APPEARANCE
" ============================================================================
syntax enable                   " Enable syntax highlighting engine
syntax on                       " Force syntax highlighting on
set laststatus=2                " Always show the status line at the bottom
set showmode                    " Display current mode (INSERT, VISUAL, etc.)
set wildmenu                    " Visual menu for command-line completion
let g:netrw_liststyle = 3       " Use 'Tree' view by default in the file explorer

" --- Color & Rendering ---
if has('termguicolors')
  set termguicolors             " Enable 24-bit RGB TrueColor support
endif
let &t_ut=''                    " Disable Background Color Erase (prevents color glitches)

" ============================================================================
" 3. SEARCH & NAVIGATION
" ============================================================================
set hlsearch                    " Highlight all matches of the previous search
set incsearch                   " Jump to matches as you are typing the pattern
set ignorecase                  " Ignore case in search patterns...
set smartcase                   " ...unless search contains an uppercase letter

" --- Mouse Support ---
set mouse=a                     " Enable mouse support in all modes
set ttymouse=sgr                " Use modern SGR protocol for mouse events
set balloonevalterm             " Enable tooltips/balloons in compatible terminals

" ============================================================================
" 4. INDENTATION & TEXT EDITING
" ============================================================================
set tabstop=4                   " A tab character renders as 4 spaces
set shiftwidth=4                " Number of spaces used for auto-indentation
set autoindent                  " Copy indent from current line to the next
set backspace=indent,eol,start  " Allow backspacing over everything in insert mode
set completeopt=menuone,noinsert,noselect " Modern behavior for the completion menu

" ============================================================================
" 5. CUSTOM KEY MAPPINGS
" ============================================================================
" Press Space to clear search highlighting
nnoremap <Space> :noh<CR>

" ============================================================================
" 6. ADVANCED TERMINAL INTEGRATION (ANSI ESCAPE CODES)
" ============================================================================

" --- Underline & Undercurl Styles ---
let &t_AU = "\e[58:5:%dm"          " Underline color (256-color)
let &t_8u = "\e[58:2:%lu:%lu:%lum"  " Underline color (TrueColor RGB)
let &t_Us = "\e[4:2m"              " Double underline
let &t_Cs = "\e[4:3m"              " Undercurl (wavy)
let &t_ds = "\e[4:4m"              " Dotted underline
let &t_Ds = "\e[4:5m"              " Dashed underline
let &t_Ce = "\e[4:0m"              " Underline reset

" --- Strikethrough ---
let &t_Ts = "\e[9m"                " Enable strikethrough
let &t_Te = "\e[29m"               " Disable strikethrough

" --- RGB Color Requesting ---
let &t_8f = "\e[38:2:%lu:%lu:%lum"  " Define TrueColor foreground
let &t_8b = "\e[48:2:%lu:%lu:%lum"  " Define TrueColor background
let &t_RF = "\e]10;?\e\\"           " Query terminal for foreground color
let &t_RB = "\e]11;?\e\\"           " Query terminal for background color

" --- Bracketed Paste ---
let &t_BE = "\e[?2004h"            " Enable bracketed paste mode
let &t_BD = "\e[?2004l"            " Disable bracketed paste mode
let &t_PS = "\e[200~"              " Sequence for start of paste
let &t_PE = "\e[201~"              " Sequence for end of paste

" --- Cursor Shapes for Different Modes ---
let &t_RC = "\e[?12$p"             " Request cursor blinking status
let &t_SH = "\e[%d q"              " Set cursor shape command
let &t_RS = "\eP$q q\e\\"          " Request cursor shape
let &t_SI = "\e[5 q"               " Insert mode: Vertical bar
let &t_SR = "\e[3 q"               " Replace mode: Underline
let &t_EI = "\e[1 q"               " Normal mode: Block
let &t_VS = "\e[?12l"              " Disable cursor blinking

" --- Focus Gained/Lost Events ---
let &t_fe = "\e[?1004h"            " Enable focus tracking
let &t_fd = "\e[?1004l"            " Disable focus tracking
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"

" --- Window Title Management ---
let &t_ST = "\e[22;2t"             " Save window title
let &t_RT = "\e[23;2t"             " Restore window title
