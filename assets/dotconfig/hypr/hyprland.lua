require("lua/autostart")
require("lua/input")
require("lua/keybinds")
require("lua/layouts")
require("lua/looks")
require("lua/monitors")
require("lua/windowrules")

hl.env("XCURSOR_THEME", "NikoCursor")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
  cursor = {
    enable_hyprcursor = false,
  },
})
