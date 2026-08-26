-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE DE PASTAS - PARTE 1 DE 3
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

-- Links base apontando diretamente para a raiz da sua estrutura de pastas do GitHub
local URL_BASE_REPOSITORIO = "https://raw.githubusercontent.com/zedojavascripts/javaserver/refs/heads/main/scripts/"

-- 📂 MAPEAMENTO EXATO DE SUBPASTAS DO SEU REPOSITÓRIO (FOTO)
local SCRIPTS_DO_REPOSITORIO = {
    ["Ilusion"] = {
        { nome = "HEALING BRQ ILUSION",     key = "healingBRQ",       cat = "HEALING",     url = URL_BASE_REPOSITORIO .. "sv_ilusion/healing/healingBRQ.lua" },
        { nome = "CAVEBOT COMPLETO ILU",    key = "cavebotILU",       cat = "CAVEBOT",     url = URL_BASE_REPOSITORIO .. "sv_ilusion/cavebot/cavebotILU.lua" },
        { nome = "MAGIAS S/PK BRQ ILUSION",  key = "magiasempkBRQ",    cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_ilusion/war/magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS ILU",   key = "extrasILU",        cat = "EXTRAS",      url = URL_BASE_REPOSITORIO .. "sv_ilusion/extras/extrasILU.lua" }
    },
    ["Minimalist"] = {
        { nome = "HEALING BRQ MINIMALIST",   key = "healingMIN",       cat = "HEALING",     url = URL_BASE_REPOSITORIO .. "sv_minimalist/healing/healingMIN.lua" },
        { nome = "CAVEBOT COMPLETO MIN",    key = "cavebotMIN",       cat = "CAVEBOT",     url = URL_BASE_REPOSITORIO .. "sv_minimalist/cavebot/cavebotMIN.lua" },
        { nome = "FILTRO BATTLE BRQ",       key = "filtroBattle",     cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_minimalist/war/Filtrobattle.lua" },
        { nome = "EXTRAS ESSENCIAIS MIN",   key = "extrasMIN",        cat = "EXTRAS",      url = URL_BASE_REPOSITORIO .. "sv_minimalist/extras/extrasMIN.lua" }
    },
    ["Legedy"] = {
        { nome = "HEALING BRQ LEGEDY",      key = "healingLEG",       cat = "HEALING",     url = URL_BASE_REPOSITORIO .. "sv_legend/healing/healingLEG.lua" },
        { nome = "CAVEBOT COMPLETO LEG",    key = "cavebotLEG",       cat = "CAVEBOT",     url = URL_BASE_REPOSITORIO .. "sv_legend/cavebot/cavebotLEG.lua" },
        { nome = "WAR LEGEDY COMBAT",        key = "magiasempkLEG",    cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_legend/war/magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS LEG",   key = "extrasLEG",        cat = "EXTRAS",      url = URL_BASE_REPOSITORIO .. "sv_legend/extras/extrasLEG.lua" }
    }
}

-- Seleciona o pacote de tabelas do servidor ativo
local MAPA_MACROS_GUILDA = SCRIPTS_DO_REPOSITORIO[servidorAtivoNoMomento] or {}
-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE DE PASTAS - PARTE 2 DE 3
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()

-- MIRA CIRÚRGICA: Puxa o painel de rolagem exclusivo da Janela B criada no PC
local painelDeMacrosJanelaB = widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos")

-- Se a Janela B de macros estiver ativa na memoria RAM do cliente, comeca a desenhar
if painelDeMacrosJanelaB and painelDeMacrosJanelaB.listaScroll then
    -- Destroi as CheckBoxes do servidor anterior para nao encavalar botoes
    painelDeMacrosJanelaB.listaScroll:destroyChildren()

    -- As 4 categorias exatas e as cores oficiais em alta definicao
    local ORDEM_CATEGORIAS = { "HEALING", "CAVEBOT", "WAR", "EXTRAS" }
    local CORES_CATEGORIAS = { 
        ["HEALING"] = "#44ff44", 
        ["CAVEBOT"] = "#00bfff", -- Azul ciano destacado para o Cavebot
        ["WAR"]     = "#ff4444", 
        ["EXTRAS"]  = "#e6bc22" 
    }

    -- Roda o construtor dinâmico de labels e caixas de PvP
    for _, nomeCat in ipairs(ORDEM_CATEGORIAS) do
        local div = g_ui.createWidget("Label", painelDeMacrosJanelaB.listaScroll)
        div:setText("-- " .. nomeCat .. " --")
        div:setFont("verdana-11px-rounded")
        div:setColor(CORES_CATEGORIAS[nomeCat])
        div:setMarginTop(5)
        div:setMarginBottom(2)

        for _, item in ipairs(MAPA_MACROS_GUILDA) do
            if item.cat == nomeCat then
                -- Vincula e sincroniza o estado da CheckBox com a memoria do storage principal
                if configMestre.macrosMarcados[item.key] == nil then 
                    configMestre.macrosMarcados[item.key] = true 
                end

                local box = g_ui.createWidget("CheckBox", painelDeMacrosJanelaB.listaScroll)
                box:setText(item.nome)
                box:setFont("verdana-11px-rounded")
                box:setHeight(16)
                box:setChecked(configMestre.macrosMarcados[item.key] == true)
                
                -- Grava na mesma hora o clique do jogador na tabela local para nao mofar
                box.onClick = function(w)
                    local val = not w:isChecked()
                    w:setChecked(val)
                    configMestre.macrosMarcados[item.key] = val
                end
            end
        end
    end
end
-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE DE PASTAS - PARTE 3 DE 3 (ÁUDIO CORRIGIDO)
-- =============================================================================

-- ESTEIRA HTTP DE INJEÇÃO EM MEMÓRIA (BAIXA APENAS OS SCRIPTS SELECIONADOS)
local loteJaEstaSendoBaixado = false

local function executarFilaCustomizadaHTTP(indice)
    -- Cruza a permissao global herdada do validador principal (new_items.lua)
    if not computadorEstaAutorizado then 
        print("[Seguranca] Sessao nao autorizada. Download de macros abortado.")
        return 
    end
    
    if indice == 1 then 
        if loteJaEstaSendoBaixado then return end 
        loteJaEstaSendoBaixado = true 
    end
    
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Brinque Scripts] Sincronizacao concluda! Macros da subpasta rodando em RAM.")
        loteJaEstaSendoBaixado = false 
        
        -- =====================================================================
        -- 🎵 GATILHO DE ÁUDIO CORRIGIDO (TOCA USANDO A FUNÇÃO NATIVA DO SEU BOT)
        -- =====================================================================
        local somCustomizadoBrinque = "/bot/Vs3_CUSTOM_PREMIUM/vBot_configs/confg/sounds/som.ogg"
        
        if g_resources.fileExists(somCustomizadoBrinque) then
            playSound(somCustomizadoBrinque) -- Toca o seu som se ele existir na pasta sounds
        else
            playSound("/sounds/som.ogg") -- Se não achar, toca o magnum nativo do bot
        end
        -- =====================================================================
        
        return 
    end
    
    -- Checa se a CheckBox desse macro específico está marcada na memória do painel
    if configMestre.macrosMarcados[macroAlvo.key] == true then
        -- Injeta quebra de cache para baixar sempre o script mais atualizado do GitHub
        HTTP.get(macroAlvo.url .. "?nocache=" .. os.time(), function(content, err)
            if not err and content and content ~= "" then
                local script, syntaxErr = loadstring(content)
                if script then 
                    pcall(script) 
                else 
                    print("[Erro Script] Falha ao compilar slot: " .. tostring(macroAlvo.nome) .. " - Erro: " .. tostring(syntaxErr)) 
                end
            end
            -- VELOCIDADE PERFORMANCE: Carrega o próximo macro da pasta após 200 milissegundos
            schedule(200, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        -- Se o macro estiver desmarcado, pula direto para o próximo da fila
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

-- =============================================================================
-- GATILHO DE ARRANCADA AUTOMÁTICA EM NUVEM (TIMEOUT SEGURO DE 300MS)
-- =============================================================================
schedule(300, function()
    if computadorEstaAutorizado then
        print("[Brinque] Inicializando download dos scripts da pasta de: " .. tostring(servidorAtivoNoMomento))
        executarFilaCustomizadaHTTP(1)
    else
        -- Proteção comercial: Se não houver acesso ativo para esse OT, limpa a tela dele
        if painelDeMacrosJanelaB and painelDeMacrosJanelaB.listaScroll then
            painelDeMacrosJanelaB.listaScroll:destroyChildren()
        end
    end
end)
