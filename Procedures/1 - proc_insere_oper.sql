CREATE OR REPLACE PROCEDURE proc_insere_oper(pcd_cli   in t402oper.cd_cli%type,
                                             pqtd_amo  in t402oper.qt_amo%type,
                                             ptx_jur   in t402oper.tx_jur%type,
                                             pcarencia in t402oper.carencia%type,
                                             pvl_ori   in t402oper.vl_ori%type) IS
BEGIN
  DECLARE
    v_nm_cli t400clie.nm_cli%type;
    v_nr_ctr t402oper.nr_ctr%type;
    v_nr_cic t400clie.nr_cic%type;
    v_vr_jur t402oper.vr_jur%type;
    v_vr_liq t402oper.vl_liq%type;
    v_id_st  t402oper.id_st%type;
  
  BEGIN
  
    SELECT cl.nm_cli, cl.nr_cic
      INTO v_nm_cli, v_nr_cic
      FROM t400clie cl
     WHERE cl.cd_cli = pcd_cli;
  
    SELECT MAX(nr_ctr) + 1 INTO v_nr_ctr FROM t402oper;
    v_id_st := 'AB';  
    v_vr_jur := (ptx_jur / 100) * pvl_ori;
    v_vr_liq := v_vr_jur + pvl_ori;
  
    INSERT INTO t402oper
    VALUES
      (pcd_cli,
	   1,
	   1,
       v_nm_cli,
       SYSDATE,
       pqtd_amo,
       v_nr_ctr,
       v_nr_cic,
       ptx_jur,
       v_vr_jur,
       pcarencia,
       pvl_ori,
       v_vr_liq,
       v_id_st,
       NULL);
    COMMIT;
  END;

END;
