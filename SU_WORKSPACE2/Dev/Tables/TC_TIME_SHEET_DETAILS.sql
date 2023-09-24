--------------------------------------------------------
--  DDL for Table TC_TIME_SHEET_DETAILS
--------------------------------------------------------

  CREATE TABLE "APEX"."TC_TIME_SHEET_DETAILS" 
   (	"TIMESHEET_DETAILS_ID" NUMBER, 
	"EMP_ID" NUMBER, 
	"PROJECT_ID" NUMBER, 
	"MONTH" NUMBER, 
	"YEAR" NUMBER, 
	"DAY01" NUMBER, 
	"DAY02" NUMBER, 
	"DAY03" NUMBER, 
	"DAY04" NUMBER, 
	"DAY05" NUMBER, 
	"DAY06" NUMBER, 
	"DAY07" NUMBER, 
	"DAY08" NUMBER, 
	"DAY09" NUMBER, 
	"DAY10" NUMBER, 
	"DAY11" NUMBER, 
	"DAY12" NUMBER, 
	"DAY13" NUMBER, 
	"DAY14" NUMBER, 
	"DAY15" NUMBER, 
	"DAY16" NUMBER, 
	"DAY17" NUMBER, 
	"DAY18" NUMBER, 
	"DAY19" NUMBER, 
	"DAY20" NUMBER, 
	"DAY21" NUMBER, 
	"DAY22" NUMBER, 
	"DAY23" NUMBER, 
	"DAY24" NUMBER, 
	"DAY25" NUMBER, 
	"DAY26" NUMBER, 
	"DAY27" NUMBER, 
	"DAY28" NUMBER, 
	"DAY29" NUMBER, 
	"DAY30" NUMBER, 
	"DAY31" NUMBER, 
	"TOTAL_HOURS" NUMBER, 
	"CREATION_DATE" DATE, 
	"CREATED_BY" NUMBER, 
	"LAST_UPDATE_DATE" DATE, 
	"LAST_UPDATED_BY" NUMBER, 
	"LAST_UPDATED_LOGIN" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
REM INSERTING into APEX.TC_TIME_SHEET_DETAILS
SET DEFINE OFF;
Insert into APEX.TC_TIME_SHEET_DETAILS (TIMESHEET_DETAILS_ID,EMP_ID,PROJECT_ID,MONTH,YEAR,DAY01,DAY02,DAY03,DAY04,DAY05,DAY06,DAY07,DAY08,DAY09,DAY10,DAY11,DAY12,DAY13,DAY14,DAY15,DAY16,DAY17,DAY18,DAY19,DAY20,DAY21,DAY22,DAY23,DAY24,DAY25,DAY26,DAY27,DAY28,DAY29,DAY30,DAY31,TOTAL_HOURS,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LAST_UPDATED_LOGIN) values (10000,100,1000,6,2021,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,10,10,10,null,30,to_date('01-AUG-21 08:39:34 PM','DD-MON-RR HH:MI:SS AM'),1,to_date('01-AUG-21 08:39:34 PM','DD-MON-RR HH:MI:SS AM'),1,1);
Insert into APEX.TC_TIME_SHEET_DETAILS (TIMESHEET_DETAILS_ID,EMP_ID,PROJECT_ID,MONTH,YEAR,DAY01,DAY02,DAY03,DAY04,DAY05,DAY06,DAY07,DAY08,DAY09,DAY10,DAY11,DAY12,DAY13,DAY14,DAY15,DAY16,DAY17,DAY18,DAY19,DAY20,DAY21,DAY22,DAY23,DAY24,DAY25,DAY26,DAY27,DAY28,DAY29,DAY30,DAY31,TOTAL_HOURS,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LAST_UPDATED_LOGIN) values (10001,100,1000,7,2021,10,10,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,10,10,10,10,10,null,70,to_date('01-AUG-21 08:39:34 PM','DD-MON-RR HH:MI:SS AM'),1,to_date('01-AUG-21 09:27:56 PM','DD-MON-RR HH:MI:SS AM'),1,1);
Insert into APEX.TC_TIME_SHEET_DETAILS (TIMESHEET_DETAILS_ID,EMP_ID,PROJECT_ID,MONTH,YEAR,DAY01,DAY02,DAY03,DAY04,DAY05,DAY06,DAY07,DAY08,DAY09,DAY10,DAY11,DAY12,DAY13,DAY14,DAY15,DAY16,DAY17,DAY18,DAY19,DAY20,DAY21,DAY22,DAY23,DAY24,DAY25,DAY26,DAY27,DAY28,DAY29,DAY30,DAY31,TOTAL_HOURS,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LAST_UPDATED_LOGIN) values (10002,100,1000,8,2021,null,10,10,10,10,10,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,50,to_date('01-AUG-21 09:27:56 PM','DD-MON-RR HH:MI:SS AM'),1,to_date('01-AUG-21 09:28:40 PM','DD-MON-RR HH:MI:SS AM'),1,1);