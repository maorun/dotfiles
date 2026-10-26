return {
    on_init = function(client)
        require('maorun.plugin-config.typescript').setup(client)
    end,
}
