-- =============================================================================
-- CENTRAL DE BACKPACKS — BRINQUE SCRIPTS — VERSÃO MASTER COMPACTA 930x340 FINAL
-- =============================================================================
-- 📌 NOVIDADE: Botão [V] calibrado para chutar itens de sobra direto para o CHÃO.
-- 📌 VISUAL: Bloco de botões recuado 3 pixels para a esquerda.
-- =============================================================================

setDefaultTab("Tools")

-- Variável que define a chave onde as configurações do usuário serão salvas no boneco
local containersbrinque = "renameContainers_Brqq"

-- [INICIALIZAÇÃO DO STORAGE] Se o usuário nunca abriu o script, carrega os valores padrão
if not ElfBrinque then print(">>> [BAGS] nucleo ElfBrinque nao carregado (profiles.lua). Modulo cancelado.") return end

-- Config do modulo = parte do PERFIL ativo
local config = ElfBrinque.get("bags", {
    enabled = false,
    height = 340,
    purse = true,
    sort = false,
    forceOpen = false,
    lootBag = false,
    list = {
        { value = "Main Backpack", enabled = true, item = 9601, min = false, emptySlot = true, items = { 3081, 3048 } },
        { value = "Runes", enabled = true, item = 2866, min = true, emptySlot = false, items = { 3161, 3180 } },
        { value = "Money", enabled = true, item = 2871, min = true, emptySlot = false, items = { 3031, 3035, 3043 } },
        { value = "Purse", enabled = true, item = 23396, min = true, emptySlot = false, items = {} },
    }
})
-- Pausa global: o Casa (casa.lua) liga BRQ_BAGS_PAUSA enquanto escaneia/guarda itens.
-- Com a pausa ligada este modulo NAO abre, NAO move e NAO minimiza nada.
if BRQ_BAGS_PAUSA == nil then BRQ_BAGS_PAUSA = false end
local function pausado() return BRQ_BAGS_PAUSA == true end
config.height = 340 -- Força o travamento da altura da janela em 340 pixels para evitar distorções

-- =============================================================================
-- [LIMPEZA DE RESÍDUOS DA RAM]
-- =============================================================================
local rootWidget = g_ui.getRootWidget()
if rootWidget then
    local todosOsFilhosDoJogo = rootWidget:getChildren()
    for _, childWidget in ipairs(todosOsFilhosDoJogo) do
        local textoDaBarra = childWidget:getText() or ""
        if textoDaBarra == "Central de Backpacks & Organizador Master" or childWidget:getId() == "janelaBagsMestrePuraOriginalDeEstudo" then
            childWidget:destroy()
        end
    end
end

-- Usa a sua variável master de clique que resolveu o conflito dos botões!
if conttListWindow then pcall(function() conttListWindow:destroy() end) conttListWindow = nil end

-- =============================================================================
-- [ESTILOS VISUAIS DA INTERFACE]
-- =============================================================================
g_ui.loadUIFromString([[
BackpackName < Label
  background-color: alpha
  text-offset: 18 2
  focusable: true
  height: 17
  font: verdana-11px-rounded

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 15
    height: 15
    margin-top: 1
    margin-left: 3

  $focus:
    background-color: #00000055

  Button
    id: remove
    !text: tr('X')
    !tooltip: tr('Remover mochila da lista')
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 18
    width: 15
    height: 15

  Button
    id: emptySlotBtn
    !text: tr('V')
    !tooltip: tr('Manter sempre 1 slot vazio jogando o item excedente direto no CHAO')
    anchors.right: remove.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 2
    width: 15
    height: 15

  Button
    id: state
    !text: tr('M')
    !tooltip: tr('Abrir minimizada')
    anchors.right: emptySlotBtn.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 2
    width: 15
    height: 15

  Button
    id: openNext
    !text: tr('N')
    !tooltip: tr('Abrir proxima mochila de mesmo ID de forma sequencial')
    anchors.right: state.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 2
    width: 15
    height: 15

  Button
    id: refill
    !text: tr('R')
    !tooltip: tr('Proxima BP: quando sobrar so 1 bag dentro desta mochila, abre ela na mesma janela (bps de guerra)')
    anchors.right: openNext.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 2
    width: 15
    height: 15
]])

-- Design estrutural completo da janela principal de 930x340 dividida em 3 colunas
local designJanelaPuraOTUI = 
"MainWindow\n" ..
"  id: janelaBagsMestrePuraOriginalDeEstudo\n" ..
"  !text: tr('Central de Backpacks & Organizador Master')\n" ..
"  size: 930 340\n" ..
"  layout: anchor\n" ..
"  @onEscape: self:hide()\n" ..

-- COLUNA 1 (ESQUERDA): CAIXAS DE SELEÇÃO TÁTICAS
"  Label\n" ..
"    id: lblTituloEsquerda\n" ..
"    text: CONTROLE E MARCACOES:\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #55ffff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"    margin-left: 10\n" ..

"  CheckBox\n" ..
"    id: forceOpen\n" ..
"    text: Manter Mochila Principal Sempre Aberta\n" ..
"    tooltip: Forca a abertura reativa imediata das mochilas ativas em caso de lag ou bug.\n" ..
"    width: 280\n" ..
"    height: 15\n" ..
"    anchors.top: lblTituloEsquerda.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 15\n" ..
"    margin-left: 15\n" ..
"    font: verdana-11px-rounded\n" ..

"  CheckBox\n" ..
"    id: sort\n" ..
"    text: Organizar/Triagem Automatica de Itens\n" ..
"    tooltip: Habilita o motor de organizacao automatica de runas e supplies para as mochilas corretas.\n" ..
"    width: 280\n" ..
"    height: 15\n" ..
"    anchors.top: forceOpen.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 12\n" ..
"    margin-left: 15\n" ..
"    font: verdana-11px-rounded\n" ..

"  CheckBox\n" ..
"    id: purse\n" ..
"    text: Abrir Store Purse Automaticamente\n" ..
"    tooltip: Abre automaticamente a Charm/Store Purse pelas costas do inventario.\n" ..
"    width: 280\n" ..
"    height: 15\n" ..
"    anchors.top: sort.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 12\n" ..
"    margin-left: 15\n" ..
"    font: verdana-11px-rounded\n" ..

"  CheckBox\n" ..
"    id: lootBag\n" ..
"    text: Monitorar Abertura de Loot Bags\n" ..
"    tooltip: Habilita o rastreamento tatico de contêineres de drops.\n" ..
"    width: 280\n" ..
"    height: 15\n" ..
"    anchors.top: purse.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 12\n" ..
"    margin-left: 15\n" ..
"    font: verdana-11px-rounded\n" ..

"  VerticalSeparator\n" ..
"    id: sepEsquerdaCentro\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: separator.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-left: 310\n" ..
"    margin-top: 5\n" ..
"    margin-bottom: 5\n" ..

-- COLUNA 2 (CENTRO): LISTA DAS MOCHILAS
"  Label\n" ..
"    id: lblTituloCentro\n" ..
"    text: LISTA DE BACKPACKS ATIVAS:\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #55ff55\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: sepEsquerdaCentro.right\n" ..
"    margin-top: 5\n" ..
"    margin-left: 15\n" ..

"  TextList\n" ..
"    id: itemList\n" ..
"    anchors.top: lblTituloCentro.bottom\n" ..
"    anchors.left: sepEsquerdaCentro.right\n" ..
"    anchors.bottom: separator.top\n" ..
"    width: 270\n" ..
"    margin-top: 15\n" ..
"    margin-left: 10\n" ..
"    margin-bottom: 5\n" ..
"    vertical-scrollbar: itemListScrollBar\n" ..

"  VerticalScrollBar\n" ..
"    id: itemListScrollBar\n" ..
"    anchors.top: itemList.top\n" ..
"    anchors.bottom: itemList.bottom\n" ..
"    anchors.right: itemList.right\n" ..
"    step: 14\n" ..
"    pixels-scroll: true\n" ..

"  VerticalSeparator\n" ..
"    id: sepCentroDireita\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: separator.top\n" ..
"    anchors.left: itemList.right\n" ..
"    margin-left: 15\n" ..
"    margin-top: 5\n" ..
"    margin-bottom: 5\n" ..

-- COLUNA 3 (DIREITA): CADASTRO DE ID, NOME E GRADE ORIGINAL DE SUPPLIES
"  Label\n" ..
"    id: lblTituloDireita\n" ..
"    text: CONFIGURACAO E SUPPLIES DA BAG:\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffaa55\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: sepCentroDireita.right\n" ..
"    margin-top: 5\n" ..
"    margin-left: 15\n" ..

"  Label\n" ..
"    id: lblName\n" ..
"    anchors.left: sepCentroDireita.right\n" ..
"    anchors.top: lblTituloDireita.bottom\n" ..
"    width: 50\n" ..
"    text: Mochila:\n" ..
"    margin-left: 15\n" ..
"    margin-top: 15\n" ..
"    font: verdana-11px-rounded\n" ..

"  TextEdit\n" ..
"    id: contName\n" ..
"    anchors.left: lblName.right\n" ..
"    anchors.top: lblName.top\n" ..
"    width: 140\n" ..
"    font: verdana-11px-rounded\n" ..

"  Label\n" ..
"    id: lblCont\n" ..
"    anchors.left: lblName.left\n" ..
"    anchors.verticalCenter: contId.verticalCenter\n" ..
"    width: 50\n" ..
"    text: ID Bag:\n" ..
"    font: verdana-11px-rounded\n" ..

"  BotItem\n" ..
"    id: contId\n" ..
"    anchors.left: contName.left\n" ..
"    anchors.top: contName.bottom\n" ..
"    margin-top: 3\n" ..

"  BotContainer\n" ..
"    id: sortList\n" ..
"    anchors.left: lblName.left\n" ..
"    anchors.top: contId.bottom\n" ..
"    anchors.bottom: separator.top\n" ..
"    width: 240\n" ..
"    margin-bottom: 5\n" ..
"    margin-top: 25\n" ..

"  Label\n" ..
"    id: lblTextoGradeOriginal\n" ..
"    anchors.left: lblName.left\n" ..
"    anchors.bottom: sortList.top\n" ..
"    text: Grade de sub-itens vinculados:\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #aeaeae\n" ..
"    margin-bottom: 4\n" ..

"  Button\n" ..
"    id: addItem\n" ..
"    anchors.right: contName.right\n" ..
"    anchors.top: contName.bottom\n" ..
"    margin-top: 5\n" ..
"    text: Salvar\n" ..
"    width: 50\n" ..
"    font: verdana-11px-rounded\n" ..

-- RODAPÉ AJUSTADO NAS EXTREMIDADES
"  HorizontalSeparator\n" ..
"    id: separator\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: closeButton.top\n" ..
"    margin-bottom: 8\n" ..

"  Button\n" ..
"    id: closeButton\n" ..
"    !text: tr('Fechar')\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ff5555\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 140 24\n" ..
"    margin-left: 5\n" ..
"    margin-bottom: 5\n" ..
"  Button\n" ..
"    id: btnReopenAllNasPontas\n" ..
"    !text: tr('Reopen All')\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #55ff55\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 140 24\n" ..
"    margin-right: 5\n" ..
"    margin-bottom: 5\n"

local function findItemsInArray_Brq(t, tfind)
local tArray = {}
for x,v in pairs(t) do
if type(v) == "table" then
local aItem = t[x].item
local aEnabled = t[x].enabled
if aItem then
if tfind and aItem == tfind then
return x
elseif not tfind then
if aEnabled then
table.insert(tArray, aItem)
end
end
end
end
end
if not tfind then return tArray end
end

local openContainer_Brq = function(id)
local t = {getRight(), getLeft(), getAmmo()}
for i=1,#t do
local slotItem = t[i]
if slotItem and slotItem:getId() == id then
return g_game.open(slotItem, nil)
end
end
for i, container in pairs(g_game.getContainers()) do
for i, item in ipairs(container:getItems()) do
if item:isContainer() and item:getId() == id then
return g_game.open(item, nil)
end
end
end
end

local function reopenBackpacks_Brq()
local lstBPs_Brq = findItemsInArray_Brq(config.list)
for _, container in pairs(g_game.getContainers()) do g_game.close(container) end
local bpItem = getBack()
if bpItem ~= nil then
g_game.open(bpItem)
end
schedule(500, function()
local delay = 200
if config.purse then
local item = getPurse()
if item then use(item) end
end
for i=1,#lstBPs_Brq do
schedule(delay, function()
openContainer_Brq(lstBPs_Brq[i])
end)
delay = delay + 250
end
end)
end

local function openFromEmpty_Brq()
local containers = g_game.getContainers() or getContainers()
if #containers < 1 and containers == nil then
local bpItem = getBack()
if bpItem ~= nil then
g_game.open(bpItem)
end
end
end

-- =============================================================================
-- [MONTAGEM DO MOTOR DE EVENTOS DA INTERFACE (CONTTLISTWINDOW)]
-- =============================================================================
if rootWidget then
conttListWindow = setupUI(designJanelaPuraOTUI, rootWidget)
conttListWindow:hide()
conttListWindow.closeButton.onClick = function(widget)
conttListWindow:hide()
end
conttListWindow.btnReopenAllNasPontas.onClick = function(widget)
if pausado() then return end
reopenBackpacks_Brq()
end
conttListWindow.purse.onClick = function(widget)
config.purse = not config.purse
conttListWindow.purse:setChecked(config.purse)
end
conttListWindow.purse:setChecked(config.purse)
conttListWindow.sort.onClick = function(widget)
config.sort = not config.sort
conttListWindow.sort:setChecked(config.sort)
end
conttListWindow.sort:setChecked(config.sort)
conttListWindow.forceOpen.onClick = function(widget)
config.forceOpen = not config.forceOpen
conttListWindow.forceOpen:setChecked(config.forceOpen)
end
conttListWindow.forceOpen:setChecked(config.forceOpen)
if conttListWindow.lootBag then
conttListWindow.lootBag.onClick = function(widget)
config.lootBag = not config.lootBag
conttListWindow.lootBag:setChecked(config.lootBag)
end
conttListWindow.lootBag:setChecked(config.lootBag)
end
local function refreshSortList_Brq(k, t)
t = t or {}
if conttListWindow and conttListWindow.sortList then
UI.Container(function()
if conttListWindow and conttListWindow.sortList then
t = conttListWindow.sortList:getItems()
if config.list[k] then config.list[k].items = t end
end
end, true, nil, conttListWindow.sortList)
if conttListWindow and conttListWindow.sortList and conttListWindow.sortList.setItems then
conttListWindow.sortList:setItems(t)
end
end
end
local refreshContNames_Brq = function(tFocus)
local storageVal = config.list
if storageVal and #storageVal > 0 then
for i, child in pairs(conttListWindow.itemList:getChildren()) do
child:destroy()
end
for k, entry in pairs(storageVal) do
local label = g_ui.createWidget("BackpackName", conttListWindow.itemList)
label.onMouseRelease = function()
conttListWindow.contId:setItemId(entry.item)
conttListWindow.contName:setText(entry.value)
if not entry.items then entry.items = {} end
if conttListWindow.sortList and conttListWindow.sortList.setItems then
conttListWindow.sortList:setItems(entry.items)
end
refreshSortList_Brq(k, entry.items)
end
label.enabled.onClick = function(widget)
entry.enabled = not entry.enabled
label.enabled:setChecked(entry.enabled)
label.enabled:setImageColor(entry.enabled and '#00FF00' or '#FF0000')
end
label.remove.onClick = function(widget)
table.removevalue(config.list, entry)
label:destroy()
refreshContNames_Brq()
end
label.state:setChecked(entry.min)
label.state.onClick = function(widget)
entry.min = not entry.min
label.state:setChecked(entry.min)
label.state:setColor(entry.min and '#00FF00' or '#FF0000')
end
label.openNext.onClick = function(widget)
entry.openNext = not entry.openNext
label.openNext:setChecked(entry.openNext)
label.openNext:setColor(entry.openNext and '#00FF00' or '#FF0000')
end
if not entry.emptySlot then entry.emptySlot = false end
label.refill.onClick = function(widget)
entry.refill = not entry.refill
label.refill:setChecked(entry.refill)
label.refill:setColor(entry.refill and '#00FF00' or '#FF0000')
end
label.refill:setColor(entry.refill and '#00FF00' or '#FF0000')
label.emptySlotBtn:setChecked(entry.emptySlot)
label.emptySlotBtn:setColor(entry.emptySlot and '#00FF00' or '#FF0000')
label.emptySlotBtn.onClick = function(widget)
entry.emptySlot = not entry.emptySlot
label.emptySlotBtn:setChecked(entry.emptySlot)
label.emptySlotBtn:setColor(entry.emptySlot and '#00FF00' or '#FF0000')
end
label:setText(entry.value .. " (ID: " .. entry.item .. ")")
label.enabled:setChecked(entry.enabled)
label.enabled:setImageColor(entry.enabled and '#00FF00' or '#FF0000')
label.state:setColor(entry.min and '#00FF00' or '#FF0000')
label.openNext:setColor(entry.openNext and '#00FF00' or '#FF0000')
if tFocus and entry.item == tFocus then tFocus = label end
end
if tFocus then conttListWindow.itemList:focusChild(tFocus) end
end
end
conttListWindow.addItem.onClick = function(widget)
local id = conttListWindow.contId:getItemId()
local trigger = conttListWindow.contName:getText()
if id > 100 and trigger:len() > 0 then
local ifind = findItemsInArray_Brq(config.list, id)
if ifind then
config.list[ifind] = { item = id, value = trigger, enabled = config.list[ifind].enabled, min = config.list[ifind].min, emptySlot = config.list[ifind].emptySlot or false, openNext = config.list[ifind].openNext, refill = config.list[ifind].refill, items = config.list[ifind].items}
else
table.insert(config.list, { item = id, value = trigger, enabled = true, min = false, emptySlot = false, items = {} })
end
conttListWindow.contId:setItemId(0)
conttListWindow.contName:setText('')
refreshContNames_Brq(id)
else
conttListWindow.contId:setItemId(0)
conttListWindow.contId:setImageColor('red')
conttListWindow.contName:setImageColor('red')
end
end
refreshContNames_Brq()
-- Quando o perfil troca, a janela se redesenha com os valores novos
ElfBrinque.aoTrocar("bags", function()
config.height = 340
conttListWindow.purse:setChecked(config.purse == true)
conttListWindow.sort:setChecked(config.sort == true)
conttListWindow.forceOpen:setChecked(config.forceOpen == true)
if conttListWindow.lootBag then conttListWindow.lootBag:setChecked(config.lootBag == true) end
refreshContNames_Brq()
end)
end
if config.forceOpen then openFromEmpty_Brq() end
-- =============================================================================
-- [GATILHOS MECÂNICOS DO MUNDO DO JOGO (SEGUNDO PLANO)]
-- =============================================================================
onContainerOpen(function(container, previousContainer)
if pausado() then return end
if not container.window then return end
local containerWindow = container.window
if not previousContainer then
containerWindow:setContentHeight(34)
end
local storageVal = config.list
if storageVal and #storageVal > 0 then
for _, entry in pairs(storageVal) do
if entry.enabled and string.find(container:getContainerItem():getId(), entry.item) then
if entry.min then
containerWindow:minimize()
end
if entry.openNext then
for i, item in ipairs(container:getItems()) do
if item:getId() == entry.item then
local time = #storageVal * 250
schedule(time, function()
time = time + 250
g_game.open(item)
end)
end
end
end
end
end
end
end)
local function moveItem_BagsBrq(item, destination)
return g_game.move(item, destination:getSlotPosition(destination:getItemsCount()), item:getCount())
end
local function properTable_BagsBrq(t)
local r = {}
for _, entry in pairs(t) do
if type(entry) == "number" then
table.insert(r, entry)
else
table.insert(r, entry.id)
end
end
return r
end
-- =============================================================================
-- [PROXIMA BP] botao R (logica das bps de guerra)
-- =============================================================================
local proxBp_Brq = {}
local function ehDaEntrada_Brq(ct, entry)
local ok, r = pcall(function()
local ci = ct:getContainerItem()
if ci and ci:getId() == entry.item then return true end
local nome = tostring(entry.value or ""):lower()
if nome ~= "" and ct:getName():lower():find(nome, 1, true) then return true end
return false
end)
return ok and r
end
macro(500, function()
if pausado() then return end
for _, entry in pairs(config.list) do
if entry.enabled and entry.refill then
for _, ct in pairs(getContainers()) do
if ehDaEntrada_Brq(ct, entry) then
local itens = ct:getItems()
local alvos = properTable_BagsBrq(entry.items or {})
local proxima = nil
if #alvos > 0 then
local tem = false
for _, it in ipairs(itens) do
if table.find(alvos, it:getId()) then tem = true break end
end
if not tem then
for _, it in ipairs(itens) do
local ehC = false
pcall(function() ehC = it:isContainer() end)
if ehC and (not proxima or it:getId() == entry.item) then proxima = it end
end
end
elseif #itens == 1 then
local ehC = false
pcall(function() ehC = itens[1]:isContainer() end)
if ehC then proxima = itens[1] end
end
if proxima then
local k = ct:getId() .. ":" .. proxima:getId()
if not proxBp_Brq[k] or now - proxBp_Brq[k] > 1500 then
proxBp_Brq[k] = now
print(">>> [BAGS] R: abrindo a proxima bp (id " .. proxima:getId() .. ") na mesma janela de '" .. tostring(entry.value) .. "'")
g_game.open(proxima, ct)
return
end
end
end
end
end
end
end)

macro(1000, function()
if pausado() then return end
if not config.forceOpen then return end
local bpItem = getBack()
local bp = getContainer(0)
if not bp and bpItem ~= nil then
g_game.open(bpItem)
schedule(350, function()
local delayAcumulado = 10
for _, entry in pairs(config.list) do
if entry.enabled then
schedule(delayAcumulado, function() openContainer_Brq(entry.item) end)
delayAcumulado = delayAcumulado + 250
end
end
end)
end
end)
macro(8000, function()
if pausado() then return end
if not config.forceOpen then return end
local containers = g_game.getContainers() or getContainers()
if #containers < 1 and containers == nil then
openFromEmpty_Brq()
end
end)
-- Motor principal de triagem e sub-bags originais
local mainLoop_BagsBrq = macro(150, function(macroObjeto)
if pausado() then macroObjeto:setOff() return end
if not config.sort and not config.purse then return end
local storageVal = config.list
for indexA, entryA in pairs(storageVal) do
if entryA.enabled and entryA.emptySlot then
local currentContainer = getContainerByItem(entryA.item)
if currentContainer and containerIsFull(currentContainer) then
local itensMochila = currentContainer:getItems()
local permitidos = properTable_BagsBrq(entryA.items or {})
local ultimoItem = nil
for iItem = #itensMochila, 1, -1 do
if table.find(permitidos, itensMochila[iItem]:getId()) then
ultimoItem = itensMochila[iItem]
break
end
end
if ultimoItem then
local posicaoDoBoneco = pos()
if posicaoDoBoneco then
g_game.move(ultimoItem, posicaoDoBoneco, ultimoItem:getCount())
delay(100)
return
end
end
end
end
end
for _, entry in pairs(storageVal) do
local dId = entry.item
local items = properTable_BagsBrq(entry.items)
if config.sort then
for _, container in pairs(getContainers()) do
local cName = container:getName():lower()
if not cName:find("depot") and not cName:find("quiver") then
local cId = container:getContainerItem():getId()
for __, item in ipairs(container:getItems()) do
local id = item:getId()
if table.find(items, id) and cId ~= dId then
local destination = getContainerByItem(dId, true)
if destination and not containerIsFull(destination) then
return moveItem_BagsBrq(item, destination)
end
end
end
end
end
end
if config.forceOpen and entry.enabled then
local container = getContainerByItem(dId)
if not container then
local cItem = findItem(dId)
if cItem then return g_game.open(cItem) end
end
end
end
if config.purse and config.forceOpen and not getContainerByItem(23396) then
return use(getPurse())
end
if config.lootBag and config.forceOpen and not getContainerByItem(23721) then
if findItem(23721) then
g_game.open(findItem(23721), getContainerByItem(23396))
else
return use(getPurse())
end
end
macroObjeto:setOff()
end)
onContainerOpen(function(container, previousContainer) mainLoop_BagsBrq:setOn() end)
onAddItem(function(container, slot, item, oldItem) mainLoop_BagsBrq:setOn() end)
onPlayerInventoryChange(function(slot, item, oldItem) mainLoop_BagsBrq:setOn() end)
onContainerClose(function(container) if not container.lootContainer then mainLoop_BagsBrq:setOn() end end)

-- =============================================================================
-- CONSTRUTOR DO BOTÃO NA ABA LATERAL "hp"
-- =============================================================================
local uiBotaoBags = nil
local function renderizarBotaoBagsMenuLateral()
    if uiBotaoBags then uiBotaoBags:destroy() end
    
    -- Injetado na aba HP (mesma lógica do botão de Equipar)
    local abaAlvo = getTab("hp") or getTab("healing")
    if not abaAlvo then return end
    
    uiBotaoBags = setupUI([[
Panel
  height: 20
  Button
    id: btnMenuBagsLivre
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Backpacks
    font: verdana-11px-rounded
  ]], abaAlvo)

    uiBotaoBags.btnMenuBagsLivre.onClick = function()
        if conttListWindow:isVisible() then 
            conttListWindow:hide() 
        else
            local painelBot = g_ui.getRootWidget():getChildById("botPanel")
            if painelBot then
                local posMestre = painelBot:getPosition()
                conttListWindow:setPosition({x = posMestre.x + 300, y = posMestre.y})
            end
            conttListWindow:show() 
            conttListWindow:raise() 
            conttListWindow:focus()
        end
    end
end

schedule(1000, renderizarBotaoBagsMenuLateral)
