require("prototypes.entities")
require("prototypes.changes")
require("prototypes.items.linking_combinator")
require("prototypes.items.logic_controller")
require("prototypes.items.field-pc-1")
require("prototypes.items.field-pc-2")
require("prototypes.equipment.field-pc-1")
require("prototypes.equipment.field-pc-2")


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
