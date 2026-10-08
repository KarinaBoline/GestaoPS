# Gestão P&S

Sistema para organizar o pagamento das contas das empresas clientes: boletos de mercadoria, NF-e, repasses e a taxa cobrada por conta paga (5% da nota no atacado, 4% no varejo).

![Painel do sistema](docs/img/01-painel.png)

## O que tem no sistema

- **Painel**: total a pagar, vencimentos da semana, contas aguardando repasse, sua taxa do mês e agenda dos próximos 10 dias.
- **Contas a pagar**: lançamento com vencimento, NF-e (com upload do arquivo), valor da NF, empresa recebedora, atacado/varejo e matriz/filial. O valor a receber é calculado automaticamente.
- **Empresas clientes**: cadastro e resumo de cada empresa.
- **Fechamento mensal**: quanto cobrar de cada empresa no mês, separado em atacado e varejo, com exportação em CSV.
- **Ajustes**: nome da empresa e percentuais das taxas.

O passo a passo completo, com imagens, está em [docs/MANUAL.md](docs/MANUAL.md).

## Arquivos

| Arquivo | Conteúdo |
| --- | --- |
| `index.html` | O aplicativo inteiro, em um único arquivo |
| `docs/MANUAL.md` | Manual de uso com capturas de tela |
| `docs/img/` | Capturas de tela usadas no manual |

## Como usar este arquivo

O `index.html` abre direto no navegador, sem instalar nada. Fora do Claude ele funciona em **modo local**:

- os dados ficam salvos apenas no navegador em que foram lançados;
- o nome do arquivo da NF-e é registrado, mas o arquivo em si não é guardado;
- cada computador tem a sua própria base.

Para a equipe trabalhar na mesma base, com os arquivos de NF-e guardados na nuvem, use a versão publicada no Claude.

Para publicar este arquivo como site (GitHub Pages): em **Settings → Pages**, escolha a branch `main` e a pasta raiz. O site continua em modo local.
