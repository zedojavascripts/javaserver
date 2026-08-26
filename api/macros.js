const https = require('https');

module.exports = async (req, res) => {
    // Configura a resposta como texto limpo
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');
    
    // Puxa o Token ghp_... que está escondido no cofre da Vercel
    const tokenOculto = process.env.GITHUB_TOKEN;

    // 🧪 ALVO DO TESTE: Busca o banco_dados.lua solto na pasta scripts/
    const configuracaoRequest = {
        hostname: '://github.com',
        path: `/repos/brinquescriptsgamer-bot/customotserver/contents/scripts/banco_dados.lua`,
        headers: {
            'Authorization': `token ${tokenOculto}`,
            'User-Agent': 'Vercel-Testing-Pure',
            'Accept': 'application/vnd.github.v3.raw' // Traz o texto puro do .lua
        }
    };

    // Dispara a requisição invisível para o GitHub privado
    https.get(configuracaoRequest, (resposta) => {
        let dadosAcumulados = '';
        resposta.on('data', (pedaco) => { dadosAcumulados += pedaco; });
        resposta.on('end', () => {
            if (resposta.statusCode === 200) {
                // SUCESSO: Achou o Token e o arquivo, devolve o texto do banco!
                return res.status(200).send(dadosAcumulados);
            } else {
                // ERRO: Devolve qual foi o código de rejeição do GitHub (Ex: 404 ou 401)
                return res.status(resposta.statusCode).send(`ERRO_GITHUB_STATUS_${resposta.statusCode}`);
            }
        });
    }).on('error', () => {
        return res.status(500).send("ERRO_CONEXAO_FISICA_NUVEM");
    });
};
