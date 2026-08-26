// =============================================================================
// [VERCEL API] ARQUIVO MESTRE INTEGRAL DE SEGURANÇA E REDIRECIONAMENTO PRIVADO
// =============================================================================

const https = require('https');

// Função auxiliar que usa o GITHUB_TOKEN oculto da Vercel para ler o repositório privado
function buscarArquivoNoGithubPrivado(caminhoDoArquivo) {
    return new Promise((resolve, reject) => {
        const tokenOculto = process.env.GITHUB_TOKEN;
        
        const configuracaoRequest = {
            hostname: '://github.com',
            path: `/repos/brinquescriptsgamer-bot/customotserver/contents/${caminhoDoArquivo}`,
            headers: {
                'Authorization': `token ${tokenOculto}`,
                'User-Agent': 'Vercel-Serverless-Function',
                'Accept': 'application/vnd.github.v3.raw' // Força o download do texto puro (.lua)
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

// Função mestre que a Vercel executa ao receber o pedido do vBot
module.exports = async (req, res) => {
    // Configura a resposta como texto puro para o vBot ler como string Lua
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');

    // Captura os parâmetros enviados na URL pelo bot do jogo
    const { hwid, servidor, script } = req.query;

    // Barreira de proteção inicial
    if (!hwid || !servidor || !script) {
        return res.status(400).send('-- [Brinque API] Parametros de conexao ausentes. Acesso Negado. --');
    }

    // 1. BAIXA O BANCO DE DADOS DE FORMA SELETA E ULTRA-SEGURA NOS BASTIDORES
    const bancoTextoLua = await buscarArquivoNoGithubPrivado('banco_dados.lua');
    
    if (!bancoTextoLua) {
        return res.status(500).send('-- [Brinque API] Erro critico ao carregar banco de dados na nuvem. Contate o Administrador. --');
    }

    // 2. PROCESSADOR DE VALIDAÇÃO DE ACESSO (VARRE O LUA VIA REGEX)
    let computadorEstaAutorizado = false;
    let nomeDoClienteIdentificado = "Nao Afiliado";

    // Regex que cruza o Dono, o HWID e o Servidor ativo na mesma tabela
    const regexCliente = new RegExp(`\\["([^"\\]]+)"\\]\\s*=\\s*\\{[^\\}]*?vence\\s*=\\s*"([^"]+)"[^\\}]*?["']${hwid}["']\\s*=\\s*["']([^"']+)["']`, 's');
    const correspondencia = bancoTextoLua.match(regexCliente);

    if (correspondencia) {
        const nomeCliente = correspondencia[1];
        const dataVence = correspondencia[2];
        const servidorCadastradoParaEsseID = correspondencia[3];

        // Validação cruzada: o servidor selecionado no ComboBox precisa bater com o dono do ID
        if (servidorCadastradoParaEsseID === servidor) {
            nomeDoClienteIdentificado = nomeCliente;

            if (dataVence === "ilimitado") {
                computadorEstaAutorizado = true;
            } else {
                // Cálculo de calendário DD/MM/AAAA em JavaScript
                const partesData = dataVence.split('/');
                if (partesData.length === 3) {
                    const dia = parseInt(partesData[0], 10);
                    const mes = parseInt(partesData[1], 10) - 1; // Meses no JS vão de 0 a 11
                    const ano = parseInt(partesData[2], 10);
                    
                    const timestampVencimento = new Date(ano, mes, dia, 23, 59, 59).getTime();
                    const timestampAtual = Date.now();

                    if (timestampVencimento - timestampAtual > 0) {
                        computadorEstaAutorizado = true;
                    }
                }
            }
        }
    }

    // 3. DIRECIONAMENTO DE PASTAS PRIVADAS E ENTREGA DO CÓDIGO
    if (computadorEstaAutorizado) {
        let caminhoRealDoArquivoNoGithub = '';

        if (script === 'carregador_macros.lua') {
            caminhoRealDoArquivoNoGithub = 'scripts/Guilda/carregador_macros.lua';
        } else {
            // Roteador dinâmico de subpastas por ID de Servidor (sv_)
            let pastaDoServidor = 'sv_ilusion';
            if (servidor === 'Minimalist') pastaDoServidor = 'sv_minimalist';
            if (servidor === 'Legedy') pastaDoServidor = 'sv_legend';

            // Identifica a subpasta correta (healing, cave_target, war, extras) baseada no nome do arquivo
            let subpastaCategoria = 'extras';
            const nomeMinusculo = script.toLowerCase();
            if (nomeMinusculo.includes('healing') || nomeMinusculo.includes('cura')) subpastaCategoria = 'healing';
            if (nomeMinusculo.includes('cave') || nomeMinusculo.includes('target')) subpastaCategoria = 'cave_target';
            if (nomeMinusculo.includes('war') || nomeMinusculo.includes('combo') || nomeMinusculo.includes('battle') || nomeMinusculo.includes('filtro')) subpastaCategoria = 'war';

            caminhoRealDoArquivoNoGithub = `scripts/${pastaDoServidor}/${subpastaCategoria}/${script}`;
        }

        // Vai buscar o script real e privado dentro do repositório
        const scriptConteudoOriginal = await buscarArquivoNoGithubPrivado(caminhoRealDoArquivoNoGithub);

        if (scriptConteudoOriginal) {
            // Entrega o script criptografado em RAM para o loadstring() do vBot rodar
            return res.status(200).send(scriptConteudoOriginal);
        } else {
            return res.status(404).send(`-- [Brinque API] Arquivo ${script} nao localizado nas pastas privadas de: ${servidor} --`);
        }
    } else {
        // Bloqueio de portaria: Cospe o texto de erro e corta a transmissão de dados
        return res.status(403).send('-- [Brinque API] ACESSO NEGADO! ID invalido ou licenca expirada para este servidor. --');
    }
};
