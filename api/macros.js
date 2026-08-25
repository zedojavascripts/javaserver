// =============================================================================
// [VERCEL API] ARQUIVO MESTRE DE SEGURANÇA E REDIRECIONAMENTO - PARTE 1 DE 3
// =============================================================================

// Importa a biblioteca nativa de internet do Node.js (Vem pronta na Vercel)
const https = require('https');

// Função auxiliar em JavaScript para fazer o download seguro usando o GITHUB_TOKEN oculto
function buscarArquivoNoGithubPrivado(caminhoDoArquivo) {
    return new Promise((resolve, reject) => {
        // Puxa a chave ghp_... que está escondida nas variáveis de ambiente da Vercel
        const tokenOculto = process.env.GITHUB_TOKEN;
        
        // Monta as credenciais de autenticação que o GitHub exige para liberar o repositório privado
        const configuracaoRequest = {
            hostname: '://github.com',
            path: `/repos/brinquescriptsgamer-bot/customotserver/contents/${caminhoDoArquivo}`,
            headers: {
                'Authorization': `token ${tokenOculto}`,
                'User-Agent': 'Vercel-Serverless-Function',
                'Accept': 'application/vnd.github.v3.raw' // Força o GitHub a entregar apenas o texto puro (.lua)
            }
        };

        // Dispara a requisição invisível nos bastidores da nuvem
        https.get(configuracaoRequest, (resposta) => {
            let dadosAcumulados = '';
            resposta.on('data', (pedaco) => { dadosAcumulados += pedaco; });
            resposta.on('end', () => {
                if (resposta.statusCode === 200) {
                    resolve(dadosAcumulados);
                } else {
                    resolve(null); // Arquivo não encontrado ou token inválido
                }
            });
        }).on('error', (erroNet) => {
            resolve(null);
        });
    });
}
// =============================================================================
// [VERCEL API] ARQUIVO MESTRE DE SEGURANÇA E REDIRECIONAMENTO - PARTE 2 DE 3
// =============================================================================

// Função nativa obrigatória que a Vercel escuta para transformar o arquivo em link
module.exports = async (req, res) => {
    // Configura o cabeçalho para responder sempre em formato de texto puro compatível com Lua
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');

    // Captura os dados que o vBot enviou via parâmetros na URL HTTP
    const { hwid, servidor, script } = req.query;

    // Barreira de proteção: Se faltar parâmetros vitais, aborta a conexão na hora
    if (!hwid || !servidor || !script) {
        return res.status(400).send('-- [Brinque API] Parametros de conexao ausentes. Acesso Negado. --');
    }

    // 1. FAZ O DOWNLOAD SEGURO DO BANCO DE DADOS DA SUAPASTA PRIVADA
    // Aponta exatamente para o caminho dentro do seu repositório: scripts/Guilda/banco_dados.lua
    const bancoTextoLua = await buscarArquivoNoGithubPrivado('scripts/Guilda/banco_dados.lua');
    
    if (!bancoTextoLua) {
        return res.status(500).send('-- [Brinque API] Erro critico ao carregar banco de dados na nuvem. Contate o Administrador. --');
    }

    // 2. MOTOR DE CHECAGEM CRUZADA (MIMETIZA A SEGURANÇA DO LUA EM JAVASCRIPT)
    let computadorEstaAutorizado = false;
    let nomeDoClienteIdentificado = "Nao Afiliado";

    // Regex inteligente para varrer a tabela Lua baixada na memória RAM da Vercel
    // Busca o bloco de texto específico do cliente que possui o HWID conectado
    const regexCliente = new RegExp(`\\["([^"\\]]+)"\\]\\s*=\\s*\\{[^\\}]*?vence\\s*=\\s*"([^"]+)"[^\\}]*?["']${hwid}["']\\s*=\\s*["']([^"']+)["']`, 's');
    const correspondencia = bancoTextoLua.match(regexCliente);

    if (correspondencia) {
        const nomeCliente = correspondencia[1];
        const dataVence = correspondencia[2];
        const servidorCadastradoParaEsseID = correspondencia[3];

        // Só avança se o servidor escolhido no ComboBox bater com o servidor do ID da pasta
        if (servidorCadastradoParaEsseID === servidor) {
            nomeDoClienteIdentificado = nomeCliente;

            if (dataVence === "ilimitado") {
                computadorEstaAutorizado = true;
            } else {
                // Quebra a string DD/MM/AAAA para validar o tempo restante do plano
                const partesData = dataVence.split('/');
                if (partesData.length === 3) {
                    const dia = parseInt(partesData[0], 10);
                    const mes = parseInt(partesData[1], 10) - 1; // Meses no JS começam em 0
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
// =============================================================================
// [VERCEL API] ARQUIVO MESTRE DE SEGURANÇA E REDIRECIONAMENTO - PARTE 3 DE 3
// =============================================================================

    // 3. DIRECIONAMENTO E ENTREGA DE ARQUIVOS BASEADO NO STATUS DA LICENÇA
    if (computadorEstaAutorizado) {
        let caminhoRealDoArquivoNoGithub = '';

        // Se o bot pedir o carregador de macros mestre
        if (script === 'carregador_macros.lua') {
            caminhoRealDoArquivoNoGithub = 'scripts/Guilda/carregador_macros.lua';
        } else {
            // Se o bot estiver pedindo um macro lógico de jogo das subpastas por ID
            // Ele monta dinamicamente o link baseado no servidor e no nome do arquivo enviado
            // Exemplo: se o bot pediu 'Filtrobattle.lua' no servidor 'Minimalist',
            // a Vercel vai buscar em: 'scripts/sv_minimalist/war/Filtrobattle.lua'
            let pastaDoServidor = 'sv_ilusion';
            if (servidor === 'Minimalist') pastaDoServidor = 'sv_minimalist';
            if (servidor === 'Legedy') pastaDoServidor = 'sv_legend';

            // Mapeia automaticamente as subpastas baseado no prefixo do nome do arquivo
            let subpastaCategoria = 'extras';
            const nomeMinusculo = script.toLowerCase();
            if (nomeMinusculo.includes('healing') || nomeMinusculo.includes('cura')) subpastaCategoria = 'healing';
            if (nomeMinusculo.includes('cave') || nomeMinusculo.includes('target')) subpastaCategoria = 'cave_target';
            if (nomeMinusculo.includes('war') || nomeMinusculo.includes('combo') || nomeMinusculo.includes('battle') || nomeMinusculo.includes('filtro')) subpastaCategoria = 'war';

            caminhoRealDoArquivoNoGithub = `scripts/${pastaDoServidor}/${subpastaCategoria}/${script}`;
        }

        // Busca o arquivo físico e privado direto no seu repositório do GitHub
        const scriptConteudoOriginal = await buscarArquivoNoGithubPrivado(caminhoRealDoArquivoNoGithub);

        if (scriptConteudoOriginal) {
            // Entrega o código mestre puro em texto para o vBot compilar direto na RAM
            return res.status(200).send(scriptConteudoOriginal);
        } else {
            return res.status(404).send(`-- [Brinque API] Arquivo ${script} nao localizado nas pastas privadas de: ${servidor} --`);
        }
    } else {
        // PORTARIA: Se o cliente não possuir licença ou for o servidor errado, cospe um texto de bloqueio rígido
        // Isso impede o vBot de rodar qualquer loadstring() e bloqueia a injeção em RAM
        return res.status(403).send('-- [Brinque API] ACESSO NEGADO! ID invalido ou licenca expirada para este servidor. --');
    }
};
