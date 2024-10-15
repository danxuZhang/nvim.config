return {
    'voldikss/vim-floaterm',

    config = function() 
        vim.keymap.set("n", "<leader>tm", vim.cmd.FloatermToggle)
    end
}
