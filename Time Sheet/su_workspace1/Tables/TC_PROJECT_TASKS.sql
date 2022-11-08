CREATE TABLE TC_PROJECT_TASKS(TASK_ID            NUMBER,
                              TASK_NAME          VARCHAR2(150),
							  PROJECT_ID         NUMBER,
							  CREATION_DATE      DATE,
							  CREATED_BY         VARCHAR2(150),
							  LAST_UPDATE_DATE   DATE,
							  LAST_UPDATED_BY    VARCHAR2(150)
                               );
							   
							   
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ1TASK1', 1000, sysdate, '-1', sysdate, '-1');
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ1TASK2', 1000, sysdate, '-1', sysdate, '-1');
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ2TASK1', 1001, sysdate, '-1', sysdate, '-1');
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ2TASK2', 1001, sysdate, '-1', sysdate, '-1');
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ3TASK1', 1002, sysdate, '-1', sysdate, '-1');
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ3TASK2', 1002, sysdate, '-1', sysdate, '-1');
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ4TASK1', 1003, sysdate, '-1', sysdate, '-1');
insert into TC_PROJECT_TASKS values(TC_PROJECT_TASKS_SEQ.nextval, 'PRJ4TASK2', 1003, sysdate, '-1', sysdate, '-1');