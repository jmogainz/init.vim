call plug#begin('~/.local/share/nvim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'windwp/nvim-autopairs'

Plug 'sheerun/vim-polyglot'
Plug 'dracula/vim', {'as': 'dracula'}

Plug 'nvim-tree/nvim-web-devicons'

Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'dense-analysis/ale'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'sindrets/diffview.nvim'

call plug#end()

syntax enable
set background=dark
colorscheme dracula

" Customizing the fzf window size and enabling text wrapping
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95, 'wrap': v:true } }
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'

" FZF
nmap <C-e> :Files<CR>
nmap <C-h> :History<CR>

" Map the command to a shortcut
nnoremap <leader>rg :Rg<Space>

nmap <Leader>fp :let @+=expand('%')<CR>

" Jump to word
nmap <Leader>w <Plug>(easymotion-bd-w)
" Jump to character
nmap <Leader>s <Plug>(easymotion-s)
" Jump to line
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)

nnoremap <Leader>t :NERDTreeFind<CR>

" ALE Configuration
let g:ale_cpp_clang_options = '-Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion'
let g:ale_cpp_gcc_options = '-std=c++17 -Wall -O2 -Wextra -Wpedantic -Wconversion -Wsign-conversion'
let g:ale_linters = {
\ 'cpp': ['clang', 'g++'],
\ 'python': ['flake8', 'pylint', 'mypy'],
\}

let g:ale_verbose = 1

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
        buf_set_keymap('n', 'gs', '<Cmd>ClangdSwitchSourceHeader<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    end
}

require('lspconfig').pyright.setup{
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
require('diffview').setup {}
EOF

lua require('nvim-autopairs').setup({})

" Configure nvim-cmp for autocompletion "
lua << EOF
local cmp = require'cmp'
cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
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
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
    }
})
EOF

lua << EOF
-- Configure diagnostics
vim.diagnostic.config({
  virtual_text = false, -- Disable virtual text
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always", -- Include the source in the diagnostics
    header = "",
    prefix = "",
  },
})

-- Customize floating window colors
vim.cmd([[
  highlight DiagnosticFloatingError guifg=#FF0000 guibg=#1E1E1E gui=bold
  highlight DiagnosticFloatingWarn guifg=#FFA500 guibg=#1E1E1E gui=bold
  highlight DiagnosticFloatingInfo guifg=#00FFFF guibg=#1E1E1E gui=bold
  highlight DiagnosticFloatingHint guifg=#00FF00 guibg=#1E1E1E gui=bold
  highlight NormalFloat guibg=#1E1E1E
  highlight FloatBorder guifg=#00FFFF guibg=#1E1E1E
]])

-- Keybinding to show diagnostics in floating window
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
EOF

" General settings "
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

" Enable persistent undo "
set undofile

" Specify a directory to store undo files "
if has("persistent_undo")
  let target_path = expand('~/.config/nvim/undodir')
  if !isdirectory(target_path)
    call mkdir(target_path, "p", 0700)
  endif
  let &undodir = target_path
endif

" NERDTree settings "
let g:NERDTreeShowHidden=1
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeWinSize=80
