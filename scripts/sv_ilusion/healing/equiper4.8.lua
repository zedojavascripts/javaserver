-- Define a aba padrão onde o ícone/botão da macro vai aparecer no vBot
setDefaultTab("hp")

local panelName = "EquipperPanel"

-- Guardando a primeira parte do visual SEM ACENTOS em formato de texto
local otuiText = [[
Panel
  height: 19

  BotSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Gerenciar EQ')

  Button
    id: setup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: SETUP

SlotBotItem < BotItem
  border-width: 0
  $on:
    image-source: /images/ui/item
  $checked:
    border-width: 1
    border-color: #FF0000

BossLabel < UIWidget
  background-color: alpha
  text-offset: 3 1
  focusable: true
  height: 16
  font: verdana-11px-rounded
  text-align: left

  $focus:
    background-color: #00000055

  Button
    id: remove
    !text: tr('X')
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 14
    height: 14
    margin-right: 15
    text-align: center
    text-offset: 0 1
    tooltip: Remover perfil da lista.

ConditionBoxPopupMenu < ComboBoxPopupMenu
ConditionBoxPopupMenuButton < ComboBoxPopupMenuButton
ConditionBox < ComboBox
  @onSetup: |
    self:addOption("-")
    self:addOption("e")
    self:addOption("ou")

PreButton < PreviousButton
  background: #363636
  height: 15

NexButton < NextButton
  background: #363636
  height: 15

CondidionLabel < FlatPanel
  padding: 1
  height: 15

  Label
    id: text
    anchors.fill: parent
    text-align: center
    font: verdana-11px-rounded
    background: #363636
]]
-- ==========================================
-- SOMA DO TEXTO DA INTERFACE SEM ACENTOS - PARTE 2
-- ==========================================
otuiText = otuiText .. [[
Rule < UIWidget
  background-color: alpha
  text-offset: 18 2
  focusable: true
  height: 16
  text-align: left
  font: verdana-11px-rounded  

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 15
    height: 15
    margin-top: 2
    margin-left: 3
    tooltip: Regra ativada/desativada

  $focus:
    background-color: #00000055

  Button
    id: remove
    text: X
    anchors.right: parent.right
    margin-right: 15
    width: 14
    height: 14
    text-align: center
    tooltip: Remover regra
    anchors.verticalCenter: parent.verticalCenter

  Button
    id: visible
    text: V
    anchors.right: prev.left
    margin-right: 3
    width: 14
    height: 14
    text-align: center
    tooltip: Os itens devem estar visiveis na backpack
    anchors.verticalCenter: parent.verticalCenter

ConditionPanel < Panel
  height: 58

  NexButton
    id: nex
    anchors.top: parent.top
    margin-top: 5
    anchors.right: parent.right

  PreButton
    id: pre
    anchors.top: parent.top
    margin-top: 5
    anchors.left: parent.left

  CondidionLabel
    id: description
    anchors.top: parent.top
    margin-top: 5
    anchors.left: prev.right
    anchors.right: nex.left
    margin-left: 3
    margin-right: 3

  SpinBox
    id: spinbox
    anchors.top: description.bottom
    margin-top: 10
    anchors.horizontalCenter: parent.horizontalCenter
    width: 100
    text-align: center
    minimum: 0
    maximum: 100
    step: 1
    focusable: true

  BotTextEdit
    id: text
    anchors.top: description.bottom
    margin-top: 10
    anchors.horizontalCenter: parent.horizontalCenter
    width: 200
    text-align: center

ListPanel < FlatPanel
  size: 270 300
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  Label
    id: title
    anchors.verticalCenter: parent.top
    anchors.left: parent.left
    text: Lista de Regras
    font: verdana-11px-rounded
    color: #FABD02

  Label
    id: mainLabel
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 10
    margin-left: 2
    !text: tr('As regras do topo possuem maior prioridade.')
    text-align: left
    font: verdana-11px-rounded
    color: #aeaeae  

  TextList
    id: list
    anchors.fill: parent
    margin-top: 25
    margin-bottom: 18
    vertical-scrollbar: listScrollBar
    padding: 2

  VerticalScrollBar
    id: listScrollBar
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: list.right
    step: 14
    pixels-scroll: true

  Button
    id: up
    anchors.right: parent.right
    anchors.top: list.bottom
    size: 60 17
    text: Subir
    text-align: center
    font: cipsoftFont
    margin-top: 5
    tooltip: Aumentar a prioridade da regra selecionada.

  Button
    id: down
    anchors.right: prev.left
    anchors.verticalCenter: prev.verticalCenter
    size: 60 17
    margin-right: 5
    text: Descer
    text-align: center
    font: cipsoftFont
    tooltip: Diminuir a prioridade da regra selecionada.
]]
-- ==========================================
-- FINAL DA INTERFACE SEM ACENTOS - PARTE 3
-- ==========================================
otuiText = otuiText .. [[
InputPanel < FlatPanel
  size: 270 300
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  Label
    id: title
    anchors.verticalCenter: parent.top
    anchors.left: parent.left
    text: Painel de Condicoes
    font: verdana-11px-rounded
    color: #FF0000

  Label
    id: mainLabel
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 10
    text: Equipar itens selecionados quando:
    text-align: center
    font: verdana-11px-rounded
    color: #aeaeae

  HorizontalSeparator
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 4
    
  ConditionPanel
    id: condition
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: mainLabel.bottom
    margin-top: 15

  HorizontalSeparator
    anchors.verticalCenter: next.verticalCenter
    anchors.left: parent.left
    anchors.right: parent.right

  ConditionBox
    id: useSecondCondition
    anchors.top: condition.bottom
    margin-top: 10
    anchors.horizontalCenter: parent.horizontalCenter
    width: 50

  ConditionPanel
    id: optionalCondition
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 10

  HorizontalSeparator
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom

  BotButton
    id: add
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    margin-bottom: 10
    text: Adicionar Regra

EQPanel < FlatPanel
  size: 160 230
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  Label
    id: title
    anchors.verticalCenter: parent.top
    anchors.left: parent.left
    text: Configuracao de Itens
    font: verdana-11px-rounded
    color: #03C04A

  SlotBotItem
    id: head
    image-source: /images/game/slots/head
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 15
    $on:
      image-source: /images/ui/item

  SlotBotItem
    id: body
    image-source: /images/game/slots/body
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item

  SlotBotItem
    id: legs
    image-source: /images/game/slots/legs
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item

  SlotBotItem
    id: feet
    image-source: /images/game/slots/feet
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item

  SlotBotItem
    id: neck
    image-source: /images/game/slots/neck
    anchors.top: head.top
    margin-top: 13
    anchors.right: head.left
    margin-right: 5
    $on:
      image-source: /images/ui/item

  SlotBotItem
    id: left-hand
    image-source: /images/game/slots/left-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item

  SlotBotItem
    id: finger
    image-source: /images/game/slots/finger
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item

  Item
    id: back
    image-source: /images/game/slots/back-blessed
    anchors.top: head.top
    margin-top: 13
    anchors.left: head.right
    margin-left: 5
    tooltip: Modificacoes na backpack principal nao estao disponiveis.

  SlotBotItem
    id: right-hand
    image-source: /images/game/slots/right-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item

  SlotBotItem
    id: ammo
    image-source: /images/game/slots/ammo
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5

  BotButton
    id: cloneEq
    anchors.top: feet.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 15
    text: Clonar EQ Atual
    font: verdana-11px-rounded
    tooltip: Copia os itens equipados e nao equipados atuais.

  BotButton
    id: default
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    text: Limpar campos
    font: verdana-11px-rounded
    tooltip: Reseta todos os campos para o estado em branco

Profile < FlatPanel
  size: 160 35

  Label
    id: title
    anchors.verticalCenter: parent.top
    anchors.left: parent.left
    margin-left: 10
    text: Nome do Perfil
    font: verdana-11px-rounded

  BotTextEdit
    id: profileName
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: 5

BossList < FlatPanel
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  Label
    id: title
    anchors.verticalCenter: parent.top
    anchors.left: parent.left
    text: Lista de Bosses
    font: verdana-11px-rounded
    color: #FABD02

  TextList
    id: list
    anchors.fill: parent
    margin-top: 10
    margin-bottom: 20
    vertical-scrollbar: listScrollBar
    padding: 2

  VerticalScrollBar
    id: listScrollBar
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: list.right
    step: 14
    pixels-scroll: true

  BotTextEdit
    id: name
    anchors.left: list.left
    anchors.top: list.bottom
    margin-top: 4
    anchors.right: next.left

  Button
    id: add
    anchors.right: list.right
    anchors.top: list.bottom
    margin-top: 3
    height: 21
    text: Add Boss
    text-align: center
    font: verdana-11px-rounded
    tooltip: Criaturas com este nome serao consideradas como Boss.

EquipWindow < MainWindow
  size: 750 350
  text: Gerenciador de Equipamentos (Equip Manager)
  @onEscape: self:hide()

  ListPanel
    id: listPanel
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: bottomSep.top
    margin-bottom: 5
    margin-left: -2
    visible: false

  BossList
    id: bossPanel
    anchors.fill: prev
    visible: true

  VerticalSeparator
    anchors.top: parent.top
    anchors.bottom: bottomSep.top
    margin-bottom: 5
    anchors.left: prev.right
    margin-left: 10
  
  Profile
    id: profileName
    anchors.top: parent.top
    anchors.left: prev.right
    margin-left: 10

  EQPanel
    id: setup
    anchors.left: prev.left
    anchors.top: prev.bottom
    anchors.bottom: bottomSep.top
    margin-bottom: 5
    margin-top: 10

  InputPanel
    id: inputPanel
    anchors.left: prev.right
    anchors.top: parent.top
    anchors.bottom: bottomSep.top
    margin-bottom: 5
    margin-left: 5

  HorizontalSeparator
    id: bottomSep
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8    

  Button
    id: closeButton
    !text: tr('Fechar')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21  

  Button
    id: bossList
    !text: tr('Lista de Bosses')
    font: cipsoftFont
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    size: 65 21
]]

local ui = setupUI(otuiText)
ui:setId(panelName)
-- ==========================================
-- INICIALIZACAO DE DADOS E CONDICOES SEM ACENTOS - PARTE 4
-- ==========================================
if not storage[panelName] or not storage[panelName].bosses then
    storage[panelName] = {
        enabled = false,
        rules = {},
        bosses = {}
    }
end

local config = storage[panelName]

ui.switch:setOn(config.enabled)
ui.switch.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
end

-- Lista de condicoes totalmente limpa de acentos
local conditions = {
    "Item esta disponivel e nao equipado.", -- 1
    "Monstros ao redor e maior que: ", -- 2
    "Monstros ao redor e menor que: ", -- 3
    "Porcentagem de Vida esta abaixo de:", -- 4
    "Porcentagem de Vida esta acima de:", -- 5
    "Porcentagem de Mana esta abaixo de:", -- 6
    "Porcentagem de Mana esta acima de:", -- 7
    "Nome do Alvo e:", -- 8
    "Hotkey esta sendo pressionada:", -- 9
    "O Jogador esta paralisado", -- 10
    "O Jogador esta em Protection Zone (PZ)", -- 11
    "Jogadores ao redor e maior que:", -- 12
    "Jogadores ao redor e menor que:", -- 13
    "Perigo do TargetBot esta Acima de:", -- 14
    "Jogador da Blacklist esta no alcance (sqm)", -- 15
    "O Alvo e um Boss", -- 16
    "O Jogador NAO esta em Protection Zone", -- 17
    "CaveBot esta LIGADO, TargetBot DESLIGADO" -- 18
}

local conditionNumber = 1
local optionalConditionNumber = 2

local mainWindow = UI.createWindow("EquipWindow")
mainWindow:hide()

ui.setup.onClick = function()
    mainWindow:show()
    mainWindow:raise()
    mainWindow:focus()
end

local inputPanel = mainWindow.inputPanel
local listPanel = mainWindow.listPanel
local namePanel = mainWindow.profileName
local eqPanel = mainWindow.setup
local bossPanel = mainWindow.bossPanel

local slotWidgets = {
    eqPanel.head, 
    eqPanel.body, 
    eqPanel.legs, 
    eqPanel.feet, 
    eqPanel.neck, 
    eqPanel["left-hand"], 
    eqPanel["right-hand"], 
    eqPanel.finger, 
    eqPanel.ammo
}

local function setCondition(first, n)
    local widget, spinBox, textEdit

    if first then
        widget = inputPanel.condition.description.text
        spinBox = inputPanel.condition.spinbox
        textEdit = inputPanel.condition.text
    else
        widget = inputPanel.optionalCondition.description.text
        spinBox = inputPanel.optionalCondition.spinbox
        textEdit = inputPanel.optionalCondition.text
    end

    spinBox:setValue(0)
    textEdit:setText('')

    if n == 1 or n == 10 or n == 11 or n == 16 or n == 17 or n == 18 then
        spinBox:hide()
        textEdit:hide()
    elseif n == 9 or n == 8 then
        spinBox:hide()
        textEdit:show()
        if n == 9 then
            textEdit:setWidth(75)
        else
            textEdit:setWidth(200)
        end
    else
        spinBox:show()
        textEdit:hide()
    end
    widget:setText(conditions[n])
end
-- ==========================================
-- GERENCIAMENTO DE INTERFACE E BOTOES SEM ACENTOS - PARTE 5
-- ==========================================
local function resetFields()
    conditionNumber = 1
    optionalConditionNumber = 2
    setCondition(false, optionalConditionNumber)
    setCondition(true, conditionNumber)
    for i, widget in ipairs(slotWidgets) do
        widget:setItemId(0)
        widget:setChecked(false)
    end
    for i, child in ipairs(listPanel.list:getChildren()) do
        child.display = false
    end
    namePanel.profileName:setText("")
    inputPanel.condition.text:setText('')
    inputPanel.condition.spinbox:setValue(0)
    inputPanel.useSecondCondition:setText('-')
    inputPanel.optionalCondition.text:setText('')
    inputPanel.optionalCondition.spinbox:setValue(0)
    inputPanel.optionalCondition:hide()
    bossPanel:hide()
    listPanel:show()
    mainWindow.bossList:setText('Lista de Bosses')
    bossPanel.name:setText('')
end
resetFields()

mainWindow.closeButton.onClick = function()
    resetFields()
    mainWindow:hide()
end

inputPanel.optionalCondition:hide()
inputPanel.useSecondCondition.onOptionChange = function(widget, option, data)
    if option ~= "-" then
        inputPanel.optionalCondition:show()
    else
        inputPanel.optionalCondition:hide()
    end
end

setCondition(true, 1)
setCondition(false, 2)

inputPanel.condition.nex.onClick = function()
    local max = #conditions
    if inputPanel.optionalCondition:isVisible() then
        if conditionNumber == max then
            conditionNumber = (optionalConditionNumber == 1) and 2 or 1
        else
            local futureNumber = conditionNumber + 1
            local safeFutureNumber = (conditionNumber + 2 > max) and 1 or conditionNumber + 2
            conditionNumber = (futureNumber ~= optionalConditionNumber) and futureNumber or safeFutureNumber
        end
    else
        conditionNumber = (conditionNumber == max) and 1 or conditionNumber + 1
        if optionalConditionNumber == conditionNumber then
            optionalConditionNumber = (optionalConditionNumber == max) and 1 or optionalConditionNumber + 1
            setCondition(false, optionalConditionNumber)
        end
    end
    setCondition(true, conditionNumber)
end

inputPanel.condition.pre.onClick = function()
    local max = #conditions
    if inputPanel.optionalCondition:isVisible() then
        if conditionNumber == 1 then
            conditionNumber = (optionalConditionNumber == max) and (max - 1) or max
        else
            local futureNumber = conditionNumber - 1
            local safeFutureNumber = (conditionNumber - 2 < 1) and max or conditionNumber - 2
            conditionNumber = (futureNumber ~= optionalConditionNumber) and futureNumber or safeFutureNumber
        end
    else
        conditionNumber = (conditionNumber == 1) and max or conditionNumber - 1
        if optionalConditionNumber == conditionNumber then
            optionalConditionNumber = (optionalConditionNumber == 1) and max or optionalConditionNumber - 1
            setCondition(false, optionalConditionNumber)
        end
    end
    setCondition(true, conditionNumber)
end

inputPanel.optionalCondition.nex.onClick = function()
    local max = #conditions
    if optionalConditionNumber == max then
        optionalConditionNumber = (conditionNumber == 1) and 2 or 1
    else
        local futureNumber = optionalConditionNumber + 1
        local safeFutureNumber = (optionalConditionNumber + 2 > max) and 1 or optionalConditionNumber + 2
        optionalConditionNumber = (futureNumber ~= conditionNumber) and futureNumber or safeFutureNumber
    end
    setCondition(false, optionalConditionNumber)
end

inputPanel.optionalCondition.pre.onClick = function()
    local max = #conditions
    if optionalConditionNumber == 1 then
        optionalConditionNumber = (conditionNumber == max) and (max - 1) or max
    else
        local futureNumber = optionalConditionNumber - 1
        local safeFutureNumber = (optionalConditionNumber - 2 < 1) and max or optionalConditionNumber - 2
        optionalConditionNumber = (futureNumber ~= conditionNumber) and futureNumber or safeFutureNumber
    end
    setCondition(false, optionalConditionNumber)
end

listPanel.up.onClick = function(widget)
    local focused = listPanel.list:getFocusedChild()
    local n = listPanel.list:getChildIndex(focused)
    local t = config.rules
    t[n], t[n-1] = t[n-1], t[n]
    if n-1 == 1 then widget:setEnabled(false) end
    listPanel.down:setEnabled(true)
    listPanel.list:moveChildToIndex(focused, n-1)
    listPanel.list:ensureChildVisible(focused)
end

listPanel.down.onClick = function(widget)
    local focused = listPanel.list:getFocusedChild()    
    local n = listPanel.list:getChildIndex(focused)
    local t = config.rules
    t[n], t[n+1] = t[n+1], t[n]
    if n + 1 == listPanel.list:getChildCount() then widget:setEnabled(false) end
    listPanel.up:setEnabled(true)
    listPanel.list:moveChildToIndex(focused, n+1)
    listPanel.list:ensureChildVisible(focused)
end

eqPanel.cloneEq.onClick = function(widget)
    eqPanel.head:setItemId(getHead() and getHead():getId() or 0)
    eqPanel.body:setItemId(getBody() and getBody():getId() or 0)
    eqPanel.legs:setItemId(getLeg() and getLeg():getId() or 0)
    eqPanel.feet:setItemId(getFeet() and getFeet():getId() or 0)  
    eqPanel.neck:setItemId(getNeck() and getNeck():getId() or 0)   
    eqPanel["left-hand"]:setItemId(getLeft() and getLeft():getId() or 0)
    eqPanel["right-hand"]:setItemId(getRight() and getRight():getId() or 0)
    eqPanel.finger:setItemId(getFinger() and getFinger():getId() or 0)    
    eqPanel.ammo:setItemId(getAmmo() and getAmmo():getId() or 0)    
end

eqPanel.default.onClick = resetFields
listPanel.up:setEnabled(false)
listPanel.down:setEnabled(false)
-- ==========================================
-- COMPORTAMENTO DOS SLOTS E REGRAS SEM ACENTOS - PARTE 6
-- ==========================================
for i, widget in ipairs(slotWidgets) do
    widget:setTooltip("Clique direito para definir este slot para DESEQUIPAR")
    widget.onItemChange = function(widget)
        local selfId = widget:getItemId()
        widget:setOn(selfId > 100)
        if widget:isChecked() then
            widget:setChecked(selfId < 100)
        end
    end
    widget.onMouseRelease = function(widget, mousePos, mouseButton)
        if mouseButton == 2 then
            local clearItem = widget:isChecked() == false
            widget:setChecked(not widget:isChecked())
            if clearItem then
                widget:setItemId(0)
            end
        end
    end
end

inputPanel.condition.description.onMouseWheel = function(widget, mousePos, scroll)
    if scroll == 1 then inputPanel.condition.nex.onClick() else inputPanel.condition.pre.onClick() end
end

inputPanel.optionalCondition.description.onMouseWheel = function(widget, mousePos, scroll)
    if scroll == 1 then inputPanel.optionalCondition.nex.onClick() else inputPanel.optionalCondition.pre.onClick() end
end

namePanel.profileName.onTextChange = function(widget, text)
    local button = inputPanel.add
    text = text:lower()
    for i, child in ipairs(listPanel.list:getChildren()) do
        local name = child:getText():lower()
        button:setText(name == text and "Substituir" or "Adicionar Regra")
        button:setTooltip(name == text and "Substituir regra existente chamada: "..name, "Adicionar nova regra a lista: "..name)
    end
end

local function setupPreview(display, data)
    namePanel.profileName:setText('')
    if not display then
        resetFields()
    else
        for i, value in ipairs(data) do
            local widget = slotWidgets[i]
            if value == false then
                widget:setChecked(false)
                widget:setItemId(0)
            elseif value == true then
                widget:setChecked(true)
                widget:setItemId(0)
            else
                widget:setChecked(false)
                widget:setItemId(value)       
            end
        end
    end
end

local function refreshRules()
    local list = listPanel.list
    list:destroyChildren()
    for i,v in ipairs(config.rules) do
        local widget = UI.createWidget('Rule', list)
        widget:setId(v.name)
        widget:setText(v.name)
        widget.ruleData = v
        widget.remove.onClick = function()
            widget:destroy()
            table.remove(config.rules, table.find(config.rules, v))
            listPanel.up:setEnabled(false)
            listPanel.down:setEnabled(false)
            refreshRules()
        end
        widget.visible:setColor(v.visible and "green" or "red")
        widget.visible.onClick = function()
            v.visible = not v.visible
            widget.visible:setColor(v.visible and "green" or "red")
        end
        widget.enabled:setChecked(v.enabled)
        widget.enabled.onClick = function()
            v.enabled = not v.enabled
            widget.enabled:setChecked(v.enabled)
        end
        widget.onHoverChange = function(widget, hover)
            for i, child in ipairs(list:getChildren()) do
                if child.display then return end
            end
            setupPreview(hover, widget.ruleData.data)
        end
        widget.onDoubleClick = function(widget)
            local ruleData = widget.ruleData
            widget.display = true
            setupPreview(true, ruleData.data)
            conditionNumber = ruleData.mainCondition
            optionalConditionNumber = ruleData.optionalCondition
            setCondition(false, optionalConditionNumber)
            setCondition(true, conditionNumber)
            inputPanel.useSecondCondition:setOption(ruleData.relation)
            namePanel.profileName:setText(v.name)

            if type(ruleData.mainValue) == "string" then
                inputPanel.condition.text:setText(ruleData.mainValue)
            elseif type(ruleData.mainValue) == "number" then
                inputPanel.condition.spinbox:setValue(ruleData.mainValue)
            end

            if type(ruleData.optValue) == "string" then
                inputPanel.optionalCondition.text:setText(ruleData.optValue)
            elseif type(ruleData.optValue) == "number" then
                inputPanel.optionalCondition.spinbox:setValue(ruleData.optValue)
            end
        end
        widget.onClick = function()
            local panel = listPanel
            if #panel.list:getChildren() == 1 then
                panel.up:setEnabled(false)
                panel.down:setEnabled(false)
            elseif panel.list:getChildIndex(panel.list:getFocusedChild()) == 1 then
                panel.up:setEnabled(false)
                panel.down:setEnabled(true)
            elseif panel.list:getChildIndex(panel.list:getFocusedChild()) == #panel.list:getChildren() then
                panel.up:setEnabled(true)
                panel.down:setEnabled(false)
            else
                panel.up:setEnabled(true)
                panel.down:setEnabled(true)
            end
        end
    end
end
refreshRules()
-- ==========================================
-- ADICIONAR REGRAS, BOSSES E CONDICOES SEM ACENTOS - PARTE 7
-- ==========================================
inputPanel.add.onClick = function(widget)
    local mainVal, optVal
    local t = {}
    local relation = inputPanel.useSecondCondition:getText()
    local profileName = namePanel.profileName:getText()
    if profileName:len() == 0 then
        return warn("Por favor, preencha o nome do perfil!")
    end

    for i, widget in ipairs(slotWidgets) do
        local checked = widget:isChecked()
        local id = widget:getItemId()

        if checked then
            table.insert(t, true)
        elseif id then
            table.insert(t, id)
        else
            table.insert(t, false)
        end
    end

    if conditionNumber == 1 then
        mainVal = nil
    elseif conditionNumber == 8 or conditionNumber == 9 then
        mainVal = inputPanel.condition.text:getText()
        if mainVal:len() == 0 then
            return warn("[vBot Equipper] Por favor, preencha o campo de alvo/hotkey corretamente.")
        end
    else
        mainVal = inputPanel.condition.spinbox:getValue()
    end

    if relation ~= "-" then
        if optionalConditionNumber == 1 then
            optVal = nil
        elseif optionalConditionNumber == 8 or optionalConditionNumber == 9 then
            optVal = inputPanel.optionalCondition.text:getText()
            if optVal:len() == 0 then
                return warn("[vBot Equipper] Por favor, preencha o campo opcional de alvo/hotkey corretamente.")
            end
        else
            optVal = inputPanel.optionalCondition.spinbox:getValue()
        end
    end

    local index
    for i, v in ipairs(config.rules) do
        if v.name == profileName then index = i end
    end

    local ruleData = {
        name = profileName, 
        data = t,
        enabled = true,
        visible = true,
        mainCondition = conditionNumber,
        optionalCondition = optionalConditionNumber,
        mainValue = mainVal,
        optValue = optVal,
        relation = relation,
    }

    if index then config.rules[index] = ruleData else table.insert(config.rules, ruleData) end

    for i, child in ipairs(listPanel.list:getChildren()) do child.display = false end
    resetFields()
    refreshRules()
end

mainWindow.bossList.onClick = function(widget)
    if bossPanel:isVisible() then
        bossPanel:hide()
        listPanel:show()
        widget:setText('Lista de Bosses')
    else
        bossPanel:show()
        listPanel:hide()
        widget:setText('Lista de Regras')
    end
end

for i, v in ipairs(config.bosses) do
    local widget = UI.createWidget("BossLabel", bossPanel.list)
    widget:setText(v)
    widget.remove.onClick = function()
        table.remove(config.bosses, table.find(config.bosses, v))
        widget:destroy()
    end
end

bossPanel.add.onClick = function()
    local name = bossPanel.name:getText()
    if name:len() == 0 then return warn("[Equipped] Por favor, digite o nome do Boss!")
    elseif table.find(config.bosses, name:lower(), true) then return warn("[Equipper] Boss ja adicionado!") end

    local widget = UI.createWidget("BossLabel", bossPanel.list)
    widget:setText(name)
    widget.remove.onClick = function()
        table.remove(config.bosses, table.find(config.bosses, name))
        widget:destroy()
    end    
    table.insert(config.bosses, name)
    bossPanel.name:setText('')
end

local function interpreteCondition(n, v)
    if n == 1 then return true
    elseif n == 2 then return getMonsters() > v
    elseif n == 3 then return getMonsters() < v
    elseif n == 4 then return hppercent() < v
    elseif n == 5 then return hppercent() > v
    elseif n == 6 then return manapercent() < v
    elseif n == 7 then return manapercent() > v
    elseif n == 8 then return target() and target():getName():lower() == v:lower() or false
    elseif n == 9 then return g_keyboard.isKeyPressed(v)
    elseif n == 10 then return isParalyzed()
    elseif n == 11 then return isInPz()
    elseif n == 12 then return getPlayers() > v
    elseif n == 13 then return getPlayers() < v
    elseif n == 14 then return TargetBot.Danger() > v and TargetBot.isOn()
    elseif n == 15 then return isBlackListedPlayerInRange(v)
    elseif n == 16 then return target() and table.find(config.bosses, target():getName():lower(), true) and true or false
    elseif n == 17 then return not isInPz()
    elseif n == 18 then return CaveBot.isOn() and TargetBot.isOff() end
end
-- ==========================================
-- SISTEMA PRINCIPAL DE TROCA E LOOP - PARTE 8
-- ==========================================
local function finalCheck(first, relation, second)
    if relation == "-" then return first
    elseif relation == "e" then return first and second
    elseif relation == "ou" then return first or second end
end

local function isEquipped(id)
    local t = {getNeck(), getHead(), getBody(), getRight(), getLeft(), getLeg(), getFeet(), getFinger(), getAmmo()}
    local ids = {id, getInactiveItemId(id), getActiveItemId(id)}
    for i, slot in pairs(t) do
        if slot and table.find(ids, slot:getId()) then return true end
    end
    return false
end

local function unequipItem(table)
    local slots = {getHead(), getBody(), getLeg(), getFeet(), getNeck(), getLeft(), getRight(), getFinger(), getAmmo()}
    if type(table) ~= "table" then return end
    for i, slot in ipairs(table) do
        local physicalSlot = slots[i]
        if slot == true and physicalSlot then
            local id = physicalSlot:getId()
            if g_game.getClientVersion() >= 910 then
                g_game.equipItemId(id)
            else
                local dest
                for _, container in ipairs(getContainers()) do
                    local cname = container:getName()
                    if not containerIsFull(container) then
                        if not cname:find("loot") and (cname:find("backpack") or cname:find("bag") or cname:find("chess")) then
                            dest = container
                        end
                        break
                    end
                end
                if not dest then return true end
                local pos = dest:getSlotPosition(dest:getItemsCount())
                g_game.move(physicalSlot, pos, physicalSlot:getCount())
            end
            return true
        end
    end
    return false
end

local function equipItem(id, slot)
    if slot == 2 then slot = 4
    elseif slot == 3 then slot = 7
    elseif slot == 8 then slot = 9
    elseif slot == 5 then slot = 2
    elseif slot == 4 then slot = 8
    elseif slot == 9 then slot = 10
    elseif slot == 7 then slot = 5 end

    if g_game.getClientVersion() >= 910 then
        return g_game.equipItemId(id)
    else
        local item = findItem(id)
        return moveToSlot(item, slot)
    end
end

local function markChild(child)
    if mainWindow:isVisible() then
        for i, childWidget in ipairs(listPanel.list:getChildren()) do
            if childWidget ~= child then childWidget:setColor('white') end
        end
        child:setColor('green')
    end
end

local missingItem = false
local lastRule = false
local correctEq = false

-- Loop constante que checa e gerencia os equipamentos cadastrados
EquipManager = macro(50, function()
    if not config.enabled then return end
    if #config.rules == 0 then return end

    for i, widget in ipairs(listPanel.list:getChildren()) do
        local rule = widget.ruleData
        if rule.enabled then
            local firstCondition = interpreteCondition(rule.mainCondition, rule.mainValue)
            local optionalCondition = nil
            if rule.relation ~= "-" then
                optionalCondition = interpreteCondition(rule.optionalCondition, rule.optValue)
            end

            if finalCheck(firstCondition, rule.relation, optionalCondition) then
                local resetLoop = not missingItem and correctEq and lastRule == rule
                if resetLoop then return end

                if unequipItem(rule.data) == true then
                    delay(200)
                    return
                end

                for slot, item in ipairs(rule.data) do
                    if type(item) == "number" and item > 100 then
                        if not isEquipped(item) then
                            if rule.visible then
                                if findItem(item) then
                                    missingItem = false
                                    delay(200)
                                    return equipItem(item, slot)
                                else
                                    missingItem = true
                                end
                            else
                                missingItem = false
                                delay(200)
                                return equipItem(item, slot)
                            end
                        end
                    end
                end

                correctEq = not missingItem
                return
            end
        end
    end
end)
