-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2: PAINEL DE ABAS PREMIUM ESTILO VBOT (dwlload.lua)
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

-- Grava a aba que estava aberta para o jogador nao perder a selecao ao dar reload
if not configMestre.abaAbertaAtual then configMestre.abaAbertaAtual = "HEALING" end

-- 🌐 RAIZ DO SEU REPOSITÓRIO PÚBLICO DO GITHUB
local BASE_RAW_PUBLICO = "https://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/scripts/"

-- =============================================================================
-- 📂 MAPEAMENTO DOS ARQUIVOS (VISÍVEIS E OCULTOS)
-- =============================================================================
local SCRIPTS_DO_REPOSITORIO = {
    ["Ilusion"] = {
        { nome = "HEALING BRQ ILUSION",     key = "healingBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/healingBRQ.lua" },
        { nome = "CAVEBOT COMPLETO ILU",    key = "cavebotILU",       cat = "CAVEBOT",     arquivo = "sv_ilusion/cave_target/cavebotILU.lua" },
        { nome = "MAGIAS S/PK BRQ ILUSION",  key = "magiasempkBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS ILU",   key = "extrasILU",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/extrasILU.lua" },
        { nome = "SISTEMA VBOT 4.8 ILU",    key = "vbot48ILU",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/vbot48ILU.lua" },

        -- 🛡️ MACROS OCULTOS IMPOSSÍVEIS DE DESMARCAR (RODAM EM SILÊNCIO NOS BASTIDORES)
        { nome = "Protecao Injetada",       key = "antidebug",        cat = "OCULTO",      arquivo = "sv_ilusion/extras/antidebug.lua", oculto = true },
        { nome = "Auto Save Core",          key = "coreSave",         cat = "OCULTO",      arquivo = "sv_ilusion/extras/coresave.lua",  oculto = true }
    },
    ["Minimalist"] = {
        { nome = "HEALING BRQ MINIMALIST",   key = "healingMIN",       cat = "HEALING",     arquivo = "sv_minimalist/healing/healingMIN.lua" },
        { nome = "CAVEBOT COMPLETO MIN",    key = "cavebotMIN",       cat = "CAVEBOT",     arquivo = "sv_minimalist/cave_target/cavebotMIN.lua" },
        { nome = "FILTRO BATTLE BRQ",       key = "filtroBattle",     cat = "WAR",         arquivo = "sv_minimalist/war/Filtrobattle.lua" },
        { nome = "EXTRAS ESSENCIAIS MIN",   key = "extrasMIN",        cat = "EXTRAS",      arquivo = "sv_minimalist/extras/extrasMIN.lua" },
        { nome = "MODS VBOT 4.8 MIN",       key = "vbot48MIN",        cat = "VBOT4.8",     arquivo = "sv_minimalist/extras/vbot48MIN.lua" }
    },
    ["Legedy"] = {
        { nome = "HEALING BRQ LEGEDY",      key = "healingLEG",       cat = "HEALING",     arquivo = "sv_legend/healing/healingLEG.lua" },
        { nome = "CAVEBOT COMPLETO LEG",    key = "cavebotLEG",       cat = "CAVEBOT",     arquivo = "sv_legend/cave_target/cavebotLEG.lua" },
        { nome = "WAR LEGEDY COMBAT",        key = "magiasempkLEG",    cat = "WAR",         arquivo = "sv_legend/war/magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS LEG",   key = "extrasLEG",        cat = "EXTRAS",      arquivo = "sv_legend/extras/extrasLEG.lua" },
        { nome = "ENGINE VBOT 4.8 LEG",     key = "vbot48LEG",        cat = "VBOT4.8",     arquivo = "sv_legend/extras/vbot48LEG.lua" }
    }
}

local MAPA_MACROS_GUILDA = SCRIPTS_DO_REPOSITORIO[servidorAtivoNoMomento] or {}

-- =============================================================================
-- 📐 DESIGN DO PAINEL DE ABAS (LARGURA ENCURTADA ESTILO MINI-MODAL DO VBOT)
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()
local painelVelhoJanelaB = widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos")
if painelVelhoJanelaB then painelVelhoJanelaB:destroy() end

-- Reduzimos a largura para 320px (perfeito para ficar compacto e bonito no monitor)
local designAbasPremiumOTUI = "MainWindow\n" ..
"  id: janelaBotoesMacrosRemotos\n" ..
"  size: 320 400\n" ..
"  text: Brinque Scripts Premium\n" ..
"  @onEscape: self:hide()\n" ..
"  padding: 12\n" ..
"  layout: anchor\n" ..
"\n" ..
"  -- CONTAINER COMPACTO HORIZONTAL PARA OS BOTÕES DAS ABAS\n" ..
"  Panel\n" ..
"    id: painelBotoesAbas\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 24\n" ..
"    layout:\n" ..
"      type: horizontalBox\n" ..
"      spacing: 4\n" ..
"\n" ..
"  HorizontalSeparator\n" ..
"    id: sepSuperiorAbas\n" ..
"    anchors.top: painelBotoesAbas.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"\n" ..
"  -- CONTEÚDO DINÂMICO VERTICAL ABAIXO DA ABA SELECIONADA\n" ..
"  ScrollablePanel\n" ..
"    id: listaScrollMacrosAba\n" ..
"    anchors.top: sepSuperiorAbas.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: sepInferior.top\n" ..
"    margin-top: 10\n" ..
"    margin-bottom: 8\n" ..
"    vertical-scrollbar: barraRolagemAbas\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: barraRolagemAbas\n" ..
"    anchors.top: listaScrollMacrosAba.top\n" ..
"    anchors.bottom: listaScrollMacrosAba.bottom\n" ..
"    anchors.right: parent.right\n" ..
"    step: 16\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  HorizontalSeparator\n" ..
"    id: sepInferior\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: btnDesmarcarTudo.top\n" ..
"    margin-bottom: 8\n" ..
"\n" ..
"  Button\n" ..
"    id: btnDesmarcarTudo\n" ..
"    text: [X] Limpar Aba\n" ..
"    color: #ff4444\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 110 22\n" ..
"    margin-bottom: 5\n" ..
"\n" ..
"  Button\n" ..
"    id: btnLinkSuporte\n" ..
"    text: Suporte\n" ..
"    color: #00bfff\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.left: btnDesmarcarTudo.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 90 22\n" ..
"    margin-left: 6\n" ..
"    margin-bottom: 5\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtnMacros\n" ..
"    text: Ocultar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 65 22\n" ..
"    margin-bottom: 5\n" ..
"    @onClick: self:getParent():hide()\n"

setupJanelaBotoesMacros = setupUI(designAbasPremiumOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros:hide()

-- =============================================================================
-- [MOTOR LÓGICO DE RENDERIZAÇÃO DAS ABAS ESTILO VBOT]
-- =============================================================================
local LISTA_CATEGORIAS_ABAS = { "HEALING", "CAVEBOT", "WAR", "EXTRAS", "VBOT4.8" }
local LISTA_LABEL_ABAS = { ["HEALING"]="Cura", ["CAVEBOT"]="Cave", ["WAR"]="War", ["EXTRAS"]="Extr", ["VBOT4.8"]="4.8" }

local widgetListaScroll = setupJanelaBotoesMacros.listaScrollMacrosAba
local botoesAbasCriados = {}
local referenciasCheckBoxesAbaAtiva = {}

-- Função principal que redesenha as caixinhas na tela quando muda de aba
local function renderizarConteudoDaAba(categoriaNome)
    configMestre.abaAbertaAtual = categoriaNome
    widgetListaScroll:destroyChildren()
    referenciasCheckBoxesAbaAtiva = {}

    -- Altera visualmente a cor do botão ativo para o jogador saber onde está
    for catKey, btnWidget in pairs(botoesAbasCriados) do
        if catKey == categoriaNome then
            btnWidget:setColor("#44ff44") -- Verde se estiver aberto
        else
            btnWidget:setColor("#ffffff") -- Branco padrão para os outros
        end
    end

    -- Varre as macros injetando apenas as caixinhas da categoria selecionada
    for _, item in ipairs(MAPA_MACROS_GUILDA) do
        if item.cat == categoriaNome and not item.oculto then
            if configMestre.macrosMarcados[item.key] == nil then 
                configMestre.macrosMarcados[item.key] = true 
            end

            local box = g_ui.createWidget("CheckBox", widgetListaScroll)
            box:setText(item.nome)
            box:setFont("verdana-11px-rounded")
            box:setHeight(16)
            box:setChecked(configMestre.macrosMarcados[item.key] == true)
            
            box.onClick = function(w)
                local val = not w:isChecked()
                w:setChecked(val)
                configMestre.macrosMarcados[item.key] = val
            end

            table.insert(referenciasCheckBoxesAbaAtiva, { widget = box, key = item.key })
        end
    end
end

-- Cria os botões das abas horizontais no topo do painel
local containerAbasBotoes = setupJanelaBotoesMacros.painelBotoesAbas
if containerAbasBotoes then
    for _, catNome in ipairs(LISTA_CATEGORIAS_ABAS) do
        local btnAba = g_ui.createWidget("Button", containerAbasBotoes)
        btnAba:setText(LISTA_LABEL_ABAS[catNome])
        btnAba:setFont("verdana-11px-rounded")
        btnAba:setHeight(22)
        btnAba:setWidth(54)
        
        btnAba.onClick = function()
            renderizarConteudoDaAba(catNome)
        end
        botoesAbasCriados[catNome] = btnAba
    end
end

-- Inicializa abrindo a aba que estava salva na memória
renderizarConteudoDaAba(configMestre.abaAbertaAtual)

-- Funcionalidade do Botão de Limpar a Aba Aberta
setupJanelaBotoesMacros.btnDesmarcarTudo.onClick = function()
    for _, itemBox in ipairs(referenciasCheckBoxesAbaAtiva) do
        itemBox.widget:setChecked(false)
        configMestre.macrosMarcados[itemBox.key] = false
    end
    print("[Brinque] Todos os macros da aba " .. configMestre.abaAbertaAtual .. " foram desligados!")
end

setupJanelaBotoesMacros.btnLinkSuporte.onClick = function()
    local linkSuporteZap = "https://wa.me"
    if g_signals and g_signals.openUrl then g_signals.openUrl(linkSuporteZap)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(linkSuporteZap) end
end

-- =============================================================================
-- [ESTEIRA HTTP ASSÍNCRONA DE INJEÇÃO EM SEGUNDO PLANO]
-- =============================================================================
local loteJaEstaSendoBaixado = false

local function executarFilaCustomizadaHTTP(indice)
    if not computadorEstaAutorizado then return end
    
    if indice == 1 then 
        if loteJaEstaSendoBaixado then return end 
        loteJaEstaSendoBaixado = true 
    end
    
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Brinque] Sincronizacao Concluida! Painel de Abas Premium Ativo.")
        loteJaEstaSendoBaixado = false 
        return 
    end
    
    if macroAlvo.oculto or configMestre.macrosMarcados[macroAlvo.key] == true then
        local urlScript = BASE_RAW_PUBLICO .. macroAlvo.arquivo .. "?nocache=" .. os.time()

        HTTP.get(urlScript, function(content, err)
            if not err and content and content ~= "" then
                local script, syntaxErr = loadstring(content)
                if script then 
                    pcall(script) 
                else 
                    print("[Erro] " .. macroAlvo.nome .. " - Erro: " .. tostring(syntaxErr)) 
                end
            end
            schedule(150, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

schedule(300, function()
    if computadorEstaAutorizado then
        print("[Brinque] Inicializando download estruturado de: " .. tostring(servidorAtivoNoMomento))
        executarFilaCustomizadaHTTP(1)
    end
end)
