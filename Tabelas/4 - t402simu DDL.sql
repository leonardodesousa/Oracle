-- Create table
create table T402SIMU
(
  cd_cli      NUMBER(5) not null,
  cd_emp      NUMBER(3) not null,
  cd_und      NUMBER(3) not null,
  dt_sml      DATE not null,
  nr_prc      NUMBER(3) not null,
  nr_ctr      NUMBER(5) not null,
  nr_cic      VARCHAR2(14) not null,
  tx_jur      NUMBER(10,4),
  vr_jur      NUMBER(6,2),
  vr_prc      NUMBER(10,2) not null,
  vr_iof      NUMBER(10,2),
  vr_tot_prc  NUMBER(10,2) not null,
  dt_venc     DATE,
  id_sit_parc VARCHAR2(2),
  dt_pgto     DATE,
  vr_pgo      NUMBER(10,2)
);

-- Add comments to the columns 
comment on column T402SIMU.cd_cli
  is 'Código do cliente';
comment on column T402SIMU.cd_emp
  is 'Código da empresa';
comment on column T402SIMU.cd_und
  is 'Codigo unidade';
comment on column T402SIMU.dt_sml
  is 'Data da simulação';
comment on column T402SIMU.nr_prc
  is 'Número da parcela';
comment on column T402SIMU.nr_ctr
  is 'Número do contrato';
comment on column T402SIMU.nr_cic
  is 'Número CPF/CNPJ';
comment on column T402SIMU.tx_jur
  is 'Taxa de júros';
comment on column T402SIMU.vr_jur
  is 'Valor do júros';
comment on column T402SIMU.vr_prc
  is 'Valor da parcela';
comment on column T402SIMU.vr_iof
  is 'Valor IOF';
comment on column T402SIMU.vr_tot_prc
  is 'Valor total da parcela';
comment on column T402SIMU.dt_venc
  is 'Data de vencimento';
comment on column T402SIMU.id_sit_parc
  is 'Situação da parcela';
comment on column T402SIMU.dt_pgto
  is 'Data de pagamento';
comment on column T402SIMU.vr_pgo
  is 'Valor pago';
-- Create/Recreate indexes 
alter table t402simu 
  add constraint pk_simu primary key(CD_CLI, NR_CTR, cd_und, cd_emp, nr_prc) using index;
alter table t402simu 
  add constraint fk_simu_oper foreign key (CD_CLI, cd_emp, NR_CTR, cd_und) references t402oper(CD_CLI, NR_CTR, cd_und, cd_emp) on delete cascade;
  
 




