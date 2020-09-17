-- Create table
create table T400ENDE
(
  cd_cli     NUMBER(5) not null,
  cd_emp     NUMBER(3) not null,
  cd_und     NUMBER(3) not null,
  nm_rua     VARCHAR2(50) not null,
  id_num     NUMBER(6) not null,
  id_compl   VARCHAR2(50),
  nm_bair    VARCHAR2(100),
  nm_cdd     VARCHAR2(25),
  sg_est     VARCHAR2(2),
  cep        VARCHAR2(10),
  ddd        NUMBER(3),
  nm_tel     VARCHAR2(20),
  nm_rua2    VARCHAR2(50),
  id_num2    NUMBER(6),
  id_compl2  VARCHAR2(50),
  nm_bair2   VARCHAR2(20),
  nm_cdd2    VARCHAR2(20),
  sg_est2    VARCHAR2(2),
  cep2       NUMBER(10),
  ddd2       NUMBER(3),
  nm_tel2    VARCHAR2(20),
  dt_cad     TIMESTAMP(6) not null,
  dt_ult_atu TIMESTAMP(6)
);

-- Add comments to the columns 
comment on column T400ENDE.cd_cli
  is 'Código Cliente';
comment on column T400ENDE.cd_emp
  is 'Código empresa';
comment on column T400ENDE.cd_und
  is 'Código unidade';
comment on column T400ENDE.nm_rua
  is 'Nome da rua';
comment on column T400ENDE.id_num
  is 'Número da casa';
comment on column T400ENDE.id_compl
  is 'Complemento';
comment on column T400ENDE.nm_bair
  is 'Nome do Bairro';
comment on column T400ENDE.nm_cdd
  is 'Cidade';
comment on column T400ENDE.sg_est
  is 'Sigla UF';
comment on column T400ENDE.cep
  is 'Número CEP';
comment on column T400ENDE.ddd
  is 'DDD Telefone principal';
comment on column T400ENDE.nm_tel
  is 'Número Telefone Principal';
comment on column T400ENDE.nm_rua2
  is 'Nome da rua para conrrespondência';
comment on column T400ENDE.id_num2
  is 'Número da casa para correspondência';
comment on column T400ENDE.id_compl2
  is 'Complemento do endereço de correspondência';
comment on column T400ENDE.nm_bair2
  is 'Bairro do endereço de correspondência';
comment on column T400ENDE.nm_cdd2
  is 'Cidade endereço de correspondência';
comment on column T400ENDE.sg_est2
  is 'Sigla UF endereço correspondência';
comment on column T400ENDE.cep2
  is 'CEP Correspondência';
comment on column T400ENDE.ddd2
  is 'DDD Telefone secundário';
comment on column T400ENDE.nm_tel2
  is 'Núero Telefone Secundário';
comment on column T400ENDE.dt_cad
  is 'Data do cadastros';
comment on column T400ENDE.dt_ult_atu
  is 'Data da última atualização';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T400ENDE
  add constraint pk_ende primary key (CD_CLI, CD_UND, cd_emp);
  
alter table T400ENDE 
  add constraint fk_ende_clie foreign key (cd_cli, cd_und, cd_emp) references t400clie(cd_cli, cd_und, cd_emp)
  using index;
