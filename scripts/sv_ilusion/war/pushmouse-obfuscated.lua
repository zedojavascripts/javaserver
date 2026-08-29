-- =============================================================================
-- [SOULE PUSH SYSTEMS V5.1] - AUTO PUSH MOUSE ISOLADO: PARTE 1 DE 4 (FIX CONFLICT)
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()
-- 🧠 FIX EXCLUSIVO: Nova chave de storage única para nunca trombar com a versão antiga
local STORAGE_MOUSE_ISOLADO = "push_mouse_isolado_v2_storage"

if not storage[STORAGE_MOUSE_ISOLADO] then
  storage[STORAGE_MOUSE_ISOLADO] = {
    enabled = false,
    pushDelay = 200,       
    maxDistance = 7,
    toggleKey = "F8",      
    cleanLixo = true,
    autoFirePee = true,
    runeId = 3188,         
    destroyRuneId = 3148   
  }
end

-- Sanitização forçada contra nils
if storage[STORAGE_MOUSE_ISOLADO].enabled == nil then storage[STORAGE_MOUSE_ISOLADO].enabled = false end
if not storage[STORAGE_MOUSE_ISOLADO].pushDelay then storage[STORAGE_MOUSE_ISOLADO].pushDelay = 200 end
if not storage[STORAGE_MOUSE_ISOLADO].maxDistance then storage[STORAGE_MOUSE_ISOLADO].maxDistance = 7 end
if not storage[STORAGE_MOUSE_ISOLADO].toggleKey then storage[STORAGE_MOUSE_ISOLADO].toggleKey = "F8" end
if not storage[STORAGE_MOUSE_ISOLADO].runeId then storage[STORAGE_MOUSE_ISOLADO].runeId = 3188 end
if not storage[STORAGE_MOUSE_ISOLADO].destroyRuneId then storage[STORAGE_MOUSE_ISOLADO].destroyRuneId = 3148 end
if storage[STORAGE_MOUSE_ISOLADO].cleanLixo == nil then storage[STORAGE_MOUSE_ISOLADO].cleanLixo = true end
if storage[STORAGE_MOUSE_ISOLADO].autoFirePee == nil then storage[STORAGE_MOUSE_ISOLADO].autoFirePee = true end

-- 🧠 FIX EXCLUSIVO: Variável local restrita para não clonar dados na RAM
local configMouseIsolado = storage[STORAGE_MOUSE_ISOLADO]

-- 🧠 FIX EXCLUSIVO: Modificado IDs de todos os elementos OTUI para isolar o layout
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaAutoPushMousePuro_IsoladoV2\n" ..
"  !text: tr('Auto Push Mouse PRO v2 - Isolado')\n" ..
"  size: 500 240\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblColunaEsquerda\n" ..
"    text: == TEMPOS E ATALHOS ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnDelayMouse\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnDistMouse\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnToggleKey\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblColunaDireita\n" ..
"    text: == ACOES TATICAS ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnRuneIdSlot\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 10\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnDestroyIdSlot\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 8\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  BotSwitch\n" ..
"    id: swLixoMouse\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 10\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 20\n" ..
"  BotSwitch\n" ..
"    id: swFireMouse\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 6\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 20\n" ..
"  VerticalSeparator\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"  HorizontalSeparator\n" ..
"    id: separator\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: closeBtn.top\n" ..
"    margin-bottom: 8\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-right: 4\n" ..
"    height: 22\n"
-- =============================================================================
-- [SOULE PUSH SYSTEMS V5.1] - AUTO PUSH MOUSE ISOLADO: PARTE 2 DE 4 (PANEL & UI)
-- =============================================================================

local designPopUpOTUI = "MainWindow\n" ..
"  id: janelaConfigChasePop_IsoladoV2\n" ..
"  !text: tr('Editar Campo Isolado')\n" ..
"  size: 260 130\n" ..
"  anchors.centerIn: parent\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblInfo\n" ..
"    text: Digite o novo valor:\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"  TextEdit\n" ..
"    id: txtEntrada\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"  Button\n" ..
"    id: btnConfirmar\n" ..
"    text: CONFIRMAR\n" ..
"    color: green\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-right: 4\n" ..
"  Button\n" ..
"    id: btnCancelar\n" ..
"    text: Cancelar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 4\n"

-- Limpeza cirúrgica de instâncias duplicadas restritas a esta versão
if widgetRaizDoJogo:getChildById("janelaAutoPushMousePuro_IsoladoV2") then 
    widgetRaizDoJogo:getChildById("janelaAutoPushMousePuro_IsoladoV2"):destroy() 
end
if widgetRaizDoJogo:getChildById("janelaConfigChasePop_IsoladoV2") then 
    widgetRaizDoJogo:getChildById("janelaConfigChasePop_IsoladoV2"):destroy() 
end

-- 🧠 FIX EXCLUSIVO: Janelas instanciadas localmente para blindar o cache da RAM
local principalWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
local popUpWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
principalWindow:hide()
popUpWindow:hide()

setDefaultTab("main")

local painelAbasNativas = getTab("main")
if painelAbasNativas:recursiveGetChildById("panelPushMousePuroIsoladoV2") then
    painelAbasNativas:recursiveGetChildById("panelPushMousePuroIsoladoV2"):destroy()
end

-- Painel Compacto com ID modificado para não chocar com a versão anterior
local botoesLateraisUI = setupUI([[
Panel
  id: panelPushMousePuroIsoladoV2
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4

  BotSwitch
    id: btnLigaMacro
    text: Push Mouse v2
    width: 125

  Button
    id: setup
    text: Setup
    width: 45
]], painelAbasNativas)
-- =============================================================================
-- [SOULE PUSH SYSTEMS V5.1] - AUTO PUSH MOUSE ISOLADO: PARTE 3 DE 4 (CLICKS & VARS)
-- =============================================================================

-- 🧠 FIX EXCLUSIVO: Função local isolada que atualiza apenas o layout desta janela
local function atualizarTextoDosBotoesPainelIsolado()
    if not principalWindow or not botoesLateraisUI then return end
    
    principalWindow.btnDelayMouse:setText("Delay Push: " .. configMouseIsolado.pushDelay .. "ms")
    principalWindow.btnDistMouse:setText("Distancia Max: " .. configMouseIsolado.maxDistance)
    principalWindow.btnToggleKey:setText("Tecla ON/OFF: [ " .. configMouseIsolado.toggleKey .. " ]")
    principalWindow.btnRuneIdSlot:setText("Runa Push ID: " .. configMouseIsolado.runeId)
    principalWindow.btnDestroyIdSlot:setText("Destroy Field ID: " .. configMouseIsolado.destroyRuneId)
    
    principalWindow.swLixoMouse:setOn(configMouseIsolado.cleanLixo)
    principalWindow.swLixoMouse:setText(configMouseIsolado.cleanLixo and "Limpar Caminho: ON" or "Limpar Caminho: OFF")
    principalWindow.swFireMouse:setOn(configMouseIsolado.autoFirePee)
    principalWindow.swFireMouse:setText(configMouseIsolado.autoFirePee and "Queimar Destino: ON" or "Queimar Destino: OFF")
    
    botoesLateraisUI.btnLigaMacro:setOn(configMouseIsolado.enabled)
    botoesLateraisUI.btnLigaMacro:setText(configMouseIsolado.enabled and "Mouse v2: ON" or "Mouse v2: OFF")
end

botoesLateraisUI.btnLigaMacro.onClick = function(w)
    configMouseIsolado.enabled = not configMouseIsolado.enabled
    if not configMouseIsolado.enabled then resetDataMouseIsolado() end
    atualizarTextoDosBotoesPainelIsolado()
end

botoesLateraisUI.setup.onClick = function()
    principalWindow:show() principalWindow:raise() principalWindow:focus()
    atualizarTextoDosBotoesPainelIsolado()
end

-- Variável local de controle do pop-up
local campoModeloEditandoVal = ""

-- 🧠 FIX EXCLUSIVO: Abertura de pop-up local sem risco de colisões na memória
local function dispararAberturaPopUpIsolado(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    popUpWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    popUpWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
    popUpWindow.txtEntrada:setText(tostring(configMouseIsolado[chaveStorage] or ""))
    popUpWindow:show() popUpWindow:raise() popUpWindow:focus() popUpWindow.txtEntrada:focus()
end

principalWindow.btnDelayMouse.onClick = function() dispararAberturaPopUpIsolado("pushDelay", "Push Mouse Delay") end
principalWindow.btnDistMouse.onClick = function() dispararAberturaPopUpIsolado("maxDistance", "Distancia Maxima Mouse") end
principalWindow.btnToggleKey.onClick = function() dispararAberturaPopUpIsolado("toggleKey", "Tecla Ligar/Desligar Macro") end
principalWindow.btnRuneIdSlot.onClick = function() dispararAberturaPopUpIsolado("runeId", "Runa Push/Fire ID") end
principalWindow.btnDestroyIdSlot.onClick = function() dispararAberturaPopUpIsolado("destroyRuneId", "Destroy Field ID") end

principalWindow.swLixoMouse.onClick = function() configMouseIsolado.cleanLixo = not configMouseIsolado.cleanLixo atualizarTextoDosBotoesPainelIsolado() end
principalWindow.swFireMouse.onClick = function() configMouseIsolado.autoFirePee = not configMouseIsolado.autoFirePee atualizarTextoDosBotoesPainelIsolado() end
principalWindow.closeBtn.onClick = function() principalWindow:hide() end

popUpWindow.btnCancelar.onClick = function() popUpWindow:hide() end
popUpWindow.btnConfirmar.onClick = function()
    local entradaDigitada = popUpWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" and entradaDigitada ~= "" then
        if campoModeloEditandoVal == "toggleKey" then
            configMouseIsolado[campoModeloEditandoVal] = entradaDigitada
        else 
            configMouseIsolado[campoModeloEditandoVal] = tonumber(entradaDigitada) or configMouseIsolado[campoModeloEditandoVal] 
        end
    end
    popUpWindow:hide() atualizarTextoDosBotoesPainelIsolado()
end

-- =============================================================================
-- TABELAS E VARIÁVEIS EXCLUSIVAS DO PUSH MOUSE ISOLADO (LOCAL V2)
-- =============================================================================
local fireFieldIds = {}
fireFieldIds["2118"] = true fireFieldIds["2119"] = true fireFieldIds["2120"] = true
fireFieldIds["2123"] = true fireFieldIds["2124"] = true fireFieldIds["2125"] = true
fireFieldIds["2121"] = true fireFieldIds["2126"] = true fireFieldIds["2125"] = true

-- 🧠 FIX EXCLUSIVO: Variáveis de combate isoladas localmente para rodar junto com a v1
local mouse_pushTarget = nil
local pushPriority = false
local pushAttempts = 0
local MAX_PUSH_PRIORITY = 8
local tempoUltimoRecuo = 0

-- 🧠 FIX EXCLUSIVO: Função local que limpa o target sem desconfigurar o macro antigo
function resetDataMouseIsolado()
  for _, tile in pairs(g_map.getTiles(posz())) do
    if tile:getText() == "TARGET" then tile:setText('') end
  end
  mouse_pushTarget = nil
  pushPriority = false
  pushAttempts = 0
end

onCreaturePositionChange(function(creature, newPos, oldPos)
  if creature == player then resetDataMouseIsolado() end
end)

local function obterDirecaoDoMouse(pPos, mPos)
    local dx, dy = mPos.x - pPos.x, mPos.y - pPos.y
    local rx, ry = 0, 0
    if dx > 0 then rx = 1 elseif dx < 0 then rx = -1 end
    if dy > 0 then ry = 1 elseif dy < 0 then ry = -1 end
    return {x = rx, y = ry}
end
-- =============================================================================
-- [SOULE PUSH SYSTEMS V5.1] - AUTO PUSH MOUSE ISOLADO: PARTE 4 DE 4 (FINAL CORE)
-- =============================================================================

-- 1. GATILHO DA HOTKEY INDEPENDENTE (ON/OFF DO BOTÃO GERAL ISOLADO)
onKeyDown(function(keys)
    if keys == configMouseIsolado.toggleKey then
        configMouseIsolado.enabled = not configMouseIsolado.enabled
        modules.game_textmessage.displayGameMessage("Auto Push Mouse PRO v2: " .. (configMouseIsolado.enabled and "LIGADO" or "DESLIGADO"))
        if not configMouseIsolado.enabled then resetDataMouseIsolado() end
        atualizarTextoDosBotoesPainelIsolado()
    elseif keys == "Escape" then 
        resetDataMouseIsolado()
    end
end)

-- 2. TARGET AUTOMÁTICO POR ATAQUE NATIVO ISOLADO
macro(100, function()
    if not configMouseIsolado.enabled then return end
    local att = g_game.getAttackingCreature()
    if att and not mouse_pushTarget then
        if att and type(att) == "userdata" and type(att.getPosition) == "function" then 
            mouse_pushTarget = att 
        end
    end
    if mouse_pushTarget and type(mouse_pushTarget) == "userdata" and type(mouse_pushTarget.getPosition) == "function" then
        local cPos = mouse_pushTarget:getPosition() 
        if not cPos or cPos.z ~= posz() then resetDataMouseIsolado() return end
        local tile = g_map.getTile(cPos) 
        if tile then tile:setText('TARGET') end
    end
end)

-- 3. LOOP CENTRAL EM 50MS COLA/AFUNILA INTEGRADO AO CURSOR DO MOUSE V2
macro(50, function()
  if not configMouseIsolado.enabled or not mouse_pushTarget then return end
  if type(mouse_pushTarget) ~= "userdata" or type(mouse_pushTarget.getPosition) ~= "function" then return end
  
  local delayVal = tonumber(configMouseIsolado.pushDelay)
  local tPos = mouse_pushTarget:getPosition() 
  local pPos = pos() 
  local nexPos = nil 
  local direcaoCalculada = nil
  local now = os.time()
  
  -- Leitura contínua do cursor físico restrita a este macro
  local mousePos = g_window.getMousePosition()
  local mouseTile = modules.game_interface.gameMapPanel:getTile(mousePos)
  
  if mouseTile then 
      local mPos = mouseTile:getPosition() 
      direcaoCalculada = obterDirecaoDoMouse(tPos, mPos)
      nexPos = {x = tPos.x + direcaoCalculada.x, y = tPos.y + direcaoCalculada.y, z = tPos.z}
  end
  
  if nexPos and direcaoCalculada then
      local distDoPlayerAteAlvo = getDistanceBetween(pPos, tPos)
      if distDoPlayerAteAlvo <= tonumber(configMouseIsolado.maxDistance) then
          
          -- MECÂNICA 1: PRIORIDADE ABSOLUTA DE PUSH (SPAM DE 8 CICLOS CONTINUO)
          if pushPriority then
              local tileAtualInimigo = g_map.getTile(tPos)
              if tileAtualInimigo then
                  local corpoMovel = tileAtualInimigo:getTopMoveThing()
                  if corpoMovel then g_game.move(corpoMovel, nexPos, 1) end
              end
              pushAttempts = pushAttempts + 1
              if pushAttempts >= MAX_PUSH_PRIORITY then pushPriority = false pushAttempts = 0 end
              return
          end

          -- PUSH NORMAL PREVENTIVO
          local nexTile = g_map.getTile(nexPos)
          if nexTile and nexTile:isWalkable() and not nexTile:hasCreature() and distDoPlayerAteAlvo >= 2 then
              local tileAtualInimigo = g_map.getTile(tPos)
              if tileAtualInimigo then
                  local corpoMovel = tileAtualInimigo:getTopMoveThing()
                  if corpoMovel then g_game.move(corpoMovel, nexPos, 1) end
              end
          end

          -- MECÂNICA 2: DESTROY FIELD NO DESTINO
          if nexTile and configMouseIsolado.cleanLixo then
              local things = nexTile:getThings()
              if things then
                  for i = #things, 1, -1 do
                      local thing = things[i]
                      if thing and thing:isItem() then
                          local ground = nexTile:getGround()
                          if thing ~= ground then
                              local thingId = tostring(thing:getId())
                              if fireFieldIds[thingId] then
                                  useWith(tonumber(configMouseIsolado.destroyRuneId), thing) return 
                              end
                          end
                      end
                  end
              end
          end

          -- MECÂNICA 3: ENCONTRAR ITEM MOVEVEL EMBAIXO DO ALVO
          local tileEmbaixoDoAlvo = g_map.getTile(tPos) local itemToFire = nil
          if tileEmbaixoDoAlvo and configMouseIsolado.cleanLixo then
              local things = tileEmbaixoDoAlvo:getThings()
              if things then
                  for i = #things, 1, -1 do
                      local thing = things[i]
                      if thing and thing:isItem() then
                          local ground = tileEmbaixoDoAlvo:getGround()
                          if thing ~= ground then
                              if not thing:isNotMoveable() then itemToFire = thing break end
                          end
                      end
                  end
              end
          end

          -- SE MANDAR A RUNA DE PUSH
          if itemToFire then
              useWith(tonumber(configMouseIsolado.runeId), itemToFire)
              
              -- TRAVA TEMPORAL DO RECUO
              if (now - tempoUltimoRecuo) > 1.5 then
                  local recuoImediatoPos = {x = pPos.x - direcaoCalculada.x, y = pPos.y - direcaoCalculada.y, z = pPos.z}
                  local recuoImediatoTile = g_map.getTile(recuoImediatoPos)
                  if recuoImediatoTile and recuoImediatoTile:isWalkable() and not recuoImediatoTile:hasCreature() then
                      autoWalk(recuoImediatoPos, true, true)
                      tempoUltimoRecuo = now 
                  end
              end
              
              local tileAtualInimigo = g_map.getTile(tPos)
              if tileAtualInimigo then
                  local corpoMovel = tileAtualInimigo:getTopMoveThing()
                  if corpoMovel then g_game.move(corpoMovel, nexPos, 1) end
              end
              
              pushPriority = true pushAttempts = 1 return
          end

          -- RECUO PREVENTIVO SE ESTIVER COLADO (DISTANCIA 1)
          if distDoPlayerAteAlvo <= 1 then
              local recuoPos = {x = pPos.x - direcaoCalculada.x, y = pPos.y - direcaoCalculada.y, z = pPos.z}
              local recuoTile = g_map.getTile(recuoPos)
              if recuoTile and recuoTile:isWalkable() and not recuoTile:hasCreature() then autoWalk(recuoPos, true, true) return end
          end

          -- QUEIMA DESTINO ADICIONAL DO PROPRIO PAINEL
          if nexTile and nexTile:isWalkable() and not nexTile:hasCreature() and distDoPlayerAteAlvo >= 2 then
              if configMouseIsolado.autoFirePee and mouse_pushTarget:canShoot() then
                  schedule(100, function() useWith(3148, mouse_pushTarget) end)
              end
              delay(delayVal)
          end

      end
  end
end)

-- Inicialização forçada sem conflito de cache
atualizarTextoDosBotoesPainelIsolado()
