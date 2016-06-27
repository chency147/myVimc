"vimrc by Anton Chen
"2015-3-5 12:09:45
"
"判定当前操作系统类型
if has("win32") || has("win32unix")
	let g:OS#name = "win"
	let g:OS#win = 1
	let g:OS#mac = 0
	let g:OS#unix = 0
elseif has("mac")
	let g:OS#name = "mac"
	let g:OS#mac = 1
	let g:OS#win = 0
	let g:OS#unix = 0
elseif has("unix")
	let g:OS#name = "unix"
	let g:OS#unix = 1
	let g:OS#win = 0
	let g:OS#mac = 0
endif
if has("gui_running")
	let g:OS#gui = 1
else
	let g:OS#gui = 0
endif

"设置用户路径
if g:OS#win
	source $VIMRUNTIME/mswin.vim
	behave mswin
	let $VIUMFILES = $VIM.'/vimfiles'
	let $HOME = $VIUMFILES
elseif g:OS#unix
	let $VIM = $HOME
	let $VIMFILES = $HOME.'~/.vim'
elseif g:OS#mac
	let $VIM = $HOME
	let $VIMFILES = $HOME.'~/.vim'
endif

if g:OS#win
	" MyDiff 
	set diffexpr=MyDiff()
	function! MyDiff()
		let opt = '-a --binary '
		if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
		if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
		let arg1 = v:fname_in
		if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
		let arg2 = v:fname_new
		if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
		let arg3 = v:fname_out
		if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
		let eq = ''
		if $VIMRUNTIME =~ ' '
			if &sh =~ '\<cmd'
				let cmd = '"' . $VIMRUNTIME . '\diff"'
				let eq = '""'
			else
				let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
			endif
		else
			let cmd = $VIMRUNTIME . '\diff'
		endif
		silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction
endif

" Win平台下窗口全屏组件 gvimfullscreen.dll
" Alt + Enter 全屏切换
" F9 降低窗口透明度
" F10 加大窗口透明度
" F11 切换Vim是否总在最前面显示
" Vim启动的时候自动使用当前颜色的背景色以去除Vim的白色边框
if has('gui_running') && has('gui_win32') && has('libcall')
	let g:MyVimLib = 'gvimfullscreen.dll'
	function! ToggleFullScreen()
		call libcall(g:MyVimLib, 'ToggleFullScreen', 1)
	endfunction

	let g:VimAlpha = 245
	function! SetAlpha(alpha)
		let g:VimAlpha = g:VimAlpha + a:alpha
		if g:VimAlpha < 180
			let g:VimAlpha = 180
		endif
		if g:VimAlpha > 255
			let g:VimAlpha = 255
		endif
		call libcall(g:MyVimLib, 'SetAlpha', g:VimAlpha)
	endfunction

	let g:VimTopMost = 0
	function! SwitchVimTopMostMode()
		if g:VimTopMost == 0
			let g:VimTopMost = 1
		else
			let g:VimTopMost = 0
		endif
		call libcall(g:MyVimLib, 'EnableTopMost', g:VimTopMost)
	endfunction
	"映射 Alt+Enter 切换全屏vim
	map <a-enter> <esc>:call ToggleFullScreen()<cr>
	"切换Vim是否在最前面显示
	nmap <F9> <esc>:call SwitchVimTopMostMode()<cr>
	"增加Vim窗体的不透明度
	nmap <F10> <esc>:call SetAlpha(10)<cr>
	"增加Vim窗体的透明度
	nmap <F11> <esc>:call SetAlpha(-10)<cr>
	" 默认设置透明
	autocmd GUIEnter * call libcallnr(g:MyVimLib, 'SetAlpha', g:VimAlpha)
endif

"配置文件自动载入
if g:OS#win
	autocmd! bufwritepost source $VIM/_vimrc %
elseif g:OS#uinx
	autocmd! bufwritepost source $HOME/.vimrc %
elseif g:OS#mac
	autocmd! bufwritepost source $HOME/.vimrc %
endif

set nocompatible

"Vundle设置
set rtp+=$VIUMFILES/bundle/Vundle.vim/
let path='$VIUMFILES/bundle'
call vundle#begin(path)

Plugin 'gmarik/Vundle.vim'

Plugin 'Lucius'
call vundle#end()
filetype plugin indent on

"中文乱码
set encoding=utf-8
set fenc=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set termencoding=utf-8
if g:OS#win
	source $VIMRUNTIME/delmenu.vim
	source $VIMRUNTIME/menu.vim
	language messages zh_CN.utf-8
endif
if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
	set ambiwidth=double
endif

"新文件格式
set fileformat=unix
set fileformats=unix,dos,mac

"禁止UTF-8 BOM
set nobomb

"自动识别文件类型
filetype on

"界面设置
set number
set numberwidth=6
set laststatus=2
set cursorline
set guifont=Consolas\ for\ Powerline\ FixedD:h11
set shortmess=atI                          
colorscheme Lucius
LuciusBlack

"隐藏菜单栏
if g:OS#gui
	set guioptions-=m " 隐藏菜单栏
	set guioptions-=T " 隐藏工具栏
	"set guioptions-=L " 隐藏左侧滚动条
	"set guioptions-=r " 隐藏右侧滚动条
	"set guioptions-=b " 隐藏底部滚动条
	"set showtabline=0 " 隐藏Tab栏
	map <silent> <F2> :if &guioptions =~# 'T' <Bar>
				\set guioptions-=T <Bar>
				\set guioptions-=m <bar>
				\else <Bar>
				\set guioptions+=T <Bar>
				\set guioptions+=m <Bar>
				\endif<CR>
endif

"默认窗口位置和大小
winpos 235 235
set lines=25 columns=108

"代码高亮
syntax enable
syntax on

"设置制表符缩进
set tabstop=4
set softtabstop=4
set noexpandtab

"继承缩进
set autoindent
set shiftwidth=4

"上次文件编辑位置
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" original repos on github<br>Bundle 'mattn/zencoding-vim'  
" Bundle 'drmingdrmer/xptemplate'  

" vim-scripts repos 
Bundle 'Yggdroot/indentLine'
set list lcs=tab:\|\ 
Bundle 'L9'
" Bundle 'autocomplpop'
" let g:AutoComplPop_Behavior = {
" 			\ 'c': [ {'command' : "\<C-x>\<C-o>",
" 			\ 'pattern' : ".",
" 			\ 'repeat' : 0}
" 			\ ]
" 			\}
filetype plugin indent on     " required!
Bundle 'scrooloose/nerdtree'
" 设置NerdTree快捷键
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>

" 设置powerline
Bundle 'Lokaltog/vim-powerline'
set nocompatible   " Disable vi-compatibility
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
set noshowmode " Disable the orgin mode showing
let g:Powerline_symbols = 'fancy'
" 设置高级的配对关键字间跳转
runtime macros/matchit.vim
" 检查当前文件代码语法(php){{{
function! CheckSyntax_PHP()
	if &filetype!="php"
		echohl WarningMsg | echo "Fail to check syntax! Please select the right file!" | echohl None
		return
	endif
	if &filetype=="php"
		" Check php syntax
		setlocal makeprg=\"php\"\ -l\ -n\ -d\ html_errors=off
		" Set shellpipe
		setlocal shellpipe=>
		" Use error format for parsing PHP error output
		setlocal errorformat=%m\ in\ %f\ on\ line\ %l
	endif
	execute "silent make %"
	set makeprg=make
	execute "normal :"
	execute "copen"
endfunction
map <A-p> :call CheckSyntax_PHP()<CR>
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" 设定html语言编写辅助插件
Bundle 'mattn/emmet-vim'

" 上下移动光标时使光标行所在行位于屏幕中央
" nmap j jzz
" nmap k kzz
" Platform
function! MySys()
	if has("win32")
		return "windows"
	else
		return "linux"
	endif
endfunction
if MySys() == "windows"   "设定windows系统中ctags程序的位置
	let Tlist_Ctags_Cmd = 'ctags'
elseif MySys() == "linux"  "设定linux系统中ctags程序的位置
	let Tlist_Ctags_Cmd = '/usr/bin/ctags'
endif
"只显示当前文件的
let Tlist_Show_One_File = 1
"如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Exit_OnlyWindow = 1
"在右侧窗口中显示taglist窗口配置好以后
let Tlist_Use_Right_Window = 1   
map <silent> <A-q> :TlistToggle<cr>

inoremap <A-9> ()<ESC>i
inoremap <A-[> []<ESC>i
inoremap <A-{> {}<ESC>i
inoremap <A-,> <><ESC>i
inoremap <A-'> ''<ESC>i
inoremap <A-"> ""<ESC>i
" 设置Shougo/neocomplete.vim
Bundle 'Shougo/neocomplete.vim'
let g:neocomplete#enable_at_startup = 1 

" 注释插件
Bundle 'scrooloose/nerdcommenter'
let NERDSpaceDelims=1

" 第80列往后加下划线
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)
" 设置根据标记折叠
set fdm=indent

" 更好的php缩进
" Bundle 'captbaritone/better-indent-support-for-php-with-html'

" html indent  
let g:html_indent_inctags = "body,head,tbody"   " 缩进body head  
"let g:html_indent_script1 = "inc"     " 缩进<script>标签  
"let g:html_indent_style1 = "inc"      " 缩进<style>标签 
