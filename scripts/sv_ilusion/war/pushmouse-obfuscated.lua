-- =============================================================================
-- [SOULE PUSH SYSTEMS V5.0] - AUTO PUSH MOUSE ISOLADO: PARTE 1 DE 3
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()
local STORAGE_MOUSE = "push_mouse_puro_config"

-- 1. Inicializacao Segura do Storage focado estritamente no Mouse Livre
if not storage[STORAGE_MOUSE] then
  storage[STORAGE_MOUSE] = {
    enabled = false,
    pushDelay = 200,       -- delayMove (200ms padrão do seu exemplo)
    maxDistance = 7,
    toggleKey = "F8",      -- Hotkey para Ligar/Desligar o macro do Mouse
    cleanLixo = true,
    autoFirePee = true,
    runeId = 3188,         -- ID da Runa de Push/Fire editavel
    destroyRuneId = 3148   -- ID do Destroy Field editavel
  }
end

-- Trava de seguranca contra nils no C++
if storage[STORAGE_MOUSE].enabled == nil then storage[STORAGE_MOUSE].enabled = false end
if not storage[STORAGE_MOUSE].pushDelay then storage[STORAGE_MOUSE].pushDelay = 200 end
if not storage[STORAGE_MOUSE].maxDistance then storage[STORAGE_MOUSE].maxDistance = 7 end
if not storage[STORAGE_MOUSE].toggleKey then storage[STORAGE_MOUSE].toggleKey = "F8" end
if not storage[STORAGE_MOUSE].runeId then storage[STORAGE_MOUSE].runeId = 3188 end
if not storage[STORAGE_MOUSE].destroyRuneId then storage[STORAGE_MOUSE].destroyRuneId = 3148 end
if storage[STORAGE_MOUSE].cleanLixo == nil then storage[STORAGE_MOUSE].cleanLixo = true end
if storage[STORAGE_MOUSE].autoFirePee == nil then storage[STORAGE_MOUSE].autoFirePee = true end

configMouse = storage[STORAGE_MOUSE]

-- 2. Janela Flutuante Limpa (Removido o botao de Hotkey de Marcação Fixa)
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaAutoPushMousePuro\n" ..
"  !text: tr('Auto Push Mouse PRO - Soule')\n" ..
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

local designPopUpOTUI = "MainWindow\n" ..
"  id: janelaConfigChasePop\n" ..
"  !text: tr('Editar Campo')\n" ..
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

if widgetRaizDoJogo:getChildById("janelaAutoPushMousePuro") then widgetRaizDoJogo:getChildById("janelaAutoPushMousePuro"):destroy() end
if widgetRaizDoJogo:getChildById("janelaConfigChasePop") then widgetRaizDoJogo:getChildById("janelaConfigChasePop"):destroy() end

principalWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
popUpWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
principalWindow:hide()
popUpWindow:hide()
-- =============================================================================
-- [SOULE PUSH SYSTEMS V5.0] - AUTO PUSH MOUSE ISOLADO: PARTE 2 DE 3
-- =============================================================================

setDefaultTab("main")

local painelAbasNativas = getTab("main")
if painelAbasNativas:recursiveGetChildById("panelPushMousePuroIsolado") then
    painelAbasNativas:recursiveGetChildById("panelPushMousePuroIsolado"):destroy()
end

-- Painel Compacto Clássico na main com BotSwitch para herdar a luz nativa
local botoesLateraisUI = setupUI([[
Panel
  id: panelPushMousePuroIsolado
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4

  BotSwitch
    id: btnLigaMacro
    text: Push Mouse
    width: 125

  Button
    id: setup
    text: Setup
    width: 45
]], painelAbasNativas)

function atualizarTextoDosBotoesPainel()
    if not principalWindow or not botoesLateraisUI then return end
    
    principalWindow.btnDelayMouse:setText("Delay Push: " .. configMouse.pushDelay .. "ms")
    principalWindow.btnDistMouse:setText("Distancia Max: " .. configMouse.maxDistance)
    principalWindow.btnToggleKey:setText("Tecla ON/OFF: [ " .. configMouse.toggleKey .. " ]")
    principalWindow.btnRuneIdSlot:setText("Runa Push ID: " .. configMouse.runeId)
    principalWindow.btnDestroyIdSlot:setText("Destroy Field ID: " .. configMouse.destroyRuneId)
    
    principalWindow.swLixoMouse:setOn(configMouse.cleanLixo)
    principalWindow.swLixoMouse:setText(configMouse.cleanLixo and "Limpar Caminho: ON" or "Limpar Caminho: OFF")
    principalWindow.swFireMouse:setOn(configMouse.autoFirePee)
    principalWindow.swFireMouse:setText(configMouse.autoFirePee and "Queimar Destino: ON" or "Queimar Destino: OFF")
    
    botoesLateraisUI.btnLigaMacro:setOn(configMouse.enabled)
    botoesLateraisUI.btnLigaMacro:setText(configMouse.enabled and "Mouse: ON" or "Mouse: OFF")
end

botoesLateraisUI.btnLigaMacro.onClick = function(w)
    configMouse.enabled = not configMouse.enabled
    if not configMouse.enabled then resetDataMouse() end
    atualizarTextoDosBotoesPainel()
end

botoesLateraisUI.setup.onClick = function()
    principalWindow:show() principalWindow:raise() principalWindow:focus()
    atualizarTextoDosBotoesPainel()
end

principalWindow.btnDelayMouse.onClick = function() dispararAberturaPopUpSeguro("pushDelay", "Push Mouse Delay") end
principalWindow.btnDistMouse.onClick = function() dispararAberturaPopUpSeguro("maxDistance", "Distancia Maxima Mouse") end
principalWindow.btnToggleKey.onClick = function() dispararAberturaPopUpSeguro("toggleKey", "Tecla Ligar/Desligar Macro") end
principalWindow.btnRuneIdSlot.onClick = function() dispararAberturaPopUpSeguro("runeId", "Runa Push/Fire ID") end
principalWindow.btnDestroyIdSlot.onClick = function() dispararAberturaPopUpSeguro("destroyRuneId", "Destroy Field ID") end

principalWindow.swLixoMouse.onClick = function() configMouse.cleanLixo = not configMouse.cleanLixo atualizarTextoDosBotoesPainel() end
principalWindow.swFireMouse.onClick = function() configMouse.autoFirePee = not configMouse.autoFirePee atualizarTextoDosBotoesPainel() end
principalWindow.closeBtn.onClick = function() principalWindow:hide() end

local campoModeloEditandoVal = ""
function dispararAberturaPopUpSeguro(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    popUpWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    popUpWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
    popUpWindow.txtEntrada:setText(tostring(configMouse[chaveStorage] or ""))
    popUpWindow:show() popUpWindow:raise() popUpWindow:focus() popUpWindow.txtEntrada:focus()
end

popUpWindow.btnCancelar.onClick = function() popUpWindow:hide() end
popUpWindow.btnConfirmar.onClick = function()
    local entradaDigitada = popUpWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" and entradaDigitada ~= "" then
        if campoModeloEditandoVal == "toggleKey" then
            configMouse[campoModeloEditandoVal] = entradaDigitada
        else configMouse[campoModeloEditandoVal] = tonumber(entradaDigitada) or configMouse[campoModeloEditandoVal] end
    end
    popUpWindow:hide() atualizarTextoDosBotoesPainel()
end

-- =============================================================================
-- TABELAS E VARIÁVEIS EXCLUSIVAS DO PUSH MOUSE ISOLADO
-- =============================================================================
local fireFieldIds = {}
fireFieldIds["2118"] = true fireFieldIds["2119"] = true fireFieldIds["2120"] = true
fireFieldIds["2123"] = true fireFieldIds["2124"] = true fireFieldIds["2125"] = true

mouse_pushTarget = nil
local pushPriority = false
local pushAttempts = 0
local MAX_PUSH_PRIORITY = 8
local tempoUltimoRecuo = 0

function resetDataMouse()
  for _, tile in pairs(g_map.getTiles(posz())) do
    if tile:getText() == "TARGET" then tile:setText('') end
  end
  mouse_pushTarget = nil
  pushPriority = false
  pushAttempts = 0
end

local function obterDirecaoDoMouse(pPos, mPos)
    local dx, dy = mPos.x - pPos.x, mPos.y - pPos.y
    local rx, ry = 0, 0
    if dx > 0 then rx = 1 elseif dx < 0 then rx = -1 end
    if dy > 0 then ry = 1 elseif dy < 0 then ry = -1 end
    return {x = rx, y = ry}
end
	-- =============================================================================
-- [SOULE PUSH SYSTEMS V5.0] - AUTO PUSH MOUSE ISOLADO: PARTE 3 DE 3 (CORE)
-- =============================================================================

-- 1. GATILHO DA HOTKEY INDEPENDENTE (ON/OFF DO BOTÃO GERAL)
onKeyDown(function(keys)
    if keys == configMouse.toggleKey then
        configMouse.enabled = not configMouse.enabled
        modules.game_textmessage.displayGameMessage("Auto Push Mouse PRO: " .. (configMouse.enabled and "LIGADO" or "DESLIGADO"))
        if not configMouse.enabled then resetDataMouse() end
        atualizarTextoDosBotoesPainel()
    elseif keys == "Escape" then 
        resetDataMouse()
    end
end)

-- 2. TARGET AUTOMATICO POR ATAQUE NATIVO
macro(100, function()
    if not configMouse.enabled then return end
    local att = g_game.getAttackingCreature()
    if att and not mouse_pushTarget then
        if att and type(att) == "userdata" and type(att.getPosition) == "function" then 
            mouse_pushTarget = att 
        end
    end
    if mouse_pushTarget and type(mouse_pushTarget) == "userdata" and type(mouse_pushTarget.getPosition) == "function" then
        local cPos = mouse_pushTarget:getPosition() 
        if not cPos or cPos.z ~= posz() then resetDataMouse() return end
        local tile = g_map.getTile(cPos) 
        if tile then tile:setText('TARGET') end
    end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if creature == player then resetDataMouse() end
end)

-- 3. LOOP CENTRAL EM 50MS TOTALMENTE LIMPO E VINCULADO AO CURSOR DO MOUSE
macro(50, function()
  if not configMouse.enabled or not mouse_pushTarget then return end
  if type(mouse_pushTarget) ~= "userdata" or type(mouse_pushTarget.getPosition) ~= "function" then return end
  
  local delayVal = tonumber(configMouse.pushDelay)
  local tPos = mouse_pushTarget:getPosition() 
  local pPos = pos() 
  local nexPos = nil 
  local direcaoCalculada = nil
  
  -- Leitura contínua do cursor físico na tela
  local mousePos = g_window.getMousePosition()
  local mouseTile = modules.game_interface.gameMapPanel:getTile(mousePos)
  
  if mouseTile then 
      local mPos = mouseTile:getPosition() 
      direcaoCalculada = obterDirecaoDoMouse(tPos, mPos)
      nexPos = {x = tPos.x + direcaoCalculada.x, y = tPos.y + direcaoCalculada.y, z = tPos.z}
  end
  
  if nexPos and direcaoCalculada then
      local distDoPlayerAteAlvo = getDistanceBetween(pPos, tPos)
      if distDoPlayerAteAlvo <= tonumber(configMouse.maxDistance) then
          
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

          -- PUSH NORMAL PREVENTIVO COLA/AFUNILA
          local nexTile = g_map.getTile(nexPos)
          if nexTile and nexTile:isWalkable() and not nexTile:hasCreature() and distDoPlayerAteAlvo >= 2 then
              local tileAtualInimigo = g_map.getTile(tPos)
              if tileAtualInimigo then
                  local corpoMovel = tileAtualInimigo:getTopMoveThing()
                  if corpoMovel then g_game.move(corpoMovel, nexPos, 1) end
              end
          end

          -- MECÂNICA 2: DESTROY FIELD NO DESTINO (DA SUA LOGICA NATIVA REVISADA)
          if nexTile and configMouse.cleanLixo then
              local things = nexTile:getThings()
              if things then
                  for i = #things, 1, -1 do
                      local thing = things[i]
                      if thing and thing:isItem() then
                          local ground = nexTile:getGround()
                          if thing ~= ground then
                              local thingId = tostring(thing:getId())
                              if fireFieldIds[thingId] then
                                  useWith(tonumber(configMouse.destroyRuneId), thing) return 
                              end
                          end
                      end
                  end
              end
          end

          -- MECÂNICA 3: ENCONTRAR ITEM MOVEVEL EMBAIXO USANDO SEU MOTOR DE GETTHINGS
          local tileEmbaixoDoAlvo = g_map.getTile(tPos) local itemToFire = nil
          if tileEmbaixoDoAlvo and configMouse.cleanLixo then
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

          -- SE MANDAR O FOGO: Dispara useWith, pula 1 SQM para tras por tempo e spama
          if itemToFire then
              useWith(tonumber(configMouse.runeId), itemToFire)
              
              -- TRAVA TEMPORAL DO RECUO: Garante estritamente um único passo para trás
              if (now - tempoUltimoRecuo) > 1500 then
                  local recuoImediatoPos = {x = pPos.x - direcaoCalculada.x, y = pPos.y - direcaoCalculada.y, z = pPos.z}
                  local recuoImediatoTile = g_map.getTile(recuoImediatoPos)
                  if recuoImediatoTile and recuoImediatoTile:isWalkable() and not recuoImediatoTile:hasCreature() then
                      autoWalk(recuoImediatoPos, true, true)
                      tempoUltimoRecuo = now 
                  end
              end
              
              -- Primeiro comando de empurrão executado instantaneamente pós-fire
              local tileAtualInimigo = g_map.getTile(tPos)
              if tileAtualInimigo then
                  local corpoMovel = tileAtualInimigo:getTopMoveThing()
                  if corpoMovel then g_game.move(corpoMovel, nexPos, 1) end
              end
              
              pushPriority = true pushAttempts = 1 return
          end

          -- RECUO PREVENTIVO AUTOMÁTICO SE ESTIVER COLADO (DISTANCIA 1)
          if distDoPlayerAteAlvo <= 1 then
              local recuoPos = {x = pPos.x - direcaoCalculada.x, y = pPos.y - direcaoCalculada.y, z = pPos.z}
              local recuoTile = g_map.getTile(recuoPos)
              if recuoTile and recuoTile:isWalkable() and not recuoTile:hasCreature() then autoWalk(recuoPos, true, true) return end
          end

          -- QUEIMA DESTINO ADICIONAL DO PROPRIO PAINEL SE ATIVO
          if nexTile and nexTile:isWalkable() and not nexTile:hasCreature() and distDoPlayerAteAlvo >= 2 then
              if configMouse.autoFirePee and mouse_pushTarget:canShoot() then
                  schedule(100, function() useWith(3148, mouse_pushTarget) end)
              end
              delay(delayVal)
          end

      end
  end
end)

atualizarTextoDosBotoesPainel()
