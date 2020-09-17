CREATE OR REPLACE PROCEDURE proc_contrato_simu_v4(pcd_cli     IN t400clie.cd_cli%type,
                                                  pnr_ctr     IN t402oper.nr_ctr%type,
                                                  pmetodo_calculo IN varchar2 default NULL) IS
BEGIN
/**********************************************************************************************
Versão 4.0
Data: 12/09/2020
Descrição: Aperfeiçoamento do método de calculo PRICE e SAC/ Redução de selects das variáveis
Recurso Responsável: Leonardo de Sousa

----------------------------------------------------------------------------------------------

Versão 3.0
Data: 02/04/2020
Descrição: Inclusao do método de cálculo PRICE
Recurso Responsável: Leonardo de Sousa

----------------------------------------------------------------------------------------------

Versão 2.0
Data: 18/08/2019
Descrição: Inclusão dos campos prazototal e v_vl_total_juros. Aperfeiçoamento do método SAC
Recurso Responsável: Leonardo de Sousa

----------------------------------------------------------------------------------------------

Versão 1.0
Data: 30/05/2016
Descrição: Criação da procedure
Recurso Responsável: Leonardo de Sousa
**********************************************************************************************/

  DECLARE
    v_dia_semana       number(1);
    v_data             date;
    v_qt_parcela       number(3);
    v_carencia         number(5);
    v_data_temp        date;
    v_ult_dia          number(2);
    v_vl_pcl           number(15, 2);
    v_nr_ctr           varchar2(10);
    v_nr_cic           varchar2(14);
    v_vl_ori           number(15, 2);
    v_vl_prc_sjur      number(15, 2);
    v_vl_juros_por_prc number(15, 2);
    v_tx_jur           number(15, 5);
    v_data_ori         date;
    v_id_sit_parc      varchar2(2);
    v_data_atual       date;
    v_prazo_total      number(5);
    v_sd_financeiro    number(20, 2);
    v_vl_total_juros   number(20,2);
    v_valor_parc_price number(20,2);
    v_metodo_calculo   varchar2(10);
    v_vr_parcel_aux    number(20,2);


  BEGIN
    v_metodo_calculo := pmetodo_calculo;
    IF pmetodo_calculo IS NULL THEN
      v_metodo_calculo := 'SAC';
      END IF;


    SELECT dataatual
      INTO v_data_atual
      FROM agencias
     WHERE empresa = 1
       AND unidade = 1;

    delete from t402simu where nr_ctr = pnr_ctr;
    commit;

    v_id_sit_parc := 'AB';
    v_nr_ctr := pnr_ctr;

    /* Define a data */      
    SELECT COALESCE(trunc(dt_inc),v_data_atual ) INTO v_data FROM t402oper WHERE cd_cli = pcd_cli AND nr_ctr = v_nr_ctr;

    /* Número CIC */
    SELECT nr_cic INTO v_nr_cic FROM t400clie WHERE cd_cli = pcd_cli;

    /* Definindo o valor das variáveis */
    SELECT to_char(dt_inc, 'D')         -- 1 Define o dia da semana
          , qt_amo                      -- 2 Define a quantidade de parcelas
          , vl_ori                      -- 3 Valor Principal do contrato
          , (vl_ori/qt_amo)             -- 4 Valor principal da parcela sem encargos
          , tx_jur                      -- 5 Taxa de Juros
          , (vr_jur / v_qt_parcela)     -- 6 Valor de juros por parcela
          , round(vl_liq / qt_amo, 2)   -- 7 Valor da parcela
          , carencia                    -- 8 Carencia em dias
          , (vr_jur / v_qt_parcela)     -- 9 Juros por parcela


      INTO v_dia_semana         -- 1
          , v_qt_parcela        -- 2
          , v_sd_financeiro     -- 3
          , v_vl_ori            -- 4
          , v_tx_jur            -- 5
          , v_vl_prc_sjur       -- 6
          , v_vl_pcl            -- 7
          , v_carencia          -- 8
          , v_vl_juros_por_prc  -- 9
      FROM t402oper
     WHERE cd_cli = pcd_cli
       AND nr_ctr = v_nr_ctr;

    /* Ajustar a data de inicio do contrato */
    v_data := v_data + v_carencia;
    v_data_temp := v_data;
    v_data_ori := v_data;

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


        v_vl_juros_por_prc := ((v_tx_jur/100) * (v_sd_financeiro - ((j-1)* v_vl_ori)));
             INSERT INTO t402simu
        VALUES
          (pcd_cli,
           1,
           1,
           v_data_atual,
           j,
           v_nr_ctr,
           v_nr_cic,
           v_tx_jur,
           v_vl_juros_por_prc,
           v_vl_ori,
           null,
           v_vl_ori + v_vl_juros_por_prc,
           v_data,
           v_id_sit_parc,
           null,
           null,
           v_sd_financeiro - (j* v_vl_ori));

           /*AJUSTANDO OS CENTAVOS DO ARRENDONDAMENTO NA ULTIMA PARCELA*/
           IF j = v_qt_parcela THEN
             UPDATE t402simu
                SET vr_principal = 0
              where nr_ctr = pnr_ctr and cd_cli = pcd_cli and nr_prc = j;
             COMMIT;
            END IF;

      END LOOP;
        COMMIT;
        select max(dt_venc) - v_data_atual
          into v_prazo_total
         from t402simu where nr_ctr = pnr_ctr;

         update t402oper set prazototal = v_prazo_total where nr_ctr = pnr_ctr;
         commit;

         select sum(vr_jur)
         into v_vl_total_juros
         from t402simu where nr_ctr = pnr_ctr and cd_cli = pcd_cli;

         update t402oper set vr_jur = v_vl_total_juros, vl_liq = vl_ori + v_vl_total_juros
         where nr_ctr = pnr_ctr and cd_cli = pcd_cli;
         commit;

         IF pmetodo_calculo = 'PRICE' THEN

            SELECT qt_amo
              INTO v_qt_parcela
              FROM t402oper
             WHERE cd_cli = pcd_cli
               AND nr_ctr = v_nr_ctr;


            select vl_ori
              into v_vl_ori
              from t402oper
             where nr_ctr = pnr_ctr and cd_cli = pcd_cli;


             v_tx_jur := (v_tx_jur*0.01);

             v_valor_parc_price := v_vl_ori * (POWER((1+v_tx_jur),v_qt_parcela)*v_tx_jur) / (POWER((1 + v_tx_jur), v_qt_parcela)-1);

             UPDATE t402simu set vr_tot_prc = v_valor_parc_price where nr_ctr = pnr_ctr and cd_cli = pcd_cli;
             COMMIT;

             BEGIN
               FOR j IN 1 .. v_qt_parcela  LOOP
                 /*CALCULANDO O VALOR DO JUROS*/
                 update t402simu
                   set vr_jur =  v_tx_jur * v_vl_ori
                   where nr_ctr = pnr_ctr and cd_cli = pcd_cli and nr_prc = j;
                   COMMIT;

                 /*CALCULANDO O VALOR DA AMORTIZAÇÃO*/
                 update t402simu
                    set vr_prc = vr_tot_prc - vr_jur
                   where nr_ctr = pnr_ctr and cd_cli = pcd_cli and nr_prc = j;
                   COMMIT;

                   /*DEFINE O VALOR DA AMORTIZAÇÃO*/
                   SELECT vr_prc
                     INTO v_vr_parcel_aux
                     FROM t402simu
                    where nr_ctr = pnr_ctr and cd_cli = pcd_cli and nr_prc = j;
                   v_vl_ori := v_vl_ori - v_vr_parcel_aux;

                  /*ATUALIZANDO O SALDO FINANCEIRO (PRINCIPAL - AMORTIZAÇÃO)*/
                 update t402simu
                    set vr_principal = v_vl_ori
                  where nr_ctr = pnr_ctr and cd_cli = pcd_cli and nr_prc = j;
                 COMMIT;

                 /*AJUSTANDO OS CENTAVOS DO ARRENDONDAMENTO NA ULTIMA PARCELA*/
                 IF j = v_qt_parcela THEN
                   UPDATE t402simu
                      SET vr_principal = 0
                    where nr_ctr = pnr_ctr and cd_cli = pcd_cli and nr_prc = j;
                   COMMIT;
                  END IF;

               END LOOP;
               END;
         END IF;
         update t402oper set metodo_calculo = v_metodo_calculo where nr_ctr = pnr_ctr and cd_cli = pcd_cli;
         DELETE FROM NOVA_OPERACAO WHERE cd_cli = pcd_cli and nr_ctr <> pnr_ctr;
         UPDATE NOVA_OPERACAO SET nr_ctr = pnr_ctr WHERE cd_cli = pcd_cli;
         COMMIT;
    END;
  END;
END;
