-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2 MESTRE: BOTÃO FECHAR REMOVIDO (FIM) - PARTE 1 DE 2
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

    -- ==========================================
    -- MACROS COM PRIORIDADE (HEALING)
    -- ==========================================
        { nome = "HEALING BRQ ILUSION",     key = "healingBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/healing_ilusion.lua" },
        { nome = "ENEGY BRQ ILUSION",     key = "enegyBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/enegy_ilusion.lua" },
		{ nome = "BLESSED BRQ ILUSION",     key = "blessedBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/stamin_ilusion.lua" },
	    { nome = "BUFF BRQ ILUSION",     key = "buffBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/buff_ilusion.lua" },
        { nome = "STAMINA BRQ ILUSION",     key = "staminBRQ",       cat = "HEALING",     arquivo = "sv_ilusion/healing/stamin_ilusion.lua" },
		
	-- ==========================================
        { nome = "FILTRO BATTLE BRQ ILUSION",   key = "filtroBRQ",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/filtrobatle_ilusion.lua" },
        { nome = "SKILLS BRQ ILUSION",   key = "skillsBRQ",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/skills_ilusion.lua" },

	-- ==========================================
    -- MACROS COM PRIORIDADE (CAVEBOT)
    -- ==========================================
        { nome = "ALARME VBOT4.8 ILU",    key = "alarmeBRQ",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/alarmeVBOT4.8_ilusion.lua" },
        { nome = "FUGAIR-1.0 BRQ ILUSION",    key = "fugirBRQ",       cat = "CAVEBOT",     arquivo = "sv_ilusion/cave_target/fugir_ilusion.lua" },
        { nome = "OLHEIRO-1.0 BRQ ILUSION",    key = "olheiroBRQ",       cat = "CAVEBOT",     arquivo = "sv_ilusion/cave_target/olheiro_ilusion.lua" },
        { nome = "ATTACK LABEL BRQ ILUSION",    key = "attacklabelBRQ",       cat = "CAVEBOT",     arquivo = "sv_ilusion/cave_target/attack_label_ilusion.lua" },
        { nome = "FUGIR LABEL BRQ ILUSION",    key = "fugirlabelBRQ",       cat = "CAVEBOT",     arquivo = "sv_ilusion/cave_target/fugir_label_ilusion.lua" },


    -- ==========================================
    -- MACROS COM PRIORIDADE (WAR)
    -- ==========================================
        { nome = "CENTRAL DE SUPORTE BRQ ILUSION",  key = "centralsuporteBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/central_suporte_ilusion.lua" },
        { nome = "COMBO LIDER BRQ ILUSION",  key = "comboliderBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/combolider_ilusion.lua" },
		{ nome = "EXIVA BRQ ILUSION",  key = "exivaBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/exiva_ilusion.lua" },
        { nome = "PUSHE MOUSE BRQ ILUSION",  key = "pushemouseBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/pushe_mouse_ilusion.lua" },
        { nome = "PUSHE WAR BRQ ILUSION",  key = "pushewarBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/pushe_war_ilusion.lua" },
        { nome = "PUSHE TECLAS BRQ ILUSION",  key = "pusheteclasBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/pushe_teclas_ilusion.lua" },
        { nome = "PUSHE ICONS BRQ ILUSION",  key = "pusheiconsBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/pushe_icons_ilusion.lua" },
        { nome = "ANT PUSHE BRQ ILUSION",  key = "antpusheBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/ant_pushe_ilusion.lua" },
        { nome = "CENTRAL RUNAS BRQ ILUSION",  key = "centralrunasBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/central_runas_ilusion.lua" },
        { nome = "ATTACK TODOS BRQ ILUSION",  key = "attacktodosBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/attack_todos_ilusion.lua" },
        { nome = "BUG MAP BRQ ILUSION",  key = "bugmapBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/bug_map_ilusion.lua" },
        { nome = "WAR VISUAL BRQ ILUSION",  key = "warvisualBRQ",    cat = "WAR",         arquivo = "sv_ilusion/war/war_visual_ilusion.lua" },


	-- ==========================================
    -- MACROS COM PRIORIDADE (EXTRAS)
    -- ==========================================
        { nome = "EXTRAS BRQ ILUSION",   key = "extrasBRQ",        cat = "VBOT4.8",      arquivo = "sv_ilusion/extras/extrasVBOT4.8_ilusion.lua" },
        { nome = "CENTRAL DE ICONS BRQ ILUSION",   key = "centraliconsBRQ",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/central_icons_ilusion.lua" },
        { nome = "HUD COLOR BRQ ILUSION",   key = "hudcolorBRQ",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/hud_color_ilusion.lua" },
        { nome = "RAINBOW COLOR BRQ ILUSION",   key = "rainbowcolorBRQ",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/rainbow_color_ilusion.lua" },
        { nome = "BAIXO FPS BRQ ILUSION",   key = "baixofpsBRQ",        cat = "EXTRAS",      arquivo = "sv_ilusion/extras/baixo_fps_ilusion.lua" },

    -- ==========================================
    -- MACROS COM PRIORIDADE (VBOT4.8)
    -- ==========================================
        { nome = "CONDITIONS VBOT4.8 ILU",    key = "conditionsBRQ",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/conditionsVBOT4.8_ilusion.lua" },
        { nome = "EQ MANAGER VBOT4.8 ILU",    key = "eqmanagerBRQ",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/eq_managerVBOT4.8_ilusion.lua" },
        { nome = "NEW HEALER VBOT4.8 ILU",    key = "newhealerBRQ",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/new_healerVBOT4.8_ilusion.lua" },
        { nome = "HOLD TARGET VBOT4.8 ILU",    key = "holdtargetBRQ",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/hold_targetVBOT4.8_ilusion.lua" },
        { nome = "FOOD VBOT4.8 ILU",    key = "foodVBOT",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/foodVBOT4.8_ilusion.lua" },
        { nome = "PLAY LIST VBOT4.8 ILU",    key = "playlistVBOT",        cat = "VBOT4.8",     arquivo = "sv_ilusion/extras/playlistVBOT4.8_ilusion.lua" },

    -- ==========================================
    -- MACROS COM PRIORIDADE (OCULTO)
    -- ==========================================
        { nome = "PAINEL BRQ ILUSION",       key = "painelBRQ",        cat = "OCULTO",      arquivo = "sv_ilusion/extras/painel_ilusion.lua", oculto = true },
        { nome = "FORUM BRQ ILUSION",          key = "forumBRQ",         cat = "OCULTO",      arquivo = "sv_ilusion/extras/forum_ilusion.lua",  oculto = true }
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
-- 🛠️ COFRE DE REGULAGEM MANUAL: CONSERVE OS SEUS NÚMEROS AQUI
-- =============================================================================
local TAMANHO_LARGURA      = "450"
local TAMANHO_ALTURA       = "500"

local ABAS_DISTANCIA_TOPO  = "60"
local ABAS_DISTANCIA_ESQ   = "85"
local ABAS_ESPACAMENTO     = "10"
local ABA_LARGURA_BOTAO    = "55"
local ABA_ALTURA_BOTAO     = "19"

local LISTA_DISTANCIA_TOPO = "80"
local LISTA_DISTANCIA_ESQ  = "60"
local LISTA_LARGURA_AREA   = "300"
local LISTA_ALTURA_AREA    = "290"

local RODAPE_DISTANCIA_BOT = "60"
local BTN_LIMPAR_ESQ       = "100"
local BTN_SUPORTE_ESQ      = "200"

-- =============================================================================
-- 📐 CONSTRUTOR OTUI - REMOVIDO TOTALMENTE O BOTÃO CLOSE DO CÓDIGO DO RODAPÉ
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
"  Panel\n" ..
"    id: sepInferior\n" ..
"    background-color: #00000000\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: btnDesmarcarTudo.top\n" ..
"    height: 1\n" ..
"    margin-bottom: 8\n" ..
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
"    size: 105 24\n"

setupJanelaBotoesMacros = setupUI(designAbasPremiumOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros:setPosition({x = configMestre.janelaX, y = configMestre.janelaY})
setupJanelaBotoesMacros:hide()
-- =============================================================================
-- [NUVEM PÚBLICA] ARQUIVO 2 MESTRE: BOTÃO FECHAR REMOVIDO (FIM) - PARTE 2 DE 2
-- =============================================================================

local LISTA_CATEGORIAS_ABAS = { "HEALING", "CAVEBOT", "WAR", "EXTRAS", "VBOT4.8" }
local LISTA_LABEL_ABAS = { ["HEALING"]="HEALING", ["CAVEBOT"]="CAVEBOT", ["WAR"]="WAR", ["EXTRAS"]="EXTRAS", ["VBOT4.8"]="VBOT4.8" }

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
    local linkSuporteZap = "https://wa.me/qr/QHQWPAJNPYRDJ1"
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
            schedule(130, function() poolDeDownloadsHTTP(indice + 1) end)
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
