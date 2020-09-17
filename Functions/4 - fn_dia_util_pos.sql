/* Calcula dia útil para vencimento postecipado */

CREATE OR REPLACE FUNCTION fn_dia_util_pos (pdata IN t400feri.desc_data%type) return date

IS
   v_dia_semana char(1);
   v_data date;
   vvar number(1);

BEGIN
  SELECT fn_feriado(v_data)
    INTO vvar
    FROM dual;
    
    v_data := v_data + vvar;

  SELECT to_char(pdata,'D')
    INTO v_dia_semana
    FROM dual;
    
    CASE
      WHEN v_dia_semana = 1 THEN  v_data := pdata + 1;     
      WHEN v_dia_semana = 7 THEN v_data := pdata + 2; 
      ELSE v_data := pdata;      
    END CASE ;
    
    SELECT fn_feriado(v_data)
    INTO vvar
    FROM dual;
    
    v_data := v_data + vvar;

    RETURN v_data;

END;
