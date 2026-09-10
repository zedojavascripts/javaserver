UI.Separator()

-- [STORAGE ÚNICO]
if not storage.autoPartySystem_v4 then
    storage.autoPartySystem_v4 = {
        enabled = false,
        keyword = "pt",
        globalCommand = "vpt",
        leaveAllCommand = "leave all",
        acceptAny = false,
        isLeader = true,
        sharedXp = false,
        playAlarm = false 
    }
end

local config = storage.autoPartySystem_v4
local aguardandoParty = false
local filaDeConvite = {}

-- [INTERFACE PRINCIPAL NO PAINEL]
local ui = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title_party
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Auto Party Pro')
  Button
    id: setupBtn_party
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit
]], parent)

-- [JANELA DE CONFIGURAÇÃO]
local partyWindow = UI.createWindow("MainWindow")
partyWindow:setText("")
partyWindow:setSize("250 280")
partyWindow:hide()
partyWindow.onEscape = function() partyWindow:hide() end

local partyContent = setupUI([[
Panel
  anchors.fill: parent
  margin: 3
  Label
    id: titleLabel
    text: PARTY CONFIGURATION
    text-align: center
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    color: #00FF00
    margin-top: 5
  Label
    text: Palavra Individual:
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
  TextEdit
    id: keywordInput
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
  Label
    text: Comando Geral (Lider):
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
  TextEdit
    id: globalInput
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
  CheckBox
    id: anyCheck
    text: Aceitar Qualquer Convite
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 200
  CheckBox
    id: leaderCheck
    text: Eu sou o Lider (Convida)
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 4
    width: 200
  CheckBox
    id: sharedCheck
    text: Ativar Shared XP (Lider)
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 4
    width: 200
  CheckBox
    id: alarmCheck
    text: Alarme: Morte/Saida da PT
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 4
    width: 200
    color: #FF4444
  Button
    id: leaveBtn
    text: SAIR DA PARTY AGORA
    color: #ff4444
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 10
    height: 20
]], partyWindow)

-- [Sincronização e Funções]
local function syncPartyUI()
    partyContent.keywordInput:setText(config.keyword)
    partyContent.globalInput:setText(config.globalCommand)
    partyContent.anyCheck:setChecked(config.acceptAny)
    partyContent.leaderCheck:setChecked(config.isLeader)
    partyContent.sharedCheck:setChecked(config.sharedXp)
    partyContent.alarmCheck:setChecked(config.playAlarm)
end

partyContent.keywordInput.onTextChange = function(w, text) config.keyword = text end
partyContent.globalInput.onTextChange = function(w, text) config.globalCommand = text end
partyContent.anyCheck.onCheckChange = function(w, checked) config.acceptAny = checked end
partyContent.leaderCheck.onCheckChange = function(w, checked) config.isLeader = checked end
partyContent.sharedCheck.onCheckChange = function(w, checked) config.sharedXp = checked end
partyContent.alarmCheck.onCheckChange = function(w, checked) config.playAlarm = checked end
partyContent.leaveBtn.onClick = function() g_game.partyLeave() end

ui.title_party:setOn(config.enabled)
ui.title_party.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
    if not config.enabled then filaDeConvite = {} end
end

ui.setupBtn_party.onClick = function()
    syncPartyUI()
    partyWindow:show(); partyWindow:raise(); partyWindow:focus()
end

-- [LÓGICA CORE]

-- 1. PROCESSADOR DE FILA DO LÍDER
macro(6000, function()
    if not config.enabled or not config.isLeader or #filaDeConvite == 0 then return end
    local nextName = table.remove(filaDeConvite, 1)
    local target = getCreatureByName(nextName)
    if target and target:getShield() <= 2 then
        g_game.partyInvite(target:getId())
        schedule(500, function() say("ok: " .. nextName) end)
    end
end)

-- 2. LOOP DE PEDIR PT
macro(10000, function()
    if not config.enabled or config.isLeader or not aguardandoParty then return end
    if player:getShield() > 2 then aguardandoParty = false; return end
    say(config.keyword)
end)

-- 3. AUTO ACCEPT & SHARED XP
macro(1000, function()
    if not config.enabled then return end
    if player:getShield() == 1 and config.acceptAny then
        for _, spec in pairs(getSpectators(false)) do
            if spec:getShield() == 1 then
                g_game.partyJoin(spec:getId())
            end
        end
    end
    if config.isLeader and config.sharedXp and player:isPartyLeader() then
        if not player:isPartySharedExperienceActive() then
            g_game.partyShareExperience(true)
        end
    end
end)

-- 4. ALERTA DE MORTE E SAÍDA (ATUALIZADO)
onTextMessage(function(mode, text)
    if not config.enabled or not config.playAlarm then return end
    local t = text:lower()
    
    -- Detecta Morte, Saída ou Expulsão da Party
    if t:find("died at level") or t:find("has left the party") or t:find("has been kicked from the party") then
        playSound("/sounds/magnum.ogg")
        -- Mensagem de alerta laranja no centro da tela
        warn("ALERTA: Alguém morreu ou saiu da Party!")
    end
end)

onTalk(function(name, level, mode, text, channelId, pos)
    if not config.enabled or mode ~= 1 then return end
    local myName = player:getName()
    local textLow = text:lower()

    if config.isLeader then
        if textLow == config.keyword:lower() and name ~= myName then
            local jaNaLista = false
            for _, n in ipairs(filaDeConvite) do
                if n == name then jaNaLista = true break end
            end
            if not jaNaLista then table.insert(filaDeConvite, name) end
        end
    else
        if textLow == config.globalCommand:lower() and name ~= myName then
            if player:getShield() <= 2 then aguardandoParty = true end
        end
        if textLow == config.leaveAllCommand:lower() and name ~= myName then
            g_game.partyLeave(); aguardandoParty = false
        end
        if textLow == "ok: " .. myName:lower() then
            local leader = getCreatureByName(name)
            if leader and player:getShield() <= 2 then
                g_game.partyJoin(leader:getId())
                aguardandoParty = false
            end
        end
    end
end)

UI.Separator()
