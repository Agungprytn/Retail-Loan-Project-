 --sqlplus -S  MISADM/inni0821@INOANMIS @/inoan/dw/batch/inoan/inoan_adst_lnb_rtldpds.sql JDMT000295 20200326
 --sqlplus MISADM/inni0821@INOANMIS @/inoan/dw/batch/inoan/inoan_adst_lnb_rtldpds.sql JDMT000295 20200326
 --------------------------------------------------------------------------------
 -- Program Name : INOAN_ADST_LNB_RTLDPDS
 -- Description  : MIS to INOAN 
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

			 

             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--B.배치작업 BODY START');
             DBMS_output.put_line('====================================================================');

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP1. HANYA COBA .');
             --------------------------------------------------------------------

		  INSERT INTO ADST_LNB_RTLDPDS@INOAN
			 (
			   --BASC_DT
			   APPC_NO
			  ,REF_NO              
			  ,TRX_DATE            
			  ,CIX_NO              
			  ,COL_GRD             
			  ,PRINCIPAL_DLY_DAYS  
			  ,PRINCIPAL_DLY_STR_DT
			  ,INT_DLY_DAYS        
			  ,INT_DLY_STR_DT      
			  ,REG_OP_NO           
			  ,REG_DT              
			  ,REG_TM              
			  ,UPD_OP_NO           
			  ,UPD_DT              
			  ,UPD_TM 
			 )
			 SELECT 
			      --V_PROC_BASC_DT 							AS BASC_DT
				  B.APPC_NO               					AS APPC_NO
				, A.REF_NO  								AS REF_NO              
				, TO_DATE(A.BASC_DT,'YYYYMMDD') 			AS TRX_DATE              
				, A.CUST_NO 								AS CIX_NO                
				, SUBSTR(A.ATSD_GRD_CD,5,1) 				AS COL_GRD   -- before A.ATSD_GRD_CD AS COL_GRD             
				, A.PRN_DLQY_DAYS 							AS PRINCIPAL_DLY_DAYS    
				, TO_DATE(A.PRN_DLQY_STRT_DT,'YYYYMMDD') 	AS PRINCIPAL_DLY_STR_DT  
				, A.INT_DLQY_DAYS 							AS INT_DLY_DAYS          
				, TO_DATE(A.INT_DLQY_STRT_DT,'YYYYMMDD') 	AS INT_DLY_STR_DT        
				, 'BATUSER'									AS REG_OP_NO             
				, SYSDATE 									AS REG_DT                
				, TO_CHAR(SYSDATE,'HH24MISS') 				   REG_TM                
				, 'BATUSER' 								AS UPD_OP_NO             
				, SYSDATE 									AS UPD_DT                
				, TO_CHAR(SYSDATE,'HH24MISS')				   UPD_TM               
			 FROM 
				IEDW_MART_LNB_RTLDPDS A,
				IDSS_ADST_LNB_APPCBASE B 
				WHERE
					A.BASC_DT = V_PROC_BASC_DT
				AND A.BASC_DT = B.BASC_DT
				AND B.LNB_REF_NO = A.REF_NO
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


 