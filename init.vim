call plug#begin('~/.local/share/nvim/plugged')

Plug 'github/copilot.vim'

Plug 'farmergreg/vim-lastplace'

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
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'Pocco81/auto-save.nvim'

call plug#end()

" Copilot configuration
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_assume_mapped = v:true

let g:gitgutter_enabled = 1

syntax enable
set background=dark
colorscheme dracula

" Customizing the fzf window size and enabling text wrapping "
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95, 'wrap': v:true } }
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
command! -bang -nargs=* Rg call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \ fzf#vim#with_preview(), <bang>0)

" FZF "
nmap <C-e> :Files<CR>
nmap <C-h> :History<CR>

nnoremap <Leader>eh :split <bar> :History<CR>
nnoremap <Leader>ev :vsplit <bar> :History<CR>

" Map the command to a shortcut "
nnoremap <leader>rg :Rg<Space>

nmap <Leader>fp :let @+=expand('%:p')<CR>

" Jump to word "
nmap <Leader>w <Plug>(easymotion-bd-w)
" Jump to character "
nmap <Leader>s <Plug>(easymotion-s)
" Jump to line "
nmap <Leader>j <Plug>(easymotion-j)
nmap <Leader>k <Plug>(easymotion-k)

nnoremap <C-t> :NERDTreeFind<CR>

nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tc :tabclose<CR>

" ALE Configuration "
let g:ale_cpp_clang_options = '-Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion'
let g:ale_cpp_gcc_options = '-std=c++17 -Wall -O2 -Wextra -Wpedantic -Wconversion -Wsign-conversion'
let g:ale_cpp_cc_options = '-Wall -Wextra -Wpedantic Wsign-conversion -Wno-c++17-extensions'
let g:ale_linters = {
\ 'cpp': ['clang', 'g++'],
\ 'python': ['flake8', 'pylint', 'mypy'],
\}

let g:ale_verbose = 1

lua << EOF
require("auto-save").setup {}
EOF

" Setup Language Server Protocol for C++ "
lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.offsetEncoding = { "utf-16" }

require('lspconfig').clangd.setup{
    capabilities = capabilities,
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
        buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    end
}

require('lspconfig').pyright.setup{
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local opts = { noremap=true, silent=true }

        -- Existing LSP mappings
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
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
vim.api.nvim_set_keymap('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
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
set incsearch
set hlsearch
set wrap
set cursorline
set timeoutlen=300

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
