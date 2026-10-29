-- =============================================================================
-- CENTRAL DE EQUIPAR - BRINQUE SCRIPTS (versao avulsa, sem o ElfBrinque)
-- Funciona sozinha em qualquer vBot 4.x: coloque este arquivo na pasta da config do
-- bot (ou cole no Ingame script editor). Abre pelo botao "Central de Equipar" na aba Main.
-- Cada caixa troca um item por HP/MP:
--   INJETAR <= X%  coloca o item ESPECIAL      STOP >= Y%  volta o item PADRAO
--   entre os dois nao mexe (nao fica trocando sem parar)
-- Corrigido da versao do Elf: PEITORAL ia para o slot da mochila e BOTA para o do peitoral.
-- =============================================================================

local raiz = g_ui.getRootWidget()
local ID_JANELA = "janelaEquiparBrinqueAvulsa"

-- [CONFIG] fica no storage do bot
if type(storage.equiparBrinque) ~= "table" or type(storage.equiparBrinque.lista) ~= "table" then
    storage.equiparBrinque = {
        lista = {
            { nome = "Equipe Item 1", on = false, padrao = 3048, especial = 3051, slot = 2,
              injetar = 50, stop = 80, barra = "HP" }
        }
    }
end
local sGlobal = storage.equiparBrinque

-- slots do corpo (numeros do Tibia)
local SLOTS = {
    { id = 1, nome = "CAPACETE" }, { id = 2, nome = "COLAR" }, { id = 4, nome = "PEITORAL" },
    { id = 6, nome = "MAO DIREITA" }, { id = 5, nome = "MAO ESQUERDA" }, { id = 9, nome = "ANEL" },
    { id = 7, nome = "CALCA" }, { id = 8, nome = "BOTA" }, { id = 10, nome = "FLECHA" },
}
local function nomeSlot(id)
    for _, s in ipairs(SLOTS) do if s.id == id then return s.nome end end
    return "SLOT " .. tostring(id)
end

-- funcoes do vBot com reserva (para funcionar em config sem a biblioteca do vBot)
local function slotDoCorpo(slot)
    if type(getSlot) == "function" then return getSlot(slot) end
    local p = g_game.getLocalPlayer()
    return p and p:getInventoryItem(slot) or nil
end
local function porcento(barra)
    local p = g_game.getLocalPlayer()
    if not p then return 100 end
    if barra == "MP" then
        local max = p:getMaxMana()
        return max > 0 and math.floor(100 * p:getMana() / max) or 100
    end
    return p:getHealthPercent()
end

-- limpa janelas de um reload anterior
for _, id in ipairs({ ID_JANELA, "popSlotEquiparBrinque", "popTextoEquiparBrinque" }) do
    for _ = 1, 20 do
        local velho = raiz:recursiveGetChildById(id)
        if not velho then break end
        pcall(function() velho:destroy() end)
    end
end

-- =============================================================================
-- [JANELAS]
-- =============================================================================
local janela = setupUI([[
MainWindow
  id: janelaEquiparBrinqueAvulsa
  !text: tr('Central de Equipar - Brinque Scripts')
  size: 550 550
  padding: 10
  @onEscape: self:hide()

  ScrollablePanel
    id: lista
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: rolagem.left
    anchors.bottom: separador.top
    margin-top: 10
    margin-bottom: 6
    vertical-scrollbar: rolagem
    layout:
      type: grid
      cell-size: 245 215
      cell-spacing: 10
      num-columns: 2

  VerticalScrollBar
    id: rolagem
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: separador.top
    margin-top: 10
    margin-bottom: 6
    step: 30
    pixels-scroll: true

  HorizontalSeparator
    id: separador
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: btnFechar.top
    margin-bottom: 6

  Button
    id: btnFechar
    text: Fechar
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    size: 110 22

  Button
    id: btnAdicionar
    text: [+] Adicionar
    color: #55ff55
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    size: 120 22
]], raiz)
janela:hide()

local popSlot = setupUI([[
MainWindow
  id: popSlotEquiparBrinque
  !text: tr('Escolha o Slot do Corpo')
  size: 250 380
  @onEscape: self:hide()

  Panel
    id: grade
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: btnVoltar.top
    margin-bottom: 4
    layout:
      type: verticalBox
      spacing: 6

  Button
    id: btnVoltar
    text: Voltar
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    size: 80 20
]], raiz)
popSlot:hide()

local popTexto = setupUI([[
MainWindow
  id: popTextoEquiparBrinque
  !text: tr('Editar valor')
  size: 260 130
  @onEscape: self:hide()

  Label
    id: info
    text: Digite o novo valor:
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 15

  TextEdit
    id: entrada
    anchors.top: info.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 6
    height: 22

  Button
    id: btnOk
    text: Confirmar
    color: #55ff55
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    size: 100 22

  Button
    id: btnCancelar
    text: Cancelar
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    size: 100 22
]], raiz)
popTexto:hide()

local function editar(titulo, valor, aoConfirmar)
    popTexto:setText(titulo)
    popTexto.entrada:setText(tostring(valor or ""))
    popTexto.btnOk.onClick = function()
        local n = tonumber(popTexto.entrada:getText())
        popTexto:hide()
        if n then aoConfirmar(n) end
    end
    popTexto.btnCancelar.onClick = function() popTexto:hide() end
    popTexto:show() popTexto:raise() popTexto:focus() popTexto.entrada:focus()
end

-- =============================================================================
-- [CAIXAS] uma por troca
-- =============================================================================
local redesenhar

-- icones na tela: um por troca com "icone" marcado, com o nome dela
local icones = {}
local function refazerIcones()
    for _, ic in pairs(icones) do pcall(function() ic:destroy() end) end
    icones = {}
    if type(addIcon) ~= "function" then return end
    for i, a in ipairs(sGlobal.lista) do
        if a.icone then
            local item = (tonumber(a.especial) or 0) > 0 and tonumber(a.especial) or tonumber(a.padrao) or 0
            local ok, ic = pcall(addIcon, "equiparBrinque" .. i, { item = item, text = tostring(a.nome or ("Equipe " .. i)) },
                function(_, ligado)
                    a.on = ligado == true
                    if janela:isVisible() then redesenhar() end
                end)
            if ok and ic then
                icones[i] = ic
                pcall(function() ic:setOn(a.on == true) end)
            end
        end
    end
end

local function campo(tipo, pai, x, y, w, h, texto)
    local wdg = setupUI(tipo .. "\n  anchors.top: parent.top\n  anchors.left: parent.left\n  margin-top: " .. y ..
        "\n  margin-left: " .. x .. "\n  width: " .. w .. "\n  height: " .. h .. "\n", pai)
    if texto then wdg:setText(texto) end
    return wdg
end

local function caixa(i, a)
    local p = setupUI("Panel\n  background-color: #141414\n  border: 1 #252525\n", janela.lista)

    local nome = campo("Label", p, 6, 4, 150, 18, a.nome or ("Equipe Item " .. i))
    nome:setColor("#e6bc22")
    local btnX = campo("Button", p, 180, 4, 58, 18, "Remove")
    btnX:setColor("#ff5555")
    btnX.onClick = function() table.remove(sGlobal.lista, i) redesenhar() refazerIcones() end

    local sw = campo("BotSwitch", p, 6, 30, 90, 20)
    sw:setOn(a.on == true)
    sw:setText(a.on and "Macro: ON" or "Macro: OFF")
    sw.onClick = function() a.on = not a.on redesenhar() refazerIcones() end
    local status = campo("Label", p, 102, 32, 130, 18, a.on and "Status: ativo" or "Status: desligado")
    status:setColor(a.on and "#55ff55" or "#aaaaaa")

    campo("Label", p, 6, 58, 110, 16, "PADRAO"):setTextAlign(AlignCenter or 3)
    campo("Label", p, 124, 58, 110, 16, "ESPECIAL"):setTextAlign(AlignCenter or 3)
    local itemP = campo("BotItem", p, 44, 74, 34, 34)
    local itemE = campo("BotItem", p, 162, 74, 34, 34)
    itemP:setItemId(tonumber(a.padrao) or 0)
    itemE:setItemId(tonumber(a.especial) or 0)
    itemP:setTooltip("Item PADRAO (arraste o item aqui).")
    itemE:setTooltip("Item ESPECIAL (arraste o item aqui).")
    -- so grava quando muda de verdade (evita laco ao redesenhar)
    itemP.onItemChange = function(w) if w:getItemId() ~= tonumber(a.padrao) then a.padrao = w:getItemId() end end
    itemE.onItemChange = function(w) if w:getItemId() ~= tonumber(a.especial) then a.especial = w:getItemId() refazerIcones() end end

    local btnSlot = campo("Button", p, 6, 116, 228, 22, "SLOT: " .. nomeSlot(a.slot))
    btnSlot.onClick = function()
        popSlot.grade:destroyChildren()
        for _, s in ipairs(SLOTS) do
            local b = g_ui.createWidget("Button", popSlot.grade)
            b:setHeight(26)
            b:setText(s.nome)
            b:setFont("verdana-11px-rounded")
            if s.id == a.slot then b:setColor("#55ff55") end
            b.onClick = function() a.slot = s.id popSlot:hide() redesenhar() end
        end
        popSlot.btnVoltar.onClick = function() popSlot:hide() end
        popSlot:show() popSlot:raise() popSlot:focus()
    end

    local btnStop = campo("Button", p, 6, 146, 110, 22, "STOP >= " .. (a.stop or 80) .. "%")
    btnStop:setTooltip("Com a barra igual ou acima disso, volta o item PADRAO.")
    btnStop.onClick = function() editar("STOP: voltar o padrao com % igual ou acima de", a.stop, function(n) a.stop = n redesenhar() end) end
    local btnInj = campo("Button", p, 124, 146, 110, 22, "INJETAR <= " .. (a.injetar or 50) .. "%")
    btnInj:setTooltip("Com a barra igual ou abaixo disso, coloca o item ESPECIAL.")
    btnInj.onClick = function() editar("INJETAR: colocar o especial com % igual ou abaixo de", a.injetar, function(n) a.injetar = n redesenhar() end) end

    local chkHP = campo("CheckBox", p, 10, 178, 50, 20, "HP")
    local chkMP = campo("CheckBox", p, 70, 178, 50, 20, "MP")
    local chkIcone = campo("CheckBox", p, 140, 178, 90, 20, "icone")
    chkIcone:setChecked(a.icone == true)
    chkIcone:setTooltip("Mostra um icone na tela com o nome desta troca. Clicar no icone liga/desliga.")
    chkIcone.onClick = function() a.icone = not a.icone refazerIcones() redesenhar() end
    chkHP:setChecked(a.barra ~= "MP")
    chkMP:setChecked(a.barra == "MP")
    chkHP.onClick = function() a.barra = "HP" redesenhar() end
    chkMP.onClick = function() a.barra = "MP" redesenhar() end
end

redesenhar = function()
    janela.lista:destroyChildren()
    for i, a in ipairs(sGlobal.lista) do caixa(i, a) end
end

janela.btnAdicionar.onClick = function()
    local n = #sGlobal.lista + 1
    table.insert(sGlobal.lista, { nome = "Equipe Item " .. n, on = false, padrao = 0, especial = 0, slot = 9,
        injetar = 50, stop = 80, barra = "HP" })
    redesenhar()
end
janela.btnFechar.onClick = function() janela:hide() end

redesenhar()
refazerIcones()

-- botao na aba Main do bot
setDefaultTab("Main")
UI.Button("Central de Equipar", function()
    if janela:isVisible() then
        janela:hide()
    else
        redesenhar()
        janela:show() janela:raise() janela:focus()
    end
end)

-- =============================================================================
-- [FUNCIONAMENTO] injetar <= X% coloca o especial; stop >= Y% volta o padrao; no meio nao mexe
-- =============================================================================
local function acharNasBags(id)
    if id <= 0 then return nil end
    for _, ct in pairs(g_game.getContainers()) do
        for _, item in ipairs(ct:getItems()) do
            if item:getId() == id then return item end
        end
    end
end

macro(100, function()
    if not g_game.isOnline() then return end
    for _, a in ipairs(sGlobal.lista) do
        if a.on then
            local pct = porcento(a.barra)
            local slot = tonumber(a.slot) or 9
            local noCorpo = slotDoCorpo(slot)
            local quer
            if pct <= (tonumber(a.injetar) or 50) then
                quer = tonumber(a.especial) or 0
            elseif pct >= (tonumber(a.stop) or 80) then
                quer = tonumber(a.padrao) or 0
            end
            if quer and quer > 0 and (not noCorpo or noCorpo:getId() ~= quer) then
                local item = acharNasBags(quer)
                if item then
                    g_game.move(item, { x = 65535, y = slot, z = 0 }, 1)
                    delay(150)
                    return
                end
            end
        end
    end
end)
