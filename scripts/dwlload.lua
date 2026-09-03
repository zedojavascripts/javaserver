-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2: DESIGN SEM BORDAS E BOTÕES COM IMAGEM - PARTE 1 DE 2
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

if not configMestre.abaAbertaAtual then configMestre.abaAbertaAtual = "HEALING" end

local BASE_RAW_PUBLICO = "ttps://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/scripts/"

local SCRIPTS_DO_REPOSITORIO = {
    ["Ilusion"] = {
        { nome = "HEALING BRQ ILUSION",     key = "healingBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/healingBRQ.lua" },
        { nome = "CAVEBOT COMPLETO ILU",    key = "cavebotILU",       cat = "CAVEBOT",     arquivo = "sv_ilusion/cave_target/cavebotILU.lua" },
        { nome = "MAGIAS S/PK BRQ ILUSION",  key = "magiasempkBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS ILU",   key = "extrasILU",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/extrasILU.lua" },
        { nome = "SISTEMA VBOT 4.8 ILU",    key = "vbot48ILU",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/vbot48ILU.lua" },
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

local widgetRaizDoJogo = g_ui.getRootWidget()
local painelVelhoJanelaB = widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos")
if painelVelhoJanelaB then painelVelhoJanelaB:destroy() end

-- 📐 DESIGN ATUALIZADO: Injetado texturas de imagem reais nos botoes do rodape
local designAbasPremiumOTUI = "MainWindow\n" ..
"  id: janelaBotoesMacrosRemotos\n" ..
"  size: 360 420\n" ..
"  text: Brinque Scripts Premium\n" ..
"  @onEscape: self:hide()\n" ..
"  padding: 12\n" ..
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
"    background-color: #000000B5\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    id: painelBotoesAbas\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 24\n" ..
"    margin-top: 5\n" ..
"    layout:\n" ..
"      type: horizontalBox\n" ..
"      spacing: 5\n" ..
"\n" ..
"  HorizontalSeparator\n" ..
"    id: sepSuperiorAbas\n" ..
"    anchors.top: painelBotoesAbas.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"\n" ..
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
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-border: 3\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 120 24\n" ..
"    margin-bottom: 5\n" ..
"\n" ..
"  Button\n" ..
"    id: btnLinkSuporte\n" ..
"    text: Suporte\n" ..
"    color: #00bfff\n" ..
"    font: verdana-11px-rounded\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-border: 3\n" ..
"    anchors.left: btnDesmarcarTudo.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 100 24\n" ..
"    margin-left: 6\n" ..
"    margin-bottom: 5\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtnMacros\n" ..
"    text: Ocultar\n" ..
"    font: cipsoftFont\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-border: 3\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 75 24\n" ..
"    margin-bottom: 5\n" ..
"    @onClick: self:getParent():hide()\n"

setupJanelaBotoesMacros = setupUI(designAbasPremiumOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros:hide()
-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2: DESIGN SEM BORDAS E BOTÕES COM IMAGEM - PARTE 2 DE 2
-- =============================================================================

local LISTA_CATEGORIAS_ABAS = { "HEALING", "CAVEBOT", "WAR", "EXTRAS", "VBOT4.8" }
local LISTA_LABEL_ABAS = { ["HEALING"]="Cura", ["CAVEBOT"]="Cave", ["WAR"]="War", ["EXTRAS"]="Extr", ["VBOT4.8"]="4.8" }

local widgetListaScroll = setupJanelaBotoesMacros.listaScrollMacrosAba
local botoesAbasCriados = {}
local referenciasCheckBoxesAbaAtiva = {}

local function renderizarConteudoDaAba(categoriaNome)
    configMestre.abaAbertaAtual = categoriaNome
    widgetListaScroll:destroyChildren()
    referenciasCheckBoxesAbaAtiva = {}

    for catKey, btnWidget in pairs(botoesAbasCriados) do
        if catKey == categoriaNome then
            btnWidget:setColor("#44ff44")
        else
            btnWidget:setColor("#ffffff")
        end
    end

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
            
            -- 🛡️ REMOVE AS BORDAS SILENCIOSAMENTE PARA FICAR TOTALMENTE LIMPO
            box:setBorderWidth(0)
            
            box.onClick = function(w)
                local val = not w:isChecked()
                w:setChecked(val)
                configMestre.macrosMarcados[item.key] = val
            end

            table.insert(referenciasCheckBoxesAbaAtiva, { widget = box, key = item.key })
        end
    end
end

local containerAbasBotoes = setupJanelaBotoesMacros.painelBotoesAbas
if containerAbasBotoes then
    for _, catNome in ipairs(LISTA_CATEGORIAS_ABAS) do
        local btnAba = g_ui.createWidget("Button", containerAbasBotoes)
        btnAba:setText(LISTA_LABEL_ABAS[catNome])
        btnAba:setFont("verdana-11px-rounded")
        
        -- Aplica a textura visual de botão premium também nas abas do topo
        btnAba:setImageSource("/bot/BRINQUE/imagens/BOTAO.png")
        btnAba:setImageBorder(3)
        
        btnAba:setHeight(22)
        btnAba:setWidth(62)
        
        btnAba.onClick = function()
            renderizarConteudoDaAba(catNome)
        end
        botoesAbasCriados[catNome] = btnAba
    end
end

renderizarConteudoDaAba(configMestre.abaAbertaAtual)

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
                if script then pcall(script) else print("[Erro] " .. macroAlvo.nome .. " - Erro: " .. tostring(syntaxErr)) end
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
