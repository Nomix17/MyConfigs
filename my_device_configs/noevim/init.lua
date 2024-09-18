vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.clipboard = "unnamedplus"
vim.g.terminal = 'alacritty'

vim.cmd [[packadd packer.nvim]]
vim.cmd ('colorscheme nord ')

vim.o.termguicolors = true

require('packer').startup(function()
    use 'morhetz/gruvbox'
    use 'wbthomason/packer.nvim'
    use 'arcticicestudio/nord-vim'
    use 'wbthomason/packer.nvim'
    use 'olivercederborg/poimandres.nvim'
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
    use 'mg979/vim-visual-multi'
end)


vim.g.python3_host_prog = '/usr/bin/python3'
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
map('v', '<C-S-X>', '"+x', opts)
map('v', '<C-S-C>', '"+y', opts)
map('n', '<C-f>', ':NERDTreeFocus<CR>', opts)
map('n', '<C-t>', ':NERDTreeToggle<CR>', opts)
map('n', '<C-a>', 'ggVG', opts)
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
vim.api.nvim_set_keymap('n', '<C-A-n>', ':belowright split | resize 10 | terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-A-Up>', '<C-w>k', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-A-Up>', '<C-\\><C-n><C-w>k', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-A-Down>', '<C-w>j', {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-A-Down>', '<C-\\><C-n><C-w>j', {noremap = true, silent = true})
vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<CR>"', {expr = true, noremap = true})


vim.g['airline#extensions#tabline#enabled'] = 0  -- Enable tabline for buffers/tabs
vim.g['airline_powerline_fonts'] = 1  -- Enable powerline fonts (make sure you have a font installed that supports this)
vim.g['airline_theme'] = 'gruvbox'  -- Set the theme (choose one matching your color scheme)
