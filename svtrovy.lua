-- =============================================================================
-- [BRINQUE SCRIPTS] ARQUIVO 1 LOCAL: CONEXÃO VERCEL SUPREMA - PARTE 1 DE 4
-- =============================================================================
setDefaultTab("GUILD")

local panelName = "painelBrinqueMultiServidores"
if type(storage[panelName]) ~= "table" then
    storage[panelName] = {
        servidorFixoAtivo = false,
        servidorSelecionado = "Ilusion",
        macrosMarcados = {}
    }
end
local config = storage[panelName]

if not config.macrosMarcados or type(config.macrosMarcados) ~= "table" then 
    config.macrosMarcados = {} 
end

-- 🌐 DIRETÓRIOS E LINKS DE ATENDIMENTO REAIS
local LINK_RENOVACAO  = "https://wa.me/qr/QHQWPAJNPYRDJ1"
local LINK_INSTAGRAM = "https://www.instagram.com/brinquescriptsgamer?igsh=dXhhN2MxNWhxMm9m"
local LINK_WHATSAPP  = "https://chat.whatsapp.com/D4WHVuAy41t6uQ6QZ3ibtR"
local LINK_DISCORD   = "https://discord.gg/BRNzJ7cZjq"
local LINK_YOUTUBE   = "https://youtube.com"
local pastaImg        = "/bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/Imagens/"

-- =============================================================================
-- 🌐 SUA NOVA PONTE DE SEGURANÇA EXCLUSIVA NA VERCEL (REPOSÍTÓRIO PRIVADO)
-- Repare que o bot NÃO SABE o link do seu GitHub! Ele só conversa com a Vercel.
-- =============================================================================
local URL_API_VERCEL_MESTRE = "customotserver.vercel.app"

-- 🧠 CÁLCULO DO HWID LOCAL INDIVIDUAL POR PASTA DO SERVIDOR CONECTADO
local pastaEscritaParaValidar = tostring(g_resources.getWriteDir()):lower():trim()
local hashCalculadoLocal = 0
for i = 1, #pastaEscritaParaValidar do
    hashCalculadoLocal = (hashCalculadoLocal * 31 + string.byte(pastaEscritaParaValidar, i)) % 100000000
end

hwidDaMaquinaDoCliente = "CELESTIAL-HWID-" .. tostring(hashCalculadoLocal)

-- Inicializadores de estado na RAM do cliente
computadorEstaAutorizado = false
nomeDoClienteIdentificado = "Nao Afiliado"
dataVencimentoCliente = "Expirado"
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 2 DE 4] STRINGS OTUI COM DUAS JANELAS CLÁSSICAS FIRED
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()

-- JANELA A: SELEÇÃO DE SERVIDORES E STATUS DA CONTA
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaEscolhaMacros\n" ..
"  size: 560 300\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoCustomCelestiais\n" ..
"    image-source: /bot/BRINQUE/imagens/minimalistum.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000055\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblServidoresTitulo\n" ..
"    text: -- SELECIONE O SEU SERVIDOR --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #00bfff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 20\n" ..
"    margin-left: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  ComboBox\n" ..
"    id: comboServidores\n" ..
"    anchors.top: lblServidoresTitulo.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 25\n" ..
"    margin-right: 25\n" ..
"    height: 22\n" ..
"\n" ..
"  CheckBox\n" ..
"    id: chkSalvarFixo\n" ..
"    text: Entrar automaticamente neste servidor\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #44ff44\n" ..
"    anchors.top: comboServidores.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 12\n" ..
"    margin-left: 25\n" ..
"    height: 16\n" ..
"\n" ..
"  Button\n" ..
"    id: btnConfirmarEntrada\n" ..
"    text: ABRIR SCRIPTS DO OT\n" ..
"    color: #44ff44\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: chkSalvarFixo.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 25\n" ..
"    margin-right: 25\n" ..
"    height: 24\n" ..
"\n" ..
"  Label\n" ..
"    id: lblRedesTitulo\n" ..
"    text: -- BRINQUE SCRIPTS --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #FFD700\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 20\n" ..
"    margin-left: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoInsta\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblRedesTitulo.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 24\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnInstagram\n" ..
"    text: Acessar Instagram\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: 4\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoInsta\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoWhats\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoInsta.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 24\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnWhatsApp\n" ..
"    text: Grupo do WhatsApp\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: 4\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoWhats\n" ..
"\n" ..
"  Label\n" ..
"    id: lblLicencaInfo\n" ..
"    text: Licenca: Aguardando clique...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #44ff44\n" ..
"    anchors.top: btnConfirmarEntrada.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 12\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblIDInfo\n" ..
"    text: ID DO PC ATUAL: ...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #FFD700\n" ..
"    anchors.top: lblLicencaInfo.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 6\n" ..
"    text-align: center\n" ..
"\n" ..
"  HorizontalSeparator\n" ..
"    id: sepInf\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: closeBtn.top\n" ..
"    margin-bottom: 8\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 60 20\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 15\n" ..
"    @onClick: self:getParent():hide()\n"

-- JANELA B: O PAINEL DE ROLAGEM VERTICAL CLÁSSICO E ESTÁVEL
local designMacrosOTUI = "MainWindow\n" ..
"  id: janelaBotoesMacrosRemotos\n" ..
"  size: 280 400\n" ..
"  text: Macros Ativos - Brinque\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoMacros\n" ..
"    image-source: /bot/BRINQUE/imagens/minimalistum.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000065\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: listaScroll\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: barraRolagem.left\n" ..
"    anchors.bottom: closeBtnMacros.top\n" ..
"    margin-top: 15\n" ..
"    margin-left: 15\n" ..
"    margin-right: 2\n" ..
"    margin-bottom: 10\n" ..
"    vertical-scrollbar: barraRolagem\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: barraRolagem\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: closeBtnMacros.top\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    margin-bottom: 10\n" ..
"    margin-right: 10\n" ..
"    step: 20\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtnMacros\n" ..
"    text: Ocultar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 60 20\n" ..
"    margin-bottom: 8\n" ..
"    margin-right: 15\n" ..
"    @onClick: self:getParent():hide()\n"

if widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros") then widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros"):destroy() end
if widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos") then widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos"):destroy() end

setupMacrosWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros = setupUI(designMacrosOTUI, widgetRaizDoJogo)

setupMacrosWindow:hide()
setupJanelaBotoesMacros:hide()

if setupMacrosWindow and setupMacrosWindow.lblIDInfo then
    setupMacrosWindow.lblIDInfo:setText("ID DO PC ATUAL: " .. tostring(hwidDaMaquinaDoCliente))
end
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 3 DE 4] GANCHOS GRÁFICOS E MENUS LATERAIS DUPLOS
-- =============================================================================

local LISTA_COMPLETA_SERVIDORES_OTS = { "Ilusion", "Minimalist", "Legedy" }

-- Alimenta a caixa do ComboBox com as opções cadastradas
setupMacrosWindow.comboServidores:clear()
for _, nomeOT in ipairs(LISTA_COMPLETA_SERVIDORES_OTS) do
    setupMacrosWindow.comboServidores:addOption(nomeOT)
end

-- Sincroniza o texto visual do ComboBox baseado na escolha salva na memória
if config.servidorSelecionado ~= "" then
    setupMacrosWindow.comboServidores:setOption(config.servidorSelecionado)
else
    setupMacrosWindow.comboServidores:setOption("Ilusion")
    config.servidorSelecionado = "Ilusion"
end

-- Sincroniza o estado do marcador de entrada automatizada direta
setupMacrosWindow.chkSalvarFixo:setChecked(config.servidorFixoAtivo == true)

-- MUDANÇA DE OPÇÃO SUAVE: Apenas grava a intenção do cliente sem travar a máquina
setupMacrosWindow.comboServidores.onOptionChange = function(comboWidget, opcaoTexto, dadosOpcao)
    if config.servidorSelecionado == opcaoTexto then return end
    
    print("=========================================================================")
    print("[Brinque Scripts] Voce alterou a selecao para o OT: " .. opcaoTexto)
    print("[AVISO] Para aplicar as credenciais, clique em ABRIR SCRIPTS DO OT!")
    print("=========================================================================")
    
    config.servidorSelecionado = opcaoTexto
    config.servidorFixoAtivo = false
    setupMacrosWindow.chkSalvarFixo:setChecked(false)
    setupJanelaBotoesMacros:hide() -- Oculta as caixinhas velhas preventivamente
end

-- Clique do marcador de automatização de entrada direta
setupMacrosWindow.chkSalvarFixo.onClick = function(widgetComponente)
    local novoEstadoMarcado = not widgetComponente:isChecked()
    widgetComponente:setChecked(novoEstadoMarcado)
    config.servidorFixoAtivo = novoEstadoMarcado
end

-- CONSTRUTOR DE DOIS BOTÕES FIXOS PERMANENTES NA ABA LATERAL "GUILD"
local uiTravaAba = nil
local function renderizarBotaoMenuLateral()
    if uiTravaAba then uiTravaAba:destroy() end
    
    uiTravaAba = setupUI([[
Panel
  height: 40
  Button
    id: btnMenuMestre
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 2
    height: 17
    text: Ver Acesso
    font: verdana-11px-rounded
  Button
    id: btnMacrosMenu
    anchors.top: parent.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 2
    height: 17
    text: Meus Macros
    font: verdana-11px-rounded
  ]], getTab("GUILD"))

    -- Botão esquerdo: Sempre abre a janela de login e seleção de OTs
    uiTravaAba.btnMenuMestre.onClick = function()
        if setupMacrosWindow:isVisible() then 
            setupMacrosWindow:hide() 
        else 
            setupMacrosWindow:show() 
            setupMacrosWindow:raise() 
            setupMacrosWindow:focus() 
        end
    end
    
    -- Botão direito: Abre a janela de caixinhas se tiver licença ativa ou barra na portaria
    uiTravaAba.btnMacrosMenu.onClick = function()
        if not computadorEstaAutorizado then
            print("[Seguranca] Painel Trancado. Seu computador nao possui licenca para este OT.")
            if setupMacrosWindow then 
                setupMacrosWindow:show() 
                setupMacrosWindow:raise() 
                setupMacrosWindow:focus() 
            end
            return
        end
        
        if setupJanelaBotoesMacros:isVisible() then 
            setupJanelaBotoesMacros:hide() 
        else 
            setupJanelaBotoesMacros:show() 
            setupJanelaBotoesMacros:raise() 
        end
    end
end
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 4 DE 4] REDIRECIONADOR INTEGRAL VERCEL BLINDADO
-- =============================================================================

macro(600000, function() 
    if not computadorEstaAutorizado then setupJanelaBotoesMacros:hide() end 
end)

onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

-- Variável de controle para impedir estouro de memória e reinicialização do PC
local loopDeSegurancaAtivo = false

local function executarProcessamentoDeSegurancaENuvem(modoSilencioso)
    if loopDeSegurancaAtivo then return end
    loopDeSegurancaAtivo = true

    local urlConsultaVercel = URL_API_VERCEL_MESTRE 
        .. "?hwid=" .. tostring(hwidDaMaquinaDoCliente)
        .. "&servidor=" .. tostring(config.servidorSelecionado)
        .. "&script=carregador_macros.lua"
        .. "&nocache=" .. os.time()

    HTTP.get(urlConsultaVercel, function(txtConteudo, erroNet)
        -- Libera a trava apenas após a internet responder
        loopDeSegurancaAtivo = false

        if erroNet or not txtConteudo or txtConteudo:find("ACESSO NEGADO") or txtConteudo:find("Parametros") or txtConteudo == "" then
            computadorEstaAutorizado = false
            
            if setupMacrosWindow then
                if setupMacrosWindow.btnConfirmarEntrada then 
                    setupMacrosWindow.btnConfirmarEntrada:setText("FALAR COM ADMINISTRADOR (RENOVAR)") 
                    setupMacrosWindow.btnConfirmarEntrada:setColor("#ff4444") 
                end
                if setupMacrosWindow.lblLicencaInfo then 
                    setupMacrosWindow.lblLicencaInfo:setText("Status: PC Nao Autorizado para o OT: " .. config.servidorSelecionado) 
                    setupMacrosWindow.lblLicencaInfo:setColor("#ff4444") 
                end
                setupJanelaBotoesMacros:hide()
            end

            if not modoSilencioso and setupMacrosWindow then setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
            
            print("=========================================================================")
            print(">>> [BRINQUE VERCEL API] ACESSO NEGADO OU EXPIRADO NESTE SERVIDOR!")
            print("=========================================================================")
            return
        end

        computadorEstaAutorizado = true
        nomeDoClienteIdentificado = "Cliente Ativo"

        if setupMacrosWindow then
            if setupMacrosWindow.btnConfirmarEntrada then 
                setupMacrosWindow.btnConfirmarEntrada:setText("ABRIR SCRIPTS DO OT") 
                setupMacrosWindow.btnConfirmarEntrada:setColor("#44ff44") 
            end
            if setupMacrosWindow.lblLicencaInfo then 
                setupMacrosWindow.lblLicencaInfo:setText("Licenca: Autenticado via Vercel (Sucesso)") 
                setupMacrosWindow.lblLicencaInfo:setColor("#00ff00") 
            end
        end

        print("[Brinque Vercel API] Acesso Confirmado! Rodando Carregador Mestre Privado em RAM...")
        
        local funcaoMestreNuvem, syntaxErr = loadstring(txtConteudo)
        if funcaoMestreNuvem then 
            pcall(funcaoMestreNuvem) 
        else 
            print("[Erro Sintaxe Vercel] Falha ao compilar carregador: " .. tostring(syntaxErr))
            return
        end

        if not modoSilencioso and setupMacrosWindow then 
            setupMacrosWindow:hide() 
            if setupJanelaBotoesMacros then setupJanelaBotoesMacros:show() setupJanelaBotoesMacros:raise() end 
        end
    end)
end

-- VINCULAÇÃO FÍSICA DO CLIQUE DO BOTÃO CENTRAL
setupMacrosWindow.btnConfirmarEntrada.onClick = function()
    if computadorEstaAutorizado then
        print("[Brinque Vercel] Processando requisicao de seguranca em nuvem...")
        executarProcessamentoDeSegurancaENuvem(false)
    else
        abrirLinkNoNavegadorReal(LINK_RENOVACAO)
    end
end

-- =============================================================================
-- GATILHO DE ARRANCADA SEGURO (NÃO RODA MAIS SCRIPT AUTOMÁTICO SE FALHAR)
-- =============================================================================
schedule(1200, function()
    renderizarBotaoMenuLateral()
    -- Roda apenas uma verificação de status inicial visual, sem forçar injeção em loop
    if not config.servidorFixoAtivo then
        if setupMacrosWindow then setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
    end
end)
