data:extend({
    {
        type = "selection-tool",
        name = "highlighter",
        icon = data.raw["selection-tool"]["blueprint"].icon,
        icon_size = data.raw["selection-tool"]["blueprint"].icon_size,
        icon_mipmaps = data.raw["selection-tool"]["blueprint"].icon_mipmaps,
        -- flags = {"hidden", "only-in-cursor"},
        subgroup = "tool",
        order = "c[automated-construction]-a[highlighter]",
        stack_size = 1,
        stackable = false,
        selection_color = { r = 1, g = 1, b = 1 },
        alt_selection_color = { r = 1, g = 1, b = 1 },
        selection_mode = {"buildable-type", "same-force"},
        alt_selection_mode = {"buildable-type", "same-force"},
        selection_cursor_box_type = "entity",
        alt_selection_cursor_box_type = "not-allowed",
        entity_filters = {"linking-combinator"},
        show_in_library = true
    }
})