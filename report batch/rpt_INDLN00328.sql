--sqlplus -S MISADM/inni0821@INOANMIS @/inoan/dw/batch/report/rpt_INDLN00328.sql JRPT000327 20200325
 --------------------------------------------------------------------------------                                                                    
 -- Report Code  : INDLN00328                                                                                                                      
 -- Report Name  : Retail Loan - Reject Reason
 -- Description  :                                                                                                                                   
 -- Parameters   : 1. JOB ID                                                                                                                         
 --                2. As Of Date                                                                                                                     
 --------------------------------------------------------------------------------                                                                    
 -- Created Date : 20200325                                                                                                                         
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
             V_RPT_CD          := 'INDLN00328';              --★★★보고서코드 설정★★★                                                                                                                     
                                                                 
                                                                                                                                                     
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
            ,   BASC_DT
            ,   VER_NO
            ,   SEQ_NO
            ,   BR_CD
            ,   CHR_COL_01
            ,   CHR_COL_02
            ,   CHR_COL_03
            ,   CHR_COL_04
            )
            WITH TB1 
			  AS (
                SELECT      
                     B.BASC_DT                                          AS BASC_DT      
                    ,B.PRODUCT                                          AS PRODUCT
                    ,B.REASON                                           AS REASON
                    ,COUNT(B.REASON)                                    AS REJECT
                FROM(
                    SELECT 
                          A.BASC_DT                                     AS BASC_DT
                         ,A.LNB_REF_NO                                  AS REF_NO
                        , A.APPC_DT                                     AS APPC_DT
                        , MP.COND_CD1_DESC                              AS Product -- DATA KOSONG DI HILANGKAN  AS APPC_NO
                        , GET_COMH_CDNM_F('G113',A.REJECT_CD1)          AS REASON
                    FROM IEDW_RT_LNB_RJCT A
                         ,(SELECT M.COND_CD2, M.COND_CD1_DESC
                                  FROM    IEDW_BI_CODE_MAP M
                                  WHERE   M.COND_CD1 = '1919'
                                  AND     M.STS_CD = '10') MP
                    WHERE   A.BASC_DT BETWEEN TO_CHAR((Last_Day(ADD_MONTHS(TO_DATE(V_PROC_BASC_DT,'YYYYMMDD'),-1))+1),'YYYYMMDD') AND V_PROC_BASC_DT
                        AND A.LON_APPC_COM_ID = MP.COND_CD2
                    ) B  
                    --WHERE B.PRODUCT IS NOT NULL
                    GROUP BY B.BASC_DT, 
							 B.PRODUCT,
							 B.REASON
                    ORDER BY B.PRODUCT DESC ,
						     B.REASON ASC
				)
				SELECT 
					 V_RPT_CD               AS RPT_CD  
					,V_PROC_BASC_DT         AS BASC_DT
					,1                      AS VER_NO
					,ROWNUM                 AS SEQ_NO
					,'0000'                 AS BR_CD 
					,PRODUCT                AS CHAR_COL_01
					,REASON                 AS CHAR_COL_02
					,REJECT                 AS CHAR_COL_03
					,Proportion             AS CHAR_COL_04
					FROM
					(   
						SELECT  
						 G.BASC_DT          AS BASC_DT
						,G.PRODUCT          AS PRODUCT
						,G.REASON           AS REASON
						,SUM(G.REJECT)      AS REJECT
						,SUM(G.Proportion)  AS Proportion
					FROM 
					(
					  SELECT 
						 BASC_DT  	AS BASC_DT
						,'TOTAL' 	AS PRODUCT
						,REASON  	AS REASON
						,count(*) REJECT
						--,sum(count(*)) over() total_cnt
						,round(100*(count(*) / sum(count(*)) over ()),2) Proportion
					FROM TB1
					GROUP BY BASC_DT, 
							 REASON
					ORDER BY REASON ASC 
					)G
					GROUP BY G.PRODUCT , 
							 G.BASC_DT, ROLLUP (G.REASON)
					
					UNION ALL
					SELECT 
							 TB4.BASC_DT        AS BASC_DT
							,TB4.PRODUCT        AS PRODUCT
							,TB4.REASON         AS REASON
							,SUM(TB4.REJECT)    AS REJECT
							,SUM(TB4.Proportion)AS Proportion
					FROM (SELECT 
							 TB2.BASC_DT    AS BASC_DT
							,TB2.PRODUCT    AS PRODUCT
							,TB2.REASON     AS REASON
							,TB2.REJECT     AS REJECT
							,ROUND((TB2.REJECT / TB3.SumPerproduct * 100),2) AS Proportion
					FROM  (
								SELECT
									TB1.BASC_DT     AS BASC_DT
									,TB1.PRODUCT    AS PRODUCT
									,TB1.REASON     AS REASON
									,COUNT(*)       AS REJECT                
								FROM TB1
								GROUP BY TB1.BASC_DT, 
										 TB1.PRODUCT, 
										 TB1.REASON                
							) TB2 
							,(SELECT PRODUCT, COUNT(*) AS SumPerproduct FROM TB1 
							GROUP BY PRODUCT, BASC_DT) TB3   
						WHERE TB2.PRODUCT = TB3.PRODUCT(+)
								--AND TB2.PRODUCT = 'Payroll Partnership Loan'
						GROUP BY TB2.BASC_DT, 
								 TB2.PRODUCT, 
								 TB2.REJECT, 
								 TB2.REASON, TB3.SumPerproduct
						ORDER BY 1 DESC) TB4
						GROUP BY TB4.PRODUCT, 
								 TB4.BASC_DT,  ROLLUP (TB4.REASON)
						);
						--,TB4.REASON);
		 
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
                       