call plug#begin('~/.local/share/nvim/plugged')

Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'

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

Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install && yarn add tslib' }

Plug 'tpope/vim-abolish'

call plug#end()

" Markdown Preview "
nmap <Leader>mp :MarkdownPreview<CR>

" Copilot configuration "
let g:copilot_enabled = 0
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")
let g:copilot_assume_mapped = v:true

let g:gitgutter_enabled = 1

syntax enable
set background=dark
colorscheme dracula

" Customizing the fzf window size and enabling text wrapping "
let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.95, 'wrap': v:true } }
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
command! -bang -nargs=* Rg call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading --color=always ' . <q-args>, 1,
      \ fzf#vim#with_preview(), <bang>0)

" FZF "
nmap <C-e> :Files<CR>
nmap <C-h> :History<CR>

nnoremap <Leader>eh :split <bar> :History<CR>
nnoremap <Leader>ev :vsplit <bar> :History<CR>

" Map the command to a shortcut "
nnoremap <leader>rg :Rg<Space>

nmap <Leader>fp :let @+=expand('%:p')<CR>
nmap <Leader>p :let @+=expand('%:p:h')<CR>

" Jump to word "
nmap <Leader>w <Plug>(easymotion-bd-w)

nnoremap <C-l> :NERDTreeFind<CR>

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

" nvim-treesitter configuration "
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
  	"json",
	"cpp",
	"yaml",
	"make",
	"bash",
	"lua",
	"html",
	"python",
	"gitignore",
	"dockerfile",
	"markdown"
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
EOF

lua << EOF
require("auto-save").setup {}
EOF

" Setup Language Server Protocol for C++ "
lua << EOF
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
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

"""""""""""""""""""""""""" CUSTOM ACTION FUNCTIONS """"""""""""""""""""""""""
lua << EOF
_G.create_cpp_definition = function()
    -- Get the current buffer and cursor position
    local bufnr = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_buf_get_lines(bufnr, pos[1] - 1, pos[1], false)[1]

    -- Extract the function signature
    local function_signature = line:match("%s*(.-);")
    if not function_signature then
        vim.notify("No valid function signature found on the current line", vim.log.levels.ERROR)
        return
    end

    -- Extract the class name if it exists
    local class_name = nil
    local prev_line_nr = pos[1] - 2
    while prev_line_nr >= 0 do
        local prev_line = vim.api.nvim_buf_get_lines(bufnr, prev_line_nr, prev_line_nr + 1, false)[1]
        class_name = prev_line:match("class%s+([%w_]+)%s*")
        if class_name then break end
        prev_line_nr = prev_line_nr - 1
    end

    -- Extract the namespace if it exists
    local namespaces = {}
    prev_line_nr = pos[1] - 2
    while prev_line_nr >= 0 do
        local prev_line = vim.api.nvim_buf_get_lines(bufnr, prev_line_nr, prev_line_nr + 1, false)[1]
        local namespace = prev_line:match("namespace%s+([%w_]+)%s*{")
        if namespace then
            table.insert(namespaces, 1, namespace)
        end
        prev_line_nr = prev_line_nr - 1
    end

    -- Add the class scope to the function definition if a class was found
    local function_definition
    if class_name then
        local return_type, function_name = function_signature:match("^(.-)%s+([%w_~]+)%s*%b()")
        if not return_type then
            function_name = function_signature:match("([%w_~]+)%s*%b()")
            return_type = ""
        end
        function_definition = return_type .. (return_type ~= "" and " " or "") .. class_name .. "::" .. function_name .. function_signature:match("%b()") .. "\n{\n    // TODO: implement\n}\n"
    else
        function_definition = function_signature .. "\n{\n    // TODO: implement\n}\n"
    end

    -- Add namespace scopes to the function definition
    if #namespaces > 0 then
        local namespace_scope = table.concat(namespaces, "::") .. "::"
        function_definition = return_type .. " " .. (return_type ~= "" and " " or "") .. namespace_scope .. (class_name and (class_name .. "::") or "") .. function_name .. function_signature:match("%b()") .. "\n{\n    // TODO: implement\n}\n"
    end

    -- Find the corresponding .cpp file
    local header_file = vim.api.nvim_buf_get_name(bufnr)
    local Path = require('plenary.path')
    local scan = require('plenary.scandir')
    
    local function find_source_file(project_root, source_base_name)
        local found_files = {}
        scan.scan_dir(project_root, {
            depth = 10,
            search_pattern = source_base_name,
            on_insert = function(entry)
                table.insert(found_files, entry)
            end,
        })
        return found_files
    end

    -- Function to create search paths
    local function create_search_paths(header_file)
        local base_name = header_file:match("([^/]+)$")
        local source_base_name = base_name:gsub("%.h$", ".cpp"):gsub("%.hpp$", ".cpp")
        local dir_name = header_file:match("(.*/)")

        -- Assume the project root is a few levels up from the source file directory
        local project_root = Path:new(dir_name):parent():parent():parent().filename
        local found_files = find_source_file(project_root, source_base_name)

        -- Convert all paths to absolute paths
        for i, path in ipairs(found_files) do
            found_files[i] = vim.fn.fnamemodify(path, ":p")
        end

        return found_files
    end

    local search_paths = create_search_paths(header_file)
    local found_source_file = nil
    for _, path in ipairs(search_paths) do
        if vim.fn.filereadable(path) == 1 then
            found_source_file = path
            break
        end
    end

    if not found_source_file then
        vim.notify("No corresponding source file found", vim.log.levels.ERROR)
        return
    end

    -- Write the function definition to the .cpp file
    local append_to_cpp = function()
        local cpp_bufnr = vim.fn.bufnr(found_source_file, true)
        if cpp_bufnr == -1 then
            vim.notify("Could not open corresponding .cpp file", vim.log.levels.ERROR)
            return
        end

        -- Check if the definition already exists
        local cpp_lines = vim.api.nvim_buf_get_lines(cpp_bufnr, 0, -1, false)
        for _, cpp_line in ipairs(cpp_lines) do
            if cpp_line:match(function_signature) then
                vim.notify("Function definition already exists in the .cpp file", vim.log.levels.WARN)
                return
            end
        end

        -- Append the function definition to the end of the .cpp file if no namespace found
        vim.api.nvim_buf_set_lines(cpp_bufnr, -1, -1, false, vim.split(function_definition, '\n'))

    end

    -- Switch to the .cpp file buffer and append the function definition
    vim.cmd("edit " .. found_source_file)
    append_to_cpp()
end

-- Keymap for creating C++ definition from declaration
vim.api.nvim_set_keymap('n', 'cd', '<Cmd>lua create_cpp_definition()<CR>', { noremap = true, silent = true })
EOF

lua << EOF
_G.create_cpp_declaration = function()
    -- Get the current buffer and cursor position
    local bufnr = vim.api.nvim_get_current_buf()
    local pos = vim.api.nvim_win_get_cursor(0)
    local line = vim.api.nvim_buf_get_lines(bufnr, pos[1] - 1, pos[1], false)[1]

    -- Extract the function definition
    local function_definition = line:match("^(.-)%s*{") or line:match("^(.-)%s*$")
    if not function_definition then
        vim.notify("No valid function definition found on the current line", vim.log.levels.ERROR)
        return
    end

    -- Extract the return type, class name, and function signature
    local return_type, class_name, function_signature = function_definition:match("^(.-)%s+(.-)::(.-%b())")
    if not function_signature then
        return_type, function_signature = function_definition:match("^(.-)%s+(.-%b())")
    end
    if not function_signature then
        vim.notify("No valid function signature found in the definition", vim.log.levels.ERROR)
        return
    end

    local function_declaration = return_type .. " " .. function_signature .. ";"

    -- Find the corresponding header file
    local cpp_file = vim.api.nvim_buf_get_name(bufnr)
    local Path = require('plenary.path')
    local scan = require('plenary.scandir')

    local function find_header_file(project_root, header_base_name)
        local found_files = {}
        scan.scan_dir(project_root, {
            depth = 10,
            search_pattern = header_base_name,
            on_insert = function(entry)
                table.insert(found_files, entry)
            end,
        })
        return found_files
    end

    local function create_search_paths(source_file)
        local base_name = source_file:match("([^/]+)$")
        local header_base_name = base_name:gsub("%.cpp$", ".h"):gsub("%.cpp$", ".hpp")
        local dir_name = source_file:match("(.*/)")

        -- Assume the project root is a few levels up from the source file directory
        local project_root = Path:new(dir_name):parent():parent().filename
        local found_files = find_header_file(project_root, header_base_name)

        -- Convert all paths to absolute paths
        for i, path in ipairs(found_files) do
            found_files[i] = vim.fn.fnamemodify(path, ":p")
        end

        return found_files
    end
    
    local search_paths = create_search_paths(cpp_file)
    local found_header_file = nil
    for _, path in ipairs(search_paths) do
        if vim.fn.filereadable(path) == 1 then
            found_header_file = path
            break
        end
    end

    if not found_header_file then
        vim.notify("No corresponding header file found", vim.log.levels.ERROR)
        return
    end

    -- Insert the function declaration into the header file
    local insert_declaration = function()
        local header_bufnr = vim.fn.bufnr(found_header_file, true)
        if header_bufnr == -1 then
            vim.notify("Could not open corresponding header file", vim.log.levels.ERROR)
            return
        end

        -- Find the class definition and insert the declaration
        local lines = vim.api.nvim_buf_get_lines(header_bufnr, 0, -1, false)
        local insert_line = nil
        if class_name then
            for i, l in ipairs(lines) do
                if l:match("class%s+" .. class_name) then
                    insert_line = i
                    break
                end
            end
        end
        
        if not insert_line then
            -- If no class is found, insert at the end of the file
            insert_line = #lines
        else
            -- Find the next line after the class definition
            for i = insert_line, #lines do
                if lines[i]:match("};") then
                    insert_line = i
                    break
                end
            end
        end
        
        -- Insert the function declaration
        vim.api.nvim_buf_set_lines(header_bufnr, insert_line, insert_line, false, { function_declaration })
    end

    -- Switch to the header file buffer and insert the declaration
    vim.cmd("edit " .. found_header_file)
    insert_declaration()
end

-- Keymap for creating C++ declaration from definition
vim.api.nvim_set_keymap('n', 'cD', '<Cmd>lua create_cpp_declaration()<CR>', { noremap = true, silent = true })
EOF

function! CopySnippetInfo()
    let l:file = expand('%')
    let l:startline = line("'<")
    let l:endline = line("'>")
    let l:lines = getline(l:startline, l:endline)
    let l:snippet = join(l:lines, "\n")
    let l:formatted = printf("File: %s\nLines: %d-%d\n\n%s", l:file, l:startline, l:endline, l:snippet)
    call setreg('+', l:formatted)
    echo "Snippet copied to clipboard"
endfunction

vnoremap cs :<C-U>call CopySnippetInfo()<CR>

""""""""""""""""""""" END OF CUSTOM ACTION FUNCTIONS """""""""""""""""""""""

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
      ['<C-j>'] = cmp.mapping.select_next_item(), -- Select next item
      ['<C-k>'] = cmp.mapping.select_prev_item(), -- Select previous item
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' }
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
