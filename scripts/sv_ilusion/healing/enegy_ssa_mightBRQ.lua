-- =============================================================================
-- [SOULE DEFENSE SYSTEMS V2.0] - DEFESA MASTER PRO: PARTE 1 DE 3
-- =============================================================================

setDefaultTab("hp")
UI.Separator()

-- =================================================================
--  1. ESTRUTURA DE COMPONENTES DA INTERFACE DE BACKPACKS
-- =================================================================
g_ui.loadUIFromString([[
DefMasterBPItem < Panel
  height: 34
  margin-top: 7
  margin-left: 25
  margin-right: 25

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter
    color: white

  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

DefMasterBPSwitch < Panel
  height: 30
  margin-top: 7
  margin-left: 25
  margin-right: 25

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter
    color: white

  Button
    id: switch
    anchors.top: parent.top
    anchors.right: parent.right
    width: 60
    height: 20
    text: OFF
    color: red

DefMasterBPTitle < UIWidget
  height: 30
  margin-top: 20
  margin-bottom: 10
  text-align: center
  color: yellow
  font: verdana-11px-rounded

DefMasterBPWindow < MainWindow
  id: janelaMestreDefesaBPs
  !text: tr('Defesa Master - Universal BP Settings')
  padding: 25

  VerticalScrollBar
    id: contentScroll
    anchors.top: parent.top
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

-- =================================================================
--  2. CONFIGURACOES, STORAGE E TABELA DE TEMPO LOCAL
-- =================================================================
local panelName = "Enegy_SSA"

if not storage[panelName] or not storage[panelName].bpConfigs then
    storage[panelName] = {
        enabled = false,
        ringEquipId = 3051,
        ringMightId = 3048,
        ringDeffId = 33422,
        ssaId = 3081,
        normalAmuletId = 3057,
        mainBagId = 0,
        ringBagId = 0,
        ssaBagId = 0,
        energyBagId = 0,
        hpEquip = 50,    -- HP maximo para colocar o Energy Ring
        mpMight = 75,    -- Mana maxima para colocar o Might Ring (Sua Regra!)
        hpSSA = 60,
        useSSA = false,
        bpConfigs = {
            { name = "BP MIGHT", autoOpen = true, keepSlotFree = false, targetItem = 3048 },
            { name = "BP ENERGY", autoOpen = true, keepSlotFree = false, targetItem = 3051 },
            { name = "BP SSA", autoOpen = true, keepSlotFree = false, targetItem = 3081 }
        }
    }
end
local s = storage[panelName]

local defMasterCooldowns = {}

local function findItemInContainer(itemId, containerId)
    if itemId <= 0 then return nil end
    for _, container in pairs(g_game.getContainers()) do
        if containerId == 0 or container:getContainerItem():getId() == containerId then
            for _, item in pairs(container:getItems()) do
                if item:getId() == itemId then 
                    return item 
                end
            end
        end
    end
    return nil
end

local function getContainerByItemId(bagId)
    if bagId <= 0 then return nil end
    for _, container in pairs(g_game.getContainers()) do
        local containerItem = container:getContainerItem()
        if containerItem and containerItem:getId() == bagId then
            return container
        end
    end
    return nil
end

-- =================================================================
--  3. INTERFACE PRINCIPAL (Painel Lateral da Home/HP)
-- =================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()
local ui = setupUI([[
Panel
  height: 40

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 125
    text: Defesa Master

  Button
    id: edit
    anchors.top: parent.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Config

  Button
    id: bpSettings
    anchors.top: title.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    height: 17
    text: BP Settings
    color: #FFA500
]], parent)
-- =============================================================================
-- [SOULE DEFENSE SYSTEMS V2.0] - DEFESA MASTER PRO: PARTE 2 DE 3
-- =============================================================================

-- Janela de Configuracoes Principal (HP / MP / Itens) - Ordem Fixada de Ancora
local configWindow = setupUI([[
MainWindow
  id: janelaConfiguracoesDefesaMaster
  text: Configuracoes de Defesa
  size: 540 340
  @onEscape: self:hide()

  Label
    id: t1
    text: --- ANEIS ---
    anchors.top: parent.top
    anchors.left: parent.left
    width: 240
    text-align: center
    color: green

  Panel
    id: rSlots
    anchors.top: t1.bottom
    anchors.left: parent.left
    height: 36
    width: 240
    margin-top: 5
    layout:
      type: horizontalBox
      spacing: 5
    BotItem
      id: r1
    BotItem
      id: rM
    BotItem
      id: r2

  Label
    id: lblE
    text: HP Energy: 50
    anchors.top: rSlots.bottom
    anchors.left: parent.left
    margin-top: 8

  HorizontalScrollBar
    id: scrollE
    anchors.top: lblE.bottom
    anchors.left: parent.left
    width: 240
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  Label
    id: lblM
    text: MP Might: 75
    anchors.top: scrollE.bottom
    anchors.left: parent.left
    margin-top: 8

  HorizontalScrollBar
    id: scrollM
    anchors.top: lblM.bottom
    anchors.left: parent.left
    width: 240
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  Label
    id: t2
    text: --- AMULETOS ---
    anchors.top: parent.top
    anchors.right: parent.right
    width: 240
    text-align: center
    color: #00FFFF

  Panel
    id: sSlots
    anchors.top: t2.bottom
    anchors.right: parent.right
    height: 36
    width: 240
    margin-top: 5
    layout:
      type: horizontalBox
      spacing: 5
    BotItem
      id: ssa
    BotItem
      id: amu

  CheckBox
    id: toggleSSA
    text: Ativar SSA
    anchors.top: sSlots.bottom
    anchors.left: sSlots.left
    width: 240
    margin-top: 10

  Label
    id: lblS
    text: HP SSA: 60
    anchors.top: toggleSSA.bottom
    anchors.left: sSlots.left
    margin-top: 5

  HorizontalScrollBar
    id: scrollS
    anchors.top: lblS.bottom
    anchors.left: sSlots.left
    width: 240
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  Label
    id: t3
    text: --- CONFIGURACAO DE BAGS ---
    anchors.top: scrollM.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-top: 15
    color: #FFA500

  Panel
    id: bagPanel
    anchors.top: t3.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 36
    margin-top: 8
    layout:
      type: horizontalBox
      spacing: 12

    Panel
      id: mainBagPanel
      width: 115
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: MAIN:
        margin-top: 10
      BotItem
        id: mBag

    Panel
      id: leftBagPanel
      width: 125
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: BP MIGHT:
        margin-top: 10
      BotItem
        id: rBag

    Panel
      id: energyBagPanel
      width: 130
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: BP ENERGY:
        margin-top: 10
      BotItem
        id: eBag

    Panel
      id: rightBagPanel
      width: 110
      height: 36
      layout:
        type: horizontalBox
        spacing: 3
      Label
        text: BP SSA:
        margin-top: 10
      BotItem
        id: sBag

  Button
    id: close
    text: Salvar
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    width: 120
    height: 22
]], widgetRaizDoJogo)
configWindow:hide()

-- Coletor de lixo preventivo para abas antigas de BPs
for _, child in pairs(widgetRaizDoJogo:getChildren()) do
    if child:getId() == "janelaMestreDefesaBPs" and child ~= bpSettingsWindow then
        pcall(function() child:destroy() end)
    end
end

local bpSettingsWindow = UI.createWindow('DefMasterBPWindow', widgetRaizDoJogo)
bpSettingsWindow:hide()
bpSettingsWindow.closeButton.onClick = function() bpSettingsWindow:hide() end
bpSettingsWindow:setHeight(450)
bpSettingsWindow:setWidth(400)

-- =================================================================
--  4. MONTAGEM DINAMICA DO PAINEL DE MOCHILAS
-- =================================================================
local leftPanel = bpSettingsWindow.content.left

local addSwitch = function(id, title, defaultValue, dest, configField)
    local widget = UI.createWidget('DefMasterBPSwitch', dest)
    widget.text:setText(title)
    
    local function updateButtonState(isOn)
        if isOn then
            widget.switch:setText("ON")
            widget.switch:setColor("green")
        else
            widget.switch:setText("OFF")
            widget.switch:setColor("red")
        end
    end
    
    updateButtonState(defaultValue)
    
    widget.switch.onClick = function()
        local currentState = s.bpConfigs[id][configField]
        local newState = not currentState
        s.bpConfigs[id][configField] = newState
        updateButtonState(newState)
    end
end

local addItemEdit = function(id, title, defaultItem, dest, configField)
    local widget = UI.createWidget('DefMasterBPItem', dest)
    widget.text:setText(title)
    widget.item:setItemId(defaultItem or 0)
    widget.item.onItemChange = function(w)
        s.bpConfigs[id][configField] = w:getItemId()
    end
end

for i = 1, 3 do
    local bpData = s.bpConfigs[i]
    local titleWidget = UI.createWidget('DefMasterBPTitle', leftPanel)
    titleWidget:setText("=== " .. bpData.name .. " ===")
    addSwitch(i, "Auto-Open Proxima BP", bpData.autoOpen, leftPanel, "autoOpen")
    addSwitch(i, "Manter Slot Livre", bpData.keepSlotFree, leftPanel, "keepSlotFree")
    addItemEdit(i, "Item para Monitorar/Drop", bpData.targetItem, leftPanel, "targetItem")
end
-- =============================================================================
-- [SOULE DEFENSE SYSTEMS V2.0] - DEFESA MASTER PRO: PARTE 3 DE 3 (SCROLLBAR FIX)
-- =============================================================================

-- 5. EXECUÇÃO DO MACRO E CONDICIONAIS RECALIBRADAS (HP/MP FIX)
macro(100, "Defesa Master", function()
    if not s.enabled then return end
    
    local hp = hppercent()
    local mp = manapercent() -- Coleta a porcentagem real de Mana do boneco
    local now = os.time()

    -- Trava Anti-Spam de abertura de bolsas
    local function checkAndOpenBag(bagId, itemId)
        if bagId and bagId > 0 then
            if getContainerByItemId(bagId) then return end
            if itemId and itemId > 0 and findItemInContainer(itemId, 0) then return end

            if defMasterCooldowns[bagId] and (now - defMasterCooldowns[bagId] < 2) then return end

            local bagItem = findItemInContainer(bagId, s.mainBagId)
            if bagItem then
                g_game.use(bagItem)
                defMasterCooldowns[bagId] = now 
                delay(500)
            end
        end
    end

    -- LOGICA DA BP PRINCIPAL
    if s.mainBagId and s.mainBagId > 0 then
        if not getContainerByItemId(s.mainBagId) then
            if not defMasterCooldowns[s.mainBagId] or (now - defMasterCooldowns[s.mainBagId] >= 2) then
                g_game.useInventoryItem(s.mainBagId)
                defMasterCooldowns[s.mainBagId] = now
                delay(500)
            end
        end
    end

    checkAndOpenBag(s.ringBagId, s.ringMightId)
    checkAndOpenBag(s.energyBagId, s.ringEquipId)
    checkAndOpenBag(s.ssaBagId, s.ssaId)

    -- REGRAS DAS CONFIGURACOES DE BAGS
    local bpMapping = { s.ringBagId, s.energyBagId, s.ssaBagId }
    
    for i = 1, 3 do
        local bpRule = s.bpConfigs[i]
        local actualBagId = bpMapping[i]
        
        if actualBagId and actualBagId > 0 and bpRule.targetItem > 0 then
            local container = getContainerByItemId(actualBagId)
            if container then
                -- Abre a proxima mochila e fecha a janela vazia antiga
                if bpRule.autoOpen then
                    local itemCount = 0
                    for _, item in pairs(container:getItems()) do
                        if item:getId() == bpRule.targetItem then
                            itemCount = itemCount + item:getCount()
                        end
                    end
                    if itemCount == 0 then
                        for _, item in pairs(container:getItems()) do
                            if item:isContainer() then
                                local internalId = item:getId()
                                if not defMasterCooldowns[internalId] or (now - defMasterCooldowns[internalId] >= 2) then
                                    g_game.use(item)
                                    g_game.close(container)
                                    defMasterCooldowns[internalId] = now
                                    delay(600)
                                end
                                break
                            end
                        end
                    end
                end

                if bpRule.keepSlotFree then
                    if container:getItemsCount() >= container:getCapacity() then
                        for _, item in pairs(container:getItems()) do
                            if item:getId() == bpRule.targetItem then
                                g_game.move(item, pos(), item:getCount())
                                delay(300)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    -- FUNÇÃO DE AUTO-ORGANIZAÇÃO DE ITENS NAS MOCHILAS CORRETAS
    local function organizeItems(itemId, targetBagId)
        if itemId <= 0 or s.mainBagId <= 0 then return end
        
        local mainContainer = getContainerByItemId(s.mainBagId)
        if not mainContainer then return end
        
        local currentRing = getFinger()
        local currentNeck = getNeck()
        
        local isEquipped = (currentRing and currentRing:getId() == itemId) or (currentNeck and currentNeck:getId() == itemId)
        if isEquipped then return end

        if itemId == s.ringDeffId or itemId == s.normalAmuletId then
            for _, container in pairs(g_game.getContainers()) do
                if container:getContainerItem():getId() ~= s.mainBagId then
                    for _, item in pairs(container:getItems()) do
                        if item:getId() == itemId then
                            g_game.move(item, mainContainer:getSlotPosition(mainContainer:getItemsCount()), item:getCount())
                            delay(200)
                            return
                        end
                    end
                end
            end
        else
            if targetBagId <= 0 then return end
            local targetContainer = getContainerByItemId(targetBagId)
            if not targetContainer then return end
            
            for _, container in pairs(g_game.getContainers()) do
                if container:getContainerItem():getId() ~= targetBagId then
                    for _, item in pairs(container:getItems()) do
                        if item:getId() == itemId then
                            g_game.move(item, targetContainer:getSlotPosition(targetContainer:getItemsCount()), item:getCount())
                            delay(200)
                            return
                        end
                    end
                end
            end
        end
    end

    organizeItems(s.ringDeffId, 0)
    organizeItems(s.normalAmuletId, 0)
    organizeItems(s.ringMightId, s.ringBagId)   
    organizeItems(s.ringEquipId, s.energyBagId) 
    organizeItems(s.ssaId, s.ssaBagId)         

    -- LOGICA DE EQUIPAR AMULETOS (BASEADO ESTREITAMENTE NA VIDA)
    local currentNeck = getNeck()
    if s.useSSA and hp <= s.hpSSA then
        if not currentNeck or currentNeck:getId() ~= s.ssaId then
            local item = findItemInContainer(s.ssaId, s.ssaBagId)
            if item then moveToSlot(item, SlotNeck) end
        end
    elseif hp > (s.hpSSA + 3) then
        if s.normalAmuletId > 0 and (not currentNeck or currentNeck:getId() ~= s.normalAmuletId) then
            local item = findItemInContainer(s.normalAmuletId, s.mainBagId)
            if item then moveToSlot(item, SlotNeck) end
        end
    end

    -- RECALIBRAÇÃO MESTRE DOS ANÉIS: Separação cirúrgica entre HP (Energy) e MP (Might)
    local currentRing = getFinger()
    local targetRing = s.ringDeffId 
    local targetBag = s.mainBagId 

    -- Se a VIDA (hp) cair abaixo do "HP Energy", bota o Energy Ring
    if hp <= (s.hpEquip or 50) then
        targetRing = s.ringEquipId
        targetBag = s.energyBagId 
    -- Se a MANA (mp) cair abaixo do "MP Might", bota o Might Ring
    elseif mp <= (s.mpMight or 75) then
        targetRing = s.ringMightId
        targetBag = s.ringBagId 
    end

    if targetRing > 0 and (not currentRing or currentRing:getId() ~= targetRing) then
        local item = findItemInContainer(targetRing, targetBag)
        if item then moveToSlot(item, SlotFinger) end
    end
end)

-- =================================================================
--  6. CONEXOES DE ACIONAMENTO DA INTERFACE VISUAL (SETUP)
-- =================================================================
ui.title:setOn(s.enabled)
ui.title.onClick = function(w)
    s.enabled = not s.enabled
    w:setOn(s.enabled)
end

ui.edit.onClick = function()
    configWindow:show() configWindow:raise() configWindow:focus()
end

ui.bpSettings.onClick = function()
    bpSettingsWindow:show() bpSettingsWindow:raise() bpSettingsWindow:focus()
end

configWindow.rSlots.r1:setItemId(s.ringEquipId)
configWindow.rSlots.r1.onItemChange = function(w) s.ringEquipId = w:getItemId() end

configWindow.rSlots.rM:setItemId(s.ringMightId)
configWindow.rSlots.rM.onItemChange = function(w) s.ringMightId = w:getItemId() end

configWindow.rSlots.r2:setItemId(s.ringDeffId)
configWindow.rSlots.r2.onItemChange = function(w) s.ringDeffId = w:getItemId() end

configWindow.bagPanel.mainBagPanel.mBag:setItemId(s.mainBagId)
configWindow.bagPanel.mainBagPanel.mBag.onItemChange = function(w) s.mainBagId = w:getItemId() end

configWindow.bagPanel.leftBagPanel.rBag:setItemId(s.ringBagId)
configWindow.bagPanel.leftBagPanel.rBag.onItemChange = function(w) s.ringBagId = w:getItemId() end

configWindow.bagPanel.energyBagPanel.eBag:setItemId(s.energyBagId)
configWindow.bagPanel.energyBagPanel.eBag.onItemChange = function(w) s.energyBagId = w:getItemId() end

configWindow.bagPanel.rightBagPanel.sBag:setItemId(s.ssaBagId)
configWindow.bagPanel.rightBagPanel.sBag.onItemChange = function(w) s.ssaBagId = w:getItemId() end

-- CORREÇÃO INDEPENDENTE DE ASSINATURA: Aplica as declarações de escopo de forma isolada
configWindow.scrollE.onValueChange = function(w, v)
    s.hpEquip = tonumber(v) or 50
    configWindow.lblE:setText("HP Energy: " .. s.hpEquip)
end

configWindow.scrollM.onValueChange = function(w, v)
    s.mpMight = tonumber(v) or 75
    configWindow.lblM:setText("MP Might: " .. s.mpMight)
end

configWindow.scrollS.onValueChange = function(w, v)
    s.hpSSA = tonumber(v) or 60
    configWindow.lblS:setText("HP SSA: " .. s.hpSSA)
end

-- Atribuição de valores travada após os construtores de eventos estarem definidos na RAM
configWindow.scrollE:setValue(tonumber(s.hpEquip) or 50)
configWindow.scrollM:setValue(tonumber(s.mpMight) or 75)
configWindow.scrollS:setValue(tonumber(s.hpSSA) or 60)

configWindow.sSlots.ssa:setItemId(s.ssaId)
configWindow.sSlots.ssa.onItemChange = function(w) s.ssaId = w:getItemId() end

configWindow.sSlots.amu:setItemId(s.normalAmuletId)
configWindow.sSlots.amu.onItemChange = function(w) s.normalAmuletId = w:getItemId() 
end

configWindow.toggleSSA:setChecked(s.useSSA == true)
configWindow.toggleSSA.onCheckChange = function(w, c) s.useSSA = c end

configWindow.close.onClick = function()
configWindow:hide()
end
UI.Separator()
