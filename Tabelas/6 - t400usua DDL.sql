-- Create table
create table T400USUA
(
  cd_func    NUMBER(4) not null,
  nm_func    VARCHAR2(50) not null,
  de_login   VARCHAR2(25) not null,
  de_senha   VARCHAR2(32) not null,
  senha_md5  VARCHAR2(32) not null,
  id_sit     CHAR(1) default 'I',
  dt_criacao TIMESTAMP(6),
  dt_ult_atu TIMESTAMP(6),
  dt_vl      NUMBER(4)
);

-- Add comments to the columns 
comment on column T400USUA.cd_func
  is 'Código do funcionário';
comment on column T400USUA.nm_func
  is 'Nome do funcionário';
comment on column T400USUA.de_login
  is 'Login';
comment on column T400USUA.de_senha
  is 'Senha';
comment on column T400USUA.senha_md5
  is 'Senha MD5';
comment on column T400USUA.id_sit
  is 'Situação';
comment on column T400USUA.dt_criacao
  is 'Data de criação';
comment on column T400USUA.dt_ult_atu
  is 'Data da última atualização';
comment on column T400USUA.dt_vl
  is 'Validade da senha';
-- Create/Recreate primary, unique and foreign key constraints 
alter table T400USUA
  add constraint pk_usua primary key (CD_FUNC, de_login)
  using index ;

