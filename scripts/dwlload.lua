-- =============================================================================
-- [NUVEM PRIVADA] ARQUIVO 2 MESTRE: CARREGADOR DE MACROS VIA VERCEL API
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

-- 🌐 REPLICAÇÃO DO SEU LINK OFICIAL DA VERCEL
local URL_API_VERCEL_MESTRE = "customotserver.vercel.app"

-- 📂 MAPEAMENTO EXATO DA SUA ÁRVORE DE PASTAS (APENAS O NOME DO ARQUIVO FINAL)
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

local MAPA_MACROS_GUILDA = SCRIPTS_DO_REPOSITORIO[servidorAtivoNoMomento] or {}

-- =============================================================================
-- [CONSTRUTOR DO PAINEL VERTICAL ESTÁVEL DE CHECKBOXES]
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()
local painelDeMacrosJanelaB = widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos")

if painelDeMacrosJanelaB and painelDeMacrosJanelaB.listaScroll then
    painelDeMacrosJanelaB.listaScroll:destroyChildren()

    local ORDEM_CATEGORIAS = { "HEALING", "CAVEBOT", "WAR", "EXTRAS" }
    local CORES_CATEGORIAS = { 
        ["HEALING"] = "#44ff44", 
        ["CAVEBOT"] = "#00bfff", 
        ["WAR"]     = "#ff4444", 
        ["EXTRAS"]  = "#e6bc22" 
    }

    for _, nomeCat in ipairs(ORDEM_CATEGORIAS) do
        local div = g_ui.createWidget("Label", painelDeMacrosJanelaB.listaScroll)
        div:setText("-- " .. nomeCat .. " --")
        div:setFont("verdana-11px-rounded")
        div:setColor(CORES_CATEGORIAS[nomeCat])
        div:setMarginTop(5)
        div:setMarginBottom(2)

        for _, item in ipairs(MAPA_MACROS_GUILDA) do
            if item.cat == nomeCat then
                if configMestre.macrosMarcados[item.key] == nil then 
                    configMestre.macrosMarcados[item.key] = true 
                end

                local box = g_ui.createWidget("CheckBox", painelDeMacrosJanelaB.listaScroll)
                box:setText(item.nome)
                box:setFont("verdana-11px-rounded")
                box:setHeight(16)
                box:setChecked(configMestre.macrosMarcados[item.key] == true)
                
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
-- [ESTEIRA HTTP ASSÍNCRONA E REDIRECIONADA VIA VERCEL]
-- =============================================================================
local loteJaEstaSendoBaixado = false

local function executarFilaCustomizadaHTTP(indice)
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
        
        -- 🎵 EFEITO SONORO C++ DE SUCESSO AO CONCLUIR
        local somCustomizadoBrinque = "/vBot_configs/confg/sounds/som.ogg"
        if g_resources.fileExists(somCustomizadoBrinque) then
            g_sound.play(somCustomizadoBrinque)
        else
            g_sound.play("/vBot_configs/confg/sounds/som.ogg")
        end
        return 
    end
    
    if configMestre.macrosMarcados[macroAlvo.key] == true then
        -- ROTA DE SEGURANÇA: Solicita o arquivo privado intermediado pela Vercel
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
            -- Intervalo fixo anti-congelamento para carregar em escada suave
            schedule(200, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
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
        if painelDeMacrosJanelaB and painelDeMacrosJanelaB.listaScroll then
            painelDeMacrosJanelaB.listaScroll:destroyChildren()
        end
    end
end)
