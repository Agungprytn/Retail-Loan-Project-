 --sqlplus -S MISADM/inni0821@INOANMIS @/inoan/dw/batch/snapshot/sns_idss_adst_lnb_interlist.sql JSNS000115 20200311
 --sqlplus MISADM/inni0821@INOANMIS @/inoan/dw/batch/snapshot/sns_idss_adst_lnb_interlist.sql JSNS000115 20200311
 --------------------------------------------------------------------------------
 -- Table Name   : IDSS_ADST_LNB_INTERLIST
 -- Description  :
 -- Parameters   : 1. JOB ID
 --------------------------------------------------------------------------------
 -- Created Date : 2020.03.10
 -- Creator      : Iqbal
 --------------------------------------------------------------------------------
 -- Memo         :
 --------------------------------------------------------------------------------
 SET SERVEROUTPUT ON SIZE 10000
 SET LINESIZE 200
 SET TIMING   ON
 SET TERMOUT  ON

 BEGIN
      DECLARE
             --------------------------------------------------------------------
             -- 변수선언부
             --------------------------------------------------------------------
             -- 1.로그관리용 변수

             i       NUMBER;

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

             V_LST_SEQ_NO                 NUMBER       ;
             V_BF1M_BIZ_DT                VARCHAR2(8)  ;

    BEGIN

             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--A.HEAD START');
             DBMS_output.put_line('====================================================================');

             --------------------------------------------------------------------
             -- 변수설정부
             --------------------------------------------------------------------

             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP1 파라미터설정');
             --------------------------------------------------------------------
             V_BAT_JOB_ID    := '&1';
             V_PROC_BASC_DT  := '&2';

             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP2 변수설정');
             --------------------------------------------------------------------
             V_PROC_DT       := TO_CHAR(SYSDATE,'YYYYMMDD');
             V_PROC_CNT      := 0;
             V_PARM_INFO_CTT := '&1'||' '||'&2';


             --V_PROC_BASC_DT  := TO_CHAR(GET_BIZ_DAY_F(SYSDATE,-1),'YYYYMMDD');
             --V_PROC_BASC_DT  :=  TO_CHAR(SYSDATE-1,'YYYYMMDD');
             V_PROC_BASC_DT  :=  NVL( V_PROC_BASC_DT, TO_CHAR(SYSDATE-1,'YYYYMMDD'));

             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP3 배치 JOB 기본정보');
             --------------------------------------------------------------------
             BEGIN
                   SELECT /*+ INDEX_DESC(A IEDW_BAT_JOB_LOG_PK) */
                          A.BAT_PGM_ID
                   ,      B.PGM_FILE_PATH
                   INTO   V_BAT_PGM_ID
                   ,      V_PGM_FILE_PATH
                   FROM   IEDW_BAT_JOB_BASE A
                   ,      IEDW_BAT_PGM_BASE B
                   WHERE  A.BAT_PGM_ID = B.BAT_PGM_ID
                   AND    A.BAT_JOB_ID = V_BAT_JOB_ID
                   ;
             EXCEPTION   WHEN OTHERS THEN
                   V_BAT_PGM_ID    := '';
                   V_PGM_FILE_PATH := '';

             END;

             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP4 로그 SEQ_NO 채번');
             --------------------------------------------------------------------
             BEGIN
                   SELECT /*+ INDEX_DESC(A IEDW_BAT_JOB_LOG_PK) */
                          RUN_SEQ_NO  AS LST_SEQ_NO
                   INTO   V_LST_SEQ_NO
                   FROM   IEDW_BAT_JOB_LOG A
                   WHERE  PROC_DT    = V_PROC_DT
                   AND    BAT_JOB_ID = V_BAT_JOB_ID
                   AND    ROWNUM = 1;
             EXCEPTION   WHEN OTHERS THEN
                   V_LST_SEQ_NO := 0;
             END;

             V_RUN_SEQ_NO := NVL(V_LST_SEQ_NO,0) + 1;


             --------------------------------------------------------------------
             DBMS_output.put_line('--[HEAD] STEP5 로그 INSERT : 처리중');
             --------------------------------------------------------------------
             V_PROC_ST_CD := '1'; --처리중
             IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);

             DBMS_output.put_line('====================================================================');
             DBMS_output.put_line('--B.배치작업 BODY START');
             DBMS_output.put_line('====================================================================');

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP1 기존 자료 DELETE');
             --------------------------------------------------------------------


            -- DELETE
            -- FROM   IDSS_ADST_LNB_INTERLIST
            -- WHERE  BASC_DT IN (
            --                    SELECT
            --                            TO_CHAR(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')-ROWNUM+1, 'YYYYMMDD')          AS BASC_DT
            --                    FROM    DUAL
            --                    CONNECT BY ROWNUM <= 2192  -- 6*365 + 2
            --                    MINUS
            --                    -- 비지니스 월말 제외
            --                    SELECT   TO_CHAR(GET_BIZ_DAY_F(ADD_MONTHS(TO_DATE(SUBSTR(V_PROC_BASC_DT,1,6)||'01','YYYYMMDD'),- NO + 1),-1),'YYYYMMDD') AS BASC_DT
            --                    FROM     COPY_T
            --                    WHERE    ROWNUM <= 100
            --                    MINUS
            --                    -- 칼렌더 월말 제외
            --                    SELECT   TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(V_PROC_BASC_DT,'YYYYMMDD'),0 - NO)),'YYYYMMDD') AS BASC_DT
            --                    FROM     COPY_T
            --                    WHERE    ROWNUM <= 100
            --                    MINUS
            --                    -- 가장 최근 7일치 제외 (당일건 예외) - 해당하는 당일데이터는 지우고 시작
            --                    SELECT   TO_CHAR(TO_DATE(V_PROC_BASC_DT, 'YYYYMMDD')-ROWNUM, 'YYYYMMDD')
            --                    FROM    DUAL
            --                    CONNECT BY ROWNUM <= 7
            --                    )
            -- ;    -- MAX 보관일수[6년] 현재 5년이지만, 해당년도-1에 해당하는 데이터는 보관하기 위하여
			--


             DBMS_output.put_line('ROW_CNT : ' || SQL%ROWCOUNT);

             --------------------------------------------------------------------
             DBMS_output.put_line('--[BODY] STEP2 자료 INSERT');
             --------------------------------------------------------------------
             
			INSERT INTO IDSS_ADST_LNB_INTERLIST
			(
			   BASC_DT
			  ,ISYS_UPD_DTM
			  ,PRD_CD     
			  ,MNG_CD     
			  ,BIZ_CD     
			  ,SEQ_NO     
			  ,BIZ_NM     
			  ,USE_STR_DT 
			  ,USE_END_DT 
			  ,USE_YN     
			  ,REG_EMP_NO 
			  ,REG_DT     
			  ,REG_TM     
			  ,UPD_EMP_NO 
			  ,UPD_DT     
			  ,UPD_TM
			  )
			    SELECT
			      V_PROC_BASC_DT AS BASC_DT
			      ,SYSDATE 
			      ,PRD_CD     
			      ,MNG_CD     
			      ,BIZ_CD     
			      ,SEQ_NO     
			      ,BIZ_NM     
			      ,USE_STR_DT 
			      ,USE_END_DT 
			      ,USE_YN     
			      ,REG_EMP_NO 
			      ,REG_DT     
			      ,REG_TM     
			      ,UPD_EMP_NO 
			      ,UPD_DT     
			      ,UPD_TM
			      FROM ADST_LNB_INTERLIST@DBBCV1;     
  
  
             DBMS_output.put_line('ROW_CNT : ' || SQL%ROWCOUNT);
             V_PROC_CNT := V_PROC_CNT + SQL%ROWCOUNT;

             COMMIT;

             DBMS_output.put_line('--------------------------------------------------------------------');
             DBMS_output.put_line('--배치작업 BODY END');
             DBMS_output.put_line('--------------------------------------------------------------------');

             --------------------------------------------------------------------
             DBMS_output.put_line('--[FOOT] STEP1 로그 UPDATE : 처리완료');
             --------------------------------------------------------------------
             V_PROC_ST_CD := '2'; --처리완료
           IEDW_BAT_JOB_LOG_P( V_PROC_DT, V_BAT_JOB_ID, V_RUN_SEQ_NO, V_PROC_ST_CD, V_ERR_MSG_CTT, V_PROC_CNT,  V_PROC_BASC_DT,  V_PARM_INFO_CTT);



      EXCEPTION   WHEN OTHERS THEN
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
