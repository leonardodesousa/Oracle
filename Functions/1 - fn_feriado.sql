/* verifica feriados */

CREATE OR REPLACE FUNCTION fn_feriado (pdata in t400feri.desc_data%type) RETURN NUMBER
IS

vvar NUMBER(1);
vexiste NUMBER;

BEGIN
  SELECT 1
    INTO vvar
    FROM t400feri
   WHERE desc_data = pdata;           
         CASE 
           WHEN vvar = 1 THEN
             vexiste := 1;
         END CASE;          
    RETURN vexiste;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      vexiste := 0;                     

    RETURN vexiste;

END;      

