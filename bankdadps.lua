-- =============================================================================
-- [NUVEM] BANCO DE DADOS GLOBAL DE CLIENTES E SERVIDORES - BRINQUE SCRIPTS
-- =============================================================================

-- 🔒 BANCO DE DADOS CENTRALIZADO (ATUALIZE SEUS CLIENTES APENAS AQUI)
BANCO_DADOS_CLIENTES = {
    ["Dono Brinque"] = {
        vence = "ilimitado",
        servidores = {
            ["CELESTIAL-HWID-37646993"] = "Ilusion",
            ["CELESTIAL-HWID-49966485"] = "Minimalist"
        }
    },
    ["Dono NTBK Brinque"] = {
        vence = "ilimitado",
        servidores = {
            ["CELESTIAL-HWID-0000000"] = "Ilusion",
            ["CELESTIAL-HWID-4049913"] = "Minimalist"
        }
    },
    ["Marcos"] = {
        vence = "01/10/2026",
        servidores = {
            ["CELESTIAL-HWID-00000000"] = "Ilusion",
            ["CELESTIAL-HWID-00000000"] = "Minimalist"
        }
    },
    ["Wesley"] = {
        vence = "12/09/2026",
        servidores = {
            ["CELESTIAL-HWID-10949865"] = "Ilusion"
        }
    }
}

-- =============================================================================
-- 🚀 COMO ADICIONAR UM NOVO SERVIDOR FÁCIL:
-- Basta colocar o nome do novo OT Server entre aspas dentro da lista abaixo!
-- Exemplo para adicionar um novo: , "Legedy", "NomeDoNovoOT"
-- =============================================================================
local LISTA_MESTRE_DE_SERVIDORES = { 
    "Ilusion", 
    "Minimalist", 
    "Legedy" 
}

-- =============================================================================
-- ⚙️ SINCRONIZADOR AUTOMÁTICO (NÃO MEXER NESTA PARTE)
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()
local setupMacrosWindow = widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros")

if setupMacrosWindow and setupMacrosWindow.comboServidores then
    local ultimaEscolhaSalva = setupMacrosWindow.comboServidores:getText()
    
    setupMacrosWindow.comboServidores:clear()
    for _, nomeOT in ipairs(LISTA_MESTRE_DE_SERVIDORES) do
        setupMacrosWindow.comboServidores:addOption(nomeOT)
    end
    
    if ultimaEscolhaSalva and ultimaEscolhaSalva ~= "" then
        setupMacrosWindow.comboServidores:setOption(ultimaEscolhaSalva)
    end
end
