--sqlplus -S MISADM/inni0821@INOANMIS @/inoan/dw/batch/report/rpt_INDLN00326.sql JRPT000321 20200318
 --------------------------------------------------------------------------------                                                                    
 -- Report Code  : INDLN00326                                                                                                                      
 -- Report Name  : Retail Loan - Sales Performance (Channel)
 -- Description  :                                                                                                                                   
 -- Parameters   : 1. JOB ID                                                                                                                         
 --                2. As Of Date                                                                                                                     
 --------------------------------------------------------------------------------                                                                    
 -- Created Date : 20200318                                                                                                                         
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
             --------------------------------------------------------------------                                                                    
             -- ???????????????                                                                                                                           
             --------------------------------------------------------------------                                                                    
             -- 1.??????????????? ??????                                                                                                                    
             V_PROC_DT                    VARCHAR2(8)  ;      --?????????(????????????)                                                                     
             V_BAT_JOB_ID                 VARCHAR2(10) ;      --JOB ID                                                                               
             V_RUN_SEQ_NO                 NUMBER(5)    ;      --????????????                                                                             
             V_PROC_ST_CD                 CHAR(1)      ;      --????????????                                                                             
             V_ERR_MSG_CTT                VARCHAR2(500);      --???????????????                                                                           
             V_PROC_CNT                   NUMBER(10)   ;      --????????????                                                                             
             V_PROC_BASC_DT               VARCHAR2(8)  ;      --?????????????????????                                                                       
             V_PARM_INFO_CTT              VARCHAR2(100);      --??????????????????                                                                         
                                                                                                                                                     
             --2.????????????????????????                                                                                                                    
             --  1) ????????????                                                                                                                         
             V_RPT_CD                     VARCHAR2(10) ;     --???????????????                                                                            
                                                                                                                                                     
             --  2) ????????????                                                                                                                         
             V_PROC_BF1M_DT               VARCHAR2(8);       --??????????????? ?????????                                                                     
             V_COA_DTLS_RPT_CD            VARCHAR2(10);      --COA???????????? ????????????                                                                  
                                                                                                                                                     
        BEGIN                                                                                                                                         
             DBMS_output.put_line('====================================================================');                                           
             DBMS_output.put_line('--A.???????????? HEAD START');                                                                                        
             DBMS_output.put_line('====================================================================');                                           
             --------------------------------------------------------------------                                                                    
             -- ???????????????                                                                                                                           
             --------------------------------------------------------------------                                                                    
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[HEAD] STEP1 ??????????????????');                                                                                    
             --------------------------------------------------------------------                                                                    
             V_PARM_INFO_CTT := '&1' || ' ' || '&2';  --??????????????????(JOB ID, ???????????????)                                                             
             V_BAT_JOB_ID    := '&1';                 --JOB ID                                                                                       
             V_PROC_BASC_DT  := '&2';                 --???????????????                                                                                   
                                                                                                                                                     
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[HEAD] STEP2 ????????????');                                                                                        
             --------------------------------------------------------------------                                                                     
             V_PROC_DT         := TO_CHAR(SYSDATE,'YYYYMMDD'); --?????????(????????????)                                                                    
             V_PROC_CNT        := 0;                           --????????????(?????????)                                                                    
             V_RPT_CD          := 'INDLN00326';              --???????????????????????? ???????????????                                                                                                                     
                                                                 
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[HEAD] STEP3 ??????????????????');                                                                                    
             --------------------------------------------------------------------                                                                    
             --???????????? ????????? ????????? ??????                                                                                                           
             SELECT TO_CHAR(GET_BIZ_DAY_F(TO_DATE((SUBSTR(V_PROC_BASC_DT, 0, 6) || '01'), 'YYYYMMDD'), -1, 2), 'YYYYMMDD')                           
             INTO V_PROC_BF1M_DT                                                                                                                     
             FROM DUAL                                                                                                                               
             ;                                                                                                                                       
                                                                                                                                                     
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[HEAD] STEP4 ??????????????????');                                                                                    
             --------------------------------------------------------------------                                                                    
             --????????????????????????                                                                                                                      
             V_RUN_SEQ_NO := GET_LOG_SEQ_F(V_BAT_JOB_ID);                                                                                            
                                                                                                                                                     
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[HEAD] ?????? INSERT : ?????????');                                                                                  
             --------------------------------------------------------------------                                                                    
             V_PROC_ST_CD := '1'; --(1:????????? 2:???????????? 3:????????????)                                                                                 
             IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT); 
                                                                                                                                                     
             DBMS_output.put_line('====================================================================');                                           
             DBMS_output.put_line('--B.???????????? BODY START');                                                                                        
             DBMS_output.put_line('====================================================================');                                           
                                                                                                                                                     
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[BODY] STEP1 ?????? ?????? DELETE');                                                                                
             --------------------------------------------------------------------                                                                    
             DELETE                                                                                                                                  
             FROM   IRPT_RPT_DAT_PTCL                                                                                                                
             WHERE  RPT_CD   = V_RPT_CD                                                                                                              
             AND    BASC_DT  = V_PROC_BASC_DT                                                                                                        
             ;                                                                                                                                       
             DBMS_output.put_line('ROW_CNT : ' || SQL%ROWCOUNT);                                                                                     
                                                                                                                                                     
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[BODY] STEP2 ???????????? INSERT');                                                                                 
             --------------------------------------------------------------------                                                                    
			 INSERT INTO IRPT_RPT_DAT_PTCL
             (
                        RPT_CD
                    ,   BASC_DT
                    ,   VER_NO
                    ,   SEQ_NO
                    ,   BR_CD
                    ,   CHR_COL_01
                    ,   CHR_COL_02
                    ,   CHR_COL_03
                    ,   NUM_COL_01
                    ,   NUM_COL_02
                    ,   CHR_COL_04
                    )
                        SELECT 
                                    V_RPT_CD                          AS RPT_CD
                                ,   V_PROC_BASC_DT                    AS BASC_DT
                                ,   1                                 AS VER_NO
                                ,   ROWNUM                            AS SEQ_NO
                                ,   '0000'                            AS BR_CD  
                                ,   NVL(PRODUCT, '')                  AS CHR_COL_01
                                ,   NVL(CHANNEL, '')                  AS CHR_COL_02
                                ,   NVL(NOA_MTD, '')                  AS CHR_COL_03 
                                ,   NVL(SALES_MTD, '0')               AS NUM_COL_01
                                ,   NVL(TICKET_SIZE, '0')             AS NUM_COL_02 
                                ,   NVL(INTEREST_RATE, '0')           AS CHR_COL_04
                            FROM
                                (
                                SELECT                         
                                            A.COM_NM                                            AS PRODUCT
                                ,           A.APPC_PATH1_CD                                     AS CHANNEL
                                ,           COUNT(A.APPC_OP_NO)                                 AS NOA_MTD
                                ,           SUM(A.FST_LON_AMT)                                  AS SALES_MTD
                                ,           ROUND(A.FST_LON_AMT/COUNT(A.APPC_OP_NO), 1)         AS TICKET_SIZE
                                ,           A.NXT_RT                                            AS INTEREST_RATE
                                FROM IEDW_RT_LNB_BASE A
                                WHERE
                                    A.BASC_DT     = V_PROC_BASC_DT    
                                    GROUP BY  
                                            A.FST_LON_AMT
                                    ,       A.NXT_RT
                                    ,       A.COM_NM
                                    ,       A.APPC_PATH1_CD
                                    ORDER BY PRODUCT ASC
                            )
                            ;
						DBMS_output.put_line('ROW_CNT : ' || SQL%ROWCOUNT);                                                                                     
																																								
						V_PROC_CNT := V_PROC_CNT + SQL%ROWCOUNT; 
			
						COMMIT                                                                                                                                  
						;

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP3 ?????????????????????(Last process date) UPDATE');
             --------------------------------------------------------------------
             UPDATE IRPT_RPT_BASE
             SET    LST_BASC_DT = V_PROC_BASC_DT
             WHERE  RPT_CD      IN (V_RPT_CD)      
             ; 
             COMMIT
             ;	

             
             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--C.???????????? FOOTER START');
             DBMS_output.put_line('====================================================================');
         
             --------------------------------------------------------------------
             DBMS_output.put_line('--[FOOT] STEP1 ?????? UPDATE : ????????????');      
             --------------------------------------------------------------------     
             V_PROC_ST_CD := '2'; --(1:?????????(in progress) 2:????????????(complete) 3:????????????(error))    
             IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);  
                                                                                                              
       EXCEPTION   WHEN OTHERS THEN                                                                                                             
             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--X.???????????? EXCEPTION');
             DBMS_output.put_line('====================================================================');
             
             V_ERR_MSG_CTT := TO_CHAR(sqlcode)|| ' '|| sqlerrm;     
             DBMS_output.put_line('Error  ');                 
             DBMS_output.put_line(V_ERR_MSG_CTT);                 
                                      
             --------------------------------------------------------------------                                                    
             DBMS_output.put_line('--[ERR] ?????? UPDATE : ????????????');           
             --------------------------------------------------------------------                
             V_PROC_ST_CD := '3'; --(1:????????? 2:???????????? 3:????????????)                                                                                                                                                                                    
             IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);  
      END;                                                                                                         
                                                                                                              
 END;                                                                                                         
 /                                                                                                            
 exit                                                                                                         
 / 			 
                       