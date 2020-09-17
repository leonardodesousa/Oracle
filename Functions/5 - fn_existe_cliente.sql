/* Verifica se existe o cliente na base através do número de cpf*/

CREATE OR REPLACE FUNCTION fn_existe_cliente (pnr_cic in t400clie.nr_cic%type) RETURN NUMBER
IS

vvar number(1);
BEGIN
  SELECT 1
  INTO vvar
  FROM t400clie
  WHERE nr_cic = pnr_cic;
  RETURN 1;

  EXCEPTION    
    WHEN others THEN
      RETURN 0;
END;





    