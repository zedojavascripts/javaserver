-- Define a aba padrao onde o icone/botao da macro vai aparecer no vBot
setDefaultTab("cave")

local panelName = "alarms"

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
    !text: tr('Alarmes')

  Button
    id: alerts
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Editar

AlarmCheckBox < Panel
  height: 20
  margin-top: 2

  CheckBox
    id: tick
    anchors.fill: parent
    margin-top: 4
    font: verdana-11px-rounded
    text: Ataque de Player
    text-offset: 17 -3

AlarmCheckBoxAndSpinBox < Panel
  height: 20
  margin-top: 2

  CheckBox
    id: tick
    anchors.fill: parent
    anchors.right: next.left
    margin-top: 4
    font: verdana-11px-rounded
    text: Ataque de Player
    text-offset: 17 -3

  SpinBox
    id: value
    anchors.top: parent.top
    margin-top: 1
    margin-bottom: 1
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    width: 40
    minimum: 0
    maximum: 100
    step: 1
    editable: true
    focusable: true

AlarmCheckBoxAndTextEdit < Panel
  height: 20
  margin-top: 2

  CheckBox
    id: tick
    anchors.fill: parent
    anchors.right: next.left
    margin-top: 4
    font: verdana-11px-rounded
    text: Nome da Criatura
    text-offset: 17 -3

  BotTextEdit
    id: text
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 150
    font: terminus-10px
    margin-top: 1
    margin-bottom: 1
]]
-- ==========================================
-- SOMA DO TEXTO DA INTERFACE SEM ACENTOS - PARTE 2
-- ==========================================
otuiText = otuiText .. [[
AlarmsWindow < MainWindow
  !text: tr('Alarmes')
  size: 330 430
  padding: 15
  @onEscape: self:hide()

  FlatPanel
    id: list
    anchors.fill: parent
    anchors.bottom: settingsList.top
    margin-bottom: 20
    margin-top: 10
    layout: verticalBox
    padding: 10
    padding-top: 5

  FlatPanel
    id: settingsList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    margin-bottom: 5
    margin-top: 10
    padding: 5
    padding-left: 10
    layout: 
      type: verticalBox
      fit-children: true

  Label
    anchors.verticalCenter: settingsList.top
    anchors.left: settingsList.left
    margin-left: 5
    width: 200
    text: Configuracoes de Alarmes
    font: verdana-11px-rounded
    color: #9f5031

  Label
    anchors.verticalCenter: list.top
    anchors.left: list.left
    margin-left: 5
    width: 200
    text: Alarmes Ativos
    font: verdana-11px-rounded
    color: #9f5031

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
    minimum: 260
    maximum: 600
    margin-left: 3
    margin-right: 3
    background: #ffffff88  

  Button
    id: closeButton
    !text: tr('Fechar')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5
    @onClick: self:getParent():hide()
]]

-- Carrega toda a interface visual unificada de uma vez so
local ui = setupUI(otuiText)
ui:setId(panelName)
-- ==========================================
-- LOGICA DO MOTOR E ALARMES TRADUZIDOS - PARTE 3
-- ==========================================
if not storage[panelName] then
    storage[panelName] = {}
end

local config = storage[panelName]

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
end

local window = UI.createWindow("AlarmsWindow")
window:hide()

ui.alerts.onClick = function()
    window:show()
    window:raise()
    window:focus()
end

local widgets = {
    "AlarmCheckBox", 
    "AlarmCheckBoxAndSpinBox", 
    "AlarmCheckBoxAndTextEdit"
}

local parents = {
    window.list, 
    window.settingsList
}

addAlarm = function(id, title, defaultValue, alarmType, parent, tooltip)
    local widget = UI.createWidget(widgets[alarmType], parents[parent])
    widget:setId(id)

    if type(config[id]) ~= 'table' then
        config[id] = {}
    end

    widget.tick:setText(title)
    widget.tick:setChecked(config[id].enabled)
    widget.tick:setTooltip(tooltip)
    widget.tick.onClick = function()
        config[id].enabled = not config[id].enabled
        widget.tick:setChecked(config[id].enabled)
    end

    if alarmType > 1 and type(config[id].value) == 'nil' then
        config[id].value = defaultValue
    end

    if alarmType == 2 then
        widget.value:setValue(config[id].value)
        widget.value.onValueChange = function(widget, value)
            config[id].value = value
        end
    elseif alarmType == 3 then
        widget.text:setText(config[id].value)
        widget.text.onTextChange = function(widget, newText)
            config[id].value = newText
        end
    end
end

-- Configuracoes Gerais (Com as novas funcoes para Guilda e Escudo Vermelho)
addAlarm("ignoreFriends", "Ignorar Amigos", true, 1, 2)
addAlarm("flashClient", "Piscar o Client", true, 1, 2)
addAlarm("ignoreGuild", "Ignorar Dano da Guilda", false, 1, 2, "Nao toca o alarme se o dano vier de um membro da mesma guilda.")
addAlarm("ignoreRedShield", "Ignorar Escudo Vermelho (War)", false, 1, 2, "Nao toca o alarme se o dano vier de uma luta de War ou escudo vermelho.")

-- Lista de Alarmes Ativos
addAlarm("damageTaken", "Dano Recebido", false, 1, 1)
addAlarm("lowHealth", "Vida Baixa (%)", 20, 2, 1)
addAlarm("lowMana", "Mana Baixa (%)", 20, 2, 1)
addAlarm("playerAttack", "Ataque de Player", false, 1, 1)

UI.Separator(window.list)

addAlarm("privateMsg", "Mensagem Privada (PM)", false, 1, 1)
addAlarm("defaultMsg", "Mensagem no Chat Comum", false, 1, 1)
addAlarm("customMessage", "Mensagem Customizada:", "", 3, 1, "Voce pode adicionar textos. Se forem encontrados em qualquer mensagem recebida, o alarme tocara.\nVoce pode adicionar varios, basta separar por virgula.")

UI.Separator(window.list)

addAlarm("creatureDetected", "Criatura Detectada", false, 1, 1)
addAlarm("playerDetected", "Player Detectado", false, 1, 1)
addAlarm("creatureName", "Nome da Criatura:", "", 3, 1, "Voce pode colocar um nome ou parte dele. Se encontrado em alguma criatura visivel, o alarme tocara.\nVoce pode adicionar varios, basta separar por virgula.")
-- ==========================================
-- ENGINE DE AUDIO E FILTROS SEM TRASVAMENTO - PARTE 4 (CORRIGIDA)
-- ==========================================
local lastCall = now

-- Funcao global de execucao dos alertas sonoros
function alarm(file, windowText)
    if now - lastCall < 2000 then return end -- Intervalo de 2 segundos
    lastCall = now

    if not g_resources.fileExists(file) then
        file = "/sounds/alarm.ogg"
        lastCall = now + 4000 
    end

    if modules.game_bot.g_app.getOs() == "windows" and config.flashClient.enabled then
        g_window.flash()
    end
    g_window.setTitle(player:getName() .. " - " .. windowText)
    playSound(file)
end

-- Monitoramento do Chat (Texto do Server Log)
onTextMessage(function(mode, text)
    if not config.enabled then return end
    
    if mode == 22 and config.damageTaken.enabled then
        local msgLower = text:lower()
        
        -- Filtro por texto para travar alertas de dano se a mensagem for de War
        if config.ignoreRedShield.enabled then
            if msgLower:find("war") or msgLower:find("escudo vermelho") or msgLower:find("red shield") or msgLower:find("combate") then
                return 
            end
        end

        -- Filtro por texto para travar alertas se vier de parceiros de guilda
        if config.ignoreGuild.enabled then
            local myGuild = player:getEmblem() 
            if myGuild and myGuild:len() > 0 then
                if msgLower:find(myGuild:lower()) then
                    return 
                end
            end
            if msgLower:find("guildmate") or msgLower:find("membro da guilda") or msgLower:find("alianca") then
                return
            end
        end

        return alarm('/sounds/magnum.ogg', "Dano Recebido!")
    end

    if config.customMessage.enabled then
        local alertText = config.customMessage.value
        if alertText:len() > 0 then
            text = text:lower()
            local parts = string.split(alertText, ",")

            for i=1,#parts do
                local part = parts[i]:trim():lower()
                if text:find(part) then
                    return alarm('/sounds/magnum.ogg', "Mensagem Especial!")
                end
            end
        end
    end
end)

-- Monitoramento de Conversas
onTalk(function(name, level, mode, text, channelId, pos)
    if not config.enabled then return end
    if name == player:getName() then return end 
    if config.ignoreFriends.enabled and isFriend(name) then return end 

    if mode == 1 and config.defaultMsg.enabled then
        return alarm("/sounds/magnum.ogg", "Mensagem no Chat!")
    end

    if mode == 4 and config.privateMsg.enabled then
        return alarm("/sounds/Private_Message.ogg", "Mensagem Privada!")
    end
end)

-- Macro de Escaneamento de Tela (Ataques Visuais)
macro(100, function() 
    if not config.enabled then return end

    if config.lowHealth.enabled then
        if hppercent() < config.lowHealth.value then
            return alarm("/sounds/Low_Health.ogg", "Vida Baixa!")
        end
    end

    if config.lowMana.enabled then
        if manapercent() < config.lowMana.value then
            return alarm("/sounds/Low_Mana.ogg", "Mana Baixa!")
        end
    end

    for i, spec in ipairs(getSpectators()) do
        if not spec:isLocalPlayer() and not (config.ignoreFriends.enabled and isFriend(spec)) then

            if config.creatureDetected.enabled then
                return alarm("/sounds/magnum.ogg", "Criatura Detected!")
            end

            if spec:isPlayer() then 
                -- Se o jogador estiver te atacando (quadrado piscando)
                if spec:isTimedSquareVisible() and config.playerAttack.enabled then
                    
                    local ignorarAgressor = false
                    
                    -- Se a caixinha da Guilda estiver MARCA DA, faz a checagem
                    if config.ignoreGuild.enabled then
                        if (player:getEmblem() and spec:getEmblem() and player:getEmblem() == spec:getEmblem()) or isFriend(spec:getName()) then
                            ignorarAgressor = true
                        end
                    end

                    -- Se a caixinha do Escudo Vermelho estiver MARCA DA, faz a checagem
                    if config.ignoreRedShield.enabled then
                        local shield = spec:getShield()
                        local emblem = spec:getEmblem()
                        -- Protecao extra: se o id do escudo/emblema indicar modo war do servidor (>= 2)
                        if (shield and shield >= 2) or (emblem and emblem >= 2) then
                            ignorarAgressor = true
                        end
                    end

                    -- Se NENHUMA trava mandar ignorar, o alarme toca livremente
                    if not ignorarAgressor then
                        return alarm("/sounds/Player_Attack.ogg", "Ataque de Player!")
                    end
                end

                if config.playerDetected.enabled then
                    return alarm("/sounds/Player_Detected.ogg", "Player Detectado!")
                end
            end

            if config.creatureName.enabled then
                local name = spec:getName():lower()
                local fragments = string.split(config.creatureName.value, ",")
                
                for j=1,#fragments do
                    local frag = fragments[j]:trim():lower()
                    if name:find(frag) then
                        return alarm("/sounds/alarm.ogg", "Criatura Especial Detectada!")
                    end
                end
            end
        end
    end
end)
