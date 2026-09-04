setDefaultTab("war")
UI.Separator()

-- 1. Cria a label nativa comum
local suporteLabel = UI.Label("CENTRAL DE SUPORTE")
suporteLabel:setColor("#ffffff") -- Sempre Branco na onda

-- Ativa a borda preta nativa do OTC
if suporteLabel.setOutline then
    suporteLabel:setOutline(true)
end

-- Títulos diferentes para cada fase
local textoOnda = "central de suporte"
local textoPisca = "BRINQUE SCRIPTS"
local tamanhoTexto = #textoOnda

-- Paleta com 7 cores para o Super Pisca do Brinque Scripts
local coresPisca = {"#00bfff", "#ffff00", "#ff0000", "#00ff00", "#ff00ff", "#ffffff", "#000000"} 
local indiceCor = 1

-- Controle de tempo, estágios e repetição das ondas
local tempoEstagio = os.clock()
local estagioAtual = 1 -- 1 = Ondinha Central de Suporte, 2 = Pisca Brinque Scripts
local ondasFeitas = 0  
local travaProximaOnda = false

-- 2. Macro mestre de animação (100ms)
macro(100, function()
    local currentTime = os.clock()
    
    if estagioAtual == 1 then
        -- [ESTÁGIO 1] A ONDA: Texto base sempre Branco
        suporteLabel:setColor("#ffffff") 
        
        local speed = 1200 
        local progresso = ((currentTime * 1000) % speed) / speed
        local posicaoOnda = math.floor(progresso * (tamanhoTexto + 2)) + 1
        
        local textoModificado = ""
        for i = 1, tamanhoTexto do
            local letra = textoOnda:sub(i, i)
            
            if i == posicaoOnda then
                -- A letra específica da onda vira o pulso (_)
                if letra == " " then
                    textoModificado = textoModificado .. " "
                else
                    textoModificado = textoModificado .. "_"
                end
            else
                -- O resto do texto continua maiúsculo e visível em Branco
                textoModificado = textoModificado .. letra:upper()
            end
        end
        suporteLabel:setText(textoModificado)
        
        -- Controlador de loops da onda
        if posicaoOnda > tamanhoTexto then
            if not travaProximaOnda then
                ondasFeitas = ondasFeitas + 1
                travaProximaOnda = true
            end
            
            -- [ALTERADO] Agora roda EXATAMENTE 4 VEZES antes de ir para o pisca
            if ondasFeitas >= 4 then
                estagioAtual = 2
                ondasFeitas = 0
                tempoEstagio = currentTime
                suporteLabel:setText(textoPisca) -- Altera o título para BRINQUE SCRIPTS
            end
        else
            travaProximaOnda = false
        end
        
    elseif estagioAtual == 2 then
        -- [ESTÁGIO 2] O SUPER PISCA: Brinque Scripts mudando de cor
        indiceCor = indiceCor + 1
        if indiceCor > #coresPisca then indiceCor = 1 end
        
        suporteLabel:setColor(coresPisca[indiceCor])
        suporteLabel:setText(textoPisca) -- Garante que o texto continue fixo no pisca
        
        -- Fica piscando por 2 segundos e depois volta para a Central de Suporte
        if currentTime - tempoEstagio > 2.0 then
            estagioAtual = 1
            indiceCor = 1
            ondasFeitas = 0
            travaProximaOnda = false
        end
    end
end)


-- Define a aba padrao onde o icone/botao da macro vai aparecer no vBot
setDefaultTab("war")

local panelName = "newHealer"

-- Guardando a primeira parte do visual SEM ACENTOS em formato de texto
local otuiText = [[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Friend Healer')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Configurar

CategoryCheckBox < CheckBox
  font: verdana-11px-rounded 
  margin-top: 3

  $checked:
    color: #98BF64

HealScroll < Panel

  ToolTipLabel
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: teste
    
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 100
    step: 1

HealItem < Panel

  BotItem
    id: item
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    size: 34 34

  ToolTipLabel
    id: text
    anchors.fill: parent
    anchors.left: prev.right
    margin-left: 8
    text-wrap: true
    text-align: left

ToolTipLabel < UIWidget
  font: verdana-11px-rounded
  color: #dfdfdf
  height: 14
  text-align: center 

HealerPlayerEntry < Label
  background-color: alpha
  text-offset: 5 1
  focusable: true
  height: 16
  font: verdana-11px-rounded
  text-align: left

  $focus:
    background-color: #00000055
  
  Button
    id: remove
    anchors.right: parent.right
    margin-right: 2
    anchors.verticalCenter: parent.verticalCenter
    size: 15 15
    margin-right: 15
    text: X
    tooltip: Remover jogador da lista
]]
-- ==========================================
-- SOMA DO TEXTO DA INTERFACE SEM ACENTOS - PARTE 2
-- ==========================================
otuiText = otuiText .. [[
PriorityEntry < ToolTipLabel
  background-color: alpha
  text-offset: 18 1
  focusable: true
  height: 16
  font: verdana-11px-rounded
  text-align: left

  $focus:
    background-color: #00000055

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    size: 15 15
    margin-top: 2
    margin-left: 3 
  
  Button
    id: increment
    anchors.right: parent.right
    margin-right: 2
    anchors.verticalCenter: parent.verticalCenter
    size: 14 14
    text: +
    tooltip: Aumentar Prioridade

  Button
    id: decrement
    anchors.right: prev.left
    margin-right: 2
    anchors.verticalCenter: parent.verticalCenter
    size: 14 14
    text: -
    tooltip: Diminuir Prioridade

TargetSettings < Panel
  size: 280 140
  padding: 3
  image-source: /images/ui/window
  image-border: 6

  Label
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    font: verdana-11px-rounded 
    text: Configuracoes de Alvos

  Groups
    id: groups
    anchors.top: prev.bottom
    margin-top: 8
    anchors.left: parent.left
    margin-left: 9

  Vocations
    id: vocations
    anchors.left: prev.right
    margin-left: 5
    anchors.verticalCenter: prev.verticalCenter

Groups < FlatPanel
  size: 150 105
  padding: 3
  padding-top: 5

  ToolTipLabel
    id: title
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    text: Grupos
    tooltip: Jogadores adicionados na lista customizada sempre serao curados

  HorizontalSeparator
    anchors.top: prev.bottom
    margin-top: 2
    anchors.left: parent.left
    anchors.right: parent.right

  Panel
    id: box
    anchors.top: prev.bottom
    margin-top: 2
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    padding: 2
    layout: 
      type: verticalBox

    CategoryCheckBox
      id: friends
      text: Amigos

    CategoryCheckBox
      id: party
      text: Party Members

    CategoryCheckBox
      id: guild
      text: Guild Members

    CategoryCheckBox
      id: alliedGuild
      text: Guilda Aliada
  
Vocations < FlatPanel
  size: 100 105
  padding: 3
  padding-top: 5

  ToolTipLabel
    id: title
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    font: verdana-11px-rounded 
    text: Vocacoes

  HorizontalSeparator
    anchors.top: prev.bottom
    margin-top: 2
    anchors.left: parent.left
    anchors.right: parent.right

  Panel
    id: box
    anchors.top: prev.bottom
    margin-top: 2
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    padding: 2

    layout: 
      type: verticalBox

    CategoryCheckBox
      id: knights
      text: Knights

    CategoryCheckBox
      id: paladins
      text: Paladins

    CategoryCheckBox
      id: druids
      text: Druids

    CategoryCheckBox
      id: sorcerers
      text: Sorcerers

Priority < Panel
  size: 190 123
  padding: 6
  padding-top: 3
  image-source: /images/ui/window
  image-border: 6

  ToolTipLabel
    id: title
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    font: verdana-11px-rounded 
    text: Prioridades

  TextList
    id: list
    anchors.top: prev.bottom
    margin-top: 3
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    fit-children: true
    padding-top: 1

AddPlayer < FlatPanel
  padding: 5

  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    font: verdana-11px-rounded 
    text: Add Player a Lista Customizada
    text-align: center
    text-wrap: true

  HorizontalSeparator
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2

  SpinBox
    id: health
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-top: 20
    width: 50
    minimum: 1
    maximum: 99
    step: 1
    focusable: true
    text-align: center

  Label
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 3
    font: verdana-11px-rounded 
    text: %HP - curar se abaixo

  TextEdit
    id: name
    anchors.top: health.bottom
    margin-top: 5
    anchors.left: health.left
    anchors.right: parent.right
    font: verdana-11px-rounded 
    text-align: center
    text: nome do amigo

  Button
    id: add
    anchors.left: health.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    font: verdana-11px-rounded 
    text: Adicionar Player

PlayerList < Panel

  TextList
    id: list
    anchors.fill: parent
    fit-children: true
    padding-top: 2
    vertical-scrollbar: listScrollBar

  VerticalScrollBar
    id: listScrollBar
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: list.right
    step: 14
    pixels-scroll: true

CustomList < Panel
  size: 190 172
  padding: 6
  padding-top: 3
  image-source: /images/ui/window
  image-border: 6

  ToolTipLabel
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    font: verdana-11px-rounded 
    text: Lista Customizada
    tooltip: Clique duplo na lista abaixo para adicionar novo jogador.

  AddPlayer
    id: addPanel
    anchors.top: prev.bottom
    margin-top: 3
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

  PlayerList
    id: playerList
    anchors.fill: prev

Conditions < Panel
  size: 280 170
  padding: 3
  image-source: /images/ui/window
  image-border: 6

  Label
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    font: verdana-11px-rounded 
    text: Condicoes de Cura

  Panel
    id: box
    anchors.fill: parent
    margin-top: 16
    padding: 5
    padding-top: 3
    layout: 
      type: grid
      cell-size: 128 31
      cell-spacing: 5
      num-columns: 2

FriendHealer < MainWindow
  !text: tr('Friend Healer')
  size: 512 405
  padding-top: 30
  @onEscape: self:hide()

  Conditions
    id: conditions
    anchors.top: parent.top
    anchors.right: parent.right

  TargetSettings
    id: targetSettings
    anchors.top: prev.bottom
    margin-top: 10
    anchors.left: prev.left

  Priority
    id: priority
    anchors.top: parent.top
    anchors.left: parent.left

  CustomList
    id: customList
    anchors.top: priority.bottom
    margin-top: 10
    anchors.left: priority.left

  HorizontalSeparator
    id: separator
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
    @onClick: self:getParent():hide()
]]

local ui = setupUI(otuiText)
ui:setId(panelName)
-- ==========================================
-- LOGICA DO MOTOR, LISTA CUSTOMIZADA E VALIDACOES - PARTE 3
-- ==========================================
if not storage[panelName] or not storage[panelName].priorities then
    storage[panelName] = nil
end

if not storage[panelName] then
    storage[panelName] = {
        enabled = false,
        customPlayers = {},
        vocations = {},
        groups = {},
        priorities = {
            {name="Custom Spell",           enabled=false,  custom=true},
            {name="Exura Gran Sio",         enabled=true,   strong = true},
            {name="Exura Sio",              enabled=true,   normal = true},
            {name="Exura Gran Mas Res",     enabled=true,   area = true},
            {name="Health Item",            enabled=true,   health=true},
            {name="Mana Item",              enabled=true,   mana=true}
        },
        settings = {
            {type="HealItem",       text="Mana Item ",                   value=268},
            {type="HealScroll",     text="Item Range: ",                 value=6},
            {type="HealItem",       text="Health Item ",                 value=3160},
            {type="HealScroll",     text="Mas Res Players: ",            value=2},
            {type="HealScroll",     text="Heal Friend at: ",             value=80},
            {type="HealScroll",     text="Use Gran Sio at: ",            value=30},
            {type="HealScroll",     text="Min Player HP%: ",             value=90},
            {type="HealScroll",     text="Min Player MP%: ",             value=30},
        },
        conditions = {
            knights = true,
            paladins = true,
            druids = false,
            sorcerers = false,
            party = true,
            guild = false,
            friends = false,
            alliedGuild = false
        }
    }
end

local config = storage[panelName]
local healerWindow = UI.createWindow('FriendHealer')
healerWindow:hide()
healerWindow:setId(panelName)

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
end

ui.edit.onClick = function()
    healerWindow:show()
    healerWindow:raise()
    healerWindow:focus()
end

local conditionsPanel = healerWindow.conditions
local targetSettings = healerWindow.targetSettings
local customList = healerWindow.customList
local priority = healerWindow.priority

-- Preenche a lista customizada ao iniciar
for name, health in pairs(config.customPlayers) do
    local widget = UI.createWidget("HealerPlayerEntry", customList.playerList.list)
    widget.remove.onClick = function()
        config.customPlayers[name] = nil
        widget:destroy()
    end
    widget:setText("["..health.."%]  "..name)
end

customList.playerList.onDoubleClick = function()
    customList.playerList:hide()
end

local function clearFields()
    customList.addPanel.name:setText("nome do amigo")
    customList.addPanel.health:setText("1")
    customList.playerList:show()
end

local function capitalFistLetter(str)
    return (string.gsub(str, "^%l", string.upper))
end

customList.addPanel.add.onClick = function()
    local name = ""
    local words = string.split(customList.addPanel.name:getText(), " ")
    local health = tonumber(customList.addPanel.health:getText())
    for i, word in ipairs(words) do
        name = name .. " " .. capitalFistLetter(word)
    end
    name = name:trim()

    if not health then    
        clearFields()
        return warn("[Friend Healer] Por favor, insira o valor em porcentagem de vida!")
    end

    if name:len() == 0 or name:lower() == "nome do amigo" then   
        clearFields()
        return warn("[Friend Healer] Por favor, insira o nome do amigo para adicionar!")
    end

    if config.customPlayers[name] or config.customPlayers[name:lower()] then 
        clearFields()
        return warn("[Friend Healer] Este jogador ja foi adicionado a lista customizada.")
    else
        config.customPlayers[name] = health
        local widget = UI.createWidget("HealerPlayerEntry", customList.playerList.list)
        widget.remove.onClick = function()
            config.customPlayers[name] = nil
            widget:destroy()
        end
        widget:setText("["..health.."%]  "..name)
    end

    clearFields()
end

local function validate(widget, category)
    local list = widget:getParent()
    local label = list:getParent().title
    category = category or 0

    if category == 2 and not (storage.extras and storage.extras.checkPlayer) then
        label:setColor("#d9321f")
        label:setTooltip("! AVISO ! \nAtive a opcao de checar jogadores (check players) em extras para usar este recurso!")
        return
    else
        label:setColor("#dfdfdf")
        label:setTooltip("")
    end

    local checked = false
    for i, child in ipairs(list:getChildren()) do
        if (category == 1 and child.enabled:isChecked()) or (category ~= 1 and child:isChecked()) then
            checked = true
        end
    end

    if not checked then
        label:setColor("#d9321f")
        label:setTooltip("! AVISO ! \nNenhuma categoria selecionada!")
    else
        label:setColor("#dfdfdf")
        label:setTooltip("")
    end
end

-- Vincula os seletores visuais da interface
targetSettings.vocations.box.knights:setChecked(config.conditions.knights)
targetSettings.vocations.box.knights.onClick = function(widget)
    config.conditions.knights = not config.conditions.knights
    widget:setChecked(config.conditions.knights)
    validate(widget, 2)
end

targetSettings.vocations.box.paladins:setChecked(config.conditions.paladins)
targetSettings.vocations.box.paladins.onClick = function(widget)
    config.conditions.paladins = not config.conditions.paladins
    widget:setChecked(config.conditions.paladins)
    validate(widget, 2)
end

targetSettings.vocations.box.druids:setChecked(config.conditions.druids)
targetSettings.vocations.box.druids.onClick = function(widget)
    config.conditions.druids = not config.conditions.druids
    widget:setChecked(config.conditions.druids)
    validate(widget, 2)
end

targetSettings.vocations.box.sorcerers:setChecked(config.conditions.sorcerers)
targetSettings.vocations.box.sorcerers.onClick = function(widget)
    config.conditions.sorcerers = not config.conditions.sorcerers
    widget:setChecked(config.conditions.sorcerers)
    validate(widget, 2)
end

targetSettings.groups.box.friends:setChecked(config.conditions.friends)
targetSettings.groups.box.friends.onClick = function(widget)
    config.conditions.friends = not config.conditions.friends
    widget:setChecked(config.conditions.friends)
    validate(widget)
end

targetSettings.groups.box.party:setChecked(config.conditions.party)
targetSettings.groups.box.party.onClick = function(widget)
    config.conditions.party = not config.conditions.party
    widget:setChecked(config.conditions.party)
    validate(widget)
end

targetSettings.groups.box.guild:setChecked(config.conditions.guild)
targetSettings.groups.box.guild.onClick = function(widget)
    config.conditions.guild = not config.conditions.guild
    widget:setChecked(config.conditions.guild)
    validate(widget)
end

-- Vincula a nova caixinha de Guilda Aliada
targetSettings.groups.box.alliedGuild:setChecked(config.conditions.alliedGuild)
targetSettings.groups.box.alliedGuild.onClick = function(widget)
    config.conditions.alliedGuild = not config.conditions.alliedGuild
    widget:setChecked(config.conditions.alliedGuild)
    validate(widget)
end

validate(targetSettings.vocations.box.knights)
validate(targetSettings.groups.box.friends)
validate(targetSettings.vocations.box.sorcerers, 2)

for i, setting in ipairs(config.settings) do
    local widget = UI.createWidget(setting.type, conditionsPanel.box)
    local text = setting.text
    local val = setting.value
    widget.text:setText(text)
-- ==========================================
-- PRIORIDADES, EXECUCAO DE CURA E LOOP FINAL - PARTE 4 (CORRIGIDA)
-- ==========================================
    if setting.type == "HealScroll" then
        widget.text:setText(widget.text:getText()..val)
        if not (text:find("Range") or text:find("Mas Res")) then
            widget.text:setText(widget.text:getText().."%")
        end
        widget.scroll:setValue(val)
        widget.scroll.onValueChange = function(scroll, value)
            setting.value = value
            widget.text:setText(text..value)
            if not (text:find("Range") or text:find("Mas Res")) then
                widget.text:setText(widget.text:getText().."%")
            end
        end
        if text:find("Range") or text:find("Mas Res") then
            widget.scroll:setMaximum(10)
        end
    else
        widget.item:setItemId(val)
        widget.item:setShowCount(false)
        widget.item.onItemChange = function(widget)
            setting.value = widget:getItemId()
        end
    end
end

-- Gerenciamento de ordem e prioridades na interface
local function setCrementalButtons()
    for i, child in ipairs(priority.list:getChildren()) do
        if i == 1 then
            child.increment:disable()
        elseif i == 6 then
            child.decrement:disable()
        else
            child.increment:enable()
            child.decrement:enable()
        end
    end
end

for i, action in ipairs(config.priorities) do
    local widget = UI.createWidget("PriorityEntry", priority.list)

    widget:setText(action.name)
    widget.increment.onClick = function()
        local index = priority.list:getChildIndex(widget)
        local table = config.priorities

        priority.list:moveChildToIndex(widget, index-1)
        table[index], table[index-1] = table[index-1], table[index]
        setCrementalButtons()
    end
    widget.decrement.onClick = function()
        local index = priority.list:getChildIndex(widget)
        local table = config.priorities

        priority.list:moveChildToIndex(widget, index+1)
        table[index], table[index+1] = table[index+1], table[index]
        setCrementalButtons()
    end
    widget.enabled:setChecked(action.enabled)
    widget:setColor(action.enabled and "#98BF64" or "#dfdfdf")
    widget.enabled.onClick = function()
        action.enabled = not action.enabled
        widget:setColor(action.enabled and "#98BF64" or "#dfdfdf")
        widget.enabled:setChecked(action.enabled)
        validate(widget, 1)  
    end
    if action.custom then
        widget.onDoubleClick = function()
            local window = modules.client_textedit.show(widget, {title = "Custom Spell", description = "Insira a formula para a magia customizada de cura"})
            schedule(50, function() 
                window:raise()
                window:focus() 
            end)
        end
        widget.onTextChange = function(widget,text)
            action.name = text
        end
        widget:setTooltip("Clique duplo para definir a formula da magia.")
    end

    if i == #config.priorities then
        validate(widget, 1)
        setCrementalButtons()
    end
end

local lastItemUse = now
local lastStrongHeal = 0
local lastMasRes = 0
local lastSio = 0

-- Executa a cura (magia ou item) baseada na prioridade definida
local function friendHealerAction(spec, targetsInRange)
    local name = spec:getName()
    local health = spec:getHealthPercent()
    local mana = spec:getManaPercent()
    local dist = distanceFromPlayer(spec:getPosition())
    targetsInRange = targetsInRange or 0

    local masResAmount = config.settings[4].value
    local itemRange = config.settings[2].value
    local healItem = config.settings[3].value
    local manaItem = config.settings[1].value
    local normalHeal = config.customPlayers[name] or config.settings[5].value
    local strongHeal = config.customPlayers[name] and normalHeal/2 or config.settings[6].value

    for i, action in ipairs(config.priorities) do
        if action.enabled then
            -- Cura em Area (Mas Res) se houver aliados suficientes perto
            if action.area and targetsInRange >= masResAmount and now > lastMasRes then
                lastMasRes = now + 2000
                return say("exura gran mas res")
            end
            
            -- Uso de item de mana no aliado
            if action.mana and findItem(manaItem) and mana <= normalHeal and dist <= itemRange and now - lastItemUse > 1000 then
                lastItemUse = now
                return useWith(manaItem, spec)
            end
            
            -- Uso de item de vida no aliado
            if action.health and findItem(healItem) and health <= normalHeal and dist <= itemRange and now - lastItemUse > 1000 then
                lastItemUse = now
                return useWith(healItem, spec)
            end
            
            -- Cura forte (Gran Sio)
            if action.strong and health <= strongHeal and now > lastStrongHeal and dist <= 7 then
                lastStrongHeal = now + 1000
                return say('exura gran sio "'..name)
            end
            
            -- Cura normal (Sio ou magia customizada)
            if (action.normal or action.custom) and health <= normalHeal and now > lastSio and dist <= 7 then
                lastSio = now + 1000
                return say('exura sio "'..name)
            end
        end
    end
end

-- Valida se o jogador na tela e um candidato a receber cura
local function isCandidate(spec)
    if spec:isLocalPlayer() or not spec:isPlayer() then 
        return nil 
    end
    if not spec:canShoot() then
        return false
    end
    
    local curHp = spec:getHealthPercent()
    local name = spec:getName()
    
    if (curHp == 100 and spec:getManaPercent() == 100) or (config.customPlayers[name] and curHp > config.customPlayers[name]) then
        return false
    end

    local specText = spec:getText()
    
    -- Filtros de Vocacao (Requer a checagem ativa em extras)
    if storage.extras and storage.extras.checkPlayer and specText:len() > 0 then
        local isValidClass = true
        if specText:find("EK") and not config.conditions.knights then
            isValidClass = false
        elseif specText:find("RP") and not config.conditions.paladins then
            isValidClass = false
        elseif specText:find("ED") and not config.conditions.druids then
            isValidClass = false
        elseif specText:find("MS") and not config.conditions.sorcerers then
            isValidClass = false
        end
        
        if not isValidClass and not config.customPlayers[name] then
            return nil
        end
    end

    local okParty = config.conditions.party and spec:isPartyMember()
    local okFriend = config.conditions.friends and isFriend(spec)
    local okGuild = config.conditions.guild and spec:getEmblem() == 1
    
    -- Logica inteligente para Guilda Aliada / Escudo Vermelho (Modo War)
    local okAlliedGuild = false
    if config.conditions.alliedGuild then
        local shield = spec:getShield()
        local emblem = spec:getEmblem()
        if (shield and shield >= 2) or (emblem and emblem >= 2) then
            okAlliedGuild = true
        end
    end

    if not (okParty or okFriend or okGuild or okAlliedGuild or config.customPlayers[name]) then
        return nil
    end

    local health = curHp
    local dist = distanceFromPlayer(spec:getPosition())

    return health, dist
end

-- Loop continuo que busca quem precisa mais de cura na tela
macro(100, function()
    if not config.enabled then return end

    local minHp = config.settings[7].value
    local minMp = config.settings[8].value

    local healTarget = {creature=nil, hp=100}
    local inMasResRange = 0
    
    -- Trava de seguranca: nao cura os outros se a sua propria vida ou mana estiverem muito baixas
    if hppercent() <= minHp or manapercent() <= minMp then return end
    
    local spectators = getSpectators(posz())

    for i, spec in ipairs(spectators) do
        local health, dist = isCandidate(spec)
        if health and dist then
            inMasResRange = (dist <= 3) and (inMasResRange + 1) or inMasResRange
            -- Seleciona o aliado com a MENOR vida da tela
            if health <= healTarget.hp then
                healTarget = {creature = spec, hp = health}
            end
        end
    end    
    
    if healTarget.creature then
        return friendHealerAction(healTarget.creature, inMasResRange)
    end
end)


setDefaultTab("war") -- Garante que os créditos apareçam na aba HP do Healer

-- =============================================================================
-- [PAINEL DE CRÉDITOS E SUPORTE - BRINQUE SCRIPT NATIVO ANIMADO]
-- =============================================================================
local version = "1.0"
local currentVersion
local available = false

storage.checkVersion = storage.checkVersion or 0

-- 1. Rótulo Principal: Nome da Marca Destacado em Amarelo Ouro Original
local labelBrinqueMarca = UI.Label("POT GUILD v" .. version)
if labelBrinqueMarca then
    labelBrinqueMarca:setColor("#ffcc00") -- Cor Ouro de Elite
    labelBrinqueMarca:setFont("verdana-11px-rounded") -- Fonte com contorno limpo
end



-- =============================================================================
-- [MOTOR DE PISCAR SIMPLES] DEGRADE CONTÍNUO EM LOOP DE BACKGROUND (SEM CRASH)
-- =============================================================================
macro(150, function()
    if not labelBrinqueMarca then return end

    -- Coleta o tempo atual em ondas matemáticas (Seno de frequência rápida)
    local tempoOnda = os.clock() * 5
    local pulsoIntensidade = math.abs(math.sin(tempoOnda))

    -- 1. FAZ A LOGO "HEALING BRINQUE" PISCAR EM DEGRADÊ (AMARELO OURO <-> LARANJA WAR)
    local gLogo = math.floor(100 + (105 * pulsoIntensidade)) -- Oscila o tom de Verde do RGB
    local corLogoHex = string.format("#FF%02X00", gLogo)
    labelBrinqueMarca:setColor(corLogoHex)
end)


--[[
===================================================
PartyPot - Party Manager + Auto Potion Allies   
===================================================
]]--

-------------------------------------------------
-- 0. SEGURANÇA DO ATUALIZADOR (AUTO-OVERWRITE)
-------------------------------------------------
if meuMacroPotGuild then meuMacroPotGuild:setOff() end
if meuMacroMpRequest then meuMacroMpRequest:setOff() end

-------------------------------------------------
-- 1. STORAGE — defaults & migration
-------------------------------------------------
local panelName = "PartyPot"

if not storage[panelName] then
    storage[panelName] = {
        enabled       = false,
        leaderName    = "Leader",
        autoPartyList = {},
        onMove        = false,
        potParty  = true,
        potGuild  = false,
        potFriend = false,
        potCustom = false,
        customPotList = {},
        hpEK = 80, hpED = 80, hpMS = 80, hpRP = 80,
        hpEnabledEK = true, hpEnabledED = true, hpEnabledMS = true, hpEnabledRP = true,
        mpEK = true, mpED = true, mpMS = true, mpRP = true,
        hpItemEK = 0, hpItemED = 0, hpItemMS = 0, hpItemRP = 0,
        mpItemEK = 0, mpItemED = 0, mpItemMS = 0, mpItemRP = 0,
        mpRequestEnabled = false,
        mpRequestPercent = 50,
        mpRequestChannel = "Party",
        mpRequestKeyword = "p",
    }
end

local function ensureField(key, default)
    if storage[panelName][key] == nil then
        storage[panelName][key] = default
    end
end
ensureField("potParty",  true) ensureField("potGuild",  false) ensureField("potFriend", false)
ensureField("potCustom", false) ensureField("customPotList", {}) ensureField("onMove", false)
ensureField("hpEK", 80)  ensureField("hpED", 80) ensureField("hpMS", 80)  ensureField("hpRP", 80)
ensureField("hpEnabledEK", true) ensureField("hpEnabledED", true) ensureField("hpEnabledMS", true) ensureField("hpEnabledRP", true)
ensureField("mpEK", true) ensureField("mpED", true) ensureField("mpMS", true) ensureField("mpRP", true)
ensureField("hpItemEK", 0) ensureField("hpItemED", 0) ensureField("hpItemMS", 0) ensureField("hpItemRP", 0)
ensureField("mpItemEK", 0) ensureField("mpItemED", 0) ensureField("mpItemMS", 0) ensureField("mpItemRP", 0)
ensureField("mpRequestEnabled", false) ensureField("mpRequestPercent", 50) ensureField("mpRequestChannel", "Party") ensureField("mpRequestKeyword", "p")

local settings = storage[panelName]

-------------------------------------------------
-- 2. WIDGET DEFINITIONS (loaded once via g_ui)
-------------------------------------------------
g_ui.loadUIFromString([[
PartyPotName < Label
  background-color: alpha
  text-offset: 2 0
  focusable: true
  height: 16
  $focus:
    background-color: #00000055
  Button
    id: remove
    text: x
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15

PartyPotScrollBar < Panel
  height: 28
  margin-top: 3
  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 10
    step: 1

PartyPotItem < Panel
  height: 34
  margin-top: 7
  margin-left: 25
  margin-right: 25
  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter
  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

PartyPotCheckBox < BotSwitch
  height: 20
  margin-top: 5

PartyPotBox < Panel
  padding: 8
  padding-top: 22
  margin-top: 8
  margin-bottom: 8  
  image-border: 1
  layout:
    type: verticalBox
    fit-children: true

PartyPotListBlock < Panel
  height: 110
  margin-top: 3
  TextList
    id: list
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 83
    padding: 1
    vertical-scrollbar: listScrollBar
  VerticalScrollBar
    id: listScrollBar
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: list.right
    step: 14
    pixels-scroll: true
  TextEdit
    id: nameEdit
    anchors.left: parent.left
    anchors.top: list.bottom
    margin-top: 5
    width: 120
  Button
    id: addBtn
    text: +
    anchors.right: parent.right
    anchors.left: nameEdit.right
    anchors.top: nameEdit.top
    margin-left: 3

PartyPotWindow < MainWindow
  text: Configuracao do PartyPot
  size: 520 480
  @onEscape: self:hide()
  Label
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: parent.top
    text-align: center
    text: Config da Party
  Label
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: Pocoes por Vocacao
  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 3
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
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true
    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true
    VerticalSeparator
      anchors.top: left.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter
      margin-top: 5
      margin-bottom: 5
  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8
  ResizeBorder
    id: bottomResizeBorder
    anchors.fill: separator
    height: 3
    minimum: 380
    maximum: 700
    margin-left: 3
    margin-right: 3
    background: #ffffff88
  Button
    id: closeButton
    text: Fechar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5
]])
-------------------------------------------------
-- 3. INLINE PANEL (bot tab)
-------------------------------------------------
local partyPotUI = setupUI([[
Panel
  height: 38
  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    height: 18
    text: PartyPot
  Button
    id: btnSetup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
  Button
    id: ptLeave
    text: Sair da Party
    anchors.left: parent.left
    anchors.top: prev.bottom
    width: 86
    height: 17
    margin-top: 3
    color: #ee0000
  Button
    id: ptShare
    text: Share EXP
    anchors.left: prev.right
    anchors.top: prev.top
    margin-left: 5
    height: 17
    width: 86
]], parent)

rootWidget = g_ui.getRootWidget()
local tcSwitch = partyPotUI.status
local ppWindow = UI.createWindow('PartyPotWindow', rootWidget)
ppWindow:hide()

ppWindow.closeButton.onClick = function() ppWindow:hide() end

partyPotUI.btnSetup.onClick = function()
    ppWindow:show() ppWindow:raise() ppWindow:focus()
end

partyPotUI.ptShare.onClick = function()
    g_game.partyShareExperience(not player:isPartySharedExperienceActive())
end

partyPotUI.ptLeave.onClick = function() g_game.partyLeave() end

tcSwitch:setOn(settings.enabled)
tcSwitch.onClick = function(widget)
    settings.enabled = not settings.enabled
    widget:setOn(settings.enabled)
end

local leftPanel  = ppWindow.content.left
local rightPanel = ppWindow.content.right

local addCheckBox = function(id, title, defaultValue, dest, tooltip)
    local widget = UI.createWidget('PartyPotCheckBox', dest)
    widget.onClick = function() widget:setOn(not widget:isOn()) settings[id] = widget:isOn() end
    widget:setText(title)
    if tooltip then widget:setTooltip(tooltip) end
    if settings[id] == nil then widget:setOn(defaultValue) else widget:setOn(settings[id]) end
    settings[id] = widget:isOn()
    return widget
end

local addItem = function(id, title, defaultItem, dest, tooltip)
    local widget = UI.createWidget('PartyPotItem', dest)
    widget.text:setText(title)
    if tooltip then widget.text:setTooltip(tooltip) widget.item:setTooltip(tooltip) end
    widget.item:setItemId(settings[id] or defaultItem)
    widget.item.onItemChange = function(w) settings[id] = w:getItemId() end
    settings[id] = settings[id] or defaultItem
    return widget
end

local addScrollBar = function(id, title, min, max, defaultValue, dest, tooltip)
    local widget = UI.createWidget('PartyPotScrollBar', dest)
    if tooltip then widget.text:setTooltip(tooltip) end
    widget.scroll.onValueChange = function(scroll, value)
        widget.text:setText(title .. ": " .. value .. "%")
        settings[id] = value
    end
    widget.scroll:setRange(min, max)
    if tooltip then widget.scroll:setTooltip(tooltip) end
    widget.scroll:setValue(settings[id] or defaultValue)
    widget.scroll.onValueChange(widget.scroll, widget.scroll:getValue())
    return widget
end

local addLabel = function(text, dest)
    local lbl = g_ui.createWidget('Label', dest)
    lbl:setText(text) lbl:setTextAlign(AlignCenter) lbl:setMarginTop(6)
    return lbl
end

local addSeparator = function(dest)
    local sep = g_ui.createWidget('HorizontalSeparator', dest)
    sep:setMarginTop(6) sep:setMarginBottom(6)
    return sep
end

local function createBox(title, dest)
    local box = UI.createWidget('PartyPotBox', dest)
    box:setImageSourceBase64("iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAYAAADimHc4AAADlUlEQVR42u2dzW7bOhCFzwxJWw7crd+v9xES5L2zSGDLIme6UKW6y9sCPl2cDzCcADQtDj08M/yR7HK5pLsjM/dXKQWJhMFQimOMQETA3bGRmTCz/e/t/4hAKQUAEBF7GTND7x1mhtYalt6Bh+/byjzWlZn79211bWWXZdmvx9338ma2X/uGmQEG9D7g2zUDyJ9t2to2xtjry8zf6t3K9d4BA2qpv7Vv+1wpZS3z0y7b+3atj+3KTFQzw/v7+69axP/i9fX1jz/79vaWNTP/qhLx53gpcJmBhwHwx3FWPJfMhG+iJp5PKQUeEbIEid47/DGMEk/WADT1AL0DZAayBsgMZA/Y0m9BEOHRFYYyqaVqCGISEcoDmNzvd3kAG3kAUwNqVSLGRJNx9DB0aAhicpom+OM6r3gu8zzDTR1Aw8zgVRpA4+XlBb4siyxB4uPjQ4kYPQ9QFMRjmiZ1AJNlWeDH41GWIFFKgW/7GMXzuS8LvNYqS5BotcoDmGguiEyMoTyAiZnBW2uyBLMDFmkADXeHF82GEvOAqvMB1DzgPisKog9BWpAhi7B2RZC9IDUEMV1Ai/JMho4ocdGKGJnWmvIAJhGhyTi6BsgDiB0gD+AyTZM6gMk8z8oDqFmwu46pcqOg1K4Iah5waNIAJgYd0qNyv9/hRUMQLw8YAw4lYjROp5NmQ5ksyyIN4KqwbtjETcTMNBnHdQAtypMz4ZAHUD3ApQFkDXDdrIOuAQpDeczzrCGISWZKhKka4K71AGoYmgpDqdSinXH8IUiL8jyu16s8gMk0nbQrghuGBjwkwlwd0DFVYhiva2VD6r19REFUDQrcuJqPZUH4ipiVJ6iAEj5QH8PKAhD8++Fg8l1r1EB8qt9tNeQBdhBUFEYNQbU38BzxAZuAREcoDmIwx1AF0DVAMRE7EdESJx/l8lgjTIyElYjyuN+2K4IahI7Q1kRoFucEul0t+/+87DEDvY1fnWitgay/13tf7m607udB7R2Til4AbgERmorWGMQYyE2aGiITZmvX1MTAdj/j8/EQpBefzGbfbbS8PAO1wQO8dyETvfX3OivsaM3tBaxXbVppaK1pruF6vaK1hexiFmcHcEWOg1IJWG+73+3oy3R1mhtYamalWVBaw3zPCMiEBHITUxOt7UthwMyAvN8Q61ru+Z5xvnbN7Racb3ekBkwcxyPB2Tm/vr6+oK743A47G1b2+AwW01XiuMHkcbm3r3D8UIAAAAASUVORK5CYII=")
    local titleLabel = g_ui.createWidget('Label', box)
    titleLabel:setText(title) titleLabel:setTextAlign(AlignCenter) titleLabel:setMarginTop(-20) titleLabel:setMarginBottom(8)
    return box
end
local playerBox = createBox("Config do Player", leftPanel)
addScrollBar("mpRequestPercent", "Mana", 0, 100, 50, playerBox, "Threshold de mana para pedir")
addCheckBox("mpRequestEnabled", "Pedir Mana", false, playerBox, "Pede mana automaticamente")

addLabel("Canal", playerBox)
local txtMpChannel = g_ui.createWidget('TextEdit', playerBox)
txtMpChannel:setText(settings.mpRequestChannel or "Party")
txtMpChannel.onTextChange = function(widget, text) settings.mpRequestChannel = text end

addLabel("Mensagem", playerBox)
local txtMpKeyword = g_ui.createWidget('TextEdit', playerBox)
txtMpKeyword:setText(settings.mpRequestKeyword or "p")
txtMpKeyword.onTextChange = function(widget, text) settings.mpRequestKeyword = text end

local partyBox = createBox("Config da Party", leftPanel)
addLabel("Nome do Lider", partyBox)
local txtLeader = g_ui.createWidget('TextEdit', partyBox)
txtLeader:setText(settings.leaderName or "Leader")
txtLeader.onTextChange = function(widget, text) settings.leaderName = text end

addLabel("Membros da Party", partyBox)
local partyListBlock = UI.createWidget('PartyPotListBlock', partyBox)
local lstParty       = partyListBlock.list
local playerNameEdit = partyListBlock.nameEdit
local addPlayerBtn   = partyListBlock.addBtn

local function addPartyLabel(pName)
    local label = g_ui.createWidget("PartyPotName", lstParty)
    label:setText(pName)
    label.remove.onClick = function() table.removevalue(settings.autoPartyList, label:getText()) label:destroy() end
end

if settings.autoPartyList and #settings.autoPartyList > 0 then
    for _, pName in ipairs(settings.autoPartyList) do addPartyLabel(pName) end
end

addPlayerBtn.onClick = function()
    local pn = playerNameEdit:getText()
    if pn:len() > 0 and not table.contains(settings.autoPartyList, pn, true) then
        table.insert(settings.autoPartyList, pn) addPartyLabel(pn) playerNameEdit:setText('')
    end
end
playerNameEdit.onKeyPress = function(self, keyCode) if keyCode ~= 5 then return false end addPlayerBtn.onClick() return true end

local potBox = createBox("Quem Potar", leftPanel)
addCheckBox("potParty",  "Membros da Party", true, potBox)
addCheckBox("potGuild",  "Membros da Guild", false, potBox)
addCheckBox("potFriend", "Amigos (FriendList)", false, potBox)

local vocations = {"EK", "ED", "MS", "RP"}
for i, voc in ipairs(vocations) do
    local vocBox = createBox(voc, rightPanel)
    addItem("hpItem" .. voc, "Pocao de HP", 0, vocBox)
    addItem("mpItem" .. voc, "Pocao de MP", 0, vocBox)
    addScrollBar("hp" .. voc, "HP " .. voc, 0, 100, 80, vocBox)
    addCheckBox("hpEnabled" .. voc, "Ativar HP", true, vocBox)
    addCheckBox("mp" .. voc, "Ativar MP", true, vocBox)
end

local function getVoc(creature)
    if not creature then return nil end
    local txt = creature:getText()
    if not txt or txt == "" then return nil end
    if txt:find("EK") then return "EK" elseif txt:find("ED") then return "ED" elseif txt:find("MS") then return "MS" elseif txt:find("RP") then return "RP" end
    return nil
end

function isFriend2(c)
    if not storage.playerList then return false end
    local name = type(c) ~= "string" and c:getName() or c
    return table.find(storage.playerList.friendList, name) and true or false
end

local function shouldPotCreature(spec)
    if not spec or not spec:isPlayer() or spec == player then return false end
    local name = spec:getName()
    if settings.potParty and spec:isPartyMember() then return true end
    if settings.potGuild and spec:getEmblem() == 1 then return true end
    if settings.potFriend and isFriend2(name) then return true end
    if settings.potParty and table.contains(settings.autoPartyList, name, true) then return true end
    return false
end

meuMacroPotGuild = macro(300, function()
    if not settings.enabled then return end
    for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec ~= player and shouldPotCreature(spec) then
            local voc = getVoc(spec)
            if voc then
                local hpEnabled = settings["hpEnabled" .. voc]
                local hpThreshold = settings["hp" .. voc]
                local hpItemId = settings["hpItem" .. voc]
                local hp = spec:getHealthPercent()
                if hpEnabled and hp and hpThreshold and hp <= hpThreshold and hpItemId > 0 then
                    usewith(hpItemId, spec) return                
                end
            end
        end
    end
end)

onTalk(function(senderName, level, mode, text)
    if not settings.enabled or text:lower() ~= "p" or senderName == player:getName() then return end
    local spec = getCreatureByName(senderName, true)
    if spec and shouldPotCreature(spec) then
        local voc = getVoc(spec)
        if voc and settings["mp" .. voc] and settings["mpItem" .. voc] > 0 then      
            usewith(settings["mpItem" .. voc], spec)
        end
    end
end)

onTextMessage(function(mode, text)
    if not tcSwitch:isOn() then return end
    if mode == 20 then
        if text:find("has joined the party") then
            local data = regexMatch(text, "([a-z A-Z-]*) has joined the party")
            if data and data and data then
                if table.contains(settings.autoPartyList, data, true) then
                    if not player:isPartySharedExperienceActive() then g_game.partyShareExperience(true) end
                end
            end
        elseif text:find("has invited you") and player:getName():lower() ~= settings.leaderName:lower() then
            local data = regexMatch(text, "([a-z A-Z-]*) has invited you")
            if data and data and data then
                if settings.leaderName:lower() == data:lower() then
                    local leader = getCreatureByName(data, true)
                    if leader then g_game.partyJoin(leader:getId()) end
                end
            end
        end
    end
end)

function ppCreatureInvites(creature)
    if not creature:isPlayer() or creature == player then return end
    if creature:getName():lower() == settings.leaderName:lower() and creature:getShield() == 1 then
        g_game.partyJoin(creature:getId()) return
    end
    if player:getName():lower() ~= settings.leaderName:lower() or not table.contains(settings.autoPartyList, creature:getName(), true) then return end
    if creature:isPartyMember() or creature:getShield() == 2 then return end
    g_game.partyInvite(creature:getId())
end

onCreatureAppear(function(creature) if tcSwitch:isOn() then ppCreatureInvites(creature) end end)

meuMacroMpRequest = macro(1500, function()
    if not settings.enabled or not settings.mpRequestEnabled then return end
    if manapercent() <= settings.mpRequestPercent then
        local partyChannel = getChannelId(settings.mpRequestChannel or "Party")
        if partyChannel then sayChannel(partyChannel, settings.mpRequestKeyword or "p") end
    end
end)
