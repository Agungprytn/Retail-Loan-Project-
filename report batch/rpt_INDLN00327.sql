--sqlplus -S  MISADM/inni0821@INOANMIS @/inoan/dw/batch/report/rpt_INDLN00327.sql JRPT000323 20200324
 --------------------------------------------------------------------------------                                                                    
 -- Report Code  : INDLN00327                                                                                                                      
 -- Report Name  : Retail Loan - Pre Screen 
 -- Description  :                                                                                                                                   
 -- Parameters   : 1. JOB ID                                                                                                                         
 --                2. As Of Date                                                                                                                     
 --------------------------------------------------------------------------------                                                                    
 -- Created Date : 20200324                                                                                                                         
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
             V_RPT_CD          := 'INDLN00329';                --???????????????????????? ???????????????                                                                                                                     
                                                                 
                                                                                                                                                     
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
						,   CHR_COL_04
						,   CHR_COL_05
						,   CHR_COL_06
						,   CHR_COL_07
						,   CHR_COL_08
						,   CHR_COL_09
						,   CHR_COL_10
						,   CHR_COL_11
						,   CHR_COL_12
						,   CHR_COL_13
						,   CHR_COL_14
						)
						WITH TB_MAIN AS
						(
						
						SELECT       
									  D.BASC_DT                     AS BASC_DT
									, D.PRODUCT                     AS PRODUCT
									, D.CHANNEL                     AS CHANNEL
									, COUNT(D.APP_CMPLTD)           AS APP_CMPLTD
									, COUNT(D.APP_RJCT)             AS APP_RJCT          
									, COUNT(D.IVTGN_CMPLTD)         AS IVTGN_CMPLTD
									, COUNT(D.REFUSAL_INVESTIGATE)  AS REFUSAL_INVESTIGATE
									, COUNT(D.APPRVL_CMPLTD)        AS APPRVL_CMPLTD
									, COUNT(D.RMTTNC_CMPLTD)        AS RMTTNC_CMPLTD
									, SUM(D.LN_AMT_RMTTNC_CMPLTD)   AS LN_AMT_RMTTNC_CMPLTD
								FROM  IEDW_RT_LNB_APPL D 
								WHERE D.BASC_DT = V_PROC_BASC_DT
							GROUP BY   
									 D.BASC_DT
									,D.PRODUCT 
									,D.CHANNEL
							ORDER BY D.PRODUCT DESC, 
							         D.CHANNEL ASC 
						)
						SELECT 
								 V_RPT_CD               AS RPT_CD        
								,V_PROC_BASC_DT         AS BASC_DT
								,1                      AS VER_NO
								,ROWNUM                 AS SEQ_NO
								,'0000'                 AS BR_CD 
								,PRODUCT                AS CHR_COL_01
								,CHANNEL                AS CHR_COL_02
								,APPLY                  AS CHR_COL_03
								,APP_CMPLTD             AS CHR_COL_04
								,APP_RJCT               AS CHR_COL_05
								,IVTGN_CMPLTD           AS CHR_COL_06
								,REFUSAL_INVESTIGATE    AS CHR_COL_07
								,APPRVL_CMPLTD          AS CHR_COL_08
								,RMTTNC_CMPLTD          AS CHR_COL_09
								,APP_CMPLTDAPPLY        AS CHR_COL_10
								,IVTGN_CMPLTDAPPLY      AS CHR_COL_11
								,APPRVL_CMPLTDAPPLY     AS CHR_COL_12
								,RMTTNC_CMPLTDAPPLY     AS CHR_COL_13
								,LN_AMT_RMTTNC_CMPLTD   AS CHR_COL_14
						FROM(                           
							SELECT   
								G.BASC_DT                                                            AS BASC_DT
								, DECODE(G.PRODUCT,'TOTAL','SUBTOTAL')                               AS PRODUCT
								, NVL(G.CHANNEL,'TOTAL')                                             AS CHANNEL
								, G.APPLY                                                                APPLY
								, G.APP_CMPLTD                                                       AS APP_CMPLTD 
								, G.APP_RJCT                                                         AS APP_RJCT
								, G.IVTGN_CMPLTD                                                     AS IVTGN_CMPLTD
								, G.REFUSAL_INVESTIGATE                                              AS REFUSAL_INVESTIGATE
								, G.APPRVL_CMPLTD                                                    AS APPRVL_CMPLTD
								, G.RMTTNC_CMPLTD                                                    AS RMTTNC_CMPLTD
								, ROUND(G.APP_CMPLTD   /DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'    AS APP_CMPLTDAPPLY
								, ROUND(G.IVTGN_CMPLTD /DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'    AS IVTGN_CMPLTDAPPLY
								, ROUND(G.APPRVL_CMPLTD/DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'    AS APPRVL_CMPLTDAPPLY
								, ROUND(G.RMTTNC_CMPLTD/DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'    AS RMTTNC_CMPLTDAPPLY
								, G.LN_AMT_RMTTNC_CMPLTD                                             AS LN_AMT_RMTTNC_CMPLTD
							FROM (
								SELECT 
								 F.BASC_DT                                                           AS BASC_DT
								, 'TOTAL'                                                            AS PRODUCT 
								, F.CHANNEL                                                          AS CHANNEL
								, SUM(F.APPLY)                                                       AS APPLY
								, SUM(F.APP_CMPLTD)                                                  AS APP_CMPLTD 
								, SUM(F.APP_RJCT)                                                    AS APP_RJCT
								, SUM(F.IVTGN_CMPLTD)                                                AS IVTGN_CMPLTD
								, SUM(F.REFUSAL_INVESTIGATE)                                         AS REFUSAL_INVESTIGATE
								, SUM(F.APPRVL_CMPLTD)                                               AS APPRVL_CMPLTD
								, SUM(F.RMTTNC_CMPLTD)                                               AS RMTTNC_CMPLTD
								, SUM(F.LN_AMT_RMTTNC_CMPLTD)                                        AS LN_AMT_RMTTNC_CMPLTD
								FROM (      
									SELECT
											  E.BASC_DT
											, E.PRODUCT
											, E.CHANNEL
											, SUM(
											     E.APP_CMPLTD 
												+E.APP_RJCT          
												+E.IVTGN_CMPLTD
												+E.REFUSAL_INVESTIGATE
												+E.APPRVL_CMPLTD
												+E.RMTTNC_CMPLTD
											) AS APPLY
											, E.APP_CMPLTD 
											, E.APP_RJCT          
											, E.IVTGN_CMPLTD
											, E.REFUSAL_INVESTIGATE
											, E.APPRVL_CMPLTD
											, E.RMTTNC_CMPLTD
											, E.LN_AMT_RMTTNC_CMPLTD
										FROM   TB_MAIN E
												GROUP BY
														 E.BASC_DT
														,E.PRODUCT 
														,E.CHANNEL
														--,APPLY
														,E.APP_CMPLTD 
														,E.APP_RJCT
														,E.IVTGN_CMPLTD 
														,E.REFUSAL_INVESTIGATE
														,E.APPRVL_CMPLTD
														,E.RMTTNC_CMPLTD
														,E.LN_AMT_RMTTNC_CMPLTD
												ORDER BY E.PRODUCT DESC,
														 E.CHANNEL ASC 
												) F
												GROUP BY ROLLUP(
																 F.BASC_DT
																,F.CHANNEL                     
																)
								)G
								UNION ALL
								SELECT 
									  G.BASC_DT                                                            AS BASC_DT
									, G.PRODUCT                                                            AS PRODUCT
									, NVL(G.CHANNEL,'TOTAL')                                               AS CHANNEL
									, G.APPLY                                                              AS APPLY
									, G.APP_CMPLTD                                                         AS APP_CMPLTD 
									, G.APP_RJCT                                                           AS APP_RJCT
									, G.IVTGN_CMPLTD                                                       AS IVTGN_CMPLTD
									, G.REFUSAL_INVESTIGATE                                                AS REFUSAL_INVESTIGATE
									, G.APPRVL_CMPLTD                                                      AS APPRVL_CMPLTD
									, G.RMTTNC_CMPLTD                                                      AS RMTTNC_CMPLTD
									, ROUND(G.APP_CMPLTD   /DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'      AS APP_CMPLTDAPPLY
									, ROUND(G.IVTGN_CMPLTD /DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'      AS IVTGN_CMPLTDAPPLY
									, ROUND(G.APPRVL_CMPLTD/DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'      AS APPRVL_CMPLTDAPPLY
									, ROUND(G.RMTTNC_CMPLTD/DECODE(G.APPLY, 0,1,G.APPLY)*100, 2)||'%'      AS RMTTNC_CMPLTDAPPLY
									, G.LN_AMT_RMTTNC_CMPLTD                                               AS LN_AMT_RMTTNC_CMPLTD
									FROM (
										SELECT 
											  F.BASC_DT                                                   AS BASC_DT  
											, F.PRODUCT                                                   AS PRODUCT 
											, F.CHANNEL                                                   AS CHANNEL
											, SUM(F.APPLY)                                                AS APPLY 
											, SUM(F.APP_CMPLTD )                                          AS APP_CMPLTD      
											, SUM(F.APP_RJCT)                                             AS APP_RJCT       
											, SUM(F.IVTGN_CMPLTD)                                         AS IVTGN_CMPLTD
											, SUM(F.REFUSAL_INVESTIGATE)                                  AS REFUSAL_INVESTIGATE
											, SUM(F.APPRVL_CMPLTD)                                        AS APPRVL_CMPLTD
											, SUM(F.RMTTNC_CMPLTD)                                        AS RMTTNC_CMPLTD
											, SUM(F.LN_AMT_RMTTNC_CMPLTD)                                 AS LN_AMT_RMTTNC_CMPLTD
											FROM (  
												SELECT      
													  E.BASC_DT
													, E.PRODUCT
													, E.CHANNEL
													, SUM(
														E.APP_CMPLTD 
														+E.APP_RJCT          
														+E.IVTGN_CMPLTD
														+E.REFUSAL_INVESTIGATE
														+E.APPRVL_CMPLTD
														+E.RMTTNC_CMPLTD
													) AS APPLY
													, E.APP_CMPLTD 
													, E.APP_RJCT          
													, E.IVTGN_CMPLTD
													, E.REFUSAL_INVESTIGATE
													, E.APPRVL_CMPLTD
													, E.RMTTNC_CMPLTD
													, E.LN_AMT_RMTTNC_CMPLTD
												FROM  TB_MAIN E
														GROUP BY E.BASC_DT
																,E.PRODUCT 
																,E.CHANNEL
																--,APPLY
																,E.APP_CMPLTD 
																,E.APP_RJCT
																,E.IVTGN_CMPLTD 
																,E.REFUSAL_INVESTIGATE
																,E.APPRVL_CMPLTD
																,E.RMTTNC_CMPLTD
																,E.LN_AMT_RMTTNC_CMPLTD
														ORDER BY E.PRODUCT DESC, 
																 E.CHANNEL ASC                         
														) F
														GROUP BY ROLLUP(
																		 F.BASC_DT
																		,F.PRODUCT
																		,F.CHANNEL                 
																		)
												) G
												WHERE G.PRODUCT IS NOT NULL
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
                       