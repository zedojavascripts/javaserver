// =============================================================================
// [VERCEL API] TESTE ULTRA-EXTREMO: BUSCA BRUTA DIRETA SEM NENHUMA VALIDAÇÃO
// =============================================================================

const https = require('https');

module.exports = async (req, res) => {
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');

    // Tenta pegar o Token oculto que salvamos no painel da Vercel
    const tokenOculto = process.env.GITHUB_TOKEN;

    // 🧪 CAMINHO FIXO DIRETO DA FOTO DO REPOSITÓRIO:
    // Se o arquivo healingBRQ.lua estiver exatamente nessa pasta, a Vercel vai achar!
    const caminhoFixoDoTeste = "scripts/sv_ilusion/healing/healingBRQ.lua";

    const configuracaoRequest = {
        hostname: '://github.com',
        path: `/repos/brinquescriptsgamer-bot/customotserver/contents/${caminhoFixoDoTeste}`,
        headers: {
            'Authorization': `token ${tokenOculto}`,
            'User-Agent': 'Vercel-Serverless-Function',
            'Accept': 'application/vnd.github.v3.raw'
        }
    };

    // Faz a chamada crua e direta para o GitHub Privado
    https.get(configuracaoRequest, (resposta) => {
        let dadosAcumulados = '';
        resposta.on('data', (pedaco) => { dadosAcumulados += pedaco; });
        resposta.on('end', () => {
            if (resposta.statusCode === 200) {
                // Se o GitHub aceitou o Token e achou o arquivo, cospe o código Lua de volta!
                return res.status(200).send(dadosAcumulados);
            } else {
                // Se deu erro, avisa qual foi o código de erro do GitHub (Ex: 404 ou 401)
                return res.status(resposta.statusCode).send(`-- [Erro GitHub] O servidor do GitHub recusou o pedido com o status: ${resposta.statusCode} --`);
            }
        });
    }).on('error', (erroNet) => {
        return res.status(500).send(`-- [Erro Net] Falha fisica de conexao na nuvem --`);
    });
};
