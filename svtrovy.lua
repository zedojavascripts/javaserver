-- =============================================================================
-- [BRINQUE SCRIPTS] ARQUIVO 1 MESTRE: SEGURANÇA E DIRETÓRIOS - PARTE 1 DE 4
-- =============================================================================
setDefaultTab("main")

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

-- 🌐 DIRETÓRIOS E LINKS DE ATENDIMENTO ORIGINAIS
local LINK_RENOVACAO  = "https://wa.me/qr/QHQWPAJNPYRDJ1"
local LINK_INSTAGRAM = "https://www.instagram.com/brinquescriptsgamer?igsh=dXhhN2MxNWhxMm9m"
local LINK_WHATSAPP  = "https://chat.whatsapp.com/D4WHVuAy41t6uQ6QZ3ibtR"
local LINK_DISCORD   = "https://discord.gg/BRNzJ7cZjq"
local LINK_YOUTUBE   = "https://youtube.com"
local pastaImg        = "/bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/Imagens/"

-- 🌐 URL DO SEU BANCO DE DADOS DE CLIENTES EM NUVEM (RAW GITHUB)
local URL_BANCO_DADOS_NUVEM = "https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/bankdadps.lua?token=GHSAT0AAAAAAEEYZWN6PPCCP3QJD4HMOVTC2UM6IBA"

-- 🧠 CÁLCULO DO HWID LOCAL INDIVIDUAL POR PASTA DO SERVIDOR CONECTADO
local pastaEscritaParaValidar = tostring(g_resources.getWriteDir()):lower():trim()
local hashCalculadoLocal = 0
for i = 1, #pastaEscritaParaValidar do
    hashCalculadoLocal = (hashCalculadoLocal * 31 + string.byte(pastaEscritaParaValidar, i)) % 100000000
end

hwidDaMaquinaDoCliente = "CELESTIAL-HWID-" .. tostring(hashCalculadoLocal)

BANCO_DADOS_CLIENTES = {}
computadorEstaAutorizado = false
nomeDoClienteIdentificado = "Nao Afiliado"
dataVencimentoCliente = "Expirado"
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 2 DE 4] STRINGS OTUI COM DUAS JANELAS CORRIGIDAS
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
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/Imagens/llogobrinque.png\n" ..
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
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/Imagens/botao_dourado_dois.png\n" ..
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
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/Imagens/botao_dourado_dois.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoInsta.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 80\n" ..
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
"    text: Licenca: Carregando dados...\n" ..
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

-- JANELA B: NOVO PAINEL EXCLUSIVO PARA EXIBIÇÃO DE MACROS (FIXADO PARENT)
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
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/Imagens/logobrinque.png\n" ..
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

local setupMacrosWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros = setupUI(designMacrosOTUI, widgetRaizDoJogo)

setupMacrosWindow:hide()
setupJanelaBotoesMacros:hide()

if setupMacrosWindow and setupMacrosWindow.lblIDInfo then
    setupMacrosWindow.lblIDInfo:setText("ID DO PC ATUAL: " .. tostring(hwidDaMaquinaDoCliente))
end

local function abrirLinkNoNavegadorReal(urlDestino)
    if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino)
    else print(">>> [BRINQUE] Link: " .. urlDestino) end
end

setupMacrosWindow.btnInstagram.onClick = function() abrirLinkNoNavegadorReal(LINK_INSTAGRAM) end
setupMacrosWindow.btnWhatsApp.onClick  = function() abrirLinkNoNavegadorReal(LINK_WHATSAPP) end

local mapeamentoBotoesImagens = {
    { widget = setupMacrosWindow.imgFundoInsta,   file = "botao_dourado_dois.png" },
    { widget = setupMacrosWindow.imgFundoWhats,   file = "botao_dourado_dois.png" }
}
for _, itemBtn in ipairs(mapeamentoBotoesImagens) do
    if not g_resources.fileExists(pastaImg .. itemBtn.file) then
        itemBtn.widget:setImageSource("")
        itemBtn.widget:setBackgroundColor("#2f2f2f")
    end
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

-- CONSTRUTOR DE DOIS BOTÕES FIXOS PERMANENTES NA ABA LATERAL "main"
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
  ]], getTab("main"))

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
-- [PAINEL CENTRAL - PARTE 4 DE 4] WEBHOOK DISCORD, NUVEM E INTERCEPTOR DO WHATSAPP
-- =============================================================================

local URL_WEBHOOK_DISCORD = "https://discord.com/api/webhooks/1536100384785834064/31bfP1tvqS7nx_s99Vzr6NxAFvGcAf2MGdpPbezQ1hocXHc_DgiGaTDxkTpMyC_lU1NL"
local jaEnviouNotificacao = false

local function registrarNotificacaoNoDiscord(nickChar, idCapturado, statusLicenca, canalTipo)
    if jaEnviouNotificacao then return end
    if not URL_WEBHOOK_DISCORD or URL_WEBHOOK_DISCORD == "" then return end
    
    jaEnviouNotificacao = true
    local corEmbed = canalTipo == "Nao Afiliado" and 16711680 or 65280

    local estruturaPayload = {
        username = "Brinque Scripts Alerta",
        embeds = {
            {
                title = "🔒 Sistema de Auditoria - " .. canalTipo,
                color = corEmbed,
                fields = {
                    { name = "👤 Personagem (Nick):", value = nickChar, inline = true },
                    { name = "🖥️ Codigo Gerado (HWID):", value = "`" .. idCapturado .. "`", inline = true },
                    { name = "⚙️ Status / Servidor Selecionado:", value = statusLicenca, inline = true }
                },
                footer = { text = "Controle de Vendas Automatizado - Brinque Scripts" }
            }
        }
    }
    HTTP.postJSON(URL_WEBHOOK_DISCORD, estruturaPayload, function(res, err) end)
end

macro(600000, function() 
    if not computadorEstaAutorizado then setupJanelaBotoesMacros:hide() end 
end)

onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

local function executarProcessamentoDeSegurancaENuvem(modoSilencioso)
    HTTP.get(URL_BANCO_DADOS_NUVEM .. "?nocache=" .. os.time(), function(txtConteudo, erroNet)
        if erroNet or not txtConteudo then
            print("[Erro Nuvem] Falha ao baixar banco de dados. Acesso trancado.")
            if setupMacrosWindow and setupMacrosWindow.lblLicencaInfo then 
                setupMacrosWindow.lblLicencaInfo:setText("Licenca: Erro de Conexao com Nuvem") 
                setupMacrosWindow.lblLicencaInfo:setColor("#ff4444") 
            end
            return
        end

        local funcaoCompilada, syntaxErr = loadstring(txtConteudo)
        if funcaoCompilada then pcall(funcaoCompilada) else 
            print("[Erro Sintaxe] Tabela corrompida: " .. tostring(syntaxErr))
            return
        end

        local function converterDataParaTimestampMestre(dataTexto)
            local dia, mes, ano = dataTexto:match("(%d+)/(%d+)/(%d+)")
            if dia and mes and ano then return os.time({year = tonumber(ano), month = tonumber(mes), day = tonumber(dia), hour = 23, min = 59, sec = 59}) end
            return nil
        end

        computadorEstaAutorizado = false
        nomeDoClienteIdentificado = "Nao Afiliado"
        dataVencimentoCliente = "Expirado"

        if BANCO_DADOS_CLIENTES then
            for nomeCliente, dados in pairs(BANCO_DADOS_CLIENTES) do
                if dados.servidores and dados.servidores[hwidDaMaquinaDoCliente] then
                    local nomeDoServidorDesseID = dados.servidores[hwidDaMaquinaDoCliente]
                    if nomeDoServidorDesseID == config.servidorSelecionado then
                        nomeDoClienteIdentificado = nomeCliente
                        dataVencimentoCliente = dados.vence
                        if dados.vence == "ilimitado" then computadorEstaAutorizado = true
                        else
                            local timestampVencimento = converterDataParaTimestampMestre(dados.vence)
                            if timestampVencimento and (timestampVencimento - os.time() > 0) then computadorEstaAutorizado = true end
                        end
                        break
                    end
                end
            end
        end

        if setupMacrosWindow then
            if computadorEstaAutorizado then
                if setupMacrosWindow.btnConfirmarEntrada then setupMacrosWindow.btnConfirmarEntrada:setText("ABRIR SCRIPTS DO OT") setupMacrosWindow.btnConfirmarEntrada:setColor("#44ff44") end
                if setupMacrosWindow.lblLicencaInfo then
                    if dataVencimentoCliente == "ilimitado" then setupMacrosWindow.lblLicencaInfo:setText("Cliente: " .. nomeDoClienteIdentificado .. " (Permanente)") setupMacrosWindow.lblLicencaInfo:setColor("#00bfff")
                    else setupMacrosWindow.lblLicencaInfo:setText("Cliente: " .. nomeDoClienteIdentificado .. " (Ate: " .. dataVencimentoCliente .. ")") setupMacrosWindow.lblLicencaInfo:setColor("#44ff44") end
                end
            else
                if setupMacrosWindow.btnConfirmarEntrada then setupMacrosWindow.btnConfirmarEntrada:setText("FALAR COM ADMINISTRADOR (RENOVAR)") setupMacrosWindow.btnConfirmarEntrada:setColor("#ff4444") end
                if setupMacrosWindow.lblLicencaInfo then setupMacrosWindow.lblLicencaInfo:setText("Status: PC Nao Autorizado para o OT: " .. config.servidorSelecionado) setupMacrosWindow.lblLicencaInfo:setColor("#ff4444") end
                setupJanelaBotoesMacros:hide()
            end
        end

        local localPlayer = g_game.getLocalPlayer()
        local nickDoCara = localPlayer and localPlayer:getName() or "Desconhecido"

        if computadorEstaAutorizado then
            registrarNotificacaoNoDiscord(nickDoCara, hwidDaMaquinaDoCliente, "Liberado no OT: " .. config.servidorSelecionado, "Afiliado / Cliente")
            print("[Brinque Scripts] Acesso confirmado! Injetando o Carregador Mestre em RAM...")
            
            local URL_ARQUIVODOSMACROS = "https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/scripts/dwlload.lua"
            HTTP.get(URL_ARQUIVODOSMACROS .. "?nocache=" .. os.time(), function(macrosCont, errM)
                if not errM and macrosCont then
                    local injetorMacros, sErr = loadstring(macrosCont)
                    if injetorMacros then pcall(injetorMacros) else print("[Erro Nuvem] Carregador Falhou: " .. tostring(sErr)) end
                end
            end)
            
            if not modoSilencioso and setupMacrosWindow then 
                setupMacrosWindow:hide() 
                if setupJanelaBotoesMacros then setupJanelaBotoesMacros:show() setupJanelaBotoesMacros:raise() end 
            end
        else
            registrarNotificacaoNoDiscord(nickDoCara, hwidDaMaquinaDoCliente, "Rejeitado para o OT: " .. config.servidorSelecionado, "Nao Afiliado")
            if not modoSilencioso and setupMacrosWindow then setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
            print("=========================================================================")
            print(">>> [BRINQUE SCRIPTS] ACESSO NEGADO! ID de pasta invalido para o OT: " .. config.servidorSelecionado)
            print(">>> Cadastre este ID de pasta no Admin: " .. hwidDaMaquinaDoCliente)
            print("=========================================================================")
        end
    end)
end

setupMacrosWindow.btnConfirmarEntrada.onClick = function()
    if computadorEstaAutorizado then
        jaEnviouNotificacao = false 
        executarProcessamentoDeSegurancaENuvem(false)
    else
        abrirLinkNoNavegadorReal(LINK_RENOVACAO)
    end
end

schedule(1200, function()
    renderizarBotaoMenuLateral()
    if config.servidorFixoAtivo then executarProcessamentoDeSegurancaENuvem(true)
    else executarProcessamentoDeSegurancaENuvem(true) end
end)
