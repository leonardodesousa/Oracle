-- Create table
create table T402OPER
(
  cd_cli   NUMBER(5) not null,
  cd_emp   NUMBER(3) not null,
  cd_und   NUMBER(3) not null, 
  nm_cli   VARCHAR2(70) not null,
  dt_inc   DATE not null,
  qt_amo   NUMBER(3) not null,
  nr_ctr   NUMBER(10) not null,
  nr_cic   VARCHAR2(14) not null,
  tx_jur   NUMBER(10,5),
  vr_jur   NUMBER(6,2),
  carencia NUMBER(1),
  vl_ori   NUMBER(10,2) not null,
  vl_liq   NUMBER(10,2) not null,
  id_st    VARCHAR2(2),
  dt_eft   DATE
);

-- Add comments to the columns 
comment on column T402OPER.cd_cli
  is 'Código do cliente';
  comment on column T402OPER.cd_emp
  is 'Código da empresa';
  comment on column T402OPER.cd_und
  is 'Código da unidade';
comment on column T402OPER.nm_cli
  is 'Nome do cliente';
comment on column T402OPER.dt_inc
  is 'Data da inclusão';
comment on column T402OPER.qt_amo
  is 'Quantidade de parcelas';
comment on column T402OPER.nr_ctr
  is 'Número do contrato';
comment on column T402OPER.nr_cic
  is 'Número CPF/CNPJ';
comment on column T402OPER.tx_jur
  is 'Taxa de Júros';
comment on column T402OPER.vr_jur
  is 'Valor do júros';
comment on column T402OPER.carencia
  is 'Carência';
comment on column T402OPER.vl_ori
  is 'Valor original';
comment on column T402OPER.vl_liq
  is 'Valor líquido';
comment on column T402OPER.id_st
  is 'Situação';
comment on column T402OPER.dt_eft
  is 'Data de efetivação';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T402OPER
  add constraint pk_oper primary key (cd_cli, cd_emp, cd_und, nr_ctr)
  using index ;
alter table t402OPER 
  add constraint fk_OPER_CLIE foreign key  (cd_cli, cd_emp, cd_und) references t400clie(cd_cli, cd_emp, cd_und);



