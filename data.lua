---@diagnostic disable-next-line: undefined-global
data:extend({
    {
        type="item",
        name="obama_prism",
        icon="__test-mod__/graphics/icons/empty-fuel-cell.png",
        icon_size=64,
        mipmap_count=4,
        subgroup="intermediate-product",
        stack_size=1
    }
})

local styles = data.raw["gui-style"].default

styles["test_content_frame"] = {
    type = "frame_style",
    parent = "inside_shallow_frame_with_padding",
    vertically_stretchable = "on"
}

styles["test_controls_flow"] = {
    type = "horizontal_flow_style",
    vertical_align = "center",
    horizontal_spacing = 16
}

styles["test_controls_textfield"] = {
    type = "textbox_style",
    width = 36
}

styles["test_deep_frame"] = {
    type = "frame_style",
    parent = "slot_button_deep_frame",
    vertically_stretchable = "on",
    horizontally_stretchable = "on",
    top_margin = 16,
    left_margin = 8,
    right_margin = 8,
    bottom_margin = 4
}