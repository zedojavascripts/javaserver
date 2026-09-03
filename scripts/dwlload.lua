-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2 MESTRE: CONTROLE MANUAL DE COORDENADAS - PARTE 1 DE 2
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

if not configMestre.abaAbertaAtual then configMestre.abaAbertaAtual = "HEALING" end

if not configMestre.janelaX then configMestre.janelaX = 300 end
if not configMestre.janelaY then configMestre.janelaY = 200 end

local BASE_RAW_PUBLICO = "https://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/scripts/"

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

-- =============================================================================
-- 🛠️ COFRE DE REGULAGEM MANUAL: ALTERE OS NÚMEROS ABAIXO PARA MOVER OS ITENS
-- =============================================================================
local TAMANHO_LARGURA      = "430"  -- Largura da janela total
local TAMANHO_ALTURA       = "480"  -- Altura da janela total

-- 📊 CONFIGURAÇÃO DAS ABAS DO TOPO (CURA, CAVE, WAR...)
local ABAS_DISTANCIA_TOPO  = "60"   -- Afasta ou aproxima as abas do topo da janela
local ABAS_DISTANCIA_ESQ   = "48"   -- Move o bloco de abas para a esquerda ou direita
local ABAS_ESPACAMENTO     = "-5"    -- Espaço em pixels de uma aba para a outra
local ABA_LARGURA_BOTAO    = "55"   -- Largura individual de cada botão de aba
local ABA_ALTURA_BOTAO     = "19"   -- Altura individual de cada botão de aba

-- 📋 CONFIGURAÇÃO DA LISTA CENTRAL DE CHECKBOXES (CONTEÚDO DOS MACROS)
local LISTA_DISTANCIA_TOPO = "80"   -- Distância do conteúdo em relação ao topo
local LISTA_DISTANCIA_ESQ  = "35"   -- Afasta os nomes dos macros da parede esquerda
local LISTA_LARGURA_AREA   = "350"  -- Largura da área onde os macros ficam listados
local LISTA_ALTURA_AREA    = "290"  -- Altura da área de rolagem dos macros

-- 🎛️ CONFIGURAÇÃO DOS BOTÕES DO RODAPÉ (LIMPAR, SUPORTE, OCULTAR)
local RODAPE_DISTANCIA_BOT = "95"   -- Distância fixa de todos os botões em relação ao fundo
local BTN_LIMPAR_ESQ       = "100"   -- Posição horizontal do botão Limpar Aba
local BTN_SUPORTE_ESQ      = "200"  -- Posição horizontal do botão Suporte
local BTN_OCULTAR_DIREITA  = "35"   -- Afastamento do botão Ocultar em relação à parede direita

-- =============================================================================
-- 📐 CONSTRUTOR OTUI DESACOPLADO E TOTALMENTE CONFIGURÁVEL MANUALMENTE
-- =============================================================================
local designAbasPremiumOTUI = "UIWindow\n" ..
"  id: janelaBotoesMacrosRemotos\n" ..
"  size: " .. TAMANHO_LARGURA .. " " .. TAMANHO_ALTURA .. "\n" ..
"  draggable: true\n" ..
"  clipping: true\n" ..
"  @onEscape: self:hide()\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoMacros\n" ..
"    image-source: /bot/BRINQUE/imagens/minimalistum.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    margin: 0\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000005\n" ..
"    anchors.fill: parent\n" ..
"    margin: 0\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    id: painelBotoesAbas\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: " .. ABAS_DISTANCIA_TOPO .. "\n" ..
"    margin-left: " .. ABAS_DISTANCIA_ESQ .. "\n" ..
"    size: " .. tostring((tonumber(ABA_LARGURA_BOTAO) * 5) + (tonumber(ABAS_ESPACAMENTO) * 4)) .. " " .. ABA_ALTURA_BOTAO .. "\n" ..
"    layout:\n" ..
"      type: horizontalBox\n" ..
"      spacing: " .. ABAS_ESPACAMENTO .. "\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: listaScrollMacrosAba\n" ..
"    background-color: #00000000\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: " .. LISTA_DISTANCIA_TOPO .. "\n" ..
"    margin-left: " .. LISTA_DISTANCIA_ESQ .. "\n" ..
"    size: " .. LISTA_LARGURA_AREA .. " " .. LISTA_ALTURA_AREA .. "\n" ..
"    vertical-scrollbar: barraRolagemAbas\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: barraRolagemAbas\n" ..
"    anchors.top: listaScrollMacrosAba.top\n" ..
"    anchors.bottom: listaScrollMacrosAba.bottom\n" ..
"    anchors.left: listaScrollMacrosAba.right\n" ..
"    margin-left: 5\n" ..
"    step: 16\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Button\n" ..
"    id: btnDesmarcarTudo\n" ..
"    text: [X] Limpar Aba\n" ..
"    color: #ff4444\n" ..
"    font: verdana-11px-rounded\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-border: 5\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    margin-left: " .. BTN_LIMPAR_ESQ .. "\n" ..
"    margin-bottom: " .. RODAPE_DISTANCIA_BOT .. "\n" ..
"    size: 115 24\n" ..
"\n" ..
"  Button\n" ..
"    id: btnLinkSuporte\n" ..
"    text: Suporte\n" ..
"    color: #00bfff\n" ..
"    font: verdana-11px-rounded\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-border: 5\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    margin-left: " .. BTN_SUPORTE_ESQ .. "\n" ..
"    margin-bottom: " .. RODAPE_DISTANCIA_BOT .. "\n" ..
"    size: 105 24\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtnMacros\n" ..
"    text: Ocultar\n" ..
"    font: cipsoftFont\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-border: 5\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    margin-right: " .. BTN_OCULTAR_DIREITA .. "\n" ..
"    margin-bottom: " .. RODAPE_DISTANCIA_BOT .. "\n" ..
"    size: 85 24\n" ..
"    @onClick: self:getParent():hide()\n"

setupJanelaBotoesMacros = setupUI(designAbasPremiumOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros:setPosition({x = configMestre.janelaX, y = configMestre.janelaY})
setupJanelaBotoesMacros:hide()
-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2 MESTRE: CONTROLE MANUAL DE COORDENADAS - PARTE 2 DE 2
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
    local larguraBotaoDefinida = tonumber(ABA_LARGURA_BOTAO) or 74
    local alturaBotaoDefinida = tonumber(ABA_ALTURA_BOTAO) or 22

    for _, catNome in ipairs(LISTA_CATEGORIAS_ABAS) do
        local btnAba = g_ui.createWidget("Button", containerAbasBotoes)
        btnAba:setText(LISTA_LABEL_ABAS[catNome])
        btnAba:setFont("verdana-11px-rounded")
        
        btnAba:setImageSource("/bot/BRINQUE/imagens/BOTAO.png")
        btnAba:setImageBorder(5)
        
        btnAba:setHeight(alturaBotaoDefinida)
        btnAba:setWidth(larguraBotaoDefinida)
        
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

-- Rastreia o movimento de arrasto manual em Lua e joga as coordenadas no storage mestre
setupJanelaBotoesMacros.onGeometryChange = function(widget)
    local pos = widget:getPosition()
    if pos and pos.x and pos.y and pos.x > 0 and pos.y > 0 then
        configMestre.janelaX = pos.x
        configMestre.janelaY = pos.y
    end
end

local loteJaEstaSendoBaixado = false

local function poolDeDownloadsHTTP(indice)
    if not computadorEstaAutorizado then return end
    
    if indice == 1 then 
        if loteJaEstaSendoBaixado then return end 
        loteJaEstaSendoBaixado = true 
    end
    
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Brinque] Sincronizacao Concluida! Painel Desacoplado Ativo.")
        loteJaEstaSendoBaixado = false 
        
        if setupJanelaBotoesMacros then
            setupJanelaBotoesMacros:show()
            setupJanelaBotoesMacros:raise()
        end
        return 
    end
    
    if macroAlvo.oculto or configMestre.macrosMarcados[macroAlvo.key] == true then
        local urlScript = BASE_RAW_PUBLICO .. macroAlvo.arquivo .. "?nocache=" .. os.time()

        HTTP.get(urlScript, function(content, err)
            if not err and content and content ~= "" then
                local script, syntaxErr = loadstring(content)
                if script then pcall(script) else print("[Erro] " .. macroAlvo.nome .. " - Erro: " .. tostring(syntaxErr)) end
            end
            schedule(150, function() poolDeDownloadsHTTP(indice + 1) end)
        end)
    else
        poolDeDownloadsHTTP(indice + 1)
    end
end

schedule(300, function()
    if computadorEstaAutorizado then
        print("[Brinque] Inicializando download estruturado de: " .. tostring(servidorAtivoNoMomento))
        poolDeDownloadsHTTP(1)
    end
end)
