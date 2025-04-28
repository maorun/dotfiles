return {
    'pwntester/octo.nvim',
    event = 'VimEnter',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
    },
    opts = {
        mappings = {
            file_panel = {
                toggle_viewed = { lhs = '<localleader><space>', desc = 'toggle viewer viewed state' },
            }
        }
    },
}
