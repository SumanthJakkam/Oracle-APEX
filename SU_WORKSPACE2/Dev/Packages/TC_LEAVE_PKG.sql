
  create or replace package tc_leave_pkg
  as
  
  function id_check
  (
  p_leave_id number
  )
  return number;
  
  procedure request_leave
  (
  p_emp_id number,
  p_leave_type  varchar2,
  p_start_date date, 
  p_end_date  date,
  p_description varchar2
  );
  
  procedure aprove_status
  (
  p_leave_id number,
  p_leave_status varchar2
  );
  
  end tc_leave_pkg;
  /
  
  
  create or replace package body tc_leave_pkg
  as
  
  function id_check
  (
  p_leave_id number
  )
  return number
  as
  l_id number;
  begin
  select count(*) 
  into l_id 
  from tc_leave 
  where leave_id = p_leave_id; 
  
  return l_id;
  
  exception
  when others then 
  dbms_output.put_line('In other Exception: '||SQLERRM);
  end id_check;
  
  
  procedure request_leave
  (
  p_emp_id number,
  p_leave_type  varchar2,
  p_start_date date, 
  p_end_date  date,
  p_description varchar2
  )
  as
  l_leave_id  number;
  l_excep exception;
  begin
  l_leave_id := tc_leave_seq.nextval;
  
      insert into tc_leave values ( l_leave_id, 
	                                 p_emp_id, 
									 p_leave_type, 
									 p_start_date,
									 p_end_date,
									 null,
                                     p_description,
									 'submitted', 
									 SYSDATE, 
									 p_emp_id,
									 SYSDATE, 
									 p_emp_id, 
									 1
									    );
  
       commit;
       dbms_output.put_line('----Record Inserted Successfully----');
  
  exception
  WHEN OTHERS THEN 
  null;
  end request_leave;
  
  
  procedure aprove_status
  (
  p_leave_id number,
  p_leave_status varchar2
  )
  as
  
  begin
       update tc_leave 
	   set leave_status = p_leave_status , 
	       last_update_date = SYSDATE ,
	       last_update_by = EMP_ID
       WHERE LEAVE_ID = p_leave_id;
       COMMIT;
  
  EXCEPTION 
  WHEN OTHERS THEN 
  NULL;
  end aprove_status;
  
  
  end tc_leave_pkg;
  
  ----https://globalsparktek.com/wp-content/uploads/2021/01/logo-1.png