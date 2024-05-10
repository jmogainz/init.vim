" Initialize plugin system
call plug#begin('~/.local/share/nvim/plugged')

" NERDTree for directory tree
Plug 'preservim/nerdtree'

" Telescope for fuzzy finding
Plug 'nvim-telescope/telescope.nvim', {'do': ':UpdateRemotePlugins'}
Plug 'nvim-lua/plenary.nvim'  " Dependency for Telescope

" Fuzzy file finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" C++ syntax highlighting and more
Plug 'octol/vim-cpp-enhanced-highlight'

" Linting and syntax checking
Plug 'dense-analysis/ale'

" Language server protocol support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" End plugin initialization
call plug#end()

" Keybindings
" Toggle NERDTree with Ctrl+Shift+e
nnoremap <C-S-e> :NERDTreeToggle<CR>

" Telescope setup for file finding
nnoremap <C-e> :Telescope find_files<CR>
nnoremap <C-o> :Telescope oldfiles<CR>

" ALE setup for C++ linting and syntax checking
let g:ale_cpp_gcc_options = '-std=c++17 -Wall -O2'
let g:ale_linters = {
\ 'cpp': ['clang', 'g++'],
\}

" Setup Language Server Protocol for C++
lua << EOF
require('lspconfig').clangd.setup{}
EOF
lua << EOF
require('lspconfig').clangd.setup{}
EOF

lua << EOF
local cmp = require'cmp'
cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<C-space>'] = cmp.mapping.complete(),
      ['<C-d>'] = cmp.mapping.select_prev_item(),
      ['<C-f>'] = cmp.mapping.select_next_item(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'buffer' },
    }
})
EOF

set mouse=a
