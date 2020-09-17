CREATE OR REPLACE PROCEDURE proc_cadastra_cliente (pemp        in t400clie.cd_emp%type
												  ,pund        in t400clie.cd_und%type
                                                  ,pnome       in t400clie.nm_cli%type
                                                  ,pmail       in t400clie.email%type                                                                                                    
                                                  ,pnr_cic     in t400clie.nr_cic%type
                                                  ,pid_tp_pes  in t400clie.id_tp_pes%type
                                                                                        )
IS
--BEGIN
 --DECLARE
 --vcd_cli number(5); -- A partir do dia 23/07/2017, passei a utilizar sequence e trigger para o campo cd_cli
 BEGIN
 /*SELECT max(cd_cli)+1
    INTO vcd_cli
    FROM t400clie;  */
  INSERT INTO t400clie (/*cd_cli*/
						cd_emp
                       ,cd_und
                       ,nm_cli
                       ,email
                       ,id_sit
                       ,dt_cad
                       ,dt_ult_atu
                       ,nr_cic
                       ,id_tp_pes)
                VALUES (/*vcd_cli*/
                        pemp
					   ,pund
                       ,pnome
                       ,pmail
                       ,'A'
                       ,SYSDATE
                       ,SYSDATE
                       ,pnr_cic
                       ,pid_tp_pes);
  COMMIT;
 END; 
--END;
