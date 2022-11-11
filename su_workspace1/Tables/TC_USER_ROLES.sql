--------------------------------------------------------
--  DDL for Table TC_USER_ROLES
--------------------------------------------------------

  CREATE TABLE TC_USER_ROLES 
   (ROLE_ID           NUMBER,
    ROLE_NAME         VARCHAR2(100),
	CREATION_DATE     DATE,
	CREATED_BYN       VARCHAR2(150),
	LAST_UPDATE_DATE  DATE,
	LAST_UPDATED_BY   VARCHAR2(150)
   );
   
   
Insert into APEX.TC_USER_ROLES (ROLE_ID,EMP_ID,ROLE) values (10000,100,'Employee');
Insert into APEX.TC_USER_ROLES (ROLE_ID,EMP_ID,ROLE) values (10001,101,'Employee');
Insert into APEX.TC_USER_ROLES (ROLE_ID,EMP_ID,ROLE) values (10002,102,'Admin');
