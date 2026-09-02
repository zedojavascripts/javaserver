-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2: PAINEL SUPREMO EM 5 COLUNAS - PARTE 1 DE 3
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

-- 🌐 RAIZ DO SEU REPOSITÓRIO PÚBLICO DO GITHUB (COLOQUE O SEU LINK ATUAL DA RAIZ)
local BASE_RAW_PUBLICO = "https://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/scripts/"

-- =============================================================================
-- 📂 MAPEAMENTO COMPLETO DOS SEUS ARQUIVOS POR SERVIDOR
-- Para esconder um macro da tela de vez, basta colocar "oculto = true" na linha!
-- =============================================================================
local SCRIPTS_DO_REPOSITORIO = {
    ["Ilusion"] = {
        -- [COLUNA 1: HEALING]
        { nome = "HEALING BRQ ILUSION",     key = "healingBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/healingBRQ.lua" },
        -- [COLUNA 2: CAVE/TAGR]
        { nome = "CAVEBOT COMPLETO ILU",    key = "cavebotILU",       cat = "CAVEBOT",     arquivo = "sv_ilusion/cave_target/cavebotILU.lua" },
        -- [COLUNA 3: WAR]
        { nome = "MAGIAS S/PK BRQ ILUSION",  key = "magiasempkBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/magiasempkBRQ.lua" },
        -- [COLUNA 4: EXTRAS]
        { nome = "EXTRAS ESSENCIAIS ILU",   key = "extrasILU",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/extrasILU.lua" },
        -- [COLUNA 5: VBOT4.8]
        { nome = "SISTEMA VBOT 4.8 ILU",    key = "vbot48ILU",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/vbot48ILU.lua" },

        -- 🛡️ MACROS OCULTOS INDESTRUTÍVEIS (RODAM EM SILÊNCIO NOS BASTIDORES)
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
-- [NUVEM PÚBLICA] ARQUIVO 2: PAINEL SUPREMO EM 5 COLUNAS - PARTE 2 DE 3 FIX
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()
local painelVelhoJanelaB = widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos")
if painelVelhoJanelaB then painelVelhoJanelaB:destroy() end

-- Nova Janela B redimensionada na horizontal com 780px de largura
local design5ColunasOTUI = "MainWindow\n" ..
"  id: janelaBotoesMacrosRemotos\n" ..
"  size: 780 430\n" ..
"  text: Painel Premium Multi-Colunas - Brinque Scripts\n" ..
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
"    background-color: #000000A0\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    id: containerColunas\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: sepInferior.top\n" ..
"    margin-top: 40\n" ..
"    margin-left: 20\n" ..
"    margin-right: 20\n" ..
"    margin-bottom: 10\n" ..
"    layout:\n" ..
"      type: horizontalBox\n" ..
"      spacing: 15\n" ..
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
"    text: [X] DESMARCA TODOS\n" ..
"    color: #ff4444\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 160 22\n" ..
"    margin-left: 15\n" ..
"    margin-bottom: 8\n" ..
"\n" ..
"  Button\n" ..
"    id: btnLinkSuporte\n" ..
"    text: SUPORTE WHATSAPP\n" ..
"    color: #00bfff\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.left: btnDesmarcarTudo.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 150 22\n" ..
"    margin-left: 10\n" ..
"    margin-bottom: 8\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtnMacros\n" ..
"    text: Ocultar Painel\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 90 22\n" ..
"    margin-bottom: 8\n" ..
"    margin-right: 15\n" ..
"    @onClick: self:getParent():hide()\n"

setupJanelaBotoesMacros = setupUI(design5ColunasOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros:hide()

-- =============================================================================
-- [CONSTRUTOR DINÂMICO RECALIBRADO]
-- =============================================================================
local referenciasCheckBoxes = {}
local containerDasColunas = setupJanelaBotoesMacros.containerColunas

if containerDasColunas then
    local ORDEM_COLUNAS = { "HEALING", "CAVEBOT", "WAR", "EXTRAS", "VBOT4.8" }
    local TITULOS_COLUNAS = {
        ["HEALING"] = "[HEALING]",
        ["CAVEBOT"] = "[CAVE/TAGR]",
        ["WAR"]     = "[WAR]",
        ["EXTRAS"]  = "[EXTRAS]",
        ["VBOT4.8"] = "[VBOT4.8]"
    }
    local CORES_COLUNAS = { 
        ["HEALING"] = "#44ff44", 
        ["CAVEBOT"] = "#00bfff", 
        ["WAR"]     = "#ff4444", 
        ["EXTRAS"]  = "#e6bc22",
        ["VBOT4.8"] = "#d156ff" 
    }

    for _, catChave in ipairs(ORDEM_COLUNAS) do
        local painelColuna = g_ui.createWidget("Panel", containerDasColunas)
        painelColuna:setLayout({type = "verticalBox", spacing = 6})
        painelColuna:setWidth(140)

        local lblTitulo = g_ui.createWidget("Label", painelColuna)
        lblTitulo:setText(TITULOS_COLUNAS[catChave])
        lblTitulo:setFont("verdana-11px-rounded")
        lblTitulo:setColor(CORES_COLUNAS[catChave])
        lblTitulo:setMarginBottom(6)

        for _, item in ipairs(MAPA_MACROS_GUILDA) do
            if item.cat == catChave and not item.oculto then
                if configMestre.macrosMarcados[item.key] == nil then 
                    configMestre.macrosMarcados[item.key] = true 
                end

                local box = g_ui.createWidget("CheckBox", painelColuna)
                box:setText(item.nome)
                box:setFont("verdana-11px-rounded")
                box:setHeight(16)
                box:setChecked(configMestre.macrosMarcados[item.key] == true)
                
                box.onClick = function(w)
                    local val = not w:isChecked()
                    w:setChecked(val)
                    configMestre.macrosMarcados[item.key] = val
                end

                table.insert(referênciasCheckBoxes, { widget = box, key = item.key })
            end
        end
    end
end

setupJanelaBotoesMacros.btnDesmarcarTudo.onClick = function()
    for _, itemBox in ipairs(referênciasCheckBoxes) do
        itemBox.widget:setChecked(false)
        configMestre.macrosMarcados[itemBox.key] = false
    end
    print("[Brinque] Todos os macros visiveis foram desmarcados!")
end

setupJanelaBotoesMacros.btnLinkSuporte.onClick = function()
    local linkSuporteZap = "https://wa.me"
    if g_signals and g_signals.openUrl then g_signals.openUrl(linkSuporteZap)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(linkSuporteZap) end
end

-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2: PAINEL SUPREMO EM 5 COLUNAS - PARTE 3 DE 3
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
        print("[Brinque] Sincronizacao Concluida! Painel 5 Colunas Ativo em RAM.")
        loteJaEstaSendoBaixado = false 
        g_sound.play("/bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/sounds/som.ogg")
        return 
    end
    
    -- 🛡️ REGRA SUPREMA DE INJEÇÃO: Se for OCULTO, roda direto. Se for VISÍVEL, checa se está marcado.
    if macroAlvo.oculto or configMestre.macrosMarcados[macroAlvo.key] == true then
        local urlScript = BASE_RAW_PUBLICO .. macroAlvo.arquivo .. "?nocache=" .. os.time()

        HTTP.get(urlScript, function(content, err)
            if not err and content and content ~= "" then
                local script, syntaxErr = loadstring(content)
                if script then 
                    pcall(script) 
                    if macroAlvo.oculto then
                        print("[🛡️ Protecao] Modulo de seguranca invisivel injetado com sucesso.")
                    end
                else 
                    print("[Erro] " .. macroAlvo.nome .. " - Erro: " .. tostring(syntaxErr)) 
                end
            end
            -- Intervalo de escada suave para carregar sem lagar o jogo do cliente
            schedule(150, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

-- Inicializa a esteira de download na arrancada com timeout de segurança
schedule(300, function()
    if computadorEstaAutorizado then
        print("[Brinque] Inicializando download estruturado de: " .. tostring(servidorAtivoNoMomento))
        executarFilaCustomizadaHTTP(1)
    end
end)
