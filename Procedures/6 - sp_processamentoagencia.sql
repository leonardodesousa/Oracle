CREATE OR REPLACE PROCEDURE sp_processamentoagencia
IS

begin
  declare
  vcontador  number;
  vcliente   number;
  vcotrato   number;
  vparcela   number;
  vdataAtual date;

  begin
    
  update agencias set processamentoiniciado = 1, inicioprocessamento = sysdate
  where empresa = 1 and unidade = 1;
  COMMIT;
  delete from t402cont_temp;
  COMMIT;
  
  SELECT dataatual 
    INTO vdataAtual
    FROM agencias
   WHERE unidade = 1
     AND empresa = 1;
  
  insert into t402cont_temp 
  (select * from t402cont where id_sit_parc = 'AB');
  commit;  
  
    select count(1)
      into vcontador
      from t402cont_temp
     where id_sit_parc = 'AB';

     FOR j IN 1 .. vcontador  LOOP
     select nr_ctr
       into vcotrato
       from t402cont_temp
     where id_sit_parc = 'AB'
       and rownum < 2
     order by nr_ctr, nr_prc asc;

       select distinct cd_cli
       into vcliente
       from t402cont_temp
     where nr_ctr = vcotrato;

      select nr_prc
       into vparcela
       from t402cont_temp
     where nr_ctr = vcotrato
     and rownum < 2
     order by nr_prc asc;

       proc_calculo_liquidacao_processamento(vcliente, vcotrato, vparcela);
       delete from t402cont_temp where nr_ctr = vcotrato and cd_cli = vcliente and nr_prc = vparcela;
       commit;
       end loop;
       
           
      INSERT INTO contabilizacaoContratos (CLIENTE, EMPRESA, UNIDADE, Contrato, Aditivo, Saldoatualcontabil, Datacalculo) 
  select cliente, 1, 1, contrato, 0, sum(valor), (SELECT dataatual FROM agencias WHERE empresa = 1 AND unidade = 1) from valorParcelas
  group by cliente, contrato
  order by contrato asc ; 
  
  COMMIT;
  DELETE FROM valorParcelas;
  COMMIT; 
  
    update agencias set dataultimoprocessamento = vdataAtual,
  dataatual = fn_dia_util(dataatual + 1), dataProximoProcessamento = fn_dia_util(dataProximoProcessamento + 1), processamentoiniciado = 0,
  fimprocessamento = sysdate
  where empresa = 1 and unidade = 1;
  
  COMMIT;
   
  end;
  

end;


 