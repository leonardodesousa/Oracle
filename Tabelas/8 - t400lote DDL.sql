-- Create table
create table T402LOTE
(
  LOTE      	NUMBER(5) not null,
  CONTRATO  	NUMBER(5) not null,
  CLIENTE   	NUMBER(5) not null,
  PARCELA   	NUMBER(3),
  DESCONTO  	NUMBER(15,2),
  VALOR     	NUMBER(15,2),
  TIPO_LOTE 	VARCHAR2(3),
  ITF_ORIGEM    VARCHAR2(20)  
  
);

-- Add comments to the columns 
comment on column T402LOTE.LOTE
  is 'Número do lote';
comment on column T402LOTE.CONTRATO
  is 'Número do contrato';
comment on column T402LOTE.CLIENTE
  is 'Código do cliente'; 
comment on column T402LOTE.PARCELA
  is 'Número da parcela'; 
comment on column T402LOTE.DESCONTO
  is 'Valor do desconto ';  
comment on column T402LOTE.VALOR
  is 'Valor calculado '; 
comment on column T402LOTE.TIPO_LOTE
  is 'Identificação do tipo de lote '; 
comment on column T402LOTE.ITF_ORIGEM
  is 'Identificação da interface de origem do lote';   
  
alter table T402LOTE
	add constraint pk_LOTE primary key (LOTE, CONTRATO, CLIENTE)
	using index ;
  
alter table T402LOTE
	add check (TIPO_LOTE in ('LIQ','RNG','EFT'));
	

 