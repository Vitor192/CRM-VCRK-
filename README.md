# VCRK Soluções Digitais — CRM

CRM web em português para organizar contatos, motivos de contato e retornos. Os dados ficam no Supabase, então entram na sua conta de qualquer computador com internet. Para ver a mesma lista, use o mesmo e-mail e senha em todos os dispositivos.

## Ativar o acesso e a sincronização

1. Crie um projeto no [Supabase](https://supabase.com/) e guarde o **Project URL** e a chave pública **anon/publishable**.
2. No painel do Supabase, abra **SQL Editor**, cole o conteúdo de `supabase.sql` e execute. A tabela aplica regras para cada usuário só acessar os próprios contatos.
3. Abra `config.js` e substitua `https://SEU-PROJETO.supabase.co` e `SUA_CHAVE_PUBLICA_ANON` pelos dados do projeto.
4. Hospede os arquivos desta pasta em um serviço de hospedagem de sites estáticos (por exemplo, Netlify ou Cloudflare Pages). A hospedagem dá a URL que você abrirá nos computadores e celulares.
5. Abra essa URL, escolha **Cadastre-se**, crie o acesso e confirme o e-mail se o Supabase solicitar. Depois, entre com o mesmo acesso nos outros dispositivos.

O cadastro pode estar sujeito à confirmação de e-mail, conforme a configuração de autenticação do projeto Supabase. Não coloque a `service_role key` no `config.js`; somente a chave pública.

## Contatos do Maps Scraper

Em **Contatos** ou na página inicial, escolha **Importar contatos** e selecione um arquivo CSV, XLSX, XLS ou JSON exportado pelo Maps Scraper. CSV separados por vírgula, ponto e vírgula ou tabulação são aceitos. O arquivo precisa ter uma coluna com nome do estabelecimento (por exemplo `name`, `title`, `business name`, `nome` ou `estabelecimento`); telefone é opcional (`phone`, `phone number`, `telefone`, `mobile`). Também são reconhecidos cidade (`city`, `cidade`), país (`country`, `pais`), site (`website`, `website url`, `site`), `motivo`/`reason` e `origem`/`source`. Para Excel, é lida a primeira planilha. Contatos importados recebem a origem “Maps Scraper” quando o arquivo não tiver uma coluna de origem.

Na lista de contatos, filtre por cidade e país. **Somente sem site** vem marcado por padrão e oculta estabelecimentos que têm site; desmarque para mostrar também esses registros. Os estabelecimentos sem site aparecem com o selo vermelho **SEM SITE**. Para habilitar os campos novos em um projeto Supabase já conectado, execute `supabase-maps-filters.sql` no SQL Editor. Os registros com site não são apagados do banco.

Exemplo:

```csv
name,phone
Padaria Central,(11) 3333-2222
Studio Verde,(11) 98888-7777
```

O sistema mantém contatos e horários na nuvem; não há armazenamento local de contatos no navegador. A agenda usa o fuso horário do dispositivo que está aberto.

## Atendimentos por cliente

Clique no nome do cliente na lista para abrir o histórico. Cada registro salva o motivo, a observação e, quando marcado, data e horário do próximo retorno. A tabela de histórico é protegida por RLS e vinculada ao dono do contato. Para atualizar um Supabase já conectado, execute uma vez o conteúdo de `supabase-attendance.sql` no SQL Editor antes de usar o novo formulário.

## Publicação

O workflow em .github/workflows/deploy.yml publica automaticamente o site no GitHub Pages sempre que uma alteração é enviada para main. No primeiro uso, o repositório precisa estar com Pages configurado para usar GitHub Actions (Settings → Pages → Source).

