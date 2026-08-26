const https = require('https');

module.exports = async (req, res) => {
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');
    const tokenOculto = process.env.GITHUB_TOKEN;

    // 🧪 CAMINHO ULTRA-SIMPLES: Busca o banco solto na pasta scripts
    const configuracaoRequest = {
        hostname: '://github.com',
        path: `/repos/brinquescriptsgamer-bot/customotserver/banco_dados.lua`,
        headers: {
            'Authorization': `token ${tokenOculto}`,
            'User-Agent': 'Vercel-Testing',
            'Accept': 'application/vnd.github.v3.raw'
        }
    };

    https.get(configuracaoRequest, (resposta) => {
        let dados = '';
        resposta.on('data', (p) => { dados += p; });
        resposta.on('end', () => {
            if (resposta.statusCode === 200) {
                return res.status(200).send(dados); // Devolve o texto do banco se achar
            } else {
                return res.status(resposta.statusCode).send(`ERRO_GITHUB_STATUS_${resposta.statusCode}`);
            }
        });
    }).on('error', () => {
        return res.status(500).send("ERRO_CONEXAO_FISICA");
    });
};
