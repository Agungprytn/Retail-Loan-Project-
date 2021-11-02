 --sqlplus -S  MISADM/inni0821@INOANMIS @/inoan/dw/batch/datamart/dmt_iedw_rt_lnb_rjct.sql JDMT000293 20200319
 --sqlplus MISADM/inni0821@INOANMIS @/inoan/dw/batch/datamart/dmt_iedw_rt_lnb_rjct.sql JDMT000293 20200319
 --------------------------------------------------------------------------------
 -- Program Name : iedw_rt_lnb_rjct
 -- Description  : RETAIL LOAN MART TABLE 
 -- Parameters   : 1. JOB ID
 --------------------------------------------------------------------------------
 -- Created Date : 2020. 03.
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

			 DELETE FROM IEDW_RT_LNB_RJCT WHERE BASC_DT = V_PROC_BASC_DT;
			 
			 COMMIT;

             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--B.배치작업 BODY START');
             DBMS_output.put_line('====================================================================');

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP1. HANYA COBA .');
             --------------------------------------------------------------------
			 INSERT INTO IEDW_RT_LNB_RJCT
             (
					BASC_DT
             ,		APPC_NO
             ,		APPC_DT
             ,		ISYS_UPD_DTM
             ,		LNB_REF_NO
             ,		LON_APPC_COM_ID
             ,		APPC_OP_NO
             ,		STS
             ,		WKF_CD
             ,		WKF_DTL_CD
             ,		COM_ID
             ,		COM_NM
             ,		REJECT_CD1
             ,		REJECT_TYPE
             ,		REJECT_REMARK
             )
             SELECT 
					 V_PROC_BASC_DT          AS BASC_DT
             ,  	 A.APPC_NO               AS APPC_NO
             ,  	 A.APPC_DT               AS APPC_DT
             ,  	 SYSDATE                 AS ISYS_UPD_DTM
             ,  	 A.LNB_REF_NO            AS LNB_REF_NO
             ,  	 A.LON_APPC_COM_ID       AS LON_APPC_COM_ID
             ,  	 A.APPC_OP_NO            AS APPC_OP_NO
             ,  	 B.STS                   AS STS
             ,  	 B.WKF_CD                AS WKF_CD
             ,  	 B.WKF_DTL_CD            AS WKF_DTL_CD
             ,  	 C.COM_ID                AS COM_ID
             ,  	 C.COM_NM                AS COM_NM
             ,  	 D.REJECT_CD1            AS REJECT_CD1
             ,  	 D.REJECT_TYPE           AS REJECT_TYPE
             ,  	 D.REJECT_REMARK         AS REJECT_REMARK
             FROM 
			      ADST_LNB_APPCBASE@ANDARA A
                 ,ADST_LNB_DSTBMNG@ANDARA  B
                 ,ADST_LNB_BASE@ANDARA     C
                 ,ADST_LNB_RJCTMNG@ANDARA  D
             WHERE A.APPC_NO    = B.APPC_NO
             AND   A.LNB_REF_NO = C.REF_NO(+)
             AND   A.APPC_NO    = D.APPC_NO
             AND   B.WKF_CD     = '001'
             AND   B.WKF_DTL_CD = '901'
             AND   B.STS        = '0'
             ;

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


 