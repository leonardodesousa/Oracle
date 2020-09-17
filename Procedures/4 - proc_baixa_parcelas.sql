CREATE OR REPLACE PROCEDURE proc_baixa_parcelas(pcd_cli in t402cont.cd_cli%type,
                                                pnr_ctr in t402cont.nr_ctr%type,
                                                pnr_prc in t402cont.nr_prc%type) IS
BEGIN
  DECLARE
    v_qt_dias number(10);
    vjuros    number(10, 2);
    v_vr_parc number(10, 2);
    vperiodo  number(10);
  
  BEGIN
    /* dias em atraso*/
    SELECT ((select trunc(sysdate) from dual) -
           (select (dt_venc)
               FROM t402cont
              where nr_prc = pnr_prc
                and nr_ctr = pnr_ctr
                and cd_cli = pcd_cli))
      INTO v_qt_dias
      FROM dual;
    /*  DBMS_OUTPUT.PUT_LINE (v_qt_dias); */
  
    CASE
      WHEN v_qt_dias <= 0 THEN
        SELECT vr_tot_prc
          INTO v_vr_parc
          FROM t402cont
         WHERE nr_ctr = pnr_ctr
           AND nr_prc = pnr_prc
           AND cd_cli = pcd_cli;
      
        UPDATE t402cont
           set id_sit_parc = 'PG', vr_pgo = v_vr_parc, dt_pgto = sysdate
         WHERE nr_ctr = pnr_ctr
           AND nr_prc = pnr_prc
           AND cd_cli = pcd_cli;
        COMMIT;
      WHEN v_qt_dias > 0 THEN
        /* Juros */
        SELECT vr_jur
          INTO vjuros
          FROM t402oper
         WHERE nr_ctr = pnr_ctr
           AND cd_cli = pcd_cli;
      
        /* Período */
        SELECT ((SELECT MAX(dt_venc)
                   FROM t402cont
                  WHERE cd_cli = pcd_cli
                    AND nr_ctr = pnr_ctr) -
               (SELECT trunc(dt_eft)
                   FROM T402oper
                  WHERE cd_cli = pcd_cli
                    AND nr_ctr = pnr_ctr))
          INTO vperiodo
          FROM dual;
      
        /* juros recalculado */
        select round(vjuros / vperiodo, 2) INTO vjuros FROM dual;
        vjuros := vjuros * v_qt_dias;
      
        /*Valor final */
        SELECT vr_tot_prc
          INTO v_vr_parc
          FROM t402cont
         WHERE nr_ctr = pnr_ctr
           AND nr_prc = pnr_prc
           AND cd_cli = pcd_cli;
      
        v_vr_parc := v_vr_parc + vjuros;
      
        UPDATE t402cont
           SET id_sit_parc = 'PG', vr_pgo = v_vr_parc, dt_pgto = sysdate
         WHERE nr_ctr = pnr_ctr
           AND nr_prc = pnr_prc
           AND cd_cli = pcd_cli;
        COMMIT;
      
    END CASE;
  END;
END;
