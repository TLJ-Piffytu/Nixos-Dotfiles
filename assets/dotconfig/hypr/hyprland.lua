require("lua/autostart")
require("lua/input")
require("lua/keybinds")
require("lua/layouts")
require("lua/looks")
require("lua/monitors")
require("lua/windowrules")
require("lua/scratchpad")

hl.env("XCURSOR_THEME", "Vanilla-DMT")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Vanilla-DMT")

hl.config({
  cursor = {
    enable_hyprcursor = false,
  },
})
