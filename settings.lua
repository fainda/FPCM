data:extend({
    {
        type = "color-setting",
        name = "fpcm_actor",
        setting_type = "startup",
        default_value = { r = 1, g = 0, b = 0 },
        order = "a"
    },
    {
        type = "color-setting",
        name = "fpcm_sensor",
        setting_type = "startup",
        default_value = { r = 0, g = 1, b = 0 },
        order = "b"
    },
    {
        type = "color-setting",
        name = "fpcm_highlight",
        setting_type = "startup",
        default_value = { r = 1, g = 1, b = 0 },
        order = "c"
    },
    {
        type = "int-setting",
        name = "fpcm_hologram_duration",
        setting_type = "startup",
        default_value = 10, -- in seconds
        minimum_value = 1,
        order = "d"
    }
})