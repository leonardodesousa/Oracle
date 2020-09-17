CREATE OR REPLACE PROCEDURE proc_contrato(pcd_cli     IN t400clie.cd_cli%type,
                                          pnr_ctr     IN t402oper.nr_ctr%type) IS
BEGIN
  DECLARE    
    v_dia_semana       number(1);
    v_data             date;
    v_qt_parcela       number(3);
    v_carencia         number(1);
    v_data_temp        date;
    v_ult_dia          number(2);
    v_vl_pcl           number(10, 6);
    v_nr_ctr           varchar2(10);
    v_nr_cic           varchar2(14);
    v_vl_ori           number(10, 2);
    v_vl_prc_sjur      number(10, 2);
    v_vl_juros_por_prc number(10, 2);
    v_tx_jur           number(9, 6);
    v_data_ori         date;
    v_id_sit_parc      varchar2(2);    
    

  BEGIN
    v_id_sit_parc := 'AB';
    v_nr_ctr := pnr_ctr;
    
    /* Define a data */
    SELECT trunc(dt_inc) INTO v_data FROM t402oper WHERE cd_cli = pcd_cli AND nr_ctr = v_nr_ctr;

    /*  Número do contrato */
  --SELECT MAX(nr_ctr) + 1 INTO v_nr_ctr FROM t402oper;
    
  
    /* Número CIC */
    SELECT nr_cic INTO v_nr_cic FROM t400clie WHERE cd_cli = pcd_cli;

    /* Define o dia  */
    SELECT to_char(dt_inc, 'D')
      INTO v_dia_semana
      FROM t402oper
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    /* Define a quantidade de parcelas */
    SELECT qt_amo 
      INTO v_qt_parcela 
      FROM t402oper 
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    /* Valor da parcela sem juros*/
    SELECT vl_ori 
      INTO v_vl_ori 
      FROM t402oper 
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    v_vl_ori := v_vl_ori / v_qt_parcela;

    /* taxa de juros*/
    SELECT tx_jur 
      INTO v_tx_jur 
      FROM t402oper 
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    SELECT vr_jur / v_qt_parcela
      INTO v_vl_prc_sjur
      FROM t402oper
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    /* Taxa de juros */
    SELECT round(vl_liq / qt_amo, 2)
      INTO v_vl_pcl
      FROM t402oper
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    /* Carencia */
    SELECT carencia 
      INTO v_carencia 
      FROM t402oper 
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    /* valor do juros por parcela */
    SELECT vr_jur / v_qt_parcela
      INTO v_vl_juros_por_prc
      FROM t402oper
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;
  -- DBMS_OUTPUT.PUT_LINE ('Carência ' || v_carencia);

    v_data := v_data + v_carencia;
    v_data_temp := v_data;
    v_data_ori := v_data;

 --   SELECT fn_dia_util(v_data) INTO v_data FROM dual;

    BEGIN
      FOR j IN 1 .. v_qt_parcela  LOOP
        SELECT EXTRACT(day FROM last_day(add_months(v_data_ori, j - 1)))
          INTO v_ult_dia
          FROM dual;
          SELECT add_months(v_data_ori,j - 1)
            INTO v_data_temp
            FROM dual;

            v_data := v_data_temp + v_ult_dia;
        SELECT fn_dia_util(v_data)
          INTO v_data
          FROM dual;

       --     DBMS_OUTPUT.PUT_LINE (v_data);
        /*      DBMS_OUTPUT.PUT_LINE (pcd_cli ||','|| v_loj ||','|| sysdate ||','|| j ||','|| v_nr_ctr ||',' || v_nr_cic ||','|| v_tx_jur ||','|| v_vl_juros_por_prc ||','|| v_vl_ori ||','|| v_vl_pcl ||','|| v_data);*/


             INSERT INTO t402cont
        VALUES
          (pcd_cli,
           1,    
		   1,
           sysdate,
           j,
           v_nr_ctr,
           v_nr_cic,
           v_tx_jur,
           v_vl_juros_por_prc,
           v_vl_ori,
           v_vl_pcl,
           v_data,
           v_id_sit_parc,
           null,
           null);


      END LOOP;
        COMMIT;
        UPDATE t402oper SET id_st = 'EF', dt_eft = sysdate where cd_cli = pcd_cli and nr_ctr = v_nr_ctr;
        COMMIT;  
    END; 
  END;
END;
