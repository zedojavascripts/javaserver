function setRainbowColor(time)
  local r = math.floor(127 * math.sin(time) + 128);
  local g = math.floor(127 * math.sin(time + 2 * math.pi / 3) + 128);
  local b = math.floor(127 * math.sin(time + 4 * math.pi / 3) + 128);
  return string.format("#%02X%02X%02X", r, g, b);
end

macro(10, function()
  local time = os.clock() * 4;
  local color = setRainbowColor(time);
  modules.game_bot.contentsPanel.config:setColor(color);
  modules.game_bot.contentsPanel.enableButton:setColor(color);
  modules.game_bot.contentsPanel.editConfig:setColor(color);
end);
