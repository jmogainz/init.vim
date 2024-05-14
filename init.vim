call plug#begin('~/.local/share/nvim/plugged')

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

" Easy Nav
Plug 'easymotion/vim-easymotion'

" Status
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" FZF
nmap <C-e> :Files<CR>
nmap <C-h> :History<CR>

" Jump to word
nmap <Leader>w <Plug>(easymotion-w)
" Jump to character
nmap <Leader>s <Plug>(easymotion-s)
" Jump to line
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)

let g:ale_cpp_gcc_options = '-std=c++17 -Wall -O2'
let g:ale_linters = {
\ 'cpp': ['clang', 'g++'],
\}

" Setup Language Server Protocol for C++
lua << EOF
require('lspconfig').clangd.setup{
    on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = { noremap=true, silent=true }

        -- Existing LSP mappings
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    end
}
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
set number
set relativenumber
set clipboard=unnamedplus
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrap
set cursorline
