-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE PRIVADO VIA VERCEL - PARTE 1 DE 3
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

-- =============================================================================
-- 🌐 SUA LINK DA VERCEL REPLICADO
-- O carregador não usa links de RAW do GitHub; ele pede o nome do arquivo para a Vercel!
-- =============================================================================
local URL_API_VERCEL_MESTRE = "customotserver.vercel.app"

-- 📂 MAPEAMENTO EXATO DE SUBPASTAS - APENAS O NOME DO ARQUIVO FINAL .LUA
local SCRIPTS_DO_REPOSITORIO = {
    ["Ilusion"] = {
        { nome = "HEALING BRQ ILUSION",     key = "healingBRQ",       cat = "HEALING",     arquivo = "healingBRQ.lua" },
        { nome = "CAVEBOT COMPLETO ILU",    key = "cavebotILU",       cat = "CAVEBOT",     arquivo = "cavebotILU.lua" },
        { nome = "MAGIAS S/PK BRQ ILUSION",  key = "magiasempkBRQ",    cat = "WAR",         arquivo = "magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS ILU",   key = "extrasILU",        cat = "EXTRAS",      arquivo = "extrasILU.lua" }
    },
    ["Minimalist"] = {
        { nome = "HEALING BRQ MINIMALIST",   key = "healingMIN",       cat = "HEALING",     arquivo = "healingMIN.lua" },
        { nome = "CAVEBOT COMPLETO MIN",    key = "cavebotMIN",       cat = "CAVEBOT",     arquivo = "cavebotMIN.lua" },
        { nome = "FILTRO BATTLE BRQ",       key = "filtroBattle",     cat = "WAR",         arquivo = "Filtrobattle.lua" },
        { nome = "EXTRAS ESSENCIAIS MIN",   key = "extrasMIN",        cat = "EXTRAS",      arquivo = "extrasMIN.lua" }
    },
    ["Legedy"] = {
        { nome = "HEALING BRQ LEGEDY",      key = "healingLEG",       cat = "HEALING",     arquivo = "healingLEG.lua" },
        { nome = "CAVEBOT COMPLETO LEG",    key = "cavebotLEG",       cat = "CAVEBOT",     arquivo = "cavebotLEG.lua" },
        { nome = "WAR LEGEDY COMBAT",        key = "magiasempkLEG",    cat = "WAR",         arquivo = "magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS LEG",   key = "extrasLEG",        cat = "EXTRAS",      arquivo = "extrasLEG.lua" }
    }
}

-- Seleciona o pacote de tabelas do servidor ativo
local MAPA_MACROS_GUILDA = SCRIPTS_DO_REPOSITORIO[servidorAtivoNoMomento] or {}
-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE PRIVADO VIA VERCEL - PARTE 2 DE 3
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()
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

    -- Roda o construtor dinamico de labels e caixas de PvP
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
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE PRIVADO VIA VERCEL - PARTE 3 DE 3
-- =============================================================================

-- ESTEIRA HTTP PRIVADA VIA VERCEL (SOLICITA CADA TEXTO LUA SELECIONADO NA ENTRADA)
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
        print("[Brinque Scripts] Sincronizacao concluida via Vercel! Macros rodando em RAM.")
        loteJaEstaSendoBaixado = false 
        
        -- =====================================================================
        -- 🎵 GATILHO DE ÁUDIO REPARADO C++ (ESTALA NO FONE AO TERMINAR A ESTEIRA)
        -- =====================================================================
        local somCustomizadoBrinque = "/vBot_configs/confg/sounds/som.ogg"
        if g_resources.fileExists(somCustomizadoBrinque) then
            g_sound.play(somCustomizadoBrinque)
        else
            g_sound.play("/vBot_configs/confg/sounds/som.ogg")
        end
        -- =====================================================================
        
        return 
    end
    
    -- Checa se a CheckBox desse macro específico está marcada na memória do painel
    if configMestre.macrosMarcados[macroAlvo.key] == true then
        -- MODIFICAÇÃO SUPREMA: Pede o macro para a sua Vercel passando as chaves cruzadas
        local urlScriptPrivadoVercel = URL_API_VERCEL_MESTRE 
            .. "?hwid=" .. tostring(hwidDaMaquinaDoCliente)
            .. "&servidor=" .. tostring(servidorAtivoNoMomento)
            .. "&script=" .. tostring(macroAlvo.arquivo)
            .. "&nocache=" .. os.time()

        HTTP.get(urlScriptPrivadoVercel, function(content, err)
            if not err and content and content ~= "" and not content:find("ACESSO NEGADO") then
                local script, syntaxErr = loadstring(content)
                if script then 
                    pcall(script) 
                else 
                    print("[Erro Script] Falha ao compilar slot: " .. tostring(macroAlvo.nome) .. " - Erro: " .. tostring(syntaxErr)) 
                end
            end
            -- VELOCIDADE PERFORMANCE: Dispara o próximo macro da fila após 200ms
            schedule(200, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        -- Se o macro estiver desmarcado, pula imediatamente para o próximo
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

-- =============================================================================
-- GATILHO DE ARRANCADA DO COMPILADOR EM NUVEM (TIMEOUT SEGURO DE 300MS)
-- =============================================================================
schedule(300, function()
    if computadorEstaAutorizado then
        print("[Brinque Vercel] Inicializando download dos scripts privados de: " .. tostring(servidorAtivoNoMomento))
        executarFilaCustomizadaHTTP(1)
    else
        -- Proteção contra invasores: Se tentar forçar, limpa a Janela B na marra
        if painelDeMacrosJanelaB and painelDeMacrosJanelaB.listaScroll then
            painelDeMacrosJanelaB.listaScroll:destroyChildren()
        end
    end
end)
