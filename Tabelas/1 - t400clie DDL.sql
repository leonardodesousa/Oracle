-- Create table
create table T400CLIE
(
  cd_cli     NUMBER(5) not null,
  cd_emp     number(3)not null, 
  cd_und     NUMBER(3) not null, 
  nm_cli     VARCHAR2(70) not null,
  email      VARCHAR2(50),
  id_sit     CHAR(1) not null,
  dt_cad     TIMESTAMP(6) not null,
  dt_ult_atu TIMESTAMP(6) not null,
  nr_cic     VARCHAR2(14) not null,
  id_tp_pes  VARCHAR2(1) not null  
);

-- Add comments to the columns 
comment on column T400CLIE.cd_cli
  is 'Código do cliente';
  comment on column T400CLIE.cd_und
  is 'Unidade do cliente';
  comment on column T400CLIE.cd_emp
  is 'Empresa do cliente';
comment on column T400CLIE.nm_cli
  is 'Nome do cliente';
comment on column T400CLIE.email
  is 'Email';
comment on column T400CLIE.id_sit
  is 'Situação';
comment on column T400CLIE.dt_cad
  is 'Data do cadastros';
comment on column T400CLIE.dt_ult_atu
  is 'Data da última atualização';
comment on column T400CLIE.nr_cic
  is 'CPF/CNPJ';
comment on column T400CLIE.id_tp_pes
  is 'Tipo pessoa (Física ou Jurídica)';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T400CLIE
  add constraint pk_clie primary key (CD_CLI, CD_UND, CD_EMP)
  using index ;

-- Create/Recreate check constraints 
alter table T400CLIE
  add check (id_tp_pes in ('F','J'));

