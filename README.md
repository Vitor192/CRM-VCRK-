# Raiz CRM

CRM web em português para organizar contatos, motivos de contato e retornos. Os dados ficam no Supabase, então entram na sua conta de qualquer computador com internet. Para ver a mesma lista, use o mesmo e-mail e senha em todos os dispositivos.

## Ativar o acesso e a sincronização

1. Crie um projeto no [Supabase](https://supabase.com/) e guarde o **Project URL** e a chave pública **anon/publishable**.
2. No painel do Supabase, abra **SQL Editor**, cole o conteúdo de `supabase.sql` e execute. A tabela aplica regras para cada usuário só acessar os próprios contatos.
3. Abra `config.js` e substitua `https://SEU-PROJETO.supabase.co` e `SUA_CHAVE_PUBLICA_ANON` pelos dados do projeto.
4. Hospede os arquivos desta pasta em um serviço de hospedagem de sites estáticos (por exemplo, Netlify ou Cloudflare Pages). A hospedagem dá a URL que você abrirá nos computadores e celulares.
5. Abra essa URL, escolha **Cadastre-se**, crie o acesso e confirme o e-mail se o Supabase solicitar. Depois, entre com o mesmo acesso nos outros dispositivos.

O cadastro pode estar sujeito à confirmação de e-mail, conforme a configuração de autenticação do projeto Supabase. Não coloque a `service_role key` no `config.js`; somente a chave pública.

## Contatos do Maps Scraper

Em **Contatos** ou na página inicial, escolha **Importar CSV**. O CSV precisa ter cabeçalho e uma coluna que identifique o nome, como `name`, `nome`, `estabelecimento` ou `business name`. Telefone é opcional (`phone`, `telefone`, `fone`); também são reconhecidos `motivo`/`reason` e `origem`/`source`. Arquivos separados por vírgula, ponto e vírgula ou tabulação são aceitos. Contatos importados recebem a origem “Maps Scraper” quando o arquivo não tiver uma coluna de origem.

Exemplo:

```csv
name,phone
Padaria Central,(11) 3333-2222
Studio Verde,(11) 98888-7777
```

O sistema mantém contatos e horários na nuvem; não há armazenamento local de contatos no navegador. A agenda usa o fuso horário do dispositivo que está aberto.
