local widgetRaizDoJogo = g_ui.getRootWidget()
local idPainelExemplo = "janelaModeloExemplo"
local idPainelEditExemplo = "janelaModeloEditPop"

-- =============================================================================
-- [BLOCO 1] ARMAZENAMENTO DE DADOS (STORAGE GLOBAL)
-- =============================================================================
setDefaultTab("hp")

if not storage.modeloExemploConfig then
    storage.modeloExemploConfig = {
        macroAtiva = false,
        campoTextoUm = "3123",        -- ID do Blessed Food
        campoTextoDois = "10",        -- Cooldown em Segundos
        campoNumero = 70,             -- Porcentagem de Ativação
        modoMana = false              -- false = HP, true = Mana
    }
end

-- =============================================================================
-- [BLOCO 2] DESIGN DO PAINEL PRINCIPAL (ATUALIZADO COM SELETOR HP/MP)
-- =============================================================================
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaModeloExemplo\n" ..
"  !text: tr('BLESSED FOOD')\n" ..
"  size: 350 250\n" .. -- Aumentado levemente para acomodar o botão de alternar de forma limpa
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblColunaEsquerda\n" ..
"    text: == CONFIGURACOES ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarTextoUm\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarTextoDois\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarNumero\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 24\n" ..
"  BotSwitch\n" ..
"    id: swModoModo\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 20\n" ..
"  Label\n" ..
"    id: lblExibicaoStatus\n" ..
"    text: Pronto para uso.\n" ..
"    color: #55ff55\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    text-align: center\n" ..
"  Label\n" ..
"    id: lblMarcaDaguaUniversal\n" ..
"    text: >> BRINQUE SCRIPTS <<\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.horizontalCenter: parent.horizontalCenter\n" ..
"    margin-bottom: 30\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-right: 4\n" ..
"    height: 22\n" ..
"  Button\n" ..
"    id: btnAcessarUrl\n" ..
"    text: Discord\n" ..
"    color: #55ffff\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 4\n" ..
"    height: 22\n"

-- =============================================================================
-- [BLOCO 3] DESIGN DO POP-UP SEGURO
-- =============================================================================
local designPopUpOTUI = "MainWindow\n" ..
"  id: janelaTomModelEditPop\n" ..
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

local principalWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
local popUpWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
principalWindow:hide()
popUpWindow:hide()

local painelDaAbaHP = getTab("HP")
if painelDaAbaHP:recursiveGetChildById("panelBotoesModeloNativos") then
    painelDaAbaHP:recursiveGetChildById("panelBotoesModeloNativos"):destroy()
end

local botoesLateraisUI = setupUI([[
Panel
  id: panelBotoesModeloNativos
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4

  BotSwitch
    id: btnLigaMacro
    width: 85

  Button
    id: btnAbrePainel
    text: Config Food
    width: 85
]], painelDaAbaHP)

-- =============================================================================
-- [BLOCO 5] MOTORES DE ATUALIZACAO
-- =============================================================================
local campoModeloEditandoVal = ""

function dispararAberturaPopUpSeguro(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    popUpWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    popUpWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
    
    local valorAtualNaMemoria = tostring(storage.modeloExemploConfig[chaveStorage] or "")
    popUpWindow.txtEntrada:setText(valorAtualNaMemoria)
    
    popUpWindow:show()
    popUpWindow:raise()
    popUpWindow:focus()
    popUpWindow.txtEntrada:focus()
end

function atualizarTextoDosBotoesPainel()
    if not storage.modeloExemploConfig or not principalWindow or not botoesLateraisUI then return end
    
    principalWindow.btnEditarTextoUm:setText("Food ID: " .. storage.modeloExemploConfig.campoTextoUm)
    principalWindow.btnEditarTextoDois:setText("Food Cooldown (s): " .. storage.modeloExemploConfig.campoTextoDois)
    
    local tipoChecagem = storage.modeloExemploConfig.modoMana and "Mana" or "HP"
    principalWindow.btnEditarNumero:setText("Min " .. tipoChecagem .. " %: " .. tostring(storage.modeloExemploConfig.campoNumero))
    
    principalWindow.swModoModo:setOn(storage.modeloExemploConfig.modoMana)
    principalWindow.swModoModo:setText(storage.modeloExemploConfig.modoMana and "Modo Atual: MANA" or "Modo Atual: HP")
    
    botoesLateraisUI.btnLigaMacro:setOn(storage.modeloExemploConfig.macroAtiva)
    botoesLateraisUI.btnLigaMacro:setText(storage.modeloExemploConfig.macroAtiva and "Blessed: ON" or "Blessed: OFF")
end

-- =============================================================================
-- [BLOCO 6] CAPTURA DE EVENTOS DE CLIQUES E ENCERRAMENTOS
-- =============================================================================
botoesLateraisUI.btnLigaMacro.onClick = function() 
    storage.modeloExemploConfig.macroAtiva = not storage.modeloExemploConfig.macroAtiva 
    atualizarTextoDosBotoesPainel() 
end

botoesLateraisUI.btnAbrePainel.onClick = function() 
    principalWindow:show() 
    principalWindow:raise() 
    principalWindow:focus() 
    atualizarTextoDosBotoesPainel() 
end

principalWindow.btnEditarTextoUm.onClick = function() dispararAberturaPopUpSeguro("campoTextoUm", "ID do Food") end
principalWindow.btnEditarTextoDois.onClick = function() dispararAberturaPopUpSeguro("campoTextoDois", "Tempo de Espera (s)") end
principalWindow.btnEditarNumero.onClick = function() 
    local campoNome = storage.modeloExemploConfig.modoMana and "Mana % Ativacao" or "HP % Ativacao"
    dispararAberturaPopUpSeguro("campoNumero", campoNome) 
end

principalWindow.swModoModo.onClick = function()
    storage.modeloExemploConfig.modoMana = not storage.modeloExemploConfig.modoMana
    atualizarTextoDosBotoesPainel()
end

principalWindow.closeBtn.onClick = function() principalWindow:hide() end

principalWindow.btnAcessarUrl.onClick = function()
    local urlDestino = "https://discord.gg"
    if g_signals and g_signals.openUrl then
        g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then
        g_platform.openUrl(urlDestino)
    end
end

popUpWindow.btnCancelar.onClick = function() popUpWindow:hide() end
popUpWindow.btnConfirmar.onClick = function()
    local entradaDigitada = popUpWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" then
        if campoModeloEditandoVal == "campoNumero" then
            storage.modeloExemploConfig[campoModeloEditandoVal] = tonumber(entradaDigitada) or 0
        else
            storage.modeloExemploConfig[campoModeloEditandoVal] = entradaDigitada
        end
    end
    popUpWindow:hide() 
    atualizarTextoDosBotoesPainel()
end

-- =============================================================================
-- [BLOCO 7] EXECUÇÃO DO MACRO E CONTADOR REGRESSIVO DE COOLDOWN
-- =============================================================================
macro(100, function()
    if botoesLateraisUI and storage.modeloExemploConfig then
        botoesLateraisUI.btnLigaMacro:setOn(storage.modeloExemploConfig.macroAtiva)
    end
    
    local tempoEspera = tonumber(storage.modeloExemploConfig.campoTextoDois) or 10

    -- Efeito de Piscar na Marca d'água e gerenciamento do Cooldown visual
    if principalWindow and principalWindow:isVisible() then
        if principalWindow.lblMarcaDaguaUniversal then
            local equacaoSeno = math.abs(math.sin(os.clock() * 4))
local tomDeCinza = math.floor(100 + (155 * equacaoSeno))
principalWindow.lblMarcaDaguaUniversal:setColor(string.format("#%02X%02X%02X", tomDeCinza, tomDeCinza, tomDeCinza))
end
if storage.timerBlessedFood then
local tempoPassado = os.time() - storage.timerBlessedFood
local tempoRestante = tempoEspera - tempoPassado
if tempoRestante > 0 then
principalWindow.lblExibicaoStatus:setText("Aguardando Cooldown: " .. tempoRestante .. "s")
principalWindow.lblExibicaoStatus:setColor("#ff5555")
else
principalWindow.lblExibicaoStatus:setText("Pronto para uso.")
principalWindow.lblExibicaoStatus:setColor("#55ff55")
end
else
principalWindow.lblExibicaoStatus:setText("Pronto para uso.")
principalWindow.lblExibicaoStatus:setColor("#55ff55")
end
end
-- Lógica inteligente de uso do Blessed Food (Alternando dinamicamente HP/Mana)
if storage.modeloExemploConfig.macroAtiva then
local idFood = tonumber(storage.modeloExemploConfig.campoTextoUm) or 3123
local porcAlvo = storage.modeloExemploConfig.campoNumero or 70
-- Verifica se vai ler a porcentagem do HP ou do MP baseado no Switch do painel
local percentualAtual = storage.modeloExemploConfig.modoMana and manapercent() or hppercent()
if percentualAtual <= porcAlvo then
if not storage.timerBlessedFood or (os.time() - storage.timerBlessedFood) >= tempoEspera then
use(idFood)
storage.timerBlessedFood = os.time()
delay(500)
end
end
end
end)
-- Inicialização da Interface
atualizarTextoDosBotoesPainel()
