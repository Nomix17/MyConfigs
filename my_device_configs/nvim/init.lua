-- General settings
vim.o.mouse = 'a'
vim.o.termguicolors = false 
vim.o.background = "dark"
vim.g.python3_host_prog = '/usr/bin/python3'
vim.opt.expandtab = true         -- Use spaces instead of tabs
vim.opt.number = true            -- Show line numbers
vim.opt.shiftwidth = 4           -- Number of spaces per indent
vim.opt.tabstop = 4              -- Number of spaces per tab
vim.opt.autoindent = true        -- Auto-indent new lines
vim.opt.clipboard = "unnamedplus" -- Enable system clipboard integration

-- Packer plugin manager setup
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function()
    use 'wbthomason/packer.nvim'  -- Packer manager
    use 'arcticicestudio/nord-vim' -- Nord theme
    use 'catppuccin/nvim'          -- Additional theme option
    use 'tpope/vim-surround'
    use 'tpope/vim-commentary'
    use 'ap/vim-css-color'
    use 'preservim/nerdtree'
    use 'rafi/awesome-vim-colorschemes'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'terryma/vim-multiple-cursors'
    use 'ryanoasis/vim-devicons'
    use 'mg979/vim-visual-multi'
    use 'rainglow/vim'
end)

-- Set colorscheme
vim.cmd 'colorscheme nord'

-- Key mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Clipboard shortcuts
map('v', '<C-S-X>', '"+x', opts)
map('v', '<C-S-C>', '"+y', opts)
map('v', 'y', '"+y', { noremap = true, silent = true })
map('n', 'Y', '"+yy', { noremap = true, silent = true })

-- NERDTree mappings
map('n', '<C-f>', ':NERDTreeFocus<CR>', opts)
map('n', '<C-t>', ':NERDTreeToggle<CR>', opts)

-- Additional mappings
map('n', '<C-a>', 'ggVG', opts)
map('n', '<C-A-Up>', '<C-w>k', opts)
map('n', '<C-A-Down>', '<C-w>j', opts)
map('t', '<C-A-Up>', '<C-\\><C-n><C-w>k', opts)
map('t', '<C-A-Down>', '<C-\\><C-n><C-w>j', opts)

-- Indent with Tab/Shift+Tab in visual mode
map('x', '<Tab>', [[:s/^/    /<CR>gv]], opts)
map('x', '<S-Tab>', [[:s/^    //<CR>gv]], opts)

-- Surround mappings
for _, char in ipairs({"(", ")", "[", "]", "{", "}", "'", '"'}) do
    map('x', char, '<ESC>>a' .. char .. '<ESC><i' .. char .. '<ESC>', opts)
end

-- Autocommand to handle mapping conflicts
local function setup_mappings()
    if vim.fn.maparg('[', 'x') ~= '' then
        vim.api.nvim_del_keymap('x', '[')
    end
end
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = setup_mappings
})

-- Function to run code in a real terminal split
function RunCode()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand("%:t") -- Get the current file name
    local filepath = vim.fn.expand("%:p:h") -- Get the directory of the file
    local command = ""

    -- Set the command based on file type
    if filetype == "python" then
        command = "cd " .. filepath .. " && python " .. filename
    elseif filetype == "cpp" then
        command = "cd " .. filepath .. " && ./run.sh"
    elseif filetype == "c" then
        command = "cd " .. filepath .. " && gcc " .. filename .. " -o code && ./code"
    else
        print("No run command set for file type: " .. filetype)
        return
    end

    -- Open a real terminal in a horizontal split
    vim.cmd("belowright split | resize 10 | terminal")

    -- Hide line numbers in the terminal
    vim.cmd("setlocal nonumber norelativenumber")

    -- Send the command inside the terminal
    vim.defer_fn(function()
        vim.api.nvim_feedkeys("i" .. command .. "\n", "n", true)
    end, 100)
end

-- Map Ctrl+Alt+N to run the function
map('n', '<C-A-n>', ':lua RunCode()<CR>', opts)
