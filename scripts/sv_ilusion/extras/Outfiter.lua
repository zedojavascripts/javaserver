--Join Discord server for free scripts
--https://discord.gg/RkQ9nyPMBH
--Made By VivoDibra#1182
--Tested on vBot 4.8 / OTCV8 3.1 rev 232

setDefaultTab("Tools")
local panelName = "MasterOutfiter"

if not storage[panelName] then
  storage[panelName] = {}
end

local config = storage[panelName]

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Master Outfiter')

  Button
    id: push
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])

g_ui.loadUIFromString([[
MobOutfitWindow < MainWindow
  !text: tr('Master Outfiter, Made by: VivoDibra')
  size: 1024 750
  @onEscape: self:hide()

  Panel
    id: itemList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    anchors.bottom: separator.top
    anchors.top: parent.top
    layout:
      type: grid
      cell-size: 80 80
      flow: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8    

  Button
    id: backButton
    !text: tr('Back')
    font: cipsoftFont
    anchors.left: parent.left
    anchors.bottom: parent.bottom

  Button
    id: nextButton
    !text: tr('Next')
    font: cipsoftFont
    anchors.left: backButton.right
    anchors.bottom: parent.bottom

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
  
  Label
    id: page
    text: 500/30000
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    width:100

OutfitWidget < UIWidget
  size: 80 80
  margin-left: 2
  layout: verticalBox

  UICreature
    id: creature
    size: 60 60   
    phantom: true    

  Button
    id: select
    text: select    
    size: 50 20
]])

local MobOutfitWindow = UI.createWindow('MobOutfitWindow', g_ui.getRootWidget())

if not config.type then
  config.type = player:getOutfit().type
end

local function setPlayerOutfit()
  if not config.enabled then return end
  local baseOutfit = player:getOutfit()
  if baseOutfit.type == config.type then return end
  baseOutfit.type = config.type 
  baseOutfit.addons = 3
  player:setOutfit(baseOutfit)
  modules.game_interface.getRootPanel():focus()
end

local function addOutfit(id)
  local widget = UI.createWidget("OutfitWidget", MobOutfitWindow.itemList)
  widget.select.onClick = function()
    config.type = id
    setPlayerOutfit()
  end
  local tempOutfit = player:getOutfit()  
  tempOutfit.type = id
  tempOutfit.addons = 3
  widget.creature:setOutfit(tempOutfit)  
end

onPlayerPositionChange(function()
  setPlayerOutfit()
end)

setPlayerOutfit()

MobOutfitWindow:hide()

ui.push.onClick = function()
  MobOutfitWindow:show()
  MobOutfitWindow:raise()
  MobOutfitWindow:focus()
end

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

local firstPage = 0
local lastPage = 2000
local pageSize = 95
local currentPage = firstPage

local function setOutfits()     
  MobOutfitWindow.itemList:destroyChildren()
  local itemsId = { }
    for i=currentPage, (currentPage + pageSize) do
      addOutfit(i)
    end
    MobOutfitWindow.page:setText(currentPage.."/"..lastPage)
end

MobOutfitWindow.closeButton.onClick = function(widget)
    MobOutfitWindow:hide()
end

MobOutfitWindow.backButton.onClick = function(widget)
  if currentPage > firstPage then
    currentPage = currentPage - pageSize
    setOutfits()
  end      
end

MobOutfitWindow.nextButton.onClick = function(widget)
  if currentPage < lastPage then
    currentPage = currentPage + pageSize
    setOutfits()
  end
end

setOutfits()

local directionCounter = 0
macro(500, function()
  if not config.enabled or not MobOutfitWindow:isVisible() then return end
  for _, c in ipairs(MobOutfitWindow.itemList:getChildren()) do    
    c.creature:setDirection(directionCounter)
  end
  directionCounter = directionCounter + 1
  if directionCounter > 3 then
    directionCounter = 0
  end
end)

--Join Discord server for free scripts
--https://discord.gg/RkQ9nyPMBH
--Made By VivoDibra#1182
--Tested on vBot 4.8 / OTCV8 3.1 rev 232
