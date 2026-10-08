# Gestão P&S

Sistema da **P&S Cobranças** para organizar o pagamento das contas das empresas clientes: boletos de mercadoria, NF-e, repasses e a taxa cobrada por conta paga (5% da nota no atacado, 4% no varejo).

**Endereço:** https://karinaboline.github.io/GestaoPS/ (depois de ligar o GitHub Pages)

![Painel do sistema](docs/img/01-painel.png)

## O que tem no sistema

- **Painel**: total a pagar, vencimentos da semana, contas aguardando repasse, sua taxa do mês e agenda dos próximos 10 dias.
- **Contas a pagar**: lançamento com vencimento, NF-e (com upload do arquivo), valor da NF, empresa recebedora, atacado/varejo e matriz/filial. O valor a receber é calculado automaticamente.
- **Empresas clientes**: cadastro e resumo de cada empresa.
- **Fechamento mensal**: quanto cobrar de cada empresa no mês, separado em atacado e varejo, com exportação em CSV.
- **Ajustes**: nome da empresa e percentuais das taxas.
- **Acesso por login**: cada pessoa da equipe entra com o próprio e-mail e senha.

## Documentação

| Documento | Conteúdo |
| --- | --- |
| [docs/MANUAL.md](docs/MANUAL.md) | Passo a passo de uso, com imagens |
| [docs/SUPABASE.md](docs/SUPABASE.md) | Como criar e conectar o banco de dados no Supabase |

## Arquivos

| Arquivo | Conteúdo |
| --- | --- |
| `index.html` | O aplicativo inteiro, em um único arquivo |
| `config.js` | Endereço e chave pública do Supabase |
| `supabase/schema.sql` | Script que cria as tabelas, a pasta de arquivos e as regras de acesso |
| `docs/` | Manual, guia do Supabase e capturas de tela |

## Onde ficam os dados

- **Com o Supabase configurado** (`config.js` preenchido): os dados e os arquivos de NF-e ficam no banco da P&S. É preciso entrar com e-mail e senha, e todos da equipe veem as mesmas informações em tempo real.
- **Sem o Supabase** (`config.js` vazio): o sistema abre em modo local, com dados de exemplo. Os lançamentos ficam só no navegador de quem usa e os arquivos não são guardados. Serve para testar.

## Publicar o site (GitHub Pages)

Em **Settings → Pages**, escolha **Deploy from a branch**, a branch `main` e a pasta `/ (root)`, e clique em **Save**. Em 1 a 2 minutos o site fica no ar no endereço acima.
