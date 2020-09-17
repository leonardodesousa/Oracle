create table t400feri 
(
desc_feriado varchar(50)not null,
desc_data date not null
);

comment on column t400feri.desc_feriado is 
'Descrição do feriado';

Comment on column t400feri.desc_data is 
'Data calendário do feriado';

create index IDX_FERI 
       on t400feri (desc_feriado, desc_data);
