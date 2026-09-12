-- =================================================================
-- SYSTEM DESIGN PREMIUM (PARTE 1) - ISOLADO CONTRA CONFLITOS
-- =================================================================

setDefaultTab("main")
UI.Separator()

-- Storage exclusivo do sistema de design de fundos para não colidir
if type(storage.brinqueDesignPremium) ~= "table" then
    storage.brinqueDesignPremium = {
        imagemSelecionada = "imagem1"
    }
end
local designConfig = storage.brinqueDesignPremium

local widgetRaizDoJogo = g_ui.getRootWidget()
local botWindow = modules.game_bot.botWindow
local contents = botWindow:recursiveGetChildById("contentsPanel")

-- Injeção do menu de imagens com IDs de botões totalmente isolados e exclusivos
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
]], contents)

-- Painel de escolhas renomeado na ID interna para evitar conflito de MainWindow
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
-- =================================================================
-- SYSTEM DESIGN PREMIUM (PARTE 2) - ISOLADO CONTRA CONFLITOS
-- =================================================================

-- [BLOCO 2] ARCO-ÍRIS RGB, DIRETÓRIO DO PERFIL E MAPEAMENTO DAS 5 TEXTURAS
local coresRGBDesign = { 
    "#FF0000", "#FF4000", "#FF8000", "#FFBF00",
    "#FFFF00", "#BFFF00", "#80FF00", "#40FF00",
    "#00FF00", "#00FF40", "#00FF80", "#00FFBF",
    "#00FFFF", "#00BFFF", "#0080FF", "#0040FF",
    "#0000FF", "#4000FF", "#8000FF", "#BF00FF",
    "#FF00FF", "#FF00BF", "#FF0080", "#FF0040" 
}
local indexCorDesign = 1

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
            contents:setBackgroundColor("alpha")
        else
            -- REVERÇÃO PURA PARA TEXTURA METÁLICA LISA (SEM EMENDAS / SEM MOSAICO)
            pcall(function() contents:unsetImageSource() end)
            contents:setImageSource("/images/ui/window")
            contents:setImageFixedRatio(false)
            contents:setImageRepeated(false)
            contents:setBackgroundColor("alpha")
        end
    end
end

-- MOTOR DE LEITURA REATIVO DO STORAGE
function aplicarFundoDoBot()
    local escolha = designConfig.imagemSelecionada
    
    if escolha == "padrao" then
        changeBotImage("padrao")
        if type(updateButtonsBot) == "function" then
            updateButtonsBot()
        end
        print(">>> [DESIGN] Imagem limpa. Textura METALICA LISA original do client restaurada!")
    elseif caminhosImagens[escolha] then
        changeBotImage(caminhosImagens[escolha])
        print(">>> [DESIGN] Sucesso ao aplicar background: " .. escolha:upper())
    end
end

-- [BLOCO 3] ANIMAÇÃO FUSIONADA COM VARIÁVEIS ISOLADAS (SEM ATROPELAR OUTROS MACROS)
local ticksAnimacaoDesign = 0
local estagioDesign = 1 
local estadoPiscaDesign = false

macro(100, function()
    if not menuImagensUI then return end
    local btnMestre = menuImagensUI.btnAlternarImagemFundo
    local b = menuImagensUI.barraLinksHorizontais
    
    if not btnMestre or not b then return end
    if not b.btnLinkD or not b.btnLinkI or not b.btnLinkS or not b.btnLinkW or not b.btnLinkGW then return end

    indexCorDesign = indexCorDesign + 1
    if indexCorDesign > #coresRGBDesign then indexCorDesign = 1 end

    ticksAnimacaoDesign = ticksAnimacaoDesign + 1

    if estagioDesign == 1 then
        -- [ESTÁGIO 1] A ONDA UNIFICADA
        local idxMestre = indexCorDesign
        local idxD = (indexCorDesign + 2) % #coresRGBDesign + 1
        local idxI = (indexCorDesign + 4) % #coresRGBDesign + 1
        local idxS = (indexCorDesign + 6) % #coresRGBDesign + 1
        local idxW = (indexCorDesign + 8) % #coresRGBDesign + 1
        local idxGW = (indexCorDesign + 10) % #coresRGBDesign + 1

        btnMestre:setColor(coresRGBDesign[idxMestre])
        b.btnLinkD:setColor(coresRGBDesign[idxD])
        b.btnLinkI:setColor(coresRGBDesign[idxI])
        b.btnLinkS:setColor(coresRGBDesign[idxS])
        b.btnLinkW:setColor(coresRGBDesign[idxW])
        b.btnLinkGW:setColor(coresRGBDesign[idxGW])

        if ticksAnimacaoDesign > 30 then
            estagioDesign = 2
            ticksAnimacaoDesign = 0
        end

    elseif estagioDesign == 2 then
        -- [ESTÁGIO 2] O TRAVA-COR UNIFICADO
        if ticksAnimacaoDesign > 15 then
            estagioDesign = 3
            ticksAnimacaoDesign = 0
            estadoPiscaDesign = true
        end

    elseif estagioDesign == 3 then
        -- [ESTÁGIO 3] O PISCA INSANO
        local corDoPisca = coresRGBDesign[indexCorDesign]
        
        if estadoPiscaDesign then
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
        
        estadoPiscaDesign = not estadoPiscaDesign

        if ticksAnimacaoDesign > 16 then
            estagioDesign = 1
            ticksAnimacaoDesign = 0
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

-- ATRIBUIÇÃO DOS CLIQUES PARA OS LINKS (AQUI O 'S' FICA EXCLUSIVO DO WHATSAPP)
if menuImagensUI and menuImagensUI.barraLinksHorizontais then
    local barra = menuImagensUI.barraLinksHorizontais
    barra.btnLinkD.onClick = function() g_platform.openUrl("https://discord.gg") end
    barra.btnLinkI.onClick = function() g_platform.openUrl("https://instagram.com") end
    barra.btnLinkS.onClick = function() g_platform.openUrl("https://whatsapp.com") end
    barra.btnLinkW.onClick = function() g_platform.openUrl("https://wa.me") end
    barra.btnLinkGW.onClick = function() g_platform.openUrl("https://whatsapp.com") end
end

if global_painelDesignImagens then
    global_painelDesignImagens.btnFundo1.onClick = function() designConfig.imagemSelecionada = "imagem1" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo2.onClick = function() designConfig.imagemSelecionada = "imagem2" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo3.onClick = function() designConfig.imagemSelecionada = "imagem3" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo4.onClick = function() designConfig.imagemSelecionada = "imagem4" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundo5.onClick = function() designConfig.imagemSelecionada = "imagem5" aplicarFundoDoBot() end
    global_painelDesignImagens.btnFundoPadrao.onClick = function() designConfig.imagemSelecionada = "padrao" aplicarFundoDoBot() end
    global_painelDesignImagens.closeBtn.onClick = function() global_painelDesignImagens:hide() end
end

botWindow:setWidth(216)
botWindow.closeButton:setImageColor("#363434")
botWindow.minimizeButton:setImageColor("#363434")

function updateButtonsBot()
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

for _, child in pairs(widgetRaizDoJogo:getChildren()) do 
    if child:getId() == "janelaEscolhaImagensDesignMestre" and child ~= global_painelDesignImagens then 
        child:destroy() 
    end
end

updateButtonsBot()
aplicarFundoDoBot()

UI.Separator()
