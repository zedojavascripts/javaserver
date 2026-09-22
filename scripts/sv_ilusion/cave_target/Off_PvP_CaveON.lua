UI.Separator()
setDefaultTab("Cave")
UI.Separator()
macro(200, "Off PvP - Cave ON", function()
  if CaveBot.isOn() then
  g_game.setSafeFight(true)
end
end)

UI.Separator()
