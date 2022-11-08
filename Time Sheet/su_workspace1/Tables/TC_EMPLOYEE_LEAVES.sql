CREATE TABLE TC_EMPLOYEE_LEAVES(ID               NUMBER,
                                EMP_ID           NUMBER,
								LEAVE_TYPE       VARCHAR2(50),
								USED             NUMBER,
								AVAILABLE        NUMBER,
								CREATION_DATE    DATE,
								CREATED_BY       VARCHAR2(100),
								LAST_UPDATE_DATE DATE,
								LAST_UPDATED_BY  VARCHAR2(100)
								  );
								  
insert into TC_EMPLOYEE_LEAVES values(TC_EMPLOYEE_LEAVES_SEQ.nextval, 100, 'Casual', 0, 12, sysdate, '-1', sysdate, '-1');
insert into TC_EMPLOYEE_LEAVES values(TC_EMPLOYEE_LEAVES_SEQ.nextval, 100, 'Earned', 0, 12, sysdate, '-1', sysdate, '-1');