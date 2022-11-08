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
									 'Submitted', 
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
  l_number     number;
  l_start_date  date;
  l_end_date    date;
  l_week_start  date;
  l_week_end    date;
  l_monday      number;
  l_tuesday     number;
  l_wednesday   number;
  l_thursday    number;
  l_friday      number;
  l_saturday    number;
  l_sunday      number;
  l_day         varchar2(10);
  l_timesheet_id number;
  l_emp_id       number;
  l_cnt          number;
  l_total_hours  number;
  begin
  
  update tc_leave 
  set leave_status = p_leave_status , 
	  last_update_date = SYSDATE ,
	  last_update_by = EMP_ID
  WHERE LEAVE_ID = p_leave_id;
  
  select start_date, end_date, emp_id 
  into   l_start_date, l_end_date, l_emp_id
  from   tc_leave 
  where  leave_id = p_leave_id;   
  
  l_number   := (l_end_date - l_start_date) + 1;
  
  for i in 1..l_number
  loop
      l_monday := null; l_tuesday := null; l_wednesday := null; l_thursday := null;
	  l_friday := null; l_saturday := null; l_sunday := null;
	  
      l_week_start := tc_timecards_pkg.get_week_start(l_start_date);
	  l_week_end   := tc_timecards_pkg.get_week_end(l_start_date);
	  
	  select count(*) into l_cnt
	  from   TC_TIME_SHEET
	  where  to_char(WEEK_START, 'DD/MM/YYYY') = to_char(l_week_start, 'DD/MM/YYYY')
	  and    emp_id = l_emp_id
	  and    project_id = 0; --official timeoff
	  
	  select to_char(l_start_date, 'DY') into l_day from dual;
	  
      if l_day = 'MON' then
         l_monday    := 8;
      elsif l_day = 'TUE' then
         l_tuesday   := 8;
      elsif l_day = 'WED' then
         l_wednesday := 8;
      elsif l_day = 'THU' then
         l_thursday  := 8;
      elsif l_day = 'FRI' then
         l_friday    := 8;
      end if;
	  l_total_hours := nvl(l_monday, 0) + nvl(l_tuesday, 0) + nvl(l_wednesday, 0) +
	                   nvl(l_thursday, 0) + nvl(l_friday, 0) + nvl(l_saturday, 0) +
					   nvl(l_sunday, 0);
	  
	  if l_cnt = 0 
	  then
         insert into TC_TIME_SHEET
         (TIMESHEET_ID, EMP_ID, PROJECT_ID, STATUS, WEEK_START, WEEK_END,
		  MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY, 
		  TOTAL_HOURS, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY,
		  LAST_UPDATE_LOGIN, TASK_ID)		 
	     values
		 (TC_TIME_SHEET_SEQ.nextval,
		  l_emp_id,
		  0,
		  'Draft',
		  l_week_start,
		  l_week_end,
		  l_monday,
		  l_tuesday,
		  l_wednesday,
		  l_thursday,
		  l_friday,
		  l_saturday,
		  l_sunday,
		  l_total_hours,
		  sysdate,
		  v('APP_USER'),
		  sysdate,
		  v('APP_USER'),
		  sysdate,
		  null
		 );
	  elsif l_cnt > 0 
	  then
	  
	  select TIMESHEET_ID into l_timesheet_id
	  from   TC_TIME_SHEET
	  where  to_char(WEEK_START, 'DD/MM/YYYY') = to_char(l_week_start, 'DD/MM/YYYY')
	  and    emp_id = l_emp_id
	  and    project_id = 0; --official timeoff
	  
	    if l_day = 'MON' then
		
		   update TC_TIME_SHEET 
		   set    monday = l_monday,
		          total_hours = total_hours + l_monday,
				  last_update_date = sysdate,
				  last_updated_by = v('APP_USER')
		   where  timesheet_id = l_timesheet_id;
		   
	    elsif l_day = 'TUE' then
		
           update TC_TIME_SHEET 
		   set    tuesday = l_tuesday,
		          total_hours = total_hours + l_tuesday,
				  last_update_date = sysdate,
				  last_updated_by = v('APP_USER')
		   where  timesheet_id = l_timesheet_id;
		   
        elsif l_day = 'WED' then
		
           update TC_TIME_SHEET 
		   set    wednesday = l_wednesday,
		          total_hours = total_hours + l_wednesday,
				  last_update_date = sysdate,
				  last_updated_by = v('APP_USER')
		   where  timesheet_id = l_timesheet_id;
		   
        elsif l_day = 'THU' then
		
           update TC_TIME_SHEET 
		   set    thursday = l_thursday,
		          total_hours = total_hours + l_thursday,
				  last_update_date = sysdate,
				  last_updated_by = v('APP_USER')
		   where  timesheet_id = l_timesheet_id;
		   
        elsif l_day = 'FRI' then
		
           update TC_TIME_SHEET 
		   set    friday = l_friday,
		          total_hours = total_hours + l_friday,
				  last_update_date = sysdate,
				  last_updated_by = v('APP_USER')
		   where  timesheet_id = l_timesheet_id; 
		   
		end if;
	     
	  end if;
  l_start_date := l_start_date + 1;
	  
  end loop;
  
  COMMIT;
  
  EXCEPTION 
  WHEN OTHERS THEN
  ROLLBACK;  
  NULL;
  end aprove_status;
  
  
  end tc_leave_pkg;
  
