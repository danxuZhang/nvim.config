local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files (project-file)' })

vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Telescope find files (git-file)' })

vim.keymap.set('n', '<leader>lf', function()
    builtin.find_files({ search_dirs = { vim.fn.expand('%:p:h') } })
end, { desc = 'Telescope find files in current buffer directory' })

vim.keymap.set('n', '<leader>gp', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<leader>lgp', function()
    builtin.grep_string({ 
        search = vim.fn.input("Grep > "),
        cwd = vim.fn.expand('%:p:h'),
    });
end)

