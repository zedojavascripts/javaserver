// =============================================================================
// [VERCEL API] CORRIGIDO: ACESSO DIRETO À ÁRVORE REAL DA BRINQUE SCRIPTS
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

    // 🛠️ ALINHADO COM A FOTO: Busca o banco_dados.lua direto na raiz da pasta scripts/
    const bancoTextoLua = await buscarArquivoNoGithubPrivado('scripts/banco_dados.lua');
    
    if (!bancoTextoLua) {
        return res.status(500).send('-- [Brinque API] Erro critico ao carregar banco_dados.lua na raiz de scripts. --');
    }

    let computadorEstaAutorizado = false;

    // Remove qualquer espaço ou caractere invisível para cruzar os dados com segurança máxima
    const hwidLimpo = hwid.trim();

    // Varre a tabela capturando as permissões do ID de forma direta
    if (bancoTextoLua.includes(hwidLimpo)) {
        // Captura o bloco do dono desse ID para inspecionar o servidor e a data
        const regexValidadorCompleto = new RegExp(`\\["([^"\\]]+)"\\]\\s*=\\s*\\{[^\\}]*?vence\\s*=\\s*"([^"]+)"[^\\}]*?\\s*servidores\\s*=\\s*\\{[^\\}]*?["']${hwidLimpo.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')}["']\\s*=\\s*["']([^"']+)["']`, 's');
        const correspondencia = bancoTextoLua.match(regexValidadorCompleto);

        if (correspondencia) {
            const dataVence = correspondencia[2];
            const servidorCadastradoParaEsseID = correspondencia[3];

            if (servidorCadastradoParaEsseID.toLowerCase().trim() === servidor.toLowerCase().trim()) {
                if (dataVence === "ilimitado") {
                    computadorEstaAutorizado = true;
                } else {
                    const partesData = dataVence.split('/');
                    if (partesData.length === 3) {
                        const dia = parseInt(partesData[0], 10);
                        const mes = parseInt(partesData[1], 10) - 1;
                        const ano = parseInt(partesData[2], 10);
                        
                        const timestampVencimento = new Date(ano, mes, dia, 23, 59, 59).getTime();
                        if (timestampVencimento - Date.now() > 0) {
                            computadorEstaAutorizado = true;
                        }
                    }
                }
            }
        }
    }

    // 3. DIRECIONAMENTO DE ACESSO AOS ARQUIVOS PRIVADOS
    if (computadorEstaAutorizado) {
        let caminhoRealDoArquivoNoGithub = '';

        // 🛠️ ALINHADO COM A FOTO: Se o bot pedir o carregador, aponta para scripts/dwlload.lua
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
