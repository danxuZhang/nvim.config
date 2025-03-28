vim.g.mapleader = " "
vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

--- jump up/down in half-pages
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

--- allows search in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

--- format files
function format_file()
    local filetype = vim.bo.filetype
    if filetype == 'cpp' then
        -- Format C++ files using clang-format with LLVM style
        vim.cmd('%!clang-format - ')
    elseif filetype == 'python' then
        -- Format Python files using Black
        vim.cmd('%!black -q -')
    else
        print("No formatter defined for filetype: " .. filetype)
    end
end

-- Map <leader>fm to call the format_file function
vim.api.nvim_set_keymap('n', '<leader>fm', ':lua format_file()<CR>', { noremap = true, silent = true })

