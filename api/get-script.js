export default async function handler(req, res) {
  // Configura o cabeçalho para permitir que qualquer OTClient faça a requisição
  res.setHeader('Access-Control-Allow-Origin', '*');
  
  // Resgata o token que vamos esconder nas configurações da Vercel
  const GITHUB_TOKEN = process.env.MY_GITHUB_TOKEN; 

  // PEGA IMPORTANTE: Altere "SEU_USUARIO", "SEU_REPO" e "seu_arquivo.lua" abaixo:
  const url = 'https://githubusercontent.com';
  
  try {
    const response = await fetch(url, {
      headers: {
        'Authorization': `token ${GITHUB_TOKEN}`,
        'Accept': 'application/vnd.github.v3.raw'
      }
    });

    if (!response.ok) {
      return res.status(500).send('-- Erro: Repositorio ou Token invalidos');
    }
    
    const data = await response.text();
    res.setHeader('Content-Type', 'text/plain; charset=utf-8');
    return res.status(200).send(data);

  } catch (error) {
    return res.status(500).send('-- Erro interno na ponte');
  }
}
