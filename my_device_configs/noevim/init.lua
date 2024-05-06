vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"

vim.cmd [[packadd packer.nvim]]
vim.cmd 'colorscheme nord'

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'arcticicestudio/nord-vim'
	use 'catppuccin/nvim'
	use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'ap/vim-css-color'
    use 'preservim/nerdtree'
    use 'rafi/awesome-vim-colorschemes'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
	use 'terryma/vim-multiple-cursors'
    use 'neoclide/coc.nvim'
    use 'ryanoasis/vim-devicons'
end)

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('v', '<C-S-X>', '"+x', opts)
map('v', '<C-S-C>', '"+y', opts)
map('n', '<C-f>', ':NERDTreeFocus<CR>', opts)
map('n', '<C-t>', ':NERDTreeToggle<CR>', opts)
map('n', '<C-a>', 'ggVG', opts)
vim.g.python3_host_prog = '/usr/bin/python3'
map('x', '(', '<ESC>`>a)<ESC>`<i(<ESC>', opts)
map('x', ')', '<ESC>`>a)<ESC>`<i(<ESC>', opts)
map('x', '[', '<ESC>`>a]<ESC>`<i[<ESC>', opts)
map('x', ']', '<ESC>`>a]<ESC>`<i[<ESC>', opts)
map('x', '{', '<ESC>`>a}<ESC>`<i{<ESC>', opts)
map('x', '}', '<ESC>`>a}<ESC>`<i{<ESC>', opts)
map('x', "'", '<ESC>`>a\'<ESC>`<i\'<ESC>', opts)
map('x', '"', '<ESC>`>a"<ESC>`<i"<ESC>', opts)

local function setup_mappings()
    if vim.fn.maparg('[', 'x') ~= '' then
        vim.api.nvim_del_keymap('x', '[')
    end
end

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = setup_mappings
})


