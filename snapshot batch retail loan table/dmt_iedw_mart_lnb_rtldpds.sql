 --sqlplus -S  MISADM/inni0821@INOANMIS @/inoan/dw/batch/datamart/dmt_iedw_mart_lnb_rtldpds.sql JDMT000292 20200319
 --sqlplus MISADM/inni0821@INOANMIS @/inoan/dw/batch/datamart/dmt_iedw_mart_lnb_rtldpds.sql JDMT000292 20200319
 --------------------------------------------------------------------------------
 -- Program Name : IEDW_MART_LNB_RTLDPDS
 -- Description  : RETAIL LOAN DEPENDENCY 
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

			 DELETE FROM IEDW_MART_LNB_RTLDPDS WHERE BASC_DT = V_PROC_BASC_DT ;
			 
			 COMMIT;

             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--B.배치작업 BODY START');
             DBMS_output.put_line('====================================================================');

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP1. HANYA COBA .');
             --------------------------------------------------------------------

			INSERT INTO IEDW_MART_LNB_RTLDPDS
			(
					 BASC_DT  
					,ISYS_UPD_DTM           
					,REF_NO            
					,CUST_NO           
					,CUST_NM           
					,COA_CD            
					,COA_NM            
					,PFMC_ORG_CD
					,PRD_CD          
					,PRD_NM          
					,ATSD_GRD_CD         
					,CUR_CD            
					,FEX_AMT           
					,CVT_AMT           
					,GRP_CD              
					,DLQY_ORGN_DV_CD
					,PRN_DLQY_YN         
					,INT_DLQY_YN         
					,DLQY_STRT_DT        
					,PRN_DLQY_STRT_DT    
					,INT_DLQY_STRT_DT    
					,DLQY_DAYS
					,PRN_DLQY_DAYS
					,INT_DLQY_DAYS
					,TOT_CVT_DLQY_AMT    
					,PRN_DLQY_CUR_CD   
					,PRN_DLQY_AMT      
					,PRN_CVT_DLQY_AMT  
					,INT_DLQY_CUR_CD   
					,INT_DLQY_AMT      
					,INT_CVT_DLQY_AMT
					,REF_NO_1
					,TOT_PST_AMT
					,CVT_PST_AMT
					,TOT_LTE_AMT
					,CVT_LTE_AMT	
				)								
				WITH SRC_DATA                                                                                                                  
				AS      (                                                                                                                                                       
				SELECT /*+ ORDERED USE_NL( A B) */                                              
					A.BASC_DT                                                                                        AS BASC_DT
				,      SYSDATE                                                                                       AS ISYS_UPD_DTM                                                             
				,      A.REF_NO                                                                                      AS REF_NO   
				,      B.CUST_NO                                                                                     AS CUST_NO  
				,      B.CUST_NM                                                                                     AS CUST_NM  
				,      B.COA_CD                                                                                      AS COA_CD   
				,      B.COA_NM                                                                                      AS COA_NM   
				,      B.PFMC_ORG_CD||' - '|| GET_CDNM_F('PFMC_BR_CD', PFMC_ORG_CD)                                  AS PFMC_ORG_CD
				,      B.PRD_CD                                                                                      AS PRD_CD  
				,      B.PRD_NM                                                                                      AS PRD_NM  
				,      'KOL '||B.ATSD_GRD_CD                                                                         AS ATSD_GRD_CD                               
				,      B.CUR_CD                                                                                      AS CUR_CD 
				,      B.FEX_AMT                                                                                     AS FEX_AMT
				,      B.CVT_AMT                                                                                     AS CVT_AMT
				,      A.DLQY_ORGN_DV_CD                                                                             AS GRP_CD 
				,      GET_CDNM_F('DLQY_RSN_CD',A.DLQY_ORGN_DV_CD,A.DLQY_ORGN_DV_CD)                                 AS DLQY_ORGN_DV_CD
				,      A.PRN_DLQY_YN                                                                                 AS PRN_DLQY_YN     
				,      A.INT_DLQY_YN                                                                                 AS INT_DLQY_YN     
				,      A.DLQY_STRT_DT                                                                                AS DLQY_STRT_DT    
				,      A.PRN_DLQY_STRT_DT                                                                            AS PRN_DLQY_STRT_DT
				,      A.INT_DLQY_STRT_DT                                                                            AS INT_DLQY_STRT_DT
				,      GET_DATE_TERM_F('D',TO_DATE(A.DLQY_STRT_DT,'YYYYMMDD'),TO_DATE(A.BASC_DT,'YYYYMMDD')) + 1     AS DLQY_DAYS
				,      GET_DATE_TERM_F('D',TO_DATE(A.PRN_DLQY_STRT_DT,'YYYYMMDD'),TO_DATE(A.BASC_DT,'YYYYMMDD')) + 1 AS PRN_DLQY_DAYS
				,      GET_DATE_TERM_F('D',TO_DATE(A.INT_DLQY_STRT_DT,'YYYYMMDD'),TO_DATE(A.BASC_DT,'YYYYMMDD')) + 1 AS INT_DLQY_DAYS
				,      SUM(NVL(PRN_CVT_DLQY_AMT,0) + NVL(INT_CVT_DLQY_AMT,0))                                        AS TOT_CVT_DLQY_AMT                    
				,      A.PRN_DLQY_CUR_CD                                                                             AS PRN_DLQY_CUR_CD                                                       
				,      A.PRN_DLQY_AMT                                                                                AS PRN_DLQY_AMT     
				,      A.PRN_CVT_DLQY_AMT                                                                            AS PRN_CVT_DLQY_AMT 
				,      A.INT_DLQY_CUR_CD                                                                             AS INT_DLQY_CUR_CD  
				,      A.INT_DLQY_AMT                                                                                AS INT_DLQY_AMT     
				,      A.INT_CVT_DLQY_AMT                                                                            AS INT_CVT_DLQY_AMT 
				FROM                                                                            
						(                                                                       
						SELECT 
							   BASC_DT                                    AS BASC_DT            
						,      REF_NO                                     AS REF_NO             
						,      MAX(DLQY_ORGN_DV_CD )                      AS DLQY_ORGN_DV_CD    
						,      MAX(DECODE(DLQY_DV_CD,'1','Y'))            AS PRN_DLQY_YN        
						,      MAX(DECODE(DLQY_DV_CD,'2','Y'))            AS INT_DLQY_YN        
						,      MIN(DLQY_STRT_DT)                          AS DLQY_STRT_DT       
						,      MAX(DECODE(DLQY_DV_CD,'1',DLQY_STRT_DT  )) AS PRN_DLQY_STRT_DT   
						,      MAX(DECODE(DLQY_DV_CD,'2',DLQY_STRT_DT))   AS INT_DLQY_STRT_DT   
						,      MAX(DECODE(DLQY_DV_CD,'1',CUR_CD  ))       AS PRN_DLQY_CUR_CD    
						,      MAX(DECODE(DLQY_DV_CD,'1',DLQY_AMT))       AS PRN_DLQY_AMT       
						,      MAX(DECODE(DLQY_DV_CD,'1',CVT_DLQY_AMT  )) AS PRN_CVT_DLQY_AMT   
						,      MAX(DECODE(DLQY_DV_CD,'2',CUR_CD  ))       AS INT_DLQY_CUR_CD    
						,      MAX(DECODE(DLQY_DV_CD,'2',DLQY_AMT))       AS INT_DLQY_AMT       
						,      MAX(DECODE(DLQY_DV_CD,'2',CVT_DLQY_AMT  )) AS INT_CVT_DLQY_AMT   
						,      SUM(CVT_DLQY_AMT  ) 					      AS CVT_DLQY_AMT                              
						FROM   IEDW_MART_DLQY_BASE                                              
						WHERE  BASC_DT = V_PROC_BASC_DT
						GROUP BY BASC_DT                                                        
						,        REF_NO                                                           
						) A                                                                     
				,     IEDW_RPT_ACCT_BAL B                                                       
				WHERE A.BASC_DT = B.BASC_DT                                                     
				AND   A.REF_NO  = B.REF_NO                                                      
				AND   B.DS_TYP_DV_CD NOT LIKE '3%'                                              
				AND   B.SUBJ_CD != 'DP'                                                         
				AND   B.MAN_COA_YN = 'Y'                                                        
				AND   ( NVL (A.PRN_DLQY_YN,'N') = 'Y'
						OR
						NVL (A.INT_DLQY_YN,'N') = 'Y'  )
				--AND   ( B.CUR_CD != A.PRN_DLQY_CUR_CD                                         
				--        OR                                                                    
				--        B.CUR_CD !=  A.INT_DLQY_CUR_CD                                        
				--      )                                                                       
				GROUP BY  A.BASC_DT
				,         A.REF_NO
				,         B.CUST_NO
				,         B.CUST_NM
				,         B.COA_CD
				,         B.COA_NM
				,         B.PFMC_ORG_CD
				,         B.PRD_CD
				,         B.PRD_NM
				,         B.ATSD_GRD_CD
				,         B.CUR_CD
				,         B.FEX_AMT
				,         B.CVT_AMT
				,         A.DLQY_ORGN_DV_CD
				,         A.PRN_DLQY_YN
				,         A.INT_DLQY_YN
				,         A.DLQY_STRT_DT
				,         A.PRN_DLQY_STRT_DT
				,         A.INT_DLQY_STRT_DT
				,         A.PRN_DLQY_CUR_CD
				,         A.PRN_DLQY_AMT
				,         A.PRN_CVT_DLQY_AMT
				,         A.INT_DLQY_CUR_CD
				,         A.INT_DLQY_AMT
				,         A.INT_CVT_DLQY_AMT
				)                                                                                                                                                                                                                                               
				,                                                                                                                                                                                                                                               
				CALC_DATA                                                                       
				AS  (                                                                           
				SELECT  DOR.*                                                                   
				FROM    (                                                                       
								/*LOAN DETAIL*/                                                 
								SELECT  XX.REF_NO                                               
				--              ,       XX.SUBJ_CD                                              
                            ,       ROUND(SUM(XX.PST_AMT))             AS  TOT_PST_AMT      
                            ,       ROUND(SUM(XX.PST_AMT*GET_EXRT_F(V_PROC_BASC_DT, 'IDR', 'IDR')))    AS  CVT_PST_AMT
                            ,       ROUND(SUM(XX.LTE_AMT))             AS  TOT_LTE_AMT      
                            ,       ROUND(SUM(XX.LTE_AMT*GET_EXRT_F(V_PROC_BASC_DT, 'IDR', 'IDR')))    AS  CVT_LTE_AMT
                            FROM    (                                                       
                                    SELECT  DFN.*                                                                                                                  
                                    ,  CASE WHEN DFN.SUBJ_CD =   '001'   
                                        THEN ROUND(((DFN.NRM_SCH_AMT*PAST_DUE_RT/100)*(DAYS_CNT/RULE)), 4)                          
                                        ELSE NULL                                                                                           
                                        END AS PST_AMT                                                                        
                                    ,  CASE WHEN DFN.SUBJ_CD = '002'   
                                        THEN ROUND(((DFN.NRM_SCH_AMT*LATE_CHG_RT/100)*(DAYS_CNT/RULE)), 4)                          
                                        ELSE NULL                                                                                           
                                        END AS LTE_AMT                                                                        
                                    FROM    
                                    (                                                                                                                      
                                         SELECT  
                                                BS.REF_NO                                        	 AS  REF_NO                                              
                                        ,       SC.SCH_GB                                        	 AS  SUBJ_CD                                            
                                        ,       SC.PLAN_IL                                       	 AS  NRM_SCH_DT                                         
                                        ,       SC.SCH_SEQ                                       	 AS  SCH_SEQ                                            
                                        ,       SC.PLAN_AMT                                      	 AS  NRM_SCH_AMT                                        
                                        ,       SC.PAY_AMT                                       	 AS  NRM_SCH_PAY                                        
                                        ,       TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')                  AS  END_DT                                                  
                                        ,       LN.LON_JAN                                       	 AS  TOT_DLQY                                           
                                        ,       LN.LATE_CHG_RT                                   	 AS  LATE_CHG_RT                                        
                                        ,       LN.PAST_DUE_RT                                   	 AS  PAST_DUE_RT                                        
                                        ,       CAST('360' AS INT)                               	 AS  RULE                                               
                                        ,       (TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD') - SC.PLAN_IL)   AS  DAYS_CNT                                
                                        FROM    SRC_DATA BS                                                                                    
                                        ,       IDSS_ADST_LNB_SCH SC                                                                           
                                        ,       IDSS_ADST_LNB_BASE LN                                                                          
                                        WHERE   BS.BASC_DT      =       SC.BASC_DT                                                             
                                        AND     SC.REF_NO       =       BS.REF_NO                                                              
                                        AND     SC.PLAN_IL     <=       TO_DATE(V_PROC_BASC_DT,'YYYYMMDD')                                         
                                        AND     SC.PLAN_AMT     >       SC.PAY_AMT                                                             
                                        AND     SC.ADJ_SEQ      =       0                                                                      
                                        AND     SC.STS          =       '0'                                                                    
                                        AND     BS.BASC_DT      =       LN.BASC_DT                                                             
                                        AND     BS.REF_NO       =       LN.REF_NO                                                              
                                        GROUP BY BS.REF_NO                                                                                     
                                        ,       SC.SCH_GB                                                                                      
                                        ,       SC.PLAN_IL                                                                                     
                                        ,       SC.SCH_SEQ                                                                                     
                                        ,       SC.PLAN_AMT                                                                                    
                                        ,       SC.PAY_AMT                                                                                     
                                        ,       LN.LON_JAN                                                                                     
                                        ,       LN.LATE_CHG_RT                                                                                 
                                        ,       LN.PAST_DUE_RT                                                                                 
                                        ) DFN                                                                                                                          
                        ) XX                                                            
                        GROUP BY    XX.REF_NO                                           
--                     ,           XX.SUBJ_CD                                          
                                                                                                                                                                                                                                                        
                        UNION ALL                                                       
                                                                                                                                                                                                                                                        
                        /*GIRO PRK*/                                                    
                        SELECT  SM.REF_NO                                               
--                     ,       SM.SUBJ_CD                                              
                        ,       CASE WHEN SM.SUBJ_CD = '001' 
                                THEN SUM(SM.FL_LT_CHG)     
                                ELSE NULL                                                                                                              
                                END  AS  TOT_PST_AMT                                         
                        ,       CASE WHEN SM.SUBJ_CD = '001' 
                                THEN ROUND(SUM(SM.FL_LT_CHG*GET_EXRT_F(V_PROC_BASC_DT, 'IDR', 'IDR')))
                                ELSE NULL                                                                                                              
                                END  AS  CVT_PST_AMT                                         
                        ,       CASE WHEN SM.SUBJ_CD = '002' 
                                THEN SUM(SM.FL_LT_CHG)     
                                ELSE NULL                                                                                                              
                                END  AS  TOT_LTE_AMT                                         
                        ,       CASE WHEN SM.SUBJ_CD = '002' 
                                THEN ROUND(SUM(SM.FL_LT_CHG*GET_EXRT_F(V_PROC_BASC_DT, 'IDR', 'IDR')))
                                ELSE NULL                                                                                                              
                                END  AS  CVT_LTE_AMT                                         
                        FROM    (                                                       
                            SELECT  FL.*                                                                                                                    
                            ,       ROUND((NVL(FL.INT_AMT_NRM,0) + NVL(FL.INT_AMT_SPC,0) + NVL(FL.OD_LT_CHG_NRM,0) + NVL(FL.OD_LT_CHG_SPC,0))) AS  FL_LT_CHG
                            FROM    (                                                                                                                       
                                    SELECT  CL.*                                                                                                    
                                    ,       ROUND(((LMT*NRM_RT/100)*(OVR_DAY_NRM/RULE)),4)                  AS  INT_AMT_NRM                         
                                    ,       ROUND(((LMT*NRM_RT/100)*(OVR_DAY_SPC/RULE)),4)                  AS  INT_AMT_SPC                         
                                    ,       ROUND(((OVR_NRM*LT_RT/100)*(OVR_DAY_NRM/RULE)),4)               AS  OD_LT_CHG_NRM                       
                                    ,       ROUND(((OVR_SPC*LT_RT/100)*(OVR_DAY_SPC/RULE)),4)               AS  OD_LT_CHG_SPC                       
                                    FROM    (                                                                                                       
                                            SELECT  SRC.*                                                                                   
                                            ,       (SRC.TO_DT_NRM - SRC.FR_DT_NRM)                 AS  OVR_DAY_NRM                 
                                            ,       (SRC.TO_DT_SPC - FR_DT_SPC)                     AS  OVR_DAY_SPC                 
                                            ,       CAST('360' AS INT)                              AS  RULE                        
                                            FROM    (                                                                                       
                                                     SELECT  SR.REF_NO                                                               
                                                     ,       CASE WHEN DP.BS_JAN < 0                                                 
                                                             AND  DP.LON_MAN_IL < TO_DATE(DP.BASC_DT ,'YYYYMMDD')   
                                                             THEN '001'                                             
                                                             WHEN DECODE(NVL(DP.LON_SNG_AMT, 0), 0, CN.LON_SNG_AMT, DP.LON_SNG_AMT) < 0-DP.BS_JAN                                                   
                                                             THEN '002'                                             
                                                             WHEN DP.LON_FST_YC_IL  <= TO_DATE(DP.BASC_DT ,'YYYYMMDD')
                                                             AND  DP.LON_PRCP_YC_INT > 0                            
                                                             THEN '001'                                             
                                                             WHEN DP.LON_FST_YC_IL  <= TO_DATE(DP.BASC_DT ,'YYYYMMDD')
                                                             AND  DP.LON_INT_YC_INT > 0                             
                                                             THEN '002'                                             
                                                             WHEN DP.LON_FST_YC_IL  <= TO_DATE(DP.BASC_DT ,'YYYYMMDD')
                                                             THEN '002'                                             
                                                             END AS SUBJ_CD                          
                                                     ,       DP.LON_INT_CAL_IL                                                 AS  FR_DT_NRM        
                                                     ,       CASE WHEN    DP.LON_INT_CAL_IL  =   DP.JAGUM_IL                      
                                                             THEN TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')         
                                                             ELSE DP.JAGUM_IL                             
                                                             END  AS TO_DT_NRM   
                                                     ,       CASE WHEN    DP.LON_INT_CAL_IL  <>  DP.JAGUM_IL                      
                                                             THEN DP.JAGUM_IL                             
                                                             ELSE NULL                                    
                                                             END  AS FR_DT_SPC   
                                                     ,       CASE WHEN DP.LON_INT_CAL_IL  <>  DP.JAGUM_IL                      
                                                             THEN TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')         
                                                             ELSE NULL                                    
                                                             END                                                                AS TO_DT_SPC   
                                                     ,       DP.LON_RT                                                          AS  NRM_RT           
                                                     ,       DP.INT_OVER_DUE_INT_RT                                             AS  LT_RT            
                                                     ,       DECODE(NVL(DP.LON_SNG_AMT, 0), 0, CN.LON_SNG_AMT, DP.LON_SNG_AMT)  AS  LMT
                                                     ,       DP.BS_JAN                                                          AS  OS_NRM           
                                                     ,       CASE WHEN DP.LON_INT_CAL_IL  <>  DP.JAGUM_IL OR DP.BS_JAN <> DP.MAX_JAN
                                                             THEN DP.MAX_JAN                              
                                                             ELSE NULL                                    
                                                             END AS OS_SPC      
                                                     ,       CASE WHEN DP.LON_INT_CAL_IL  =  DP.JAGUM_IL                       
                                                             THEN (-DP.BS_JAN) - DECODE(NVL(DP.LON_SNG_AMT, 0), 0, CN.LON_SNG_AMT, DP.LON_SNG_AMT)                                        
                                                             ELSE (-DP.MAX_JAN) - DECODE(NVL(DP.LON_SNG_AMT, 0), 0, CN.LON_SNG_AMT, DP.LON_SNG_AMT)                                       
                                                             END AS OVR_NRM     
                                                     ,       CASE WHEN DP.LON_INT_CAL_IL <> DP.JAGUM_IL OR DP.BS_JAN <> DP.MAX_JAN
                                                             THEN (-DP.BS_JAN) - DECODE(NVL(DP.LON_SNG_AMT, 0), 0, CN.LON_SNG_AMT, DP.LON_SNG_AMT)                                        
                                                             ELSE NULL                                    
                                                             END  AS  OVR_SPC     
                                                     FROM    SRC_DATA  SR                                                            
                                                     LEFT JOIN IDSS_ADST_DPB_BASE DP ON SR.REF_NO  = DP.ACCT_NO                      
                                                     LEFT JOIN IDSS_ADST_DPB_LNIF CN ON DP.ACCT_NO = CN.ACCT_NO                      
                                                     WHERE   SR.BASC_DT =   DP.BASC_DT                                               
                                                     AND     DP.BASC_DT =   CN.BASC_DT                                               
                                                     AND     CN.STS     =   '0'                                                      
                                                     ) SRC                                                                           
                                            ) CL                                                                                            
                                                ) FL                                                                                                            
                                            ) SM                                                                                                                            
                                    GROUP BY   SM.REF_NO                                           
                                    ,          SM.SUBJ_CD                                                                                                                                                                                                                                                                          
                                    ) DOR                                                           
                                )                                                                                                                                            
                            SELECT  *                                                                       
                            FROM SRC_DATA SRC                                                               
                            LEFT JOIN CALC_DATA CLC ON SRC.REF_NO = CLC.REF_NO 
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


 