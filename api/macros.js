// =============================================================================
// [VERCEL API] VERSÃO PURE-TEXT: IMUNE A CARACTERES ESPECIAIS E TRAÇOS DUPLOS
// =============================================================================

const https = require('https');

function buscarArquivoNoGithubPrivado(caminhoDoArquivo) {
    return new Promise((resolve, reject) => {
        const tokenOculto = process.env.GITHUB_TOKEN;
        
        const configuracaoRequest = {
            hostname: '://github.com',
            path: `/repos/brinquescriptsgamer-bot/customotserver/contents/${caminhoDoArquivo}`,
            headers: {
                'Authorization': `token ${tokenOculto}`,
                'User-Agent': 'Vercel-Serverless-Function',
                'Accept': 'application/vnd.github.v3.raw'
            }
        };

        https.get(configuracaoRequest, (resposta) => {
            let dadosAcumulados = '';
            resposta.on('data', (pedaco) => { dadosAcumulados += pedaco; });
            resposta.on('end', () => {
                if (resposta.statusCode === 200) {
                    resolve(dadosAcumulados);
                } else {
                    resolve(null);
                }
            });
        }).on('error', (erroNet) => {
            resolve(null);
        });
    });
}

module.exports = async (req, res) => {
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');

    const { hwid, servidor, script } = req.query;

    if (!hwid || !servidor || !script) {
        return res.status(400).send('-- [Brinque API] Parametros de conexao ausentes. Acesso Negado. --');
    }

    // Busca o seu banco_dados.lua direto na raiz da pasta scripts/
    const bancoTextoLua = await buscarArquivoNoGithubPrivado('scripts/banco_dados.lua');
    
    if (!bancoTextoLua) {
        return res.status(500).send('-- [Brinque API] Erro critico ao carregar banco_dados.lua na raiz de scripts. --');
    }

    let computadorEstaAutorizado = false;

    // Padroniza e limpa as strings para eliminar qualquer conflito de espaco ou caractere invisivel
    const hwidAlvo = hwid.trim();
    const servidorAlvo = servidor.toLowerCase().trim();

    // 🧠 ENGENHARIA SUPREMA: Se o ID bruto do cliente constar no texto do banco, comeca a inspecionar as permissoes
    if (bancoTextoLua.includes(hwidAlvo)) {
        // Divide o banco de dados linha por linha para varrer o calendario sem bugar com caracteres especiais
        const linhasDoBanco = bancoTextoLua.split('\n');
        let dataVencimentoEncontrada = "Expirado";
        let servidorAutorizadoEncontrado = "";
        let encontrouBlocoDoCliente = false;

        // Limpa e varre o arquivo testando a correspondencia direta de palavras chave
        for (let i = 0; i < linhasDoBanco.length; i++) {
            let linhaLimpa = linhasDoBanco[i].replace(/\s+/g, '');

            if (linhaLimpa.includes(`vence=`)) {
                let extraiData = linhasDoBanco[i].match(/vence\s*=\s*"([^"]+)"/);
                if (extraiData) dataVencimentoEncontrada = extraiData[1];
            }

            // Testa se a linha contem o casamento perfeito do HWID e captura o servidor associado na frente
            if (linhaLimpa.includes(`["${hwidAlvo}"]=`) || linhaLimpa.includes(`['${hwidAlvo}']=`)) {
                let extraiServidor = linhasDoBanco[i].match(/=\s*["']([^"']+)["']/);
                if (extraiServidor) {
                    servidorAutorizadoEncontrado = extraiServidor[1].toLowerCase().trim();
                    encontrouBlocoDoCliente = true;
                    break;
                }
            }
        }

        // Se a Vercel localizou o ID e o servidor bater com a escolha do ComboBox, confere a folha de validade
        if (encontrouBlocoDoCliente && servidorAutorizadoEncontrado === servidorAlvo) {
            if (dataVencimentoEncontrada === "ilimitado") {
                computadorEstaAutorizado = true;
            } else {
                const partesData = dataVencimentoEncontrada.split('/');
                if (partesData.length === 3) {
                    const dia = parseInt(partesData[10], 10);
                    const mes = parseInt(partesData[10], 10) - 1;
                    const ano = parseInt(partesData[10], 10);
                    
                    const timestampVencimento = new Date(ano, mes, dia, 23, 59, 59).getTime();
                    if (timestampVencimento - Date.now() > 0) {
                        computadorEstaAutorizado = true;
                    }
                }
            }
        }
    }

    // ROTEAMENTO E ENTREGA SEGURA DE SCRIPTS
    if (computadorEstaAutorizado) {
        let caminhoRealDoArquivoNoGithub = '';

        if (script === 'dwlload.lua' || script === 'dwlload.lua') {
            caminhoRealDoArquivoNoGithub = 'scripts/dwlload.lua';
        } else {
            let pastaDoServidor = 'sv_ilusion';
            if (servidor === 'Minimalist') pastaDoServidor = 'sv_minimalist';
            if (servidor === 'Legedy') pastaDoServidor = 'sv_legend';

            let subpastaCategoria = 'extras';
            const nomeMinusculo = script.toLowerCase();
            if (nomeMinusculo.includes('healing') || nomeMinusculo.includes('cura')) subpastaCategoria = 'healing';
            if (nomeMinusculo.includes('cave') || nomeMinusculo.includes('target')) subpastaCategoria = 'cave_target';
            if (nomeMinusculo.includes('war') || nomeMinusculo.includes('combo') || nomeMinusculo.includes('battle') || nomeMinusculo.includes('filtro')) subpastaCategoria = 'war';

            caminhoRealDoArquivoNoGithub = `scripts/${pastaDoServidor}/${subpastaCategoria}/${script}`;
        }

        const scriptConteudoOriginal = await buscarArquivoNoGithubPrivado(caminhoRealDoArquivoNoGithub);

        if (scriptConteudoOriginal) {
            return res.status(200).send(scriptConteudoOriginal);
        } else {
            return res.status(404).send(`-- [Brinque API] Arquivo ${script} nao localizado nas pastas privadas. --`);
        }
    } else {
        return res.status(403).send('-- [Brinque API] ACESSO NEGADO! ID ou Servidor incorretos no banco_dados.lua --');
    }
};
