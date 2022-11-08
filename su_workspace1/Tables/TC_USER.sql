--------------------------------------------------------
--  DDL for Table TC_USER
--------------------------------------------------------

  CREATE TABLE TC_USER
   (USER_ID          NUMBER, 
	USER_NAME        VARCHAR2(100), 
	PASSWORD         VARCHAR2(20), 
	EMP_ID           NUMBER, 
	USER_ROLES       VARCHAR2(500),
	USER_IMAGE       BLOB,
	IMAGE_NAME       VARCHAR2(250),
	MIME_TYPE        VARCHAR2(250),
	CREATION_DATE    DATE, 
	CREATED_BY       NUMBER, 
	LAST_UPDATE_DATE DATE, 
	LAST_UPDATED_BY  NUMBER
   );
   
   
Insert into APEX.TC_USER (USER_ID,USER_NAME,PASSWORD,EMP_ID,USER_ROLE,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LAST_UPDATE_LOGIN) values (100,'employee3@gmail.com','employee31234',102,'ADMIN',to_date('03-SEP-21 10:47:48 AM','DD-MON-RR HH:MI:SS AM'),1,to_date('03-SEP-21 12:00:00 AM','DD-MON-RR HH:MI:SS AM'),1,1);
Insert into APEX.TC_USER (USER_ID,USER_NAME,PASSWORD,EMP_ID,USER_ROLE,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LAST_UPDATE_LOGIN) values (101,'employee1@gmail.com','employee11234',100,'EMPLOYEE',to_date('03-SEP-21 12:00:00 AM','DD-MON-RR HH:MI:SS AM'),1,to_date('03-SEP-21 12:00:00 AM','DD-MON-RR HH:MI:SS AM'),1,1);
Insert into APEX.TC_USER (USER_ID,USER_NAME,PASSWORD,EMP_ID,USER_ROLE,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LAST_UPDATE_LOGIN) values (102,'employee2@gmail.com','employee21234',101,'EMPLOYEE',to_date('03-SEP-21 12:00:00 AM','DD-MON-RR HH:MI:SS AM'),1,to_date('03-SEP-21 12:00:00 AM','DD-MON-RR HH:MI:SS AM'),1,1);
