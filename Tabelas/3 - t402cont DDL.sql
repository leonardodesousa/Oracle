-- Create table
create table T402CONT
(
  cd_cli      NUMBER(5) not null,
  cd_emp      NUMBER(3) not null,
  cd_und    NUMBER(3) not null,
  dt_sml      DATE not null,
  nr_prc      NUMBER(3) not null,
  nr_ctr      NUMBER(5) not null,
  nr_cic      VARCHAR2(14) not null,
  tx_jur      NUMBER(10,4),
  vr_jur      NUMBER(6,2),
  vr_prc      NUMBER(10,2) not null,
  vr_tot_prc  NUMBER(10,2) not null,
  dt_venc     DATE not null,
  id_sit_parc VARCHAR2(2) not null,
  dt_pgto     DATE,
  vr_pgo      NUMBER(10,2)
);

-- Add comments to the columns 
comment on column T402CONT.cd_cli
  is 'Código cliente';
comment on column T402CONT.cd_emp
  is 'Código empresa';
comment on column T402CONT.cd_und
  is 'Código unidade';
comment on column T402CONT.dt_sml
  is 'Data da simulação';
comment on column T402CONT.nr_prc
  is 'Número da parcela';
comment on column T402CONT.nr_ctr
  is 'Número do contrato';
comment on column T402CONT.nr_cic
  is 'Número CPF/CNPJ';
comment on column T402CONT.tx_jur
  is 'Taxa de Júros';
comment on column T402CONT.vr_jur
  is 'Valor cobrado de Júros';
comment on column T402CONT.vr_prc
  is 'Valor da parcela';
comment on column T402CONT.vr_tot_prc
  is 'Valor total da parcela';
comment on column T402CONT.dt_venc
  is 'Data de vencimento';
comment on column T402CONT.id_sit_parc
  is 'Situação da parcela';
comment on column T402CONT.dt_pgto
  is 'Data do pagamento';
comment on column T402CONT.vr_pgo
  is 'Valor pago';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T402CONT
  add constraint pk_cont primary key (cd_cli, cd_emp, cd_und ,nr_ctr, nr_prc)
  using index;
alter table T402CONT
  add constraint fk_cont_oper foreign key (cd_cli, cd_emp, cd_und ,nr_ctr) references t402oper(cd_cli, cd_emp, cd_und ,nr_ctr);
  

 

