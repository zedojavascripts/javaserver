UI.Separator()
setDefaultTab("tools")

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

-- STORAGE CONFIGS: Salva o nome padrão do NPC e a lista de cidades inicial por vírgulas
if not configMestre.travelNpcName then configMestre.travelNpcName = "Minoru" end
if not configMestre.travelCitiesStr then 
    configMestre.travelCitiesStr = "thais, carlin, Kirigakure, venom" 
end

local configPanelTravel = "coordenadasTravelOriginalBrq"
if not storage[configPanelTravel] then storage[configPanelTravel] = {} end
local travelStorage = storage[configPanelTravel]

if not travelStorage.x then travelStorage.x = 400 end
if not travelStorage.y then travelStorage.y = 250 end

local isTraveling = false

-- Limpa instâncias anteriores da RAM por segurança antes da arrancada
if travelUI then travelUI:destroy() travelUI = nil end
if configPanelUI then configPanelUI:destroy() configPanelUI = nil end

-- =============================================================================
-- 🛠️ JANELA 1: PAINEL EDITOR ACOPLADO PARA CONFIGURAR NPC E CIDADES
-- =============================================================================
local designConfigOTUI = "MainWindow\n" ..
"  id: configTravelWindow\n" ..
"  size: 320 220\n" ..
"  text: Configurar Fast Travel\n" ..
"  color: #ffffff\n" ..
"  @onEscape: self:hide()\n" ..
"\n" ..
"  Label\n" ..
"    text: Nome do NPC:\n" ..
"    font: cipsoftFont\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: editNpcName\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 4\n" ..
"\n" ..
"  Label\n" ..
"    text: Cidades (Separadas por virgula):\n" ..
"    font: cipsoftFont\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 10\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: editCitiesList\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 4\n" ..
"    height: 45\n" ..
"\n" ..
"  Button\n" ..
"    id: btnSalvarConfigs\n" ..
"    text: Salvar Configuracoes\n" ..
"    color: #44ff44\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    height: 22\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFecharConfig\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.right: parent.right\n" ..
"    size: 60 20\n" ..
"    @onClick: self:getParent():hide()\n"

configPanelUI = setupUI(designConfigOTUI, g_ui.getRootWidget())
configPanelUI:hide()

-- Carrega os textos salvos nos inputs ao abrir
configPanelUI.editNpcName:setText(configMestre.travelNpcName)
configPanelUI.editCitiesList:setText(configMestre.travelCitiesStr)

-- Botão no painel principal do bot para chamar o editor de texto
UI.Button("Editar Fast Travel", function()
    if configPanelUI:isVisible() then
        configPanelUI:hide()
    else
        configPanelUI:show()
        configPanelUI:raise()
        configPanelUI:focus()
    end
end)
-- =============================================================================
-- [BRINQUE SCRIPTS] FAST TRAVEL INTEGRAL EDITÁVEL - PARTE 2 DE 2 FIX CIDADES
-- =============================================================================

-- =============================================================================
-- 📐 JANELA 2: TRAVEL BRQ - AJUSTE FIXO DE TAMANHO E CENTRALIZAÇÃO DA GRADE
-- =============================================================================
local designTravelOTUI = "MainWindow\n" ..
"  id: travelWindow\n" ..
"  size: 260 365\n" ..
"  text: TRAVEL BRQ\n" ..
"  color: #ffffff\n" ..
"  @onEscape: self:hide()\n" ..
"\n" ..
"  Panel\n" ..
"    id: buttonGrid\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.horizontalCenter: parent.horizontalCenter\n" ..
"    size: 230 280\n" ..
"    margin-top: 10\n" ..
"    layout:\n" ..
"      type: grid\n" ..
"      cell-size: 110 26\n" ..
"      cell-spacing: 6\n" ..
"      flow: true\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 60 20\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 15\n" ..
"    @onClick: self:getParent():hide()\n"

travelUI = setupUI(designTravelOTUI, g_ui.getRootWidget())
travelUI:setPosition({x = travelStorage.x, y = travelStorage.y})
travelUI:hide()

local function npcTalk(text)
  if g_game.getClientVersion() >= 810 then
    g_game.talkChannel(11, 0, text)
  else
    say(text)
  end
end

local function executeTravel(cityName)
  if isTraveling then return end
  isTraveling = true

  npcTalk("hi")
  
  schedule(450, function()
    npcTalk(cityName)
  end)
  
  schedule(1250, function()
    npcTalk("yes")
    isTraveling = false
  end)
end

-- 🧠 RECONSTRUTOR DINÂMICO DE BOTÕES: Lê a string do Storage e divide por vírgulas
local function atualizarBotoesDasCidades()
    travelUI.buttonGrid:destroyChildren()
    
    local cidadesString = configMestre.travelCitiesStr or ""
    for cidadeNome in string.gmatch(cidadesString, "([^,]+)") do
        cidadeNome = cidadeNome:trim()
        if cidadeNome ~= "" then
            local btn = g_ui.createWidget('Button', travelUI.buttonGrid)
            btn:setText(cidadeNome)
            btn:setHeight(26)
            
            if cidadeNome == 'Konohagakure' then
                btn:setFont('verdana-11px-rounded')
                btn:setColor('#00b3ff')
            elseif cidadeNome:lower():find('kure') then
                btn:setFont('verdana-11px-rounded')
                btn:setColor('#38bdf8')
            else
                btn:setFont('cipsoftFont')
                btn:setColor('#cbd5e1')
            end
            
            btn.onClick = function()
                executeTravel(cidadeNome)
            end
        end
    end
end

-- Ação do botão salvar da Janela 1
configPanelUI.btnSalvarConfigs.onClick = function()
    configMestre.travelNpcName = configPanelUI.editNpcName:getText():trim()
    configMestre.travelCitiesStr = configPanelUI.editCitiesList:getText():trim()
    atualizarBotoesDasCidades()
    configPanelUI:hide()
    print("[Brinque] Configuracoes do Fast Travel salvas com sucesso!")
end

-- Inicializa os botões na arrancada
atualizarBotoesDasCidades()

travelUI.onGeometryChange = function(widget)
    local pos = widget:getPosition()
    if pos and pos.x and pos.y and pos.x > 0 and pos.y > 0 then
        travelStorage.x = pos.x
        travelStorage.y = pos.y
    end
end

-- =============================================================================
-- [SENSOR MACRO: PROXIMIDADE MATEMÁTICA DO NPC DINÂMICO]
-- =============================================================================
macro(500, function()
  local npcNomeAlvo = configMestre.travelNpcName or "Minoru"
  local findNpc = getCreatureByName(npcNomeAlvo)
  
  if findNpc and getDistanceBetween(pos(), findNpc:getPosition()) <= 3 then
    if not travelUI:isVisible() then
      travelUI:show()
      travelUI:raise()
    end
  else
    if travelUI:isVisible() then
      travelUI:hide()
      isTraveling = false
    end
  end
end)
UI.Separator()
