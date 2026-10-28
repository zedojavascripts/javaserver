-- =============================================================================
-- CENTRAL DE BACKPACKS - BRINQUE SCRIPTS (versao avulsa, sem o ElfBrinque)
-- Funciona sozinha em qualquer vBot 4.x: coloque este arquivo na pasta da config
-- do bot (ou cole no Ingame script editor). Abre pelo botao "Central de Backpacks"
-- na aba Main. A configuracao fica no storage do bot.
--
-- Em cada mochila da lista:
--   [caixa] liga/desliga   R = proxima bp de guerra   N = abre a proxima de mesmo ID
--   M = abre minimizada    V = mochila cheia: joga o excedente da grade no chao
--   X = remove da lista
-- =============================================================================
setDefaultTab("hp")
local TITULO = "Central de Backpacks - Brinque Scripts"
local ID_JANELA = "janelaBagsBrinqueAvulsa"
local ID_PURSE, ID_LOOTBAG = 23396, 23721

-- [CONFIG] valores padrao na primeira vez
if type(storage.bagsBrinque) ~= "table" then
    storage.bagsBrinque = {
        purse = true,
        sort = false,
        forceOpen = false,
        lootBag = false,
        list = {
            { value = "Main Backpack", enabled = true, item = 9601, min = false, emptySlot = true, items = { 3081, 3048 } },
            { value = "Runes", enabled = true, item = 2866, min = true, emptySlot = false, items = { 3161, 3180 } },
            { value = "Money", enabled = true, item = 2871, min = true, emptySlot = false, items = { 3031, 3035, 3043 } },
            { value = "Purse", enabled = true, item = ID_PURSE, min = true, emptySlot = false, items = {} },
        }
    }
end
local config = storage.bagsBrinque
if type(config.list) ~= "table" then config.list = {} end

-- Se outro script ligar BRQ_BAGS_PAUSA (ex.: o Casa do ElfBrinque), nada e mexido
local function pausado() return BRQ_BAGS_PAUSA == true end

local raiz = g_ui.getRootWidget()

-- =============================================================================
-- [FUNCOES DO vBot] Se o bot ja tem (vBot 4.x), usa as dele. Se nao tem (config
-- sem a biblioteca do vBot), usa estas, feitas so com o OTClient.
-- =============================================================================
local function slotInventario(slot)
    local p = g_game.getLocalPlayer()
    return p and p:getInventoryItem(slot) or nil
end

local getContainers = getContainers or function() return g_game.getContainers() or {} end
local getContainer = getContainer or function(i) return g_game.getContainer(i) end
local getBack = getBack or function() return slotInventario(InventorySlotBack or 3) end
local getRight = getRight or function() return slotInventario(InventorySlotRight or 5) end
local getLeft = getLeft or function() return slotInventario(InventorySlotLeft or 6) end
local getAmmo = getAmmo or function() return slotInventario(InventorySlotAmmo or 10) end
local getPurse = getPurse or function() return slotInventario(InventorySlotPurse or 11) end

local containerIsFull = containerIsFull or function(ct)
    return ct and ct:getItemsCount() >= ct:getCapacity()
end

-- mochila aberta pelo ID da bag (comEspaco = so se nao estiver cheia)
local getContainerByItem = getContainerByItem or function(id, comEspaco)
    for _, ct in pairs(g_game.getContainers()) do
        local ci = ct:getContainerItem()
        if ci and ci:getId() == id and (not comEspaco or not containerIsFull(ct)) then return ct end
    end
end

-- item pelo ID em qualquer mochila aberta
local findItem = findItem or function(id)
    for _, ct in pairs(g_game.getContainers()) do
        for _, item in ipairs(ct:getItems()) do
            if item:getId() == id then return item end
        end
    end
end

local use = use or function(item) if item then g_game.use(item) end end

-- getContainers() devolve tabela por id: conta com pairs
local function contarContainers()
    local n = 0
    for _ in pairs(g_game.getContainers() or {}) do n = n + 1 end
    return n
end

local function idsDaGrade(t)
    local r = {}
    for _, e in pairs(t or {}) do
        if type(e) == "number" then r[#r + 1] = e
        elseif type(e) == "table" and e.id then r[#r + 1] = e.id end
    end
    return r
end

local function indiceDaBag(id)
    for i, e in ipairs(config.list) do
        if e.item == id then return i end
    end
end

local function abrirPurse()
    local p = getPurse()
    if p then use(p) end
end

-- abre a bag de ID "id" que estiver nas maos/municao ou dentro de outra mochila aberta
local function abrirBagPorId(id)
    for _, slot in ipairs({ getRight(), getLeft(), getAmmo() }) do
        if slot and slot:getId() == id then return g_game.open(slot, nil) end
    end
    for _, ct in pairs(g_game.getContainers()) do
        for _, item in ipairs(ct:getItems()) do
            if item:isContainer() and item:getId() == id then return g_game.open(item, nil) end
        end
    end
end

-- fecha tudo e abre de novo: mochila principal, purse e as bags ligadas da lista
local function reabrirTudo()
    for _, ct in pairs(g_game.getContainers()) do g_game.close(ct) end
    local bp = getBack()
    if bp then g_game.open(bp) end
    schedule(500, function()
        if config.purse then abrirPurse() end
        local espera = 200
        for _, e in ipairs(config.list) do
            if e.enabled then
                local id = e.item
                schedule(espera, function() abrirBagPorId(id) end)
                espera = espera + 250
            end
        end
    end)
end

local function abrirSeNadaAberto()
    if contarContainers() > 0 then return end
    local bp = getBack()
    if bp then g_game.open(bp) end
end

-- =============================================================================
-- [JANELA]
-- =============================================================================
for _, filho in ipairs(raiz:getChildren()) do
    if filho:getId() == ID_JANELA then pcall(function() filho:destroy() end) end
end

g_ui.loadUIFromString([[
BagsBrinqueLinha < Label
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
    !tooltip: tr('Mochila cheia: joga no chao o excedente dos itens da grade (sempre sobra 1 slot)')
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
    !tooltip: tr('Abre tambem as mochilas de mesmo ID que estiverem dentro dela')
    anchors.right: state.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 2
    width: 15
    height: 15

  Button
    id: refill
    !text: tr('R')
    !tooltip: tr('Proxima BP: quando acabarem os itens, abre a bag de dentro na mesma janela (bps de guerra)')
    anchors.right: openNext.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 2
    width: 15
    height: 15
]])

local janela = setupUI([[
MainWindow
  id: janelaBagsBrinqueAvulsa
  !text: tr('Central de Backpacks - Brinque Scripts')
  size: 760 330
  @onEscape: self:hide()

  Label
    id: lblEsquerda
    text: OPCOES
    color: #55ffff
    anchors.top: parent.top
    anchors.left: parent.left
    width: 200
    height: 16

  CheckBox
    id: forceOpen
    text: Manter as mochilas abertas
    !tooltip: tr('Se fechar tudo (lag, morte, relog), abre de novo a principal e as da lista')
    anchors.top: lblEsquerda.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 210

  CheckBox
    id: sort
    text: Organizar itens nas mochilas
    !tooltip: tr('Move os itens da grade de cada mochila para ela')
    anchors.top: forceOpen.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 210

  CheckBox
    id: purse
    text: Abrir a Store Purse
    anchors.top: sort.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 210

  CheckBox
    id: lootBag
    text: Abrir a Loot Bag (dentro da purse)
    anchors.top: purse.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 210

  Label
    id: lblAjuda
    text: Clique numa mochila da lista para editar o nome e a grade. Passe o mouse em R N M V X para ver o que cada um faz.
    anchors.top: lootBag.bottom
    anchors.left: parent.left
    margin-top: 16
    width: 210
    height: 60
    text-wrap: true
    color: #8f8f8f

  VerticalSeparator
    id: sep1
    anchors.top: parent.top
    anchors.bottom: separator.top
    anchors.left: parent.left
    margin-left: 220
    margin-bottom: 5

  Label
    id: lblCentro
    text: MOCHILAS
    color: #55ff55
    anchors.top: parent.top
    anchors.left: sep1.right
    margin-left: 10
    width: 200
    height: 16

  TextList
    id: itemList
    anchors.top: lblCentro.bottom
    anchors.left: sep1.right
    anchors.bottom: separator.top
    width: 260
    margin-top: 10
    margin-left: 10
    margin-bottom: 5
    vertical-scrollbar: itemListScrollBar

  VerticalScrollBar
    id: itemListScrollBar
    anchors.top: itemList.top
    anchors.bottom: itemList.bottom
    anchors.right: itemList.right
    step: 14
    pixels-scroll: true

  VerticalSeparator
    id: sep2
    anchors.top: parent.top
    anchors.bottom: separator.top
    anchors.left: itemList.right
    margin-left: 10
    margin-bottom: 5

  Label
    id: lblDireita
    text: CADASTRAR / EDITAR MOCHILA
    color: #ffaa55
    anchors.top: parent.top
    anchors.left: sep2.right
    margin-left: 10
    width: 220
    height: 16

  Label
    id: lblName
    text: Nome:
    anchors.top: lblDireita.bottom
    anchors.left: sep2.right
    margin-top: 12
    margin-left: 10
    width: 45
    height: 20

  TextEdit
    id: contName
    anchors.left: lblName.right
    anchors.verticalCenter: lblName.verticalCenter
    width: 150
    height: 20

  Label
    id: lblCont
    text: ID bag:
    anchors.left: lblName.left
    anchors.top: lblName.bottom
    margin-top: 16
    width: 45
    height: 20

  BotItem
    id: contId
    anchors.left: contName.left
    anchors.verticalCenter: lblCont.verticalCenter

  Button
    id: addItem
    text: Salvar
    anchors.right: contName.right
    anchors.verticalCenter: lblCont.verticalCenter
    width: 60
    height: 20

  Label
    id: lblGrade
    text: Itens que ficam nesta mochila:
    anchors.left: lblName.left
    anchors.top: lblCont.bottom
    margin-top: 18
    width: 220
    height: 16
    color: #aeaeae

  BotContainer
    id: sortList
    anchors.left: lblName.left
    anchors.top: lblGrade.bottom
    anchors.bottom: separator.top
    width: 230
    margin-top: 4
    margin-bottom: 5

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    !text: tr('Fechar')
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    size: 110 22

  Button
    id: btnReabrir
    !text: tr('Reabrir tudo')
    !tooltip: tr('Fecha todas as mochilas e abre de novo a principal, a purse e as da lista')
    color: #55ff55
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 110 22
]], raiz)
janela:hide()

local function cor(ligado) return ligado and "#00FF00" or "#FF0000" end

local function ligarCaixa(id, chave)
    local chk = janela[id]
    chk:setChecked(config[chave] == true)
    chk.onCheckChange = function(_, v) config[chave] = v == true end
end
ligarCaixa("forceOpen", "forceOpen")
ligarCaixa("sort", "sort")
ligarCaixa("purse", "purse")
ligarCaixa("lootBag", "lootBag")

janela.closeButton.onClick = function() janela:hide() end
janela.btnReabrir.onClick = function() if not pausado() then reabrirTudo() end end

-- grade da mochila selecionada: o BotContainer avisa quando muda
local function mostrarGrade(entrada)
    entrada.items = entrada.items or {}
    UI.Container(function()
        entrada.items = janela.sortList:getItems()
    end, true, nil, janela.sortList)
    janela.sortList:setItems(entrada.items)
end

local desenharLista
desenharLista = function(focarId)
    janela.itemList:destroyChildren()
    local focar
    for _, e in ipairs(config.list) do
        local linha = g_ui.createWidget("BagsBrinqueLinha", janela.itemList)
        linha:setText(e.value .. " (ID: " .. e.item .. ")")

        linha.onMouseRelease = function()
            janela.contId:setItemId(e.item)
            janela.contName:setText(e.value)
            mostrarGrade(e)
        end

        linha.enabled:setChecked(e.enabled == true)
        linha.enabled:setImageColor(cor(e.enabled))
        linha.enabled.onClick = function()
            e.enabled = not e.enabled
            linha.enabled:setChecked(e.enabled)
            linha.enabled:setImageColor(cor(e.enabled))
        end

        -- botoes R N M V: cada um liga/desliga um campo da mochila
        for _, b in ipairs({ { "refill", "refill" }, { "openNext", "openNext" }, { "state", "min" }, { "emptySlotBtn", "emptySlot" } }) do
            local botao, campo = linha[b[1]], b[2]
            botao:setColor(cor(e[campo]))
            botao.onClick = function()
                e[campo] = not e[campo]
                botao:setColor(cor(e[campo]))
            end
        end

        linha.remove.onClick = function()
            table.removevalue(config.list, e)
            desenharLista()
        end

        if focarId and e.item == focarId then focar = linha end
    end
    if focar then janela.itemList:focusChild(focar) end
end

janela.addItem.onClick = function()
    local id = janela.contId:getItemId()
    local nome = janela.contName:getText():trim()
    if id <= 100 or nome == "" then
        janela.contId:setImageColor("red")
        janela.contName:setImageColor("red")
        return
    end
    janela.contId:setImageColor("white")
    janela.contName:setImageColor("white")
    local i = indiceDaBag(id)
    if i then
        config.list[i].value = nome -- mantem as opcoes e a grade
    else
        table.insert(config.list, { item = id, value = nome, enabled = true, min = false, emptySlot = false, items = {} })
    end
    janela.contId:setItemId(0)
    janela.contName:setText("")
    desenharLista(id)
end

desenharLista()

-- botao na aba Main do bot
setDefaultTab("Main")
UI.Button("Central de Backpacks", function()
    if janela:isVisible() then
        janela:hide()
    else
        janela:show()
        janela:raise()
        janela:focus()
    end
end)

if config.forceOpen then abrirSeNadaAberto() end

-- =============================================================================
-- [FUNCIONAMENTO]
-- =============================================================================
-- mochila abriu: minimiza (M) e abre as de mesmo ID que estao dentro (N), uma de cada vez
onContainerOpen(function(container, anterior)
    if pausado() or not container.window then return end
    if not anterior then container.window:setContentHeight(34) end
    local idBag = container:getContainerItem():getId()
    for _, e in ipairs(config.list) do
        if e.enabled and idBag == e.item then
            if e.min then container.window:minimize() end
            if e.openNext then
                local espera = 250
                for _, item in ipairs(container:getItems()) do
                    if item:getId() == e.item then
                        schedule(espera, function() g_game.open(item) end)
                        espera = espera + 250
                    end
                end
            end
        end
    end
end)

-- R (proxima bp de guerra): acabaram os itens da grade -> abre a bag de dentro na mesma janela
local ultimaProxima = {}
local function ehDaEntrada(ct, e)
    local ok, r = pcall(function()
        local ci = ct:getContainerItem()
        if ci and ci:getId() == e.item then return true end
        local nome = tostring(e.value or ""):lower()
        return nome ~= "" and ct:getName():lower():find(nome, 1, true) ~= nil
    end)
    return ok and r
end

macro(500, function()
    if pausado() then return end
    for _, e in ipairs(config.list) do
        if e.enabled and e.refill then
            for _, ct in pairs(getContainers()) do
                if ehDaEntrada(ct, e) then
                    local itens = ct:getItems()
                    local grade = idsDaGrade(e.items)
                    local proxima
                    if #grade > 0 then
                        local temDaGrade = false
                        for _, it in ipairs(itens) do
                            if table.find(grade, it:getId()) then temDaGrade = true break end
                        end
                        if not temDaGrade then
                            for _, it in ipairs(itens) do
                                if it:isContainer() and (not proxima or it:getId() == e.item) then proxima = it end
                            end
                        end
                    elseif #itens == 1 and itens[1]:isContainer() then
                        proxima = itens[1]
                    end
                    if proxima then
                        local k = ct:getId() .. ":" .. proxima:getId()
                        if not ultimaProxima[k] or now - ultimaProxima[k] > 1500 then
                            ultimaProxima[k] = now
                            g_game.open(proxima, ct)
                            return
                        end
                    end
                end
            end
        end
    end
end)

-- manter abertas: se nao tem nada aberto, abre a principal e depois as da lista
macro(1000, function()
    if pausado() or not config.forceOpen then return end
    local bp = getBack()
    if getContainer(0) or not bp then return end
    g_game.open(bp)
    schedule(350, function()
        local espera = 10
        for _, e in ipairs(config.list) do
            if e.enabled then
                local id = e.item
                schedule(espera, function() abrirBagPorId(id) end)
                espera = espera + 250
            end
        end
    end)
end)

-- organizar, slot vazio (V), reabrir bags e purse. Liga sozinho quando algo muda
-- nas mochilas e desliga quando nao tem mais nada para fazer (nao pesa parado).
local principal = macro(150, function(m)
    if pausado() then m:setOff() return end

    -- V: mochila cheia -> joga no chao o ultimo item da grade dela
    for _, e in ipairs(config.list) do
        if e.enabled and e.emptySlot then
            local ct = getContainerByItem(e.item)
            if ct and containerIsFull(ct) then
                local grade = idsDaGrade(e.items)
                local itens = ct:getItems()
                for i = #itens, 1, -1 do
                    if table.find(grade, itens[i]:getId()) then
                        local p = pos()
                        if p then
                            g_game.move(itens[i], p, itens[i]:getCount())
                            delay(100)
                            return
                        end
                        break
                    end
                end
            end
        end
    end

    for _, e in ipairs(config.list) do
        local destinoId = e.item
        if config.sort and e.enabled then
            local grade = idsDaGrade(e.items)
            for _, ct in pairs(getContainers()) do
                local nome = ct:getName():lower()
                if not nome:find("depot") and not nome:find("quiver") and ct:getContainerItem():getId() ~= destinoId then
                    for _, item in ipairs(ct:getItems()) do
                        if table.find(grade, item:getId()) then
                            local destino = getContainerByItem(destinoId, true)
                            if destino and not containerIsFull(destino) then
                                return g_game.move(item, destino:getSlotPosition(destino:getItemsCount()), item:getCount())
                            end
                        end
                    end
                end
            end
        end
        if config.forceOpen and e.enabled and not getContainerByItem(destinoId) then
            local bag = findItem(destinoId)
            if bag then return g_game.open(bag) end
        end
    end

    if config.purse and config.forceOpen and not getContainerByItem(ID_PURSE) and getPurse() then
        return abrirPurse()
    end
    if config.lootBag and config.forceOpen and not getContainerByItem(ID_LOOTBAG) then
        local loot = findItem(ID_LOOTBAG)
        if loot then
            g_game.open(loot, getContainerByItem(ID_PURSE))
        elseif getPurse() then
            return abrirPurse()
        end
    end
    m:setOff()
end)

onContainerOpen(function() principal:setOn() end)
onAddItem(function() principal:setOn() end)
onPlayerInventoryChange(function() principal:setOn() end)
onContainerClose(function(container) if not container.lootContainer then principal:setOn() end end)
