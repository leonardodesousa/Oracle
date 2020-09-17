-- Create table
create table T402CPLT
(
  LOTE        NUMBER(5) not null,
  CONTRATO    NUMBER(5) not null,
  CLIENTE    NUMBER(5) not null, 
 TIPO_LOTE     VARCHAR2(3) not null,  
  VALOR       NUMBER(15,2),  
  ITF_ORIGEM    VARCHAR2(20)  
  
);

-- Add comments to the columns 
comment on column T402CPLT.LOTE
  is 'Número do lote';
comment on column T402CPLT.CONTRATO
  is 'Número do contrato';
comment on column T402CPLT.TIPO_LOTE
  is 'Tipo do lote'; 
comment on column T402CPLT.VALOR
  is 'Valor Total'; 
 comment on column T402CPLT.ITF_ORIGEM
  is 'Número da parcela'; 
 
  
alter table T402CPLT
  add constraint pk_cplt primary key (LOTE, CONTRATO, CLIENTE)
  using index ;
  
alter table T402CPLT
  add check (TIPO_LOTE in ('LIQ','RNG','EFT'));
  
alter table T402CPLT
  add constraint fk_cplt_lote foreign key (LOTE, CONTRATO, CLIENTE) references t402lote(LOTE, CONTRATO, CLIENTE);
  


  

 