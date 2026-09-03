-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2: PAINEL 5 COLUNAS INTEGRAL UNIFICADO (dwlload.lua)
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

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

        -- 🛡️ MACROS OCULTOS IMPOSSÍVEIS DE DESMARCAR (RODAM EM SILÊNCIO)
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
-- 📐 ESTRUTURA VISUAL DA JANELA NATIVA (IMUNE A ERROS E SINTAXE LIMPA)
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()
local painelVelhoJanelaB = widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos")
if painelVelhoJanelaB then painelVelhoJanelaB:destroy() end

local design5ColunasLimpoOTUI = "MainWindow\n" ..
"  id: janelaBotoesMacrosRemotos\n" ..
"  size: 780 400\n" ..
"  text: Painel de Macros Premium - Brinque Scripts\n" ..
"  @onEscape: self:hide()\n" ..
"  padding: 15\n" ..
"  layout: anchor\n" ..
"\n" ..
"  Panel\n" ..
"    id: colHealing\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    size: 140 310\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"    Label\n" ..
"      text: [HEALING]\n" ..
"      font: verdana-11px-rounded\n" ..
"      color: #44ff44\n" ..
"      margin-bottom: 5\n" ..
"\n" ..
"  Panel\n" ..
"    id: colCavebot\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: colHealing.right\n" ..
"    margin-left: 12\n" ..
"    size: 140 310\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"    Label\n" ..
"      text: [CAVE/TAGR]\n" ..
"      font: verdana-11px-rounded\n" ..
"      color: #00bfff\n" ..
"      margin-bottom: 5\n" ..
"\n" ..
"  Panel\n" ..
"    id: colWar\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: colCavebot.right\n" ..
"    margin-left: 12\n" ..
"    size: 140 310\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"    Label\n" ..
"      text: [WAR]\n" ..
"      font: verdana-11px-rounded\n" ..
"      color: #ff4444\n" ..
"      margin-bottom: 5\n" ..
"\n" ..
"  Panel\n" ..
"    id: colExtras\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: colWar.right\n" ..
"    margin-left: 12\n" ..
"    size: 140 310\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"    Label\n" ..
"      text: [EXTRAS]\n" ..
"      font: verdana-11px-rounded\n" ..
"      color: #e6bc22\n" ..
"      margin-bottom: 5\n" ..
"\n" ..
"  Panel\n" ..
"    id: colVbot\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: colExtras.right\n" ..
"    margin-left: 12\n" ..
"    size: 140 310\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"    Label\n" ..
"      text: [VBOT4.8]\n" ..
"      font: verdana-11px-rounded\n" ..
"      color: #d156ff\n" ..
"      margin-bottom: 5\n" ..
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
"    margin-bottom: 5\n" ..
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
"    margin-bottom: 5\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtnMacros\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 80 22\n" ..
"    margin-bottom: 5\n" ..
"    @onClick: self:getParent():hide()\n"

setupJanelaBotoesMacros = setupUI(design5ColunasLimpoOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros:hide()

local dicionarioColunas = {
    ["HEALING"] = setupJanelaBotoesMacros.colHealing,
    ["CAVEBOT"] = setupJanelaBotoesMacros.colCavebot,
    ["WAR"]     = setupJanelaBotoesMacros.colWar,
    ["EXTRAS"]  = setupJanelaBotoesMacros.colExtras,
    ["VBOT4.8"] = setupJanelaBotoesMacros.colVbot
}

-- =============================================================================
-- [ALIMENTADOR DAS CHECKBOXES NAS COLUNAS REAIS]
-- =============================================================================
local referenciasCheckBoxes = {}

for _, item in ipairs(MAPA_MACROS_GUILDA) do
    local alvoColunaWidget = dicionarioColunas[item.cat]
    
    if alvoColunaWidget and not item.oculto then
        if configMestre.macrosMarcados[item.key] == nil then 
            configMestre.macrosMarcados[item.key] = true 
        end

        local box = g_ui.createWidget("CheckBox", alvoColunaWidget)
        box:setText(item.nome)
        box:setFont("verdana-11px-rounded")
        box:setHeight(16)
        box:setChecked(configMestre.macrosMarcados[item.key] == true)
        
        box.onClick = function(w)
            local val = not w:isChecked()
            w:setChecked(val)
            configMestre.macrosMarcados[item.key] = val
        end

        table.insert(referenciasCheckBoxes, { widget = box, key = item.key })
    end
end

setupJanelaBotoesMacros.btnDesmarcarTudo.onClick = function()
    for _, itemBox in ipairs(referenciasCheckBoxes) do
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
        print("[Brinque] Sincronizacao Concluida! Painel 5 Colunas Ativo em RAM.")
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
