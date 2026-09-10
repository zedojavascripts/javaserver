if milMainWidget then milMainWidget:destroy(); milMainWidget = nil end
UI.Separator()

if not storage.followProParty then storage.followProParty = {} end
local config = storage.followProParty
local defaults = {
    enabled = false,
    autoStair = true,
    isMainLeader = true,
    squad1 = false,
    squad2 = false,
    antiStop = true,
    ignoreFields = true,
    ignorePlayers = true,
    useNative = false
}

for k, v in pairs(defaults) do
    if config[k] == nil then config[k] = v end
end

local partyLevels = {}
local alvoAtual = ""
local ultimaPosAlvo = nil
local marechalName = ""
local modoAtual = "unica" -- "unica", "squad1" ou "squad2"

local function isSafe(name)
    if name == player:getName() then return true end
    local creature = getCreatureByName(name)
    return creature and creature:getShield() >= 3
end

-- UI SETUP
local ui = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Ordem Militar')

  Button
    id: setupBtn
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit
]], parent)

local followWindow = UI.createWindow("MainWindow")
followWindow:setText("Quartel General")
followWindow:setSize("310 200")
followWindow:hide()
followWindow.onEscape = function() followWindow:hide() end

local settingsWindow = UI.createWindow("MainWindow")
settingsWindow:setText("Opcoes de Marcha")
settingsWindow:setSize("250 210")
settingsWindow:hide()
settingsWindow.onEscape = function() settingsWindow:hide() end

local partyContent = setupUI([[
Panel
  anchors.fill: parent
  margin: 3
  Button
    id: btnStartAll
    text: LIGAR ALL
    anchors.top: parent.top
    anchors.left: parent.left
    width: 145
    height: 20
    color: #44FF44
  Button
    id: btnGlobalStop
    text: PARAR ALL
    anchors.top: parent.top
    anchors.left: btnStartAll.right
    anchors.right: parent.right
    margin-left: 5
    height: 20
    color: #FF4444
  Button
    id: btnUnica
    text: FILA UNICA
    anchors.top: btnStartAll.bottom
    anchors.left: parent.left
    width: 145
    margin-top: 5
    height: 22
    color: #00FFFF
  Button
    id: btnStack
    text: AGRUPAR
    anchors.top: btnUnica.top
    anchors.left: btnUnica.right
    anchors.right: parent.right
    margin-left: 5
    height: 22
    color: #FFD700
  Button
    id: btnSquad1
    text: BRIGADA 1
    anchors.top: btnUnica.bottom
    anchors.left: parent.left
    width: 145
    margin-top: 5
    height: 22
    color: #FFA500
  Button
    id: btnSquad2
    text: BRIGADA 2
    anchors.top: btnSquad1.top
    anchors.left: btnSquad1.right
    anchors.right: parent.right
    margin-left: 5
    height: 22
    color: #FFA500
  Button
    id: btnOpenSettings
    text: OPCOES DE MARCHA
    anchors.top: btnSquad1.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 22
  Label
    id: separator
    text: ________________________________________________
    anchors.top: btnOpenSettings.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    color: #444444
  CheckBox
    id: leaderCheck
    text: Marechal
    anchors.top: separator.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 90
  CheckBox
    id: s1Check
    text: Brigada 1
    anchors.top: leaderCheck.top
    anchors.left: leaderCheck.right
    margin-left: 10
    width: 90
  CheckBox
    id: s2Check
    text: Brigada 2
    anchors.top: leaderCheck.top
    anchors.left: s1Check.right
    margin-left: 10
    width: 90
  Label
    id: statusFila
    text: STATUS: AGUARDANDO
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    color: #FFA500
]], followWindow)

local marchSettings = setupUI([[
Panel
  anchors.fill: parent
  margin: 5
  CheckBox
    id: nativeCheck
    text: Usar Follow Nativo (Jogo)
    anchors.top: parent.top
    anchors.left: parent.left
    width: 220
  CheckBox
    id: stairCheck
    text: Atravessar Escadas/Teleport
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    width: 220
    color: #FFA500
  CheckBox
    id: ignoreFCheck
    text: Ignorar Fields (Fogo/Energy)
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    width: 220
  CheckBox
    id: ignorePCheck
    text: Ignorar Outros Players
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    width: 220
  Button
    id: btnCloseSettings
    text: VOLTAR E SALVAR
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 15
    height: 25
    color: #44FF44
]], settingsWindow)

local function organizarFila()
    if config.isMainLeader then alvoAtual = ""; return end
    local myName = player:getName()
    local members = {}
    
    for name, data in pairs(partyLevels) do
        local podeEntrar = false
        
        -- Se o Marechal chamou Fila Única, todo mundo entra
        if modoAtual == "unica" then
            podeEntrar = true
        -- Se chamou Brigada 1, eu só sigo se eu for Brigada 1 E o alvo for Brigada 1
        elseif modoAtual == "squad1" and config.squad1 and data.squad == 1 then
            podeEntrar = true
        -- Se chamou Brigada 2, eu só sigo se eu for Brigada 2 E o alvo for Brigada 2
        elseif modoAtual == "squad2" and config.squad2 and data.squad == 2 then
            podeEntrar = true
        end
        
        if podeEntrar then
            table.insert(members, {name = name, lvl = data.lvl})
        end
    end

    table.sort(members, function(a, b)
        if a.lvl ~= b.lvl then return a.lvl > b.lvl else return a.name < b.name end
    end)

    for i, m in ipairs(members) do
        if m.name == myName then
            alvoAtual = (i == 1) and marechalName or members[i-1].name
            partyContent.statusFila:setText("Seguindo: " .. alvoAtual)
            break
        end
    end
end

onTalk(function(name, level, mode, text, channelId, pos)
    local t = text:lower()
    if not isSafe(name) or mode ~= 1 then return end

    if t == "ligar tudo" then 
        config.enabled = true; ui.title:setOn(true)
    elseif t == "parar tudo" then 
        config.enabled = false; ui.title:setOn(false); alvoAtual = ""; g_game.cancelFollow()
    elseif t == "soldados em fila unica!!" then
        marechalName = name; partyLevels = {}; modoAtual = "unica"
        schedule(math.random(500, 2000), function() if not config.isMainLeader then say("Soldado " .. player:getLevel()) end end)
    elseif t == "brigada um em forma!!" then
        marechalName = name; partyLevels = {}; modoAtual = "squad1"
        if config.squad1 then schedule(math.random(500, 2000), function() say("Brigada Um " .. player:getLevel()) end) end
    elseif t == "brigada dois em forma!!" then
        marechalName = name; partyLevels = {}; modoAtual = "squad2"
        if config.squad2 then schedule(math.random(500, 2000), function() say("Brigada Dois " .. player:getLevel()) end) end
    elseif t == "todos agrupar no marechal!!" then
        marechalName = name; if not config.isMainLeader then g_game.cancelFollow(); alvoAtual = name end
    elseif t:find("marechal") then
        marechalName = name; partyLevels[name] = {lvl = 99999, squad = 0}; schedule(500, organizarFila)
    elseif t:find("soldado") or t:find("brigada um") or t:find("brigada dois") then
        local lvlStr = t:match("%d+")
        if lvlStr then 
            local sq = 0
            if t:find("um") then sq = 1 elseif t:find("dois") then sq = 2 end
            partyLevels[name] = {lvl = tonumber(lvlStr), squad = sq}
            schedule(2000, organizarFila) 
        end
    end
end)

macro(150, function()
    if not config.enabled or config.isMainLeader or alvoAtual == "" then return end
    local target = getCreatureByName(alvoAtual)
    if target then
        local tPos = target:getPosition()
        ultimaPosAlvo = tPos
        if tPos.z ~= player:getPosition().z then
            if not g_game.isFollowing() then g_game.follow(target) end
            return
        end
        if config.useNative then
            if not g_game.isFollowing() then g_game.follow(target) end
        else
            if g_game.isFollowing() then g_game.cancelFollow() end
            autoWalk(tPos, 2000, {ignoreFields = config.ignoreFields, ignoreCreatures = config.ignorePlayers, precision = 0})
        end
    elseif ultimaPosAlvo and config.autoStair then
        autoWalk(ultimaPosAlvo, 2000)
    end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
    if not config.enabled or not config.autoStair or config.isMainLeader then return end
    local targetName = (alvoAtual ~= "" and alvoAtual or marechalName)
    if not targetName or creature:getName():lower() ~= targetName:lower() then return end
    if oldPos and (not newPos or oldPos.z ~= newPos.z) then
        ultimaPosAlvo = oldPos; g_game.cancelFollow()
        autoWalk(oldPos, 2000)
        schedule(350, function()
            local tile = g_map.getTile(oldPos)
            if tile and tile:getTopUseThing() then g_game.use(tile:getTopUseThing()) end
        end)
    end
end)

partyContent.btnStartAll.onClick = function() say("ligar tudo") end
partyContent.btnGlobalStop.onClick = function() say("parar tudo") end
partyContent.btnOpenSettings.onClick = function() settingsWindow:show(); settingsWindow:raise(); settingsWindow:focus() end
partyContent.btnUnica.onClick = function() say("Soldados em Fila Unica!!"); if config.isMainLeader then schedule(3500, function() say("Marechal") end) end end
partyContent.btnSquad1.onClick = function() say("Brigada Um em forma!!"); if config.isMainLeader then schedule(3500, function() say("Marechal") end) end end
partyContent.btnSquad2.onClick = function() say("Brigada Dois em forma!!"); if config.isMainLeader then schedule(3500, function() say("Marechal") end) end end
partyContent.btnStack.onClick = function() say("todos agrupar no marechal!!") end

partyContent.leaderCheck:setChecked(config.isMainLeader); partyContent.leaderCheck.onCheckChange = function(w, c) config.isMainLeader = c end
partyContent.s1Check:setChecked(config.squad1); partyContent.s1Check.onCheckChange = function(w, c) config.squad1 = c end
partyContent.s2Check:setChecked(config.squad2); partyContent.s2Check.onCheckChange = function(w, c) config.squad2 = c end
marchSettings.nativeCheck:setChecked(config.useNative); marchSettings.nativeCheck.onCheckChange = function(w, c) config.useNative = c end
marchSettings.stairCheck:setChecked(config.autoStair); marchSettings.stairCheck.onCheckChange = function(w, c) config.autoStair = c end
marchSettings.ignoreFCheck:setChecked(config.ignoreFields); marchSettings.ignoreFCheck.onCheckChange = function(w, c) config.ignoreFields = c end
marchSettings.ignorePCheck:setChecked(config.ignorePlayers); marchSettings.ignorePCheck.onCheckChange = function(w, c) config.ignorePlayers = c end
marchSettings.btnCloseSettings.onClick = function() settingsWindow:hide() end
ui.setupBtn.onClick = function() followWindow:show(); followWindow:raise(); followWindow:focus() end
ui.title.onClick = function(w) config.enabled = not config.enabled; w:setOn(config.enabled) end
ui.title:setOn(config.enabled)

UI.Separator()
