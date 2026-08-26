// =============================================================================
// [VERCEL API] VERSÃO DIRECT-PATH: CORREÇÃO DE SUBPASTAS DA NUVEM
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

    // VALIDAÇÃO DIRETA DE ACESSO POR TEXTO
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
                    const dia = parseInt(partesData, 10);
                    const mes = parseInt(partesData, 10) - 1;
                    const ano = parseInt(partesData, 10);
                    
                    const timestampVencimento = new Date(ano, mes, dia, 23, 59, 59).getTime();
                    if (timestampVencimento - Date.now() > 0) {
                        computadorEstaAutorizado = true;
                    }
                }
            }
        }
    }

    // 🛠️ ROTEAMENTO DE CAMINHOS CORRIGIDO:
    // Se o script não for o dwlload, ele procura o macro baseado na pasta que você estruturou
    if (script === 'carregador_macros.lua' || script === 'dwlload.lua') {
        return res.status(200).send(await buscarArquivoNoGithubPrivado('scripts/dwlload.lua'));
    }

    // Roteador inteligente de OTs com base no ComboBox
    let pastaDoServidor = 'sv_ilusion';
    if (servidor === 'Minimalist') pastaDoServidor = 'sv_minimalist';
    if (servidor === 'Legedy') pastaDoServidor = 'sv_legend';

    // 🚀 BUSCA DINÂMICA REFORÇADA: Testa encontrar o arquivo em todas as subpastas possiveis (Minusa/Maiuscula)
    const subpastasParaTestar = ['healing', 'Healing', 'war', 'War', 'cave_target', 'Cave_target', 'extras', 'Extras'];
    let scriptConteudoOriginal = null;

    // Varre as combinações até achar o seu arquivo físico no GitHub privado
    for (let pastaCat of subpastasParaTestar) {
        let caminhoTentativa = `scripts/${pastaDoServidor}/${pastaCat}/${script}`;
        scriptConteudoOriginal = await buscarArquivoNoGithubPrivado(caminhoTentativa);
        if (scriptConteudoOriginal) break; // Se achou o arquivo, para o loop e entrega
    }

    if (scriptConteudoOriginal) {
        return res.status(200).send(scriptConteudoOriginal);
    } else {
        return res.status(404).send(`-- [Brinque API] Arquivo ${script} nao localizado nas pastas privadas de: ${pastaDoServidor} --`);
    }
};
