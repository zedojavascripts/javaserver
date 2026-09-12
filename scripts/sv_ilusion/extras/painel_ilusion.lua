setDefaultTab("main")
UI.Separator()
-- Inicializa o storage expandido para gerenciar as 5 imagens ou o modo padrao
if type(storage.brinqueDesignPremium) ~= "table" then
    storage.brinqueDesignPremium = {
        imagemSelecionada = "imagem1"
    }
end
local designConfig = storage.brinqueDesignPremium

local widgetRaizDoJogo = g_ui.getRootWidget()
local botWindow = modules.game_bot.botWindow
local contents = botWindow:recursiveGetChildById("contentsPanel")

-- ALTERAÇÃO FÍSICA: Largura recalculada para 22px cada para acoplar o 5º botao de forma simétrica
local menuImagensUI = setupUI([[
Panel
  height: 52
  margin-top: 5
  layout:
    type: verticalBox
    spacing: 4

  Button
    id: btnAlternarImagemFundo
    text: Brinque scripts
    font: verdana-11px-rounded
    background-color: #00000088
    height: 22

  Panel
    id: barraLinksHorizontais
    height: 22
    margin-left: 2
    margin-right: 2
    layout:
      type: horizontalBox
      spacing: 4

    Button
      id: btnLinkD
      text: D
      font: verdana-11px-rounded
      color: #00bfff
      width: 31
      height: 30

    Button
      id: btnLinkI
      text: I
      font: verdana-11px-rounded
      color: #ff007f
      width: 31
      height: 30

    Button
      id: btnLinkS
      text: S
      font: verdana-11px-rounded
      color: #ffff00
      width: 31
      height: 30

    Button
      id: btnLinkW
      text: W
      font: verdana-11px-rounded
      color: #44ff44
      width: 31
      height: 30

    Button
      id: btnLinkGW
      text: GW
      font: verdana-9px-bold
      color: #556b2f
      width: 31
      height: 30
]], parent)

-- Painel de escolhas concatenado nativo do seu modelo estavel
local designPainelImagensOTUI = "MainWindow\n" ..
"  id: janelaEscolhaImagensDesignMestre\n" ..
"  !text: tr('Fundos Premium - BRQ')\n" ..
"  size: 240 250\n" ..
"  anchors.centerIn: parent\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: #1a1a1aef\n" ..
"  layout: anchor\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFundo1\n" ..
"    text: Aplicar Fundo 1\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    height: 22\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFundo2\n" ..
"    text: Aplicar Fundo 2\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFundo3\n" ..
"    text: Aplicar Fundo 3\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFundo4\n" ..
"    text: Aplicar Fundo 4\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFundo5\n" ..
"    text: Aplicar Fundo 5\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFundoPadrao\n" ..
"    text: Restaurar Padrao do Bot\n" ..
"    color: #ffaa00\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar Menu\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 20\n"

global_painelDesignImagens = setupUI(designPainelImagensOTUI, widgetRaizDoJogo)
global_painelDesignImagens:hide()
-- =============================================================================
-- [BLOCO 2] ARCO-ÍRIS RGB, DIRETÓRIO DO PERFIL E MAPEAMENTO DAS 5 TEXTURAS
-- =============================================================================

-- Tabela de cores completa que comanda a sincronia de toda a interface do bot
local colorsRGB = { 
    "#FF0000", "#FF4000", "#FF8000", "#FFBF00",
    "#FFFF00", "#BFFF00", "#80FF00", "#40FF00",
    "#00FF00", "#00FF40", "#00FF80", "#00FFBF",
    "#00FFFF", "#00BFFF", "#0080FF", "#0040FF",
    "#0000FF", "#4000FF", "#8000FF", "#BF00FF",
    "#FF00FF", "#FF00BF", "#FF0080", "#FF0040" 
}
local colorIndexRGB = 1

-- Rota dinamica que puxa as imagens de dentro do Perfil ativo no momento
local configProfileName = modules.game_bot.contentsPanel.config:getCurrentOption().text
local pathPastaImagens = "/bot/" .. configProfileName .. "/vBot_configs/confg/Imagens/"

-- Registro fixo para buscar os arquivos .png dentro do client customizado
local caminhosImagens = {
    imagem1 = pathPastaImagens .. "custompremium",
    imagem2 = pathPastaImagens .. "dourado_brinque",
    imagem3 = pathPastaImagens .. "dragon_brinque",
    imagem4 = pathPastaImagens .. "itachi_binque",
    imagem5 = pathPastaImagens .. "logobrinque"
}

-- Funcao nativa tatica para desenhar as customizadas ou a Textura Metalica Esticada Lisa
local function changeBotImage(path)
    if contents then
        if path and path ~= "" and path ~= " " and path ~= "padrao" then
            contents:setImageSource(path)
            contents:setImageFixedRatio(false)
            contents:setImageRepeated(false)
            contents:setBackgroundColor("alpha") -- Remove cor solida para mostrar a imagem customizada
        else
            -- REVERÇÃO PURA PARA TEXTURA METÁLICA LISA (SEM EMENDAS / SEM MOSAICO)
            pcall(function() contents:unsetImageSource() end)
            contents:setImageSource("/images/ui/window") -- Textura metalica nativa embutida
            contents:setImageFixedRatio(false) -- Permite esticar para preencher toda a Janela
            contents:setImageRepeated(false) -- DESATIVADO MOSAICO: Remove as emendas e camadas de quadradinhos!
            contents:setBackgroundColor("alpha")
        end
    end
end

-- MOTOR DE LEITURA REATIVO DO STORAGE (RESTAURADOR CINZA METÁLICO LISO)
function aplicarFundoDoBot()
    local escolha = designConfig.imagemSelecionada
    
    if escolha == "padrao" then
        changeBotImage("padrao") -- Cai no bloco de reset da textura metalica esticada sem divisorias
        
        -- Recarrega a estilizacao padrão dos botoes e janelas
        if type(updateButtonsBot) == "function" then
            updateButtonsBot()
        end
        print(">>> [DESIGN] Imagem limpa. Textura METALICA LISA original do client restaurada!")
    elseif caminhosImagens[escolha] then
        changeBotImage(caminhosImagens[escolha])
        print(">>> [DESIGN] Sucesso ao aplicar background: " .. escolha:upper())
    end
end
-- =============================================================================
-- [BLOCO 3] ANIMAÇÃO FUSIONADA (ONDA, TRAVA E PISCA), LINKS DO PRO E CLEAN RAM
-- =============================================================================

-- Controle interno da super animacao unificada de 3 estágios
local ticksAnimacao = 0
local estagioAtual = 1 -- 1 = Onda correndo, 2 = Trava estatica, 3 = Pisca total
local estadoPiscaGeral = false

-- Macro mestre de sincronizacao visual (100ms)
macro(100, function()
    if not menuImagensUI then return end
    local btnMestre = menuImagensUI.btnAlternarImagemFundo
    local b = menuImagensUI.barraLinksHorizontais
    
    if not btnMestre or not b then return end
    if not b.btnLinkD or not b.btnLinkI or not b.btnLinkS or not b.btnLinkW or not b.btnLinkGW then return end

    -- Avanca a cor base do arco-iris
    colorIndexRGB = colorIndexRGB + 1
    if colorIndexRGB > #colorsRGB then colorIndexRGB = 1 end

    ticksAnimacao = ticksAnimacao + 1

    if estagioAtual == 1 then
        -- [ESTÁGIO 1] A ONDA UNIFICADA: Degradê corre do botao mestre ate o ultimo menor
        local idxMestre = colorIndexRGB
        local idxD = (colorIndexRGB + 2) % #colorsRGB + 1
        local idxI = (colorIndexRGB + 4) % #colorsRGB + 1
        local idxS = (colorIndexRGB + 6) % #colorsRGB + 1
        local idxW = (colorIndexRGB + 8) % #colorsRGB + 1
        local idxGW = (colorIndexRGB + 10) % #colorsRGB + 1

        btnMestre:setColor(colorsRGB[idxMestre])
        b.btnLinkD:setColor(colorsRGB[idxD])
        b.btnLinkI:setColor(colorsRGB[idxI])
        b.btnLinkS:setColor(colorsRGB[idxS])
        b.btnLinkW:setColor(colorsRGB[idxW])
        b.btnLinkGW:setColor(colorsRGB[idxGW])

        -- Onda corre por 30 ticks (3 segundos)
        if ticksAnimacao > 30 then
            estagioAtual = 2
            ticksAnimacao = 0
        end

    elseif estagioAtual == 2 then
        -- [ESTÁGIO 2] O TRAVA-COR UNIFICADO: Todos congelam na cor brilhante onde a onda parou
        -- Mantem congelado por 15 ticks (1.5 segundos)
        if ticksAnimacao > 15 then
            estagioAtual = 3
            ticksAnimacao = 0
            estadoPiscaGeral = true
        end

    elseif estagioAtual == 3 then
        -- [ESTÁGIO 3] O PISCA INSANO: Botao mestre e os 5 menores piscam juntos em sincronia
        local corDoPisca = colorsRGB[colorIndexRGB]
        
        if estadoPiscaGeral then
            btnMestre:setColor(corDoPisca)
            b.btnLinkD:setColor(corDoPisca)
            b.btnLinkI:setColor(corDoPisca)
            b.btnLinkS:setColor(corDoPisca)
            b.btnLinkW:setColor(corDoPisca)
            b.btnLinkGW:setColor(corDoPisca)
        else
            btnMestre:setColor("#ffffff")
            b.btnLinkD:setColor("#ffffff")
            b.btnLinkI:setColor("#ffffff")
            b.btnLinkS:setColor("#ffffff")
            b.btnLinkW:setColor("#ffffff")
            b.btnLinkGW:setColor("#ffffff")
        end
        
        estadoPiscaGeral = not estadoPiscaGeral

        -- Metralha o pisca por 16 ticks (1.6 segundos) e reinicia o ciclo
        if ticksAnimacao > 16 then
            estagioAtual = 1
            ticksAnimacao = 0
        end
    end
end)

-- Acao de Clique no botao Principal: Abre e fecha o Painel de Escolhas
menuImagensUI.btnAlternarImagemFundo.onClick = function()
    if global_painelDesignImagens then
        if global_painelDesignImagens:isVisible() then
            global_painelDesignImagens:hide()
        else
            global_painelDesignImagens:show()
            global_painelDesignImagens:raise()
            global_painelDesignImagens:focus()
        end
    end
end

-- ATRIBUIÇÃO DOS CLIQUES PARA OS 5 BOTÕES DE LINKS DA ABA MAIN (MODO SEGURO)
if menuImagensUI and menuImagensUI.barraLinksHorizontais then
    local barra = menuImagensUI.barraLinksHorizontais
    barra.btnLinkD.onClick = function() g_platform.openUrl("https://discord.gg/BRNzJ7cZjq") end
    barra.btnLinkI.onClick = function() g_platform.openUrl("https://www.instagram.com/brinquescriptsgamer?igsh=dXhhN2MxNWhxMm9m") end
    barra.btnLinkS.onClick = function() g_platform.openUrl("https://chat.whatsapp.com/KH06HKx6tkq2cjOB0F4k4P") end
    barra.btnLinkW.onClick = function() g_platform.openUrl("https://wa.me/qr/QHQWPAJNPYRDJ1") end
    
    -- [GW] - Seu novo botao de Guild War / Clan (Altere o link para o seu site se desejar)
    barra.btnLinkGW.onClick = function() g_platform.openUrl("https://chat.whatsapp.com/KH06HKx6tkq2cjOB0F4k4P") end
end

-- ATRIBUIÇÃO DOS CLIQUES INDIVIDUAIS DO PAINEL DE CONFIGURAÇÃO DE IMAGENS
if global_painelDesignImagens then
    global_painelDesignImagens.btnFundo1.onClick = function() designConfig.imagemSelecionada = "imagem1" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo2.onClick = function() designConfig.imagemSelecionada = "imagem2" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo3.onClick = function() designConfig.imagemSelecionada = "imagem3" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo4.onClick = function() designConfig.imagemSelecionada = "imagem4" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo5.onClick = function() designConfig.imagemSelecionada = "imagem5" aplicarFundoDoBot() end

    -- Botao de Pânico: Reseta a imagem para a Textura Metalica Lisa de fabrica
    global_painelDesignImagens.btnFundoPadrao.onClick = function() 
        designConfig.imagemSelecionada = "padrao" 
        aplicarFundoDoBot() 
    end

    -- Botao de Fechar do Painel
    global_painelDesignImagens.closeBtn.onClick = function() 
        global_painelDesignImagens:hide() 
    end
end

-- Configurações visuais nativas e travadas da janela mestre por Brinque Premium
botWindow:setWidth(216)
botWindow.closeButton:setImageColor("#363434")
botWindow.minimizeButton:setImageColor("#363434")

local function updateButtonsBot()
    modules.game_bot.botWindow.closeButton:setImageColor("#363434")
    modules.game_bot.botWindow.minimizeButton:setImageColor("#363434")
    modules.game_bot.botWindow.lockButton:setImageColor("#363434")
    modules.game_bot.botWindow:setImageSource()
    modules.game_bot.botWindow:setBackgroundColor("black")
    modules.game_bot.botWidth = 216
    modules.game_bot.botWindow:setBorderWidth(1)
    modules.game_bot.botWindow:setBorderColor("black")
    modules.game_bot.botWindow:setText("BRINQUE PREMIUM")
    modules.game_bot.botWindow:setFont("verdana-11px-rounded")
    modules.game_bot.botWindow:setColor("red")
end

-- VARREDURA DE LIMPEZA RAM CONTRA JANELAS DUPLICADAS POR RELOAD
for _, child in pairs(widgetRaizDoJogo:getChildren()) do 
    if child:getId() == "janelaEscolhaImagensDesignMestre" and child ~= global_painelDesignImagens then 
        child:destroy() 
    end
end

-- Roda as atualizações de inicialização fixa do client de War
updateButtonsBot()
aplicarFundoDoBot()

-- SEU SEPARADOR FINAL EMBUTIDO ABAIXO DE TODO O CONJUNTO
UI.Separator()
