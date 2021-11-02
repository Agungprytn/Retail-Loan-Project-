 --sqlplus -S  MISADM/inni0821@INOANMIS @/inoan/dw/batch/datamart/dmt_iedw_rt_lnb_base.sql JDMT000291 20200216
 --sqlplus MISADM/inni0821@INOANMIS @/inoan/dw/batch/datamart/dmt_iedw_rt_lnb_base.sql JDMT000291 20200216
 --------------------------------------------------------------------------------
 -- Program Name : iedw_rt_lnb_base
 -- Description  : RETAIL LOAN MART TABLE  INSERT
 -- Parameters   : 1. JOB ID
 --------------------------------------------------------------------------------
 -- Created Date : 2013. 03.
 -- Creator      :
 --------------------------------------------------------------------------------
 -- Memo         :
 --------------------------------------------------------------------------------
 SET SERVEROUTPUT ON SIZE 1000000
 SET LINESIZE 200
 SET TIMING   ON
 SET TERMOUT  ON

 BEGIN
      DECLARE
             i       NUMBER;

             --------------------------------------------------------------------
             -- 변수선언부
             --------------------------------------------------------------------
             -- 로그관리용 변수
             V_PROC_DT                    VARCHAR2(8)  ;
             V_BAT_JOB_ID                 VARCHAR2(10) ;
             V_RUN_SEQ_NO                 NUMBER(5)    ;
             V_PROC_ST_CD                 CHAR(1)      ;
             V_ERR_MSG_CTT                VARCHAR2(500);
             V_PROC_CNT                   NUMBER(10)   ;
             V_BAT_PGM_ID                 VARCHAR2(10) ;
             V_PROC_BASC_DT               VARCHAR2(8)  ;
             V_PGM_FILE_PATH              VARCHAR2(100);
             V_PARM_INFO_CTT              VARCHAR2(100);

             V_LST_SEQ_NO                 NUMBER   ;
             V_BF1M_BIZ_DT                VARCHAR2(8)  ;

     BEGIN

             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--A.배치작업 HEAD START');
             DBMS_output.put_line('====================================================================');
             --------------------------------------------------------------------
             -- 변수설정부
             --------------------------------------------------------------------

             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP1 파라미터설정');
             --------------------------------------------------------------------
             V_PARM_INFO_CTT :='&1' || ' ' || '&2';  --파라미터정보(JOB ID)
             --V_PARM_INFO_CTT :='&1';  --파라미터정보(JOB ID)
             V_BAT_JOB_ID    := '&1';                 --JOB ID



             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP2 변수설정');
             --------------------------------------------------------------------
             V_PROC_DT         := TO_CHAR(SYSDATE,'YYYYMMDD'); --처리일(시스템일)
             V_PROC_CNT        := 0;                           --처리건수(초기화)

             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP3 연산변수설정');
             --------------------------------------------------------------------

             --V_PROC_BASC_DT := TO_CHAR(SYSDATE,'YYYYMMDD');

             V_PROC_BASC_DT := '&2';

             DBMS_output.put_line('V_PROC_BASC_DT : ' || V_PROC_BASC_DT);

             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP4 실행순번채번');
             --------------------------------------------------------------------
             --로그실행순번채번
             V_RUN_SEQ_NO := GET_LOG_SEQ_F(V_BAT_JOB_ID);


             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] 로그 INSERT : 처리중');
             --------------------------------------------------------------------
             V_PROC_ST_CD := '1'; --(1:처리중 2:처리완료 3:에러발생)
             
			 IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);

			 DELETE FROM IEDW_RT_LNB_BASE WHERE BASC_DT = V_PROC_BASC_DT;
			 
			 COMMIT;

             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--B.배치작업 BODY START');
             DBMS_output.put_line('====================================================================');

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP1. HANYA COBA .');
             --------------------------------------------------------------------
			 
			 INSERT INTO  IEDW_RT_LNB_BASE
            (
                      BASC_DT
             ,        REF_NO
             ,        ISYS_UPD_DTM
             ,        IKIS_STS
             ,        BK_GB
             ,        CIX_NO             
             ,        COM_ID
             ,        COM_NM
             ,        OPEN_IL
             ,        TOT_EXP_IL
             ,        REAL_EXP_IL
             ,        FST_EXP_IL
             ,        LON_CCY
             ,        FST_LON_AMT
             ,        LON_JAN
             ,        REPAY_GB
             ,        SCH_GB
             ,        TERM_GB
             ,        ACCRUAL_GB
             ,        ACT_GB
             ,        GUCH_TERM
             ,        REPAY_TERM
             ,        REPAY_GAP
             ,        REPAY_GAP_GB
             ,        GRACE_DAYS
             ,        REPAY_CNT
             ,        FST_REPAY_IL
             ,        LST_REPAY_IL
             ,        NX_REPAY_IL
             ,        LST_ISU_IL
             ,        LST_IIB_IL
             ,        NX_ISU_IL             
             ,        LST_RT
             ,        MISU_AMT
             ,        MISU_SEQ
             ,        MKJ_AMT
             ,        MKJ_SEQ
             ,        REPAY_ADJ_SEQ
             ,        REPAY_NX_SEQ
             ,        INT_ADJ_SEQ
             ,        INT_NX_SEQ
             ,        PRN_YC_GB
             ,        PRN_YC_IL
             ,        INT_YC_GB
             ,        YC_GUN
             ,        TIMES_PAST_DUE_CNT
             ,        REG_PAY_AMT
             ,        NON_EQ_GB
             ,        NON_EQ_AMT
             ,        RATE_CCY
             ,        FIX_FLT_GB
             ,        SPREAD_GB
             ,        SPREAD_RT             
             ,        ROLL_GAP
             ,        ROLL_GAP_GB
             ,        LATE_CHG_YN
             ,        LATE_CHG_RT
             ,        PAST_DUE_RT
             ,        ACCRUAL_RT
             ,        CAP_RT_YN
             ,        CAP_RT_LIFE
             ,        CAP_RT_PRD
             ,        FLOOR_RT_YN
             ,        FLOOR_RT_LIFE
             ,        FLOOR_RT_PRD
             ,        ADV_ARR_GB
             ,        SINGLE_BOTH_TYPE
             ,        ACCR_TYPE
             ,        BSNS_DAY_RULE
             ,        INT_GAP
             ,        INT_GAP_GB
             ,        INT_ADJ_YN
             ,        ALL_IN_YIELD
             ,        HD_SNG_NO
             ,        FEE_YN
             ,        APPLI_FEE
             ,        ORIGI_FEE
             ,        RENEW_FEE
             ,        BROKA_FEE
             ,        OTHER_FEE
             ,        EVID_AMT
             ,        USD_CVT_AMT
             ,        BBS_CVT_AMT
             ,        AUTO_DEBIT_YN
             ,        LOSS_AMT
             ,        RESTRUCTURING_YN
             ,        FST_IB_IL
             ,        LST_DEAL_IL
             ,        LST_IB_IL
             ,        OP_NO
             ,        IBF_GB             
             ,        NXT_RT
             ,        NXT_SCH_YN
             ,        NEW_SCH_YN
             ,        AGR_REF_NO
             ,        AGR_SEQ_NO             
             ,        FLAT_SLIDING
			 ,        COLL_CD 
			 ,        APPC_OP_NO   
			 ,        APPC_PATH1_CD
			 ) 
             SELECT 
                     V_PROC_BASC_DT                AS       BASC_DT
             ,       A.REF_NO                      AS       REF_NO
             ,       SYSDATE                       AS       ISYS_UPD_DTM
             ,       A.IKIS_STS                    AS       IKIS_STS
             ,       A.BK_GB                       AS       BK_GB
             ,       A.CIX_NO                      AS       CIX_NO             
             ,       A.COM_ID                      AS       COM_ID
             ,       A.COM_NM                      AS       COM_NM
             ,       A.OPEN_IL                     AS       OPEN_IL
             ,       A.TOT_EXP_IL                  AS       TOT_EXP_IL
             ,       A.REAL_EXP_IL                 AS       REAL_EXP_IL
             ,       A.FST_EXP_IL                  AS       FST_EXP_IL
             ,       A.LON_CCY                     AS       LON_CCY
             ,       A.FST_LON_AMT                 AS       FST_LON_AMT
             ,       A.LON_JAN                     AS       LON_JAN
             ,       A.REPAY_GB                    AS       REPAY_GB
             ,       A.SCH_GB                      AS       SCH_GB
             ,       A.TERM_GB                     AS       TERM_GB
             ,       A.ACCRUAL_GB                  AS       ACCRUAL_GB
             ,       A.ACT_GB                      AS       ACT_GB
             ,       A.GUCH_TERM                   AS       GUCH_TERM
             ,       A.REPAY_TERM                  AS       REPAY_TERM
             ,       A.REPAY_GAP                   AS       REPAY_GAP
             ,       A.REPAY_GAP_GB                AS       REPAY_GAP_GB
             ,       A.GRACE_DAYS                  AS       GRACE_DAYS
             ,       A.REPAY_CNT                   AS       REPAY_CNT
             ,       A.FST_REPAY_IL                AS       FST_REPAY_IL
             ,       A.LST_REPAY_IL                AS       LST_REPAY_IL
             ,       A.NX_REPAY_IL                 AS       NX_REPAY_IL
             ,       A.LST_ISU_IL                  AS       LST_ISU_IL
             ,       A.LST_IIB_IL                  AS       LST_IIB_IL
             ,       A.NX_ISU_IL                   AS       NX_ISU_IL             
             ,       A.LST_RT                      AS       LST_RT
             ,       A.MISU_AMT                    AS       MISU_AMT
             ,       A.MISU_SEQ                    AS       MISU_SEQ
             ,       A.MKJ_AMT                     AS       MKJ_AMT
             ,       A.MKJ_SEQ                     AS       MKJ_SEQ
             ,       A.REPAY_ADJ_SEQ               AS       REPAY_ADJ_SEQ
             ,       A.REPAY_NX_SEQ                AS       REPAY_NX_SEQ
             ,       A.INT_ADJ_SEQ                 AS       INT_ADJ_SEQ
             ,       A.INT_NX_SEQ                  AS       INT_NX_SEQ
             ,       A.PRN_YC_GB                   AS       PRN_YC_GB
             ,       A.PRN_YC_IL                   AS       PRN_YC_IL
             ,       A.INT_YC_GB                   AS       INT_YC_GB
             ,       A.YC_GUN                      AS       YC_GUN
             ,       A.TIMES_PAST_DUE_CNT          AS       TIMES_PAST_DUE_CN
             ,       A.REG_PAY_AMT                 AS       REG_PAY_AMT
             ,       A.NON_EQ_GB                   AS       NON_EQ_GB
             ,       A.NON_EQ_AMT                  AS       NON_EQ_AMT
             ,       A.RATE_CCY                    AS       RATE_CCY
             ,       A.FIX_FLT_GB                  AS       FIX_FLT_GB
             ,       A.SPREAD_GB                   AS       SPREAD_GB
             ,       A.SPREAD_RT                   AS       SPREAD_RT             
             ,       A.ROLL_GAP                    AS       ROLL_GAP
             ,       A.ROLL_GAP_GB                 AS       ROLL_GAP_GB
             ,       A.LATE_CHG_YN                 AS       LATE_CHG_YN
             ,       A.LATE_CHG_RT                 AS       LATE_CHG_RT
             ,       A.PAST_DUE_RT                 AS       PAST_DUE_RT
             ,       A.ACCRUAL_RT                  AS       ACCRUAL_RT
             ,       A.CAP_RT_YN                   AS       CAP_RT_YN
             ,       A.CAP_RT_LIFE                 AS       CAP_RT_LIFE
             ,       A.CAP_RT_PRD                  AS       CAP_RT_PRD
             ,       A.FLOOR_RT_YN                 AS       FLOOR_RT_YN
             ,       A.FLOOR_RT_LIFE               AS       FLOOR_RT_LIFE
             ,       A.FLOOR_RT_PRD                AS       FLOOR_RT_PRD
             ,       A.ADV_ARR_GB                  AS       ADV_ARR_GB
             ,       A.SINGLE_BOTH_TYPE            AS       SINGLE_BOTH_TYPE
             ,       A.ACCR_TYPE                   AS       ACCR_TYPE
             ,       A.BSNS_DAY_RULE               AS       BSNS_DAY_RULE
             ,       A.INT_GAP                     AS       INT_GAP
             ,       A.INT_GAP_GB                  AS       INT_GAP_GB
             ,       A.INT_ADJ_YN                  AS       INT_ADJ_YN
             ,       A.ALL_IN_YIELD                AS       ALL_IN_YIELD
             ,       A.HD_SNG_NO                   AS       HD_SNG_NO
             ,       A.FEE_YN                      AS       FEE_YN
             ,       A.APPLI_FEE                   AS       APPLI_FEE
             ,       A.ORIGI_FEE                   AS       ORIGI_FEE
             ,       A.RENEW_FEE                   AS       RENEW_FEE
             ,       A.BROKA_FEE                   AS       BROKA_FEE
             ,       A.OTHER_FEE                   AS       OTHER_FEE
             ,       A.EVID_AMT                    AS       EVID_AMT
             ,       A.USD_CVT_AMT                 AS       USD_CVT_AMT
             ,       A.BBS_CVT_AMT                 AS       BBS_CVT_AMT
             ,       A.AUTO_DEBIT_YN               AS       AUTO_DEBIT_YN
             ,       A.LOSS_AMT                    AS       LOSS_AMT
             ,       A.RESTRUCTURING_YN            AS       RESTRUCTURING_YN
             ,       A.FST_IB_IL                   AS       FST_IB_IL
             ,       A.LST_DEAL_IL                 AS       LST_DEAL_IL
             ,       A.LST_IB_IL                   AS       LST_IB_IL
             ,       A.OP_NO                       AS       OP_NO
             ,       A.IBF_GB                      AS       IBF_GB                          
             ,       A.NXT_RT                      AS       NXT_RT
             ,       A.NXT_SCH_YN                  AS       NXT_SCH_YN
             ,       A.NEW_SCH_YN                  AS       NEW_SCH_YN
             ,       A.AGR_REF_NO                  AS       AGR_REF_NO
             ,       A.AGR_SEQ_NO                  AS       AGR_SEQ_NO             
             ,       A.FLAT_SLIDING                AS       FLAT_SLIDING
			 ,       B.DBT_APTC_YN                 AS       COLL_CD      
			 ,       C.APPC_OP_NO                  AS       APPC_OP_NO 
			 ,       C.APPC_PATH1_CD               AS       APPC_PATH1_CD 
             FROM 
                    IDSS_ADST_LNB_BASE  A   
			       ,IDSS_ACOM_CONT_BASE B  
				   ,IDSS_ADST_LNB_APPCBASE C
			    WHERE 1=1
                  AND A.BASC_DT = V_PROC_BASC_DT 
				  AND A.BASC_DT = C.BASC_DT
			      AND A.BASC_DT = B.BASC_DT
                  AND A.REF_NO  = B.REF_NO
				  AND A.REF_NO  = C.LNB_REF_NO
                  AND A.CIX_NO  = B.CIX_NO
                  AND A.COM_ID IN (SELECT M.COND_CD2 
                                  FROM    IEDW_BI_CODE_MAP M
                                  WHERE   M.COND_CD1 = '1919'
                                  AND     M.STS_CD = '10'
                                  ) 
            ORDER BY A.BASC_DT, A.REF_NO, A.CIX_NO;
                    

             DBMS_output.put_line('ROW_CNT : ' || SQL%ROWCOUNT);
             V_PROC_CNT := V_PROC_CNT + SQL%ROWCOUNT;
	 
			 COMMIT; 
			 
			
			 
			 ------------------------------------ --------------------------------
             DBMS_output.put_line('--[BODY] STEP.2 AGUNG TEST FIRST TIME ');
             --------------------------------------------------------------------
	 
				
             COMMIT;
                                                  
             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--C.배치작업 FOOTER START');
             DBMS_output.put_line('====================================================================');

             --------------------------------------------------------------------
             DBMS_output.put_line('--[FOOT] STEP1 로그 UPDATE : 처리완료');
             --------------------------------------------------------------------
             V_PROC_ST_CD := '2'; --(1:처리중 2:처리완료 3:에러발생)
             IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);

      EXCEPTION   WHEN OTHERS THEN
          ROLLBACK;

          DBMS_output.put_line('====================================================================');
          DBMS_output.put_line('--X.배치작업 EXCEPTION');
          DBMS_output.put_line('====================================================================');

          V_ERR_MSG_CTT := to_char(sqlcode)|| ' '|| sqlerrm;
          DBMS_output.put_line('Error  ');
          DBMS_output.put_line(V_ERR_MSG_CTT);

          --------------------------------------------------------------------
          DBMS_output.put_line('--[ERR] 로그 UPDATE : 에러발생');
          --------------------------------------------------------------------
          V_PROC_ST_CD := '3'; --(1:처리중 2:처리완료 3:에러발생)
          IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);
      END;

 END;
 /
 exit
 /


 