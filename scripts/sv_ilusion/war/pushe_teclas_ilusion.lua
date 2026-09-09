
-- Storage para Advanced Push
if not storage.AdvancedPushSystem then
  storage.AdvancedPushSystem = {}
end

-- Configurações do sistema com persistência
local pushConfig = {
    enabled = storage.AdvancedPushSystem.enabled or false,
    pushDelay = storage.AdvancedPushSystem.pushDelay or 1000,    -- Delay entre empurrões
    lookDelay = storage.AdvancedPushSystem.lookDelay or 500,     -- Delay após look
    maxDistance = storage.AdvancedPushSystem.maxDistance or 3,     -- Distância máxima para empurrar
    autoLook = storage.AdvancedPushSystem.autoLook ~= false      -- Ativar look automático (true por padrão)
}

-- Carregar UI da janela de configuração
g_ui.loadUIFromString([[
PushConfigTextEdit < Panel
  height: 40

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  TextEdit
    id: textEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    minimum: 0
    maximum: 10
    step: 1
    text-align: center

PushConfigWindow < MainWindow
  !text: tr('Advanced Push System Config')
  size: 300 250
  padding: 25

  Label
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: "Configuracoes do Push System"
    color: #ffaa00

  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 10
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 5
    margin-bottom: 5

  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 10
      
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    text: Close
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5
]])

-- Função para adicionar campos de texto
local addTextEdit = function(id, title, defaultValue, dest, tooltip)
  local widget = UI.createWidget('PushConfigTextEdit', dest)
  widget.text:setText(title)
  widget.textEdit:setText(pushConfig[id] or defaultValue or "")
  widget.text:setTooltip(tooltip)
  widget.textEdit.onTextChange = function(widget,text)
    pushConfig[id] = tonumber(text) or defaultValue
    storage.AdvancedPushSystem[id] = pushConfig[id]
  end
  pushConfig[id] = pushConfig[id] or defaultValue
end

-- Criar janela de configuração PRIMEIRO
local pushConfigWindow = UI.createWindow('PushConfigWindow', rootWidget)
pushConfigWindow:hide()
pushConfigWindow.closeButton.onClick = function(widget)
  pushConfigWindow:hide()
end

-- Função para criar janela de configuração (AGORA pode usar pushConfigWindow)
local function createConfigWindow()
  local leftPanel = pushConfigWindow.content.left
  
  -- Limpar painel
  leftPanel:destroyChildren()
  
  -- Adicionar campos de configuração
  addTextEdit("pushDelay", "Push Delay (ms)", 1000, leftPanel, "Delay entre empurrões")
  addTextEdit("lookDelay", "Look Delay (ms)", 500, leftPanel, "Delay após look")
  addTextEdit("maxDistance", "Max Distance", 3, leftPanel, "Distância máxima para empurrar")
  
  -- Checkbox para Auto Look
  local autoLookCheck = UI.createWidget('UICheckBox', leftPanel)
  autoLookCheck:setText("Auto Look")
  autoLookCheck:setChecked(pushConfig.autoLook)
  autoLookCheck.onClick = function()
    pushConfig.autoLook = autoLookCheck:isChecked()
    storage.AdvancedPushSystem.autoLook = pushConfig.autoLook
  end
end

-- UI principal
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Advanced Push')

  Button
    id: setup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

]])

-- Criar o macro PRIMEIRO
local pushSystemMacro = macro(100, function()
    if not pushConfig.enabled then return end
    local attackingTarget = g_game.getAttackingCreature()
    local followingTarget = g_game.getFollowingCreature()
    if attackingTarget then
        currentTarget = attackingTarget
    elseif followingTarget then
        currentTarget = followingTarget
    end
end)

-- Restaurar estado do macro baseado no storage
if pushConfig.enabled then
    pushSystemMacro:setOn()
end

ui.title:setOn(pushConfig.enabled)
ui.title.onClick = function(widget)
  pushConfig.enabled = not pushConfig.enabled
  storage.AdvancedPushSystem.enabled = pushConfig.enabled
  widget:setOn(pushConfig.enabled)
  if pushConfig.enabled then
    pushSystemMacro.setOn()
    modules.game_textmessage.displayGameMessage("Advanced Push System ATIVADO!")
  else
    pushSystemMacro.setOff()
    modules.game_textmessage.displayGameMessage("Advanced Push System DESATIVADO!")
  end
end

ui.setup.onClick = function(widget)
  createConfigWindow()
  pushConfigWindow:show()
  pushConfigWindow:raise()
  pushConfigWindow:focus()
end

-- Direções mapeadas para teclas numéricas
local directionMap = {
    ["1"] = {x = -1, y =  1, name = "SW"}, -- Southwest
    ["2"] = {x =  0, y =  1, name = "S"},  -- South
    ["3"] = {x =  1, y =  1, name = "SE"}, -- Southeast
    ["4"] = {x = -1, y =  0, name = "W"},  -- West
    ["6"] = {x =  1, y =  0, name = "E"},  -- East
    ["7"] = {x = -1, y = -1, name = "NW"}, -- Northwest
    ["8"] = {x =  0, y = -1, name = "N"},  -- North
    ["9"] = {x =  1, y = -1, name = "NE"}  -- Northeast
}

-- Variáveis de estado
local currentTarget = nil
local lastLookName = nil
local lastLookTime = 0
local isLooking = false

-- Função para obter o target atual
local function getCurrentTarget()
    -- Método 1: Target atual (atacando/seguindo)
    local attackingTarget = g_game.getAttackingCreature()
    local followingTarget = g_game.getFollowingCreature()
    
    if attackingTarget then
        return attackingTarget
    elseif followingTarget then
        return followingTarget
    end
    
    -- Método 2: Target via Look (se configurado)
    if pushConfig.autoLook and currentTarget then
        return currentTarget
    end
    
    return nil
end

-- Função para empurrar o target (VERSÃO MELHORADA)
local function pushTarget(target, direction)
    if not target or not direction then
        return false
    end
    
    local targetPos = target:getPosition()
    local playerPos = pos()
    local newPos = {
        x = targetPos.x + direction.x,
        y = targetPos.y + direction.y,
        z = targetPos.z
    }
    
    -- Verificar se a posição de destino é válida
    local destTile = g_map.getTile(newPos)
    if not destTile or not destTile:isWalkable() or #destTile:getCreatures() > 0 then
        modules.game_textmessage.displayGameMessage("Não é possível empurrar para essa direção!")
        return false
    end
    
    -- CALCULAR distância atual do player até o target
    local currentDistance = getDistanceBetween(playerPos, targetPos)
    
    -- Se player está adjacente (distância 1), precisa se afastar ANTES do push
    if currentDistance <= 1 then
        local retreatPos = {
            x = playerPos.x - direction.x,
            y = playerPos.y - direction.y,
            z = playerPos.z
        }
        
        local retreatTile = g_map.getTile(retreatPos)
        if retreatTile and retreatTile:isWalkable() and #retreatTile:getCreatures() == 0 then
            -- Primeiro se afasta, depois empurra
            autoWalk(retreatPos, true, true)
            modules.game_textmessage.displayGameMessage("Posicionando para push eficiente...")
            
            -- Aguarda movimento e depois executa push
            schedule(300, function()
                g_game.move(target, newPos)
                modules.game_textmessage.displayGameMessage("Empurrando " .. target:getName() .. " para " .. direction.name .. " (push otimizado)")
            end)
        else
            -- Se não consegue se afastar, empurra mesmo assim
            g_game.move(target, newPos)
            modules.game_textmessage.displayGameMessage("Empurrando " .. target:getName() .. " para " .. direction.name .. " (sem otimização)")
        end
    else
        -- Player já está na distância ideal, empurra diretamente
        g_game.move(target, newPos)
        modules.game_textmessage.displayGameMessage("Empurrando " .. target:getName() .. " para " .. direction.name .. " (distância ideal)")
    end
    
    return true
end

-- Função para processar o look
local function processLookByName(creatureName)
    if not creatureName then return end
    -- Busca apenas criaturas no mesmo andar do player
    local playerZ = posz()
    local found = nil
    for _, spec in ipairs(getSpectators()) do
        if spec:getName():lower() == creatureName:lower() and spec:getPosition().z == playerZ then
            found = spec
            break
        end
    end
    if found then
        currentTarget = found
        modules.game_textmessage.displayGameMessage("Target definido via Look: " .. found:getName())
    else
        modules.game_textmessage.displayGameMessage("Não foi possível encontrar a criatura '" .. creatureName .. "' no mapa.")
    end
end

-- Callback para quando o player olha em uma criatura
onTextMessage(function(mode, text)
    if not pushConfig.enabled then return end
    local name = text:match("You see ([^%(]+) %(")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")
        lastLookName = name
        lastLookTime = now
        processLookByName(name)
    end
end)

-- Hotkeys para empurrar (1-9, exceto 5) - SEM NOME VISÍVEL
for key, direction in pairs(directionMap) do
    hotkey(key, "", function() -- Nome vazio para não aparecer na interface
        if not pushConfig.enabled then
            modules.game_textmessage.displayGameMessage("Sistema de Push desativado!")
            return
        end
        
        local target = getCurrentTarget()
        if not target then
            modules.game_textmessage.displayGameMessage("Nenhum target encontrado! Use 'Look' em uma criatura ou ataque-a.")
            return
        end
        
        -- Verificar distância
        local distance = getDistanceBetween(pos(), target:getPosition())
        if distance > pushConfig.maxDistance then
            modules.game_textmessage.displayGameMessage("Target muito distante! Distância: " .. distance)
            return
        end
        
        pushTarget(target, direction)
    end)
end

-- Hotkey para Look (L) - SEM NOME VISÍVEL
hotkey("L", "", function() -- Nome vazio para não aparecer na interface
    if not pushConfig.enabled then
        modules.game_textmessage.displayGameMessage("Sistema de Push desativado!")
        return
    end
    
    local tile = getTileUnderCursor()
    if tile then
        local creatures = tile:getCreatures()
        if #creatures > 0 then
            local creature = creatures[1]
            g_game.look(creature)
            modules.game_textmessage.displayGameMessage("Olhando em " .. creature:getName() .. "...")
        else
            modules.game_textmessage.displayGameMessage("Nenhuma criatura encontrada no tile!")
        end
    else
        modules.game_textmessage.displayGameMessage("Nenhum tile selecionado!")
    end
end)



-- Remover os ícones antigos e usar apenas a interface principal
-- (remover as linhas dos addIcon)

-- Informações iniciais
modules.game_textmessage.displayGameMessage("Advanced Push System carregado!")
modules.game_textmessage.displayGameMessage("Use o botão para ativar/desativar o sistema")
modules.game_textmessage.displayGameMessage("Teclas: 1-9 (empurrar), L (look), Setup (configuraçoes)") 
modules.game_textmessage.displayGameMessage("Você esta usando a Script da Guild MOST WANTED") 

