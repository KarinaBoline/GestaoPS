# Conectar o P&S Cobranças ao Supabase

Com o Supabase, os lançamentos e os arquivos de NF-e ficam guardados num banco de dados na nuvem. Cada pessoa da equipe entra com o próprio e-mail e senha e todos veem as mesmas contas, em tempo real.

São cinco etapas, uma vez só. Leva uns 15 minutos.

## 1. Criar o projeto

1. Entre em [supabase.com](https://supabase.com) e clique em **New project**.
2. Dê o nome `ps-cobrancas`.
3. Crie uma senha forte para o banco e guarde-a num lugar seguro. O sistema não usa essa senha, mas o Supabase pode pedir depois.
4. Em **Region**, escolha **South America (São Paulo)**.
5. Clique em **Create new project** e espere 1 a 2 minutos.

## 2. Criar as tabelas

1. No menu da esquerda, abra **SQL Editor** e clique em **New query**.
2. Abra o arquivo [`supabase/schema.sql`](../supabase/schema.sql) deste repositório, copie tudo e cole no editor.
3. Clique em **Run**. Deve aparecer "Success. No rows returned".

O script cria:

| Item | Para que serve |
| --- | --- |
| Tabela `clientes` | Empresas clientes |
| Tabela `contas` | Contas a pagar: NF-e, valores, vencimento, atacado/varejo, matriz/filial, repasse, pagamento |
| Tabela `config` | Nome da empresa e percentuais (5% atacado, 4% varejo) |
| Pasta `documentos` | Arquivos de NF-e e comprovantes, privada |
| Regras de acesso | Só usuários logados leem e gravam |

A coluna `taxa` (o valor que a P&S recebe) é calculada pelo próprio banco: valor da NF × percentual. Ninguém consegue gravar um valor diferente por engano.

## 3. Fechar o cadastro público

Assim só entra quem você cadastrar.

1. Abra **Authentication → Sign In / Providers**.
2. Desligue **Allow new users to sign up** e salve.
3. Em **Authentication → URL Configuration**, coloque em **Site URL** o endereço do site:
   `https://karinaboline.github.io/GestaoPS/`

## 4. Cadastrar a equipe

Para cada pessoa:

1. Abra **Authentication → Users** e clique em **Add user → Create new user**.
2. Digite o e-mail e uma senha provisória.
3. Deixe marcado **Auto Confirm User** e clique em **Create user**.
4. Passe o e-mail e a senha para a pessoa. Ela pode trocar a senha depois em **Esqueci minha senha**, na tela de entrada.

Outra opção é **Send invitation**: a pessoa recebe um e-mail, clica no link e cria a própria senha no sistema.

## 5. Ligar o sistema ao projeto

1. Abra **Project Settings → API** (ou **Data API**).
2. Copie o **Project URL**, algo como `https://abcdefgh.supabase.co`.
3. Copie a chave **anon public**. É uma chave longa que começa com `eyJ`. Em projetos novos ela pode aparecer como **Publishable key** e começar com `sb_publishable_`.
4. Coloque os dois valores no arquivo [`config.js`](../config.js):

```js
window.PS_CONFIG = {
  supabaseUrl: 'https://abcdefgh.supabase.co',
  supabaseAnonKey: 'eyJhbGciOi...'
};
```

A chave **anon public** pode ficar no repositório: sozinha ela não abre nada, porque as regras de acesso exigem login. **Nunca** use a chave **service_role** (ou **secret**): ela ignora todas as regras e dá acesso total ao banco.

Pronto. Ao abrir o site, aparece a tela de entrada:

![Tela de entrada](img/00-login.png)

## Dúvidas comuns

**Os dados de exemplo aparecem?** Não. Com o Supabase conectado, o sistema começa vazio. Para testar, clique em **Carregar exemplos** no Painel e depois em **Remover exemplos** em Ajustes.

**Onde vejo os dados fora do sistema?** No Supabase, em **Table Editor**. Ali você também pode exportar as tabelas em CSV.

**E os arquivos de NF-e?** Ficam em **Storage → documentos**, organizados por mês do lançamento. No sistema, basta clicar no nome do arquivo na ficha da conta.

**Quanto custa?** O plano gratuito do Supabase guarda até 500 MB de dados e 1 GB de arquivos. Projetos gratuitos ficam pausados depois de uma semana sem nenhum acesso; basta entrar no painel do Supabase e clicar em **Restore**. Confira os limites atuais em [supabase.com/pricing](https://supabase.com/pricing).
