--sqlplus -S MISADM/inni0821@INOANMIS @/inoan/dw/batch/report/rpt_INMLN00326.sql JRPT000326 20200318
 --------------------------------------------------------------------------------                                                                    
 -- Report Code  : INMLN00326                                                                                                                      
 -- Report Name  : Retail Loan - Sales (monthly)
 -- Description  :                                                                                                                                   
 -- Parameters   : 1. JOB ID                                                                                                                         
 --                2. As Of Date                                                                                                                     
 --------------------------------------------------------------------------------                                                                    
 -- Created Date : 20200317                                                                                                                         
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
             V_RPT_CD          := 'INMLN00326';              --???????????????????????? ???????????????                                                                                                                     
                                                                 
                                                                                                                                                     
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
				,BASC_DT
				,VER_NO
				,SEQ_NO
				,BR_CD
				,CHR_COL_01  --Product
				,CHR_COL_02  --Month
				,NUM_COL_01  --Business Day
				,NUM_COL_02  --Amount
				,NUM_COL_03  --No
			)
			SELECT
				 V_RPT_CD          AS RPT_CD
				,V_PROC_BASC_DT    AS BASC_DT
				,1                 AS VER_NO
				,ROWNUM            AS SEQ_NO
				,'0000'            AS BR_CD	
				,Z.PRD_ENG_NM      AS PRD_ENG_NM
				,Z.DT              AS DT        
				,Z.BIZ_DT          AS BIZ_DT    
				,Z.SUM             AS SUM     
				,Z.NO              AS NO       
				FROM 
					(
					SELECT 
					 PRD_ENG_NM        AS PRD_ENG_NM
					,DT                AS DT        
					,BIZ_DT            AS BIZ_DT    
					,SUM(SUM)          AS SUM
					,NO                AS NO
					FROM 
						( 
						SELECT 
							B.DT			    AS DT
							,SUBSTR(B.DT,1,6)   AS BASC_MM
							,B.PRD_ENG_NM		AS PRD_ENG_NM
							,NVL(A.SUM,0)       AS SUM
							,B.NO				AS NO
							FROM 
							( 
								SELECT  
										 A.BASC_DT              AS MONTH				
										,NVL(A.COM_NM,'EMPTY')  AS PRD_NM 					
										,SUM(A.LON_JAN)         AS SUM  					
									FROM  IDSS_ADST_LNB_BASE  A 
										 ,IDSS_ACOM_CONT_BASE B 	 
										WHERE 
											  A.BASC_DT = B.BASC_DT
										AND   A.COM_ID IN
									(
										-- '030300004006' -- General KTA
										--,'030300004004' -- Payroll Partnership Loan
										--,'030300004005' -- Merchant Loan
										SELECT COND_CD1_DESC AS PRD_ENG_NM FROM IEDW_BI_CODE_MAP WHERE COND_CD1 = '1919'
									)
									AND A.REF_NO   = B.REF_NO
									AND A.LON_JAN != 0
									GROUP BY 
									A.BASC_DT, 
									B.DBT_APTC_YN, 
									A.COM_ID, 
									A.COM_NM	
								) A,	
						(-- INLINE VIEW
							SELECT DT_TBL.NO, DT_TBL.DT, PRDNM_TBL.PRD_ENG_NM FROM
								(					
								SELECT  ROW_NUMBER() OVER(ORDER BY B.DT ASC) AS NO
										,B.DT AS DT
										FROM (SELECT TO_CHAR(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD'),'YYYYMMDD') AS DT FROM DUAL 
											UNION 
												SELECT TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD'), 0 - NO)), 'YYYYMMDD') AS DT FROM  COPY_T
												WHERE ROWNUM <= 11 ) B	
										) DT_TBL,					
									(
			--						SELECT PRD_ENG_NM FROM INRT_AFTR_PFH_BASE  WHERE PRD_CD IN (
			--																					 '030300004006' -- General KTA
			--																					,'030300004004' -- Payroll Partnership Loan
			--																					,'030300004005' -- Merchant Loan
			--																					)	
									SELECT COND_CD1_DESC AS PRD_ENG_NM FROM IEDW_BI_CODE_MAP WHERE COND_CD1 = '1919'					
								) PRDNM_TBL
								WHERE DT_TBL.DT >= TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD'), 0 - 11)), 'YYYYMMDD')				
								ORDER BY 1 DESC, 2, 3 DESC			    
						) B  
						WHERE 
							A.MONTH(+)    = B.DT
						AND A.PRD_NM(+)   = B.PRD_ENG_NM			 	
						ORDER BY B.DT DESC, B.PRD_ENG_NM DESC 
						) C,
						(		 
							SELECT 
								A.BASC_DT               AS BASC_MM,
								A.ALL_DT - B.HOLI_DT    AS BIZ_DT
							FROM 
							(
								SELECT  
								TO_CHAR((ADD_MONTHS( LAST_DAY( TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')) ,-NO ) +1),'YYYYMM') BASC_DT,
										(ADD_MONTHS( LAST_DAY( TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')) ,-NO +1 ) +1)-
										(ADD_MONTHS( LAST_DAY( TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')) ,-NO ) +1)  AS ALL_DT     
								FROM COPY_T 
								WHERE NO < 13
								ORDER BY 1 
							) A,
							(
								SELECT
								 DT         AS BASC_DT
								,COUNT(DT)  AS HOLI_DT 
								FROM  
								(
								SELECT TO_CHAR(IL,'YYYYMM') AS DT FROM INRT_ACOM_COM_HOLI WHERE CTRY_CD ='ID' AND IL BETWEEN  ADD_MONTHS(   LAST_DAY( TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')) ,-12 ) +1   AND TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')  ORDER BY IL ASC
								)
								GROUP BY DT
							) B
							WHERE 
								A.BASC_DT  = B.BASC_DT
						) BIZ	
						WHERE 
						BIZ.BASC_MM = C.BASC_MM 
						GROUP BY DT, PRD_ENG_NM, NO, BIZ_DT
						ORDER BY 1 DESC , 2 ASC ) Z
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
                       