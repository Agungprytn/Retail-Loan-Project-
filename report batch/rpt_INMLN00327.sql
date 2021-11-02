--sqlplus -S MISADM/inni0821@INOANMIS @/inoan/dw/batch/report/rpt_INMLN00327.sql JRPT000324 20200318
 --------------------------------------------------------------------------------                                                                    
 -- Report Code  : INMLN00327                                                                                                                      
 -- Report Name  : Retail Loan - Balance (Remaining Balance)
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
             -- 변수선언부                                                                                                                           
             --------------------------------------------------------------------                                                                    
             -- 1.로그관리용 변수                                                                                                                    
             V_PROC_DT                    VARCHAR2(8)  ;      --작업일(시스템일)                                                                     
             V_BAT_JOB_ID                 VARCHAR2(10) ;      --JOB ID                                                                               
             V_RUN_SEQ_NO                 NUMBER(5)    ;      --실행순번                                                                             
             V_PROC_ST_CD                 CHAR(1)      ;      --처리상태                                                                             
             V_ERR_MSG_CTT                VARCHAR2(500);      --에러메시지                                                                           
             V_PROC_CNT                   NUMBER(10)   ;      --처리건수                                                                             
             V_PROC_BASC_DT               VARCHAR2(8)  ;      --배치처리기준일                                                                       
             V_PARM_INFO_CTT              VARCHAR2(100);      --파라미터정보                                                                         
                                                                                                                                                     
             --2.보고서처리용변수                                                                                                                    
             --  1) 기본변수                                                                                                                         
             V_RPT_CD                     VARCHAR2(10) ;     --보고서코드                                                                            
                                                                                                                                                     
             --  2) 추가변수                                                                                                                         
             V_PROC_BF1M_DT               VARCHAR2(8);       --전달마지막 영업일                                                                     
             V_COA_DTLS_RPT_CD            VARCHAR2(10);      --COA상세정보 연결변수                                                                  
                                                                                                                                                     
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
             V_PARM_INFO_CTT := '&1' || ' ' || '&2';  --파라미터정보(JOB ID, 처리기준일)                                                             
             V_BAT_JOB_ID    := '&1';                 --JOB ID                                                                                       
             V_PROC_BASC_DT  := '&2';                 --처리기준일                                                                                   
                                                                                                                                                     
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[HEAD] STEP2 변수설정');                                                                                        
             --------------------------------------------------------------------                                                                     
             V_PROC_DT         := TO_CHAR(SYSDATE,'YYYYMMDD'); --처리일(시스템일)                                                                    
             V_PROC_CNT        := 0;                           --처리건수(초기화)                                                                    
             V_RPT_CD          := 'INMLN00327';              --★★★보고서코드 설정★★★                                                                                                                     
                                                                 
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[HEAD] STEP3 연산변수설정');                                                                                    
             --------------------------------------------------------------------                                                                    
             --이전달의 마지막 영업일 조회                                                                                                           
             SELECT TO_CHAR(GET_BIZ_DAY_F(TO_DATE((SUBSTR(V_PROC_BASC_DT, 0, 6) || '01'), 'YYYYMMDD'), -1, 2), 'YYYYMMDD')                           
             INTO V_PROC_BF1M_DT                                                                                                                     
             FROM DUAL                                                                                                                               
             ;                                                                                                                                       
                                                                                                                                                     
                                                                                                                                                     
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
             DBMS_output.put_line('--[BODY] STEP1 기존 자료 DELETE');                                                                                
             --------------------------------------------------------------------                                                                    
             DELETE                                                                                                                                  
             FROM   IRPT_RPT_DAT_PTCL                                                                                                                
             WHERE  RPT_CD   = V_RPT_CD                                                                                                              
             AND    BASC_DT  = V_PROC_BASC_DT                                                                                                        
             ;                                                                                                                                       
             DBMS_output.put_line('ROW_CNT : ' || SQL%ROWCOUNT);                                                                                     
                                                                                                                                                     
                                                                                                                                                     
             --------------------------------------------------------------------                                                                    
             DBMS_output.put_line('--[BODY] STEP2 자료생성 INSERT');                                                                                 
             --------------------------------------------------------------------                                                                    
			 INSERT INTO IRPT_RPT_DAT_PTCL 
				(
					 RPT_CD
					,BASC_DT
					,VER_NO
					,SEQ_NO
					,BR_CD	
					,CHR_COL_01
					,CHR_COL_02
					,CHR_COL_03
					,NUM_COL_01
					,NUM_COL_02
					,NUM_COL_03
				)
				SELECT 
						V_RPT_CD         AS RPT_CD
						,V_PROC_BASC_DT   AS BASC_DT
						,1                AS VER_NO
						,ROWNUM           AS SEQ_NO
						,'0000'           AS BR_CD	
						,C.DT             AS CHR_COL_01
						,C.PRD_ENG_NM     AS CHR_COL_02
						,C.COL            AS CHR_COL_03
						,C.SUM            AS NUM_COL_01
						,C.NO             AS NUM_COL_02
						,C.CNT            AS NUM_COL_03
					FROM 
					(
						SELECT 
							B.DT
							--,A.PRD_NM 
							,B.PRD_ENG_NM
							,B.COL
							,NVL(A.SUM,0) AS SUM
							,B.NO	
							,A.CNT
						FROM 
						( 
							SELECT  
									A.BASC_DT                  AS MONTH
									,NVL(A.COM_NM,'EMPTY')      AS PRD_NM 
									,'COL'||NVL(A.COLL_CD,5)    AS COL
									,SUM(A.LON_JAN)             AS SUM  
									,COUNT(A.BASC_DT)           AS CNT
								FROM
									IEDW_RT_LNB_BASE A
									WHERE A.LON_JAN != 0
									GROUP BY A.BASC_DT , A.COLL_CD, A.COM_ID, A.COM_NM	
								) A	
							,(
								SELECT DT_TBL.NO, DT_TBL.DT, COL_TBL.COL, PRDNM_TBL.PRD_ENG_NM FROM
									(
									SELECT  ROW_NUMBER() OVER(ORDER BY B.DT ASC) AS NO
											,B.DT AS DT
										FROM ( SELECT TO_CHAR(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD'),'YYYYMMDD') AS DT FROM DUAL 
												UNION 
											SELECT TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD'), 0 - NO)), 'YYYYMMDD') AS DT FROM COPY_T
											WHERE ROWNUM <= 11 ) B	
									) DT_TBL,
									(
										SELECT 'COL'||NO AS COL FROM COPY_T WHERE NO <= 5	
									) COL_TBL,
									(
										SELECT COND_CD1_DESC AS PRD_ENG_NM FROM IEDW_BI_CODE_MAP WHERE COND_CD1 = '1919' 
									) PRDNM_TBL
									WHERE DT_TBL.DT >= TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD'), 0 - 11)), 'YYYYMMDD')				
									ORDER BY 1 DESC, 2, 3 DESC			    
							) B  
							WHERE 
								A.MONTH(+) = B.DT
							AND A.COL(+)   = B.COL
							AND A.PRD_NM(+) = B.PRD_ENG_NM
							ORDER BY B.DT DESC, B.PRD_ENG_NM DESC, B.COL) C
							;

						DBMS_output.put_line('ROW_CNT : ' || SQL%ROWCOUNT);                                                                                     
																																								
						V_PROC_CNT := V_PROC_CNT + SQL%ROWCOUNT; 
			
						COMMIT                                                                                                                                  
						;

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP3 최종작업기준일(Last process date) UPDATE');
             --------------------------------------------------------------------
             UPDATE IRPT_RPT_BASE
             SET    LST_BASC_DT = V_PROC_BASC_DT
             WHERE  RPT_CD      IN (V_RPT_CD)      
             ; 
             COMMIT
             ;	

             
             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--C.배치작업 FOOTER START');
             DBMS_output.put_line('====================================================================');
         
             --------------------------------------------------------------------
             DBMS_output.put_line('--[FOOT] STEP1 로그 UPDATE : 처리완료');      
             --------------------------------------------------------------------     
             V_PROC_ST_CD := '2'; --(1:처리중(in progress) 2:처리완료(complete) 3:에러발생(error))    
             IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);  
                                                                                                              
       EXCEPTION   WHEN OTHERS THEN                                                                                                             
             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--X.배치작업 EXCEPTION');
             DBMS_output.put_line('====================================================================');
             
             V_ERR_MSG_CTT := TO_CHAR(sqlcode)|| ' '|| sqlerrm;     
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
                       