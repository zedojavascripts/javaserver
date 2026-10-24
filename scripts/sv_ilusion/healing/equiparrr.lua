UI.Separator()
-- =============================================================================
-- CENTRAL DE EQUIPAR — BRINQUE SCRIPTS — VERSÃO TOTALMENTE INDEPENDENTE
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()
local nomeDoProjetoMestre = "CentralDeEquiparBrinque_Livre_v1"

-- Usa a storage nativa do bot para salvar as configurações
if not storage[nomeDoProjetoMestre] or not storage[nomeDoProjetoMestre].listaDeAbas then
    storage[nomeDoProjetoMestre] = {
        listaDeAbas = {
            { id = 1, nome = "Equipe Item 1", enabled = false, idItemPadrao = 3048, idItemEspecial = 3051, slotAlvoHardware = 2, porcentagemInjetar = 50, porcentagemVoltar = 80, tipoGatilhoBarra = "HP" }
        }
    }
end
local sGlobal = storage[nomeDoProjetoMestre]

-- =============================================================================
-- DESIGNS DA INTERFACE (Removido o btnConfigBag)
-- =============================================================================
local designPrincipalOTUI = "MainWindow\n  id: janelaCentralDeEquiparBrinque\n  !text: tr('Central de Equipar Brinque')\n  size: 550 550\n  background-color: #1e1e1e\n  border: 1 #3a3333\n  padding: 10\n  @onEscape: self:hide()\n  ScrollablePanel\n    id: painelConteudoAbas\n    anchors.top: parent.top\n    anchors.left: parent.left\n    anchors.right: parent.right\n    height: 480\n    margin-top: 15\n    vertical-scrollbar: scrollAbas\n    layout:\n      type: grid\n      cell-size: 245 215\n      cell-spacing: 15\n      num-columns: 2\n  VerticalScrollBar\n    id: scrollAbas\n    anchors.top: painelConteudoAbas.top\n    anchors.bottom: painelConteudoAbas.bottom\n    anchors.right: parent.right\n    step: 30\n  Button\n    id: closeBtn\n    text: Fechar\n    width: 110\n    height: 22\n    anchors.bottom: parent.bottom\n    anchors.left: parent.left\n    margin-left: 5\n  Button\n    id: btnAdicionarNovaConfig\n    text: [+] Adicionar\n    color: #55ff55\n    width: 120\n    height: 22\n    anchors.bottom: parent.bottom\n    anchors.left: closeBtn.right\n    margin-left: 10\n"

local designPopUpSlotOTUI = "MainWindow\n  id: janelaSelecaoSlotPop\n  !text: tr('Escolha o Slot')\n  size: 260 410\n  anchors.centerIn: parent\n  background-color: #1a1a1a\n  border: 1 #444444\n  @onEscape: self:hide()\n  Button\n    id: btnSlotCapacete\n    text: CAPACETE\n    width: 220\n    height: 24\n    anchors.top: parent.top\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 15\n  Button\n    id: btnSlotPescoco\n    text: COLAR\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnSlotArmor\n    text: PEITORAL\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnSlotMaoDireita\n    text: MAO DIREITA\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnSlotShield\n    text: MAO ESQUERDA\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnSlotAnel\n    text: ANEL\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnSlotLegs\n    text: CALCA\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnSlotBota\n    text: BOTA\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnSlotArrow\n    text: FLECHA\n    width: 220\n    height: 24\n    anchors.top: prev.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-top: 8\n  Button\n    id: btnVoltarPop\n    text: Voltar\n    width: 100\n    height: 22\n    anchors.bottom: parent.bottom\n    anchors.horizontalCenter: parent.horizontalCenter\n    margin-bottom: 5\n"

local designPopUpTextoOTUI = "MainWindow\n  id: janelaEntradaTextoBrinquePop\n  !text: tr('Editar Campo')\n  size: 260 130\n  anchors.centerIn: parent\n  background-color: #1e1e1e\n  border: 1 #444444\n  @onEscape: self:hide()\n  Label\n    id: lblInfo\n    text: Digite o novo valor:\n    width: 230\n    height: 15\n    anchors.top: parent.top\n    anchors.left: parent.left\n    margin-top: 10\n  TextEdit\n    id: txtEntrada\n    width: 230\n    height: 22\n    anchors.top: lblInfo.bottom\n    anchors.left: parent.left\n    margin-top: 8\n  Button\n    id: btnConfirmar\n    text: Confirmar\n    color: #55ff55\n    width: 100\n    height: 22\n    anchors.bottom: parent.bottom\n    anchors.left: parent.left\n    margin-bottom: 5\n  Button\n    id: btnCancelar\n    text: Cancelar\n    width: 100\n    height: 22\n    anchors.bottom: parent.bottom\n    anchors.right: parent.right\n    margin-bottom: 5\n"

if global_janelaCentralDeEquiparBrinque then global_janelaCentralDeEquiparBrinque:destroy() end
global_janelaCentralDeEquiparBrinque = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
global_janelaSelecaoSlotPop = setupUI(designPopUpSlotOTUI, widgetRaizDoJogo)
global_janelaEntradaTextoBrinquePop = setupUI(designPopUpTextoOTUI, widgetRaizDoJogo)

local configWindow = global_janelaCentralDeEquiparBrinque
local slotPopWindow = global_janelaSelecaoSlotPop
local textoPopWindow = global_janelaEntradaTextoBrinquePop

configWindow:hide() slotPopWindow:hide() textoPopWindow:hide()

-- =============================================================================
-- CONSTRUTOR DA INTERFACE (RECONSTRÓI OS CARDS)
-- =============================================================================
local function reconstrutorGeralDeInterface()
    if not configWindow then return end
    local container = configWindow.painelConteudoAbas
    container:destroyChildren()

    for index, aba in ipairs(sGlobal.listaDeAbas) do
        local linhasUI = {
            "Panel", "  id: blocoAba_" .. aba.id, "  background-color: #141414", "  border: 1 #252525", "  padding: 6",
            "  Label", "    id: lblNomeConfig_" .. aba.id, "    text: " .. aba.nome, "    font: verdana-11px-rounded", "    color: #e6bc22", "    width: 140", "    height: 20", "    anchors.top: parent.top", "    anchors.left: parent.left", "    margin-top: 2", "    margin-left: 4",
            "  Button", "    id: btnRemover_" .. aba.id, "    text: Remove", "    background-color: #ff0000", "    color: black", "    width: 55", "    height: 18", "    anchors.verticalCenter: lblNomeConfig_" .. aba.id .. ".verticalCenter", "    anchors.right: parent.right", "    margin-right: 4",
            "  BotSwitch", "    id: swHabilitaMacro_" .. aba.id, "    width: 80", "    height: 20", "    anchors.top: lblNomeConfig_" .. aba.id .. ".bottom", "    anchors.left: parent.left", "    margin-top: 10", "    margin-left: 4",
            "  Label", "    id: lblMonitoramentoStatus_" .. aba.id, "    text: Status: Ok", "    font: verdana-11px-rounded", "    color: #aeaeae", "    width: 100", "    height: 20", "    anchors.verticalCenter: swHabilitaMacro_" .. aba.id .. ".verticalCenter", "    anchors.left: swHabilitaMacro_" .. aba.id .. ".right", "    margin-left: 6", "    text-align: left",
            "  Label", "    id: lblSubPadrao_" .. aba.id, "    text: PADRAO", "    font: verdana-11px-rounded", "    color: #aeaeae", "    width: 105", "    anchors.top: swHabilitaMacro_" .. aba.id .. ".bottom", "    anchors.left: parent.left", "    margin-top: 12", "    margin-left: 4", "    text-align: center",
            "  Label", "    id: lblSubEspecial_" .. aba.id, "    text: ESPECIAL", "    font: verdana-11px-rounded", "    color: #aeaeae", "    width: 105", "    anchors.top: swHabilitaMacro_" .. aba.id .. ".bottom", "    anchors.left: lblSubPadrao_" .. aba.id .. ".right", "    margin-top: 12", "    margin-left: 10", "    text-align: center",
            "  Button", "    id: btnItemPadraoId_" .. aba.id, "    text: ID: " .. aba.idItemPadrao, "    width: 105", "    height: 24", "    anchors.top: lblSubPadrao_" .. aba.id .. ".bottom", "    anchors.left: parent.left", "    margin-top: 4", "    margin-left: 4",
            "  Button", "    id: btnItemEspecialId_" .. aba.id, "    text: ID: " .. aba.idItemEspecial, "    width: 105", "    height: 24", "    anchors.top: lblSubEspecial_" .. aba.id .. ".bottom", "    anchors.left: btnItemPadraoId_" .. aba.id .. ".right", "    margin-top: 4", "    margin-left: 10",
            "  Button", "    id: btnAbrePopUpSlot_" .. aba.id, "    text: CONFIGURAR SLOT", "    width: 220", "    height: 24", "    anchors.top: btnItemPadraoId_" .. aba.id .. ".bottom", "    anchors.left: parent.left", "    margin-top: 10", "    margin-left: 4",
            "  Button", "    id: btnGatilhoVoltar_" .. aba.id, "    text: STOP >= " .. aba.porcentagemVoltar .. "%", "    width: 105", "    height: 24", "    anchors.top: btnAbrePopUpSlot_" .. aba.id .. ".bottom", "    anchors.left: parent.left", "    margin-top: 10", "    margin-left: 4",
            "  Button", "    id: btnGatilhoInjetar_" .. aba.id, "    text: INJETAR <= " .. aba.porcentagemInjetar .. "%", "    width: 105", "    height: 24", "    anchors.top: btnAbrePopUpSlot_" .. aba.id .. ".bottom", "    anchors.left: btnGatilhoVoltar_" .. aba.id .. ".right", "    margin-top: 10", "    margin-left: 10",
            "  CheckBox", "    id: chkModoHP_" .. aba.id, "    text: HP", "    width: 45", "    height: 20", "    anchors.top: btnGatilhoVoltar_" .. aba.id .. ".bottom", "    anchors.left: parent.left", "    margin-top: 12", "    margin-left: 50",
            "  CheckBox", "    id: chkModoMP_" .. aba.id, "    text: MP", "    width: 45", "    height: 20", "    anchors.top: btnGatilhoVoltar_" .. aba.id .. ".bottom", "    anchors.left: chkModoHP_" .. aba.id .. ".right", "    margin-top: 12", "    margin-left: 40"
        }
        local designAbaOTUI = table.concat(linhasUI, "\n")
        local pAbaWidget = setupUI(designAbaOTUI, container)
        local swMestre = pAbaWidget:getChildById("swHabilitaMacro_" .. aba.id)
        local lblStatus = pAbaWidget:getChildById("lblMonitoramentoStatus_" .. aba.id)
        local btnPadrao = pAbaWidget:getChildById("btnItemPadraoId_" .. aba.id)
        local btnEspecial = pAbaWidget:getChildById("btnItemEspecialId_" .. aba.id)
        local btnSlot = pAbaWidget:getChildById("btnAbrePopUpSlot_" .. aba.id)
        local btnVoltar = pAbaWidget:getChildById("btnGatilhoVoltar_" .. aba.id)
        local btnInjetar = pAbaWidget:getChildById("btnGatilhoInjetar_" .. aba.id)
        local chkHP = pAbaWidget:getChildById("chkModoHP_" .. aba.id)
        local chkMP = pAbaWidget:getChildById("chkModoMP_" .. aba.id)
        local btnDel = pAbaWidget:getChildById("btnRemover_" .. aba.id)
        
        swMestre:setOn(aba.enabled) swMestre:setText(aba.enabled and "Macro: ON" or "Macro: OFF")
        if aba.enabled then lblStatus:setText("Status: Ativo") lblStatus:setColor("yellow") else lblStatus:setText("Status: Okey") lblStatus:setColor("#aeaeae") end
        
        chkHP:setChecked(aba.tipoGatilhoBarra == "HP") chkMP:setChecked(aba.tipoGatilhoBarra == "MP")
        chkHP.onCheckChange = function(w, verificado)
            if verificado then aba.tipoGatilhoBarra = "HP" chkMP:setChecked(false) else if not chkMP:isChecked() then w:setChecked(true) end end
        end
        chkMP.onCheckChange = function(w, verificado)
            if verificado then aba.tipoGatilhoBarra = "MP" chkHP:setChecked(false) else if not chkHP:isChecked() then w:setChecked(true) end end
        end
        
        local function dispararPopUpAba(chave)
            if not textoPopWindow then return end
            textoPopWindow.txtEntrada:setText(tostring(aba[chave] or 0))
            textoPopWindow.btnConfirmar.onClick = function()
                local val = textoPopWindow.txtEntrada:getText()
                if val and val:len() > 0 then aba[chave] = tonumber(val) or 0 end
                textoPopWindow:hide() reconstrutorGeralDeInterface()
            end
            textoPopWindow.btnCancelar.onClick = function() textoPopWindow:hide() end
            textoPopWindow:show() textoPopWindow:raise() textoPopWindow:focus() textoPopWindow.txtEntrada:focus()
        end
        
        swMestre.onClick = function() aba.enabled = not aba.enabled reconstrutorGeralDeInterface() end
        btnPadrao.onClick = function() dispararPopUpAba("idItemPadrao") end
        btnEspecial.onClick = function() dispararPopUpAba("idItemEspecial") end
        btnInjetar.onClick = function() dispararPopUpAba("porcentagemInjetar") end
        btnVoltar.onClick = function() dispararPopUpAba("porcentagemVoltar") end
        
        btnSlot.onClick = function()
            if not slotPopWindow then return end
            slotPopWindow:show() slotPopWindow:raise() slotPopWindow:focus()
            local slots = { {b=slotPopWindow.btnSlotCapacete, id=1}, {b=slotPopWindow.btnSlotPescoco, id=2}, {b=slotPopWindow.btnSlotArmor, id=3}, {b=slotPopWindow.btnSlotBota, id=4}, {b=slotPopWindow.btnSlotShield, id=5}, {b=slotPopWindow.btnSlotMaoDireita, id=6}, {b=slotPopWindow.btnSlotLegs, id=7}, {b=slotPopWindow.btnSlotAnel, id=9}, {b=slotPopWindow.btnSlotArrow, id=10} }
            for _, sl in ipairs(slots) do
                sl.b.onClick = function() aba.slotAlvoHardware = sl.id slotPopWindow:hide() reconstrutorGeralDeInterface() end
            end
            slotPopWindow.btnVoltarPop.onClick = function() slotPopWindow:hide() end
        end
        
        local sId = tonumber(aba.slotAlvoHardware) or 2
        local nomes = { "CAPACETE", "COLAR", "PEITORAL", "BOTA", "MAO ESQUERDA", "MAO DIREITA", "CALCA", "ANEL", "ANEL", "FLECHA" }
        btnSlot:setText("SLOT: " .. (nomes[sId] or sId))
        
        btnDel.onClick = function() table.remove(sGlobal.listaDeAbas, index) reconstrutorGeralDeInterface() end
    end
end

configWindow.btnAdicionarNovaConfig.onClick = function()
    local novoId = #sGlobal.listaDeAbas + 1
    table.insert(sGlobal.listaDeAbas, {id = novoId, nome = "Equipe Item " .. novoId, enabled = false, idItemPadrao = 0, idItemEspecial = 0, slotAlvoHardware = 2, porcentagemInjetar = 50, porcentagemVoltar = 80, tipoGatilhoBarra = "HP"})
    reconstrutorGeralDeInterface()
end

configWindow.closeBtn.onClick = function() configWindow:hide() end

local function localizadorDeItensNasBags(itemId)
    if itemId <= 0 then return nil end
    local containers = g_game.getContainers()
    if not containers then return nil end
    for _, container in pairs(containers) do
        for __, item in ipairs(container:getItems()) do if item:getId() == itemId then return item end end
    end
    return nil
end

macro(100, function()
    if not sGlobal or not sGlobal.listaDeAbas or type(sGlobal.listaDeAbas) ~= "table" then return end
    for _, aba in ipairs(sGlobal.listaDeAbas) do
        if aba and aba.enabled then
            local pct = (aba.tipoGatilhoBarra == "MP") and manapercent() or hppercent()
            local targetSlot = tonumber(aba.slotAlvoHardware) or 2
            local itemNoCorpo = getSlot(targetSlot)
            local id1, id2 = tonumber(aba.idItemPadrao) or 0, tonumber(aba.idItemEspecial) or 0
            local metaEspecialDireita, metaPadraoEsquerda = tonumber(aba.porcentagemInjetar) or 50, tonumber(aba.porcentagemVoltar) or 80
            
            if pct <= metaEspecialDireita then
                if id2 > 0 and (not itemNoCorpo or itemNoCorpo:getId() ~= id2) then
                    local itemAlvo = localizadorDeItensNasBags(id2)
                    if itemAlvo then g_game.move(itemAlvo, {x=65535, y=targetSlot, z=0}, 1) delay(150) return end
                end
            elseif pct >= metaPadraoEsquerda then
                if id1 > 0 and (not itemNoCorpo or itemNoCorpo:getId() ~= id1) then
                    local itemAlvo = localizadorDeItensNasBags(id1)
                    if itemAlvo then g_game.move(itemAlvo, {x=65535, y=targetSlot, z=0}, 1) delay(150) return end
                end
            else
                if id1 > 0 and (not itemNoCorpo or itemNoCorpo:getId() ~= id1) then
                    local itemAlvo = localizadorDeItensNasBags(id1)
                    if itemAlvo then g_game.move(itemAlvo, {x=65535, y=targetSlot, z=0}, 1) delay(150) return end
                end
            end
        end
    end
end)

-- =============================================================================
-- CONSTRUTOR DO BOTÃO NA ABA LATERAL "main"
-- =============================================================================
local uiBotaoEquipar = nil
local function renderizarBotaoEquiparMenuLateral()
    if uiBotaoEquipar then uiBotaoEquipar:destroy() end
    
    uiBotaoEquipar = setupUI([[
Panel
  height: 20
  Button
    id: btnMenuEquiparLivre
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Equipar
    font: verdana-11px-rounded
  ]], getTab("hp"))

    uiBotaoEquipar.btnMenuEquiparLivre.onClick = function()
        if configWindow:isVisible() then 
            configWindow:hide() 
        else
            local painelBot = g_ui.getRootWidget():getChildById("botPanel")
            if painelBot then
                local posMestre = painelBot:getPosition()
                configWindow:setPosition({x = posMestre.x + 300, y = posMestre.y})
            end
            configWindow:show() 
            configWindow:raise() 
            configWindow:focus()
            reconstrutorGeralDeInterface()
        end
    end
end

schedule(1000, renderizarBotaoEquiparMenuLateral)


UI.Separator()

local okR, errR = pcall(reconstrutorGeralDeInterface)
if not okR then print(">>> [EQUIPAR] erro ao montar a lista: " .. tostring(errR)) end
