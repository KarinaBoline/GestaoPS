-- P&S Cobranças — estrutura do banco de dados no Supabase
-- Como usar: no painel do Supabase, abra SQL Editor → New query,
-- cole este arquivo inteiro e clique em Run. Pode rodar mais de uma vez.

-- ---------------------------------------------------------------
-- Empresas clientes (quem contrata a P&S para pagar as contas)
-- ---------------------------------------------------------------
create table if not exists public.clientes (
  id          text primary key,
  nome        text not null,
  cnpj        text,
  contato     text,
  tel         text,
  email       text,
  obs         text,
  exemplo     boolean not null default false,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- ---------------------------------------------------------------
-- Contas a pagar (um boleto + a NF-e correspondente)
-- ---------------------------------------------------------------
create table if not exists public.contas (
  id                text primary key,
  cliente_id        text not null references public.clientes(id) on delete restrict,
  tipo_empresa      text not null default 'matriz' check (tipo_empresa in ('matriz','filial')),
  transacao         text not null check (transacao in ('atacado','varejo')),
  recebedor         text not null,            -- empresa recebedora da nota
  recebedor_doc     text,                     -- CNPJ do recebedor
  nfe               text not null,            -- número da NF-e
  valor_nf          numeric(14,2) not null check (valor_nf > 0),
  valor_boleto      numeric(14,2) not null check (valor_boleto > 0),
  vencimento        date not null,
  pct               numeric(5,2) not null,    -- % da taxa usado quando a conta foi lançada
  taxa              numeric(14,2) generated always as (round(valor_nf * pct / 100, 2)) stored,
  status            text not null default 'aberto' check (status in ('aberto','pago','cancelado')),
  linha             text,                     -- linha digitável
  obs               text,
  criado_em         date not null default current_date,
  repasse_status    text not null default 'pendente' check (repasse_status in ('pendente','recebido')),
  repasse_data      date,
  repasse_valor     numeric(14,2),
  pago_em           date,
  valor_pago        numeric(14,2),
  forma             text,
  taxa_recebida     boolean not null default false,
  taxa_recebida_em  date,
  nfe_arquivo       jsonb,                    -- {path, nome, tipo} no bucket "documentos"
  comprovante       jsonb,
  exemplo           boolean not null default false,
  updated_at        timestamptz not null default now()
);

create index if not exists contas_cliente_idx    on public.contas (cliente_id);
create index if not exists contas_vencimento_idx on public.contas (vencimento);
create index if not exists contas_pago_em_idx    on public.contas (pago_em);

-- ---------------------------------------------------------------
-- Ajustes (uma linha só)
-- ---------------------------------------------------------------
create table if not exists public.config (
  id          int primary key default 1 check (id = 1),
  empresa     text not null default 'P&S Cobranças',
  pct_atacado numeric(5,2) not null default 5,
  pct_varejo  numeric(5,2) not null default 4,
  updated_at  timestamptz not null default now()
);
insert into public.config (id) values (1) on conflict (id) do nothing;

-- Atualiza updated_at automaticamente
create or replace function public.set_updated_at() returns trigger
language plpgsql as $$ begin new.updated_at = now(); return new; end $$;

drop trigger if exists clientes_updated on public.clientes;
create trigger clientes_updated before update on public.clientes for each row execute function public.set_updated_at();
drop trigger if exists contas_updated on public.contas;
create trigger contas_updated before update on public.contas for each row execute function public.set_updated_at();
drop trigger if exists config_updated on public.config;
create trigger config_updated before update on public.config for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------
-- Segurança: só usuários logados (equipe da P&S) leem e gravam
-- ---------------------------------------------------------------
alter table public.clientes enable row level security;
alter table public.contas   enable row level security;
alter table public.config   enable row level security;

drop policy if exists "equipe acessa clientes" on public.clientes;
create policy "equipe acessa clientes" on public.clientes
  for all to authenticated using (true) with check (true);

drop policy if exists "equipe acessa contas" on public.contas;
create policy "equipe acessa contas" on public.contas
  for all to authenticated using (true) with check (true);

drop policy if exists "equipe acessa config" on public.config;
create policy "equipe acessa config" on public.config
  for all to authenticated using (true) with check (true);

-- ---------------------------------------------------------------
-- Arquivos (NF-e e comprovantes) — bucket privado
-- ---------------------------------------------------------------
insert into storage.buckets (id, name, public, file_size_limit)
values ('documentos', 'documentos', false, 20971520)
on conflict (id) do nothing;

drop policy if exists "equipe le documentos" on storage.objects;
create policy "equipe le documentos" on storage.objects
  for select to authenticated using (bucket_id = 'documentos');

drop policy if exists "equipe envia documentos" on storage.objects;
create policy "equipe envia documentos" on storage.objects
  for insert to authenticated with check (bucket_id = 'documentos');

drop policy if exists "equipe apaga documentos" on storage.objects;
create policy "equipe apaga documentos" on storage.objects
  for delete to authenticated using (bucket_id = 'documentos');

-- ---------------------------------------------------------------
-- Atualização em tempo real entre os computadores da equipe
-- ---------------------------------------------------------------
do $$
begin
  begin alter publication supabase_realtime add table public.clientes; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.contas;   exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.config;   exception when duplicate_object then null; end;
end $$;

-- Faz a API do Supabase reconhecer as tabelas novas na hora
notify pgrst, 'reload schema';
