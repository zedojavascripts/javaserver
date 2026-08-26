// =============================================================================
// [VERCEL API] VERSÃO CERTIFICADA: CAMINHOS IDÊNTICOS À ÁRVORE REAL DO REPOSITÓRIO
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
    const hwidAlvo = hwid.trim();
    const servidorAlvo = servidor.toLowerCase().trim();

    // VALIDAÇÃO DIRETA DE ACESSO POR TEXTO NO BANCO DE DADOS PRIVADO
    if (bancoTextoLua.includes(hwidAlvo)) {
        const linhasDoBanco = bancoTextoLua.split('\n');
        let dataVencimentoEncontrada = "Expirado";
        let servidorAutorizadoEncontrado = "";
        let encontrouBlocoDoCliente = false;

        for (let i = 0; i < linhasDoBanco.length; i++) {
            let linhaLimpa = linhasDoBanco[i].replace(/\s+/g, '');

            if (linhaLimpa.includes(`vence=`)) {
                let extraiData = linhasDoBanco[i].match(/vence\s*=\s*"([^"]+)"/);
                if (extraiData) dataVencimentoEncontrada = extraiData[1];
            }

            if (linhaLimpa.includes(`["${hwidAlvo}"]=`) || linhaLimpa.includes(`['${hwidAlvo}']=`)) {
                let extraiServidor = linhasDoBanco[i].match(/=\s*["']([^"']+)["']/);
                if (extraiServidor) {
                    servidorAutorizadoEncontrado = extraiServidor[1].toLowerCase().trim();
                    encontrouBlocoDoCliente = true;
                    break;
                }
            }
        }

        if (encontrouBlocoDoCliente && servidorAutorizadoEncontrado === servidorAlvo) {
            if (dataVencimentoEncontrada === "ilimitado") {
                computadorEstaAutorizado = true;
            } else {
                const partesData = dataVencimentoEncontrada.split('/');
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

    // MAPEAMENTO RÍGIDO DE DIRETÓRIOS CONFORME A FOTO DO SEU REPOSITÓRIO
    // Força o casamento perfeito com o nome real das suas pastas do GitHub
    let pastaDoServidorReal = 'sv_ilusion'; 
    const servMinusculo = servidor.toLowerCase().trim();
    if (servMinusculo.includes('minimalist')) pastaDoServidorReal = 'sv_minimalist';
    if (servMinusculo.includes('legedy') || servMinusculo.includes('legend')) pastaDoServidorReal = 'sv_legend';

    // Se o pedido for do carregador principal, entrega o dwlload.lua direto da raiz de scripts/
    if (script === 'carregador_macros.lua' || script === 'dwlload.lua') {
        const conteudoDwlload = await buscarArquivoNoGithubPrivado('scripts/dwlload.lua');
        if (conteudoDwlload) {
            return res.status(200).send(conteudoDwlload);
        } else {
            return res.status(404).send('-- [Brinque API] Arquivo dwlload.lua nao localizado na raiz de scripts/. --');
        }
    }

    // BUSCA ROBUSTA EM ESCADA PARA AS SUBPASTAS DE SCRIPTS DE JOGO (.LUA)
    const subpastasParaVarrer = ['healing', 'Healing', 'war', 'War', 'cave_target', 'Cave_target', 'extras', 'Extras'];
    let scriptConteudoOriginal = null;

    for (let pastaCat of subpastasParaVarrer) {
        let caminhoTentativa = `scripts/${pastaDoServidorReal}/${pastaCat}/${script}`;
        scriptConteudoOriginal = await buscarArquivoNoGithubPrivado(caminhoTentativa);
        if (scriptConteudoOriginal) break; 
    }

    if (scriptConteudoOriginal) {
        return res.status(200).send(scriptConteudoOriginal);
    } else {
        return res.status(404).send(`-- [Brinque API] O arquivo ${script} nao foi encontrado dentro de scripts/${pastaDoServidorReal}/ --`);
    }
};
