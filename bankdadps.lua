-- =============================================================================
-- [NUVEM] BANCO DE DADOS GLOBAL DE CLIENTES E SERVIDORES - BRINQUE SCRIPTS
-- =============================================================================

-- 🔒 BANCO DE DADOS CENTRALIZADO (ATUALIZE SEUS CLIENTES APENAS AQUI)
BANCO_DADOS_CLIENTES = {
    ["Dono Brinque"] = {
        vence = "ilimitado",
        servidores = {
            ["CELESTIAL-HWID-14233261"] = "Ilusion",
            ["CELESTIAL-HWID-45889926"] = "Brutal",
            ["CELESTIAL-HWID-4049913"] = "Minimalist"
        }
    },
    
    ["Dono NTBK Brinque"] = {
        vence = "ilimitado",
        servidores = {
            ["CELESTIAL-HWID-47"] = "Ilusion",
            ["CELESTIAL-HWID-4049913"] = "Minimalist"
        }
    },


    ["Matheus Samengudo"] = {
        vence = "26/09/2026",
        servidores = {
            ["CELESTIAL-HWID-38396807"] = "Ilusion",
            ["CELESTIAL-HWID-0000000"] = "Brutal",
            ["CELESTIAL-HWID-0000000"] = "Minimalist"
        }
    },

    ["Felipe Farias"] = {
        vence = "20/10/2026",
        servidores = {
            ["CELESTIAL-HWID-62223939"] = "Ilusion",
            ["CELESTIAL-HWID-0000000"] = "Brutal",
            ["CELESTIAL-HWID-0000000"] = "Minimalist"
        }
    },
    
    ["Daniel Velaski"] = {
        vence = "20/10/2026",
        servidores = {
            ["CELESTIAL-HWID-1570839"] = "Ilusion",
            ["CELESTIAL-HWID-0000000"] = "Brutal",
            ["CELESTIAL-HWID-0000000"] = "Minimalist"
        }
    },
    
    ["Kyan Rodrigo"] = {
        vence = "19/10/2026",
        servidores = {
            ["CELESTIAL-HWID-8481060"] = "Ilusion",
            ["CELESTIAL-HWID-597885"] = "Brutal",
            ["CELESTIAL-HWID-0000000"] = "Minimalist"
        }
    },
    
    ["Joao Bono"] = {
        vence = "29/10/2026",
        servidores = {
            ["CELESTIAL-HWID-85737931"] = "Ilusion",
            ["CELESTIAL-HWID-0000000"] = "Brutal",
            ["CELESTIAL-HWID-0000000"] = "Minimalist"
        }
    },
    
    ["Wesley Bigodeira"] = {
        vence = "09/11/2026",
        servidores = {
            ["CELESTIAL-HWID-10949865"] = "Ilusion",
            ["CELESTIAL-HWID-00000000"] = "Brutal",
            ["CELESTIAL-HWID-00000000"] = "Minimalist"
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
    "Brutal",
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
