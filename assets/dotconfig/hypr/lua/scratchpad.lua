local kew = '(kitty --class="kitty-kew" kew)'
local ff = '(kitty --hold --class="kitty-ff" fastfetch)'
local selector = "special:scratchpad"

hl.workspace_rule({
  workspace = selector,
  on_created_empty = kew .. "&" .. ff,
})

hl.window_rule({
  match = { workspace = selector, class = "kitty-kew" },
  float = true,
  size = { 400, 550 },
  move = { "50", "70" }
})

hl.window_rule({
  match = { workspace = selector, class = "kitty-ff" },
  float = true,
  size = { 550, 400 },
  move = { "monitor_w - 600", "monitor_h - 450" }
})
