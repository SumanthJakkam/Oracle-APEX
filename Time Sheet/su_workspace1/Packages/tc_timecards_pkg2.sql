CREATE OR REPLACE package tc_timecards_pkg2
   as
   
   function emp_id_check
   (
   p_emp_id  number
   )
   return number;

   function week_start_check
   (
   p_employee_id  number,
   p_week_start   date
   )
   return number;

   function week_end_check
   (
   p_employee_id  number,
   p_week_end   date
   )
   return number;

   function emp_project_combi_check
   (
   p_employee_id       number,
   p_project_id   number,
   p_month        number,
   p_year         number
   )
   return number;

   procedure get_week_start_end
   (
   x_week_start out date,
   x_week_end  out date
   );

   procedure week_start_end_date
   (
   p_date  date,
   x_week_start out  date,
   x_week_end  out  date
   );

   procedure submit_timecard
   (
   p_emp_id       number,
   p_project_name varchar2,
   p_week_start   date,
   p_week_end     date,
   p_monday       number,
   p_tuesday      number,
   p_wednesday    number,
   p_thursday     number,
   p_friday       number,
   p_saturday     number,
   p_sunday       number,
   p_status       varchar2
   );

   procedure submit_saved_timecard
   (
   p_emp_id       number,
   p_project_name varchar2,
   p_week_start   date,
   p_week_end     date,
   p_monday       number,
   p_tuesday      number,
   p_wednesday    number,
   p_thursday     number,
   p_friday       number,
   p_saturday     number,
   p_sunday       number,
   p_status       varchar2
   );
   
   procedure submit_approved_timecard
   (
   p_emp_id       number,
   p_project_name varchar2,
   p_week_start   date,
   p_week_end     date,
   p_monday       number,
   p_tuesday      number,
   p_wednesday    number,
   p_thursday     number,
   p_friday       number,
   p_saturday     number,
   p_sunday       number,
   p_status       varchar2
   );

   procedure submit_timecard_daily
   (
      p_emp_id       number,
      p_project_name varchar2,
      p_week_start   date,
      p_week_end     date,
      p_monday       number,
      p_tuesday      number,
      p_wednesday    number,
      p_thursday     number,
      p_friday       number,
      p_saturday     number,
      p_sunday       number,
      p_status       varchar2
   );
   
   
   /*
   function  count_hours
   (
   p_employee_id   number,
   p_project_name  varchar2,
   p_from  date,
   p_to  date
   )
   return number;
   */


   end tc_timecards_pkg2;
/


CREATE OR REPLACE package body tc_timecards_pkg2
   as
   
   function emp_id_check
   (p_emp_id  number
   )
   return number
   as
   l_count  number;
   begin
     select count(*) 
     into l_count
     from tc_employee
     where emp_id = p_emp_id;
     return l_count;

     exception
     when others then
     --tc_test_log_pkg.log('tc_timecards_pkg.emp_id_check', 'Employee ID not found');
     return 0;
   end emp_id_check;

   function week_start_check
   (
   p_employee_id  number,
   p_week_start  date
   )

   return number
   as
   l_ret   number;
   begin
     select count(*) 
     into l_ret
     from tc_time_sheet
     where emp_id = p_employee_id 
     and   week_start = p_week_start;

     return l_ret;

     exception
     when others then
     --tc_test_log_pkg.log('tc_timecards_pkg.week_start_check', 'Week Start not found');
     return 0;
   end week_start_check;


   function week_end_check
   (
   p_employee_id  number,
   p_week_end  date
   )

   return number
   as
   l_ret   number;
   begin
     select count(*) 
     into l_ret
     from tc_time_sheet
     where emp_id = p_employee_id 
     and   week_end = p_week_end;

     return l_ret;

     exception
     when others then
    -- tc_test_log_pkg.log('tc_timecards_pkg.week_end_check', 'Week End not found');
     return 0;
   end week_end_check;

   function emp_project_combi_check
   (
   p_employee_id    number,
   p_project_id     number,
   p_month          number,
   p_year           number
   )
   return number
   as
   l_ret  number;
   begin
      select count(*)
      into l_ret
      from tc_time_sheet_details
      where emp_id = p_employee_id
      and   project_id = p_project_id
      and   month = p_month
      and   year  = p_year;

      return l_ret;

      exception
      when others then
      --tc_test_log_pkg.log('tc_timecards_pkg.week_end_check', 'Week End not found');
      return 0;

   end emp_project_combi_check;

   procedure get_week_start_end
   (
   x_week_start out  date,
   x_week_end out  date
   )
   is
   l_date  varchar2(20);
   l_day  varchar2(10);
   l_week_start date;
   l_week_end date;
   begin

   select to_char(sysdate, 'DY') into l_day from dual;
   --dbms_output.put_line(l_day);

   if l_day = 'MON' then

      select sysdate into l_week_start from dual;
   --dbms_output.put_line(l_week_start);
      x_week_start := l_week_start;
      select sysdate + 6 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'TUE' then

      select sysdate - 1 into l_week_start from dual;
      x_week_start := l_week_start;
      select sysdate + 5 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'WED' then

      select sysdate - 2 into l_week_start from dual;
      x_week_start := l_week_start;
      select sysdate + 4 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'THU' then

      select sysdate - 3 into l_week_start from dual;
      x_week_start := l_week_start;
      select sysdate + 3 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'FRI' then

      select sysdate - 4 into l_week_start from dual;
      x_week_start := l_week_start;
      select sysdate + 2 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'SAT' then

      select sysdate - 5 into l_week_start from dual;
      x_week_start := l_week_start;
      select sysdate + 1 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'SUN' then

      select sysdate - 6 into l_week_start from dual;
      x_week_start := l_week_start;
      select sysdate into l_week_end from dual;
      x_week_end := l_week_end;
   end if;

   exception
   when others then
   --tc_test_log_pkg.log('tc_timecards_pkg.get_week_start_end', SQLERRM);
   null;
   end get_week_start_end;


   procedure week_start_end_date
   (
   p_date  date,
   x_week_start out  date,
   x_week_end  out  date
   )
   is
   l_day   varchar2(10);
   l_week_start  date;
   l_week_end    date;
   begin
     select to_char(p_date,'DY') into l_day from dual;

   if l_day = 'MON' then

      select p_date into l_week_start from dual;
   --dbms_output.put_line(l_week_start);
      x_week_start := l_week_start;
      select p_date + 6 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'TUE' then

      select p_date - 1 into l_week_start from dual;
      x_week_start := l_week_start;
      select p_date + 5 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'WED' then

      select p_date - 2 into l_week_start from dual;
      x_week_start := l_week_start;
      select p_date + 4 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'THU' then

      select p_date - 3 into l_week_start from dual;
      x_week_start := l_week_start;
      select p_date + 3 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'FRI' then

      select p_date - 4 into l_week_start from dual;
      x_week_start := l_week_start;
      select p_date + 2 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'SAT' then

      select p_date - 5 into l_week_start from dual;
      x_week_start := l_week_start;
      select p_date + 1 into l_week_end from dual;
      x_week_end := l_week_end;

   elsif l_day = 'SUN' then

      select p_date - 6 into l_week_start from dual;
      x_week_start := l_week_start;
      select p_date into l_week_end from dual;
      x_week_end := l_week_end;
   end if;

   exception
   when others then
   --tc_test_log_pkg.log('tc_timecards_pkg.get_week_start_end', SQLERRM);  
   null;
   end week_start_end_date;


   procedure submit_timecard
   (
   p_emp_id       number,
   p_project_name varchar2,
   p_week_start   date,
   p_week_end     date,
   p_monday       number,
   p_tuesday      number,
   p_wednesday    number,
   p_thursday     number,
   p_friday       number,
   p_saturday     number,
   p_sunday       number,
   p_status       varchar2
   )
   is
    l_emp_count  number;
    l_project_id  number;
    l_month       number;
    l_year        number;
    l_week_start_month   number;
    l_week_end_month     number;
    l_week_start_year    number;
    l_week_end_year      number;
	l_week_start1        date;
	l_week_end1          date;
	l_month1             varchar2(10);
	l_monday             varchar2(5);
	l_tuesday            varchar2(5);
	l_wednesday          varchar2(5);
	l_thursday           varchar2(5);
	l_friday             varchar2(5);
	l_saturday           varchar2(5);
	l_sunday             varchar2(5);
	l_new_month_day      varchar2(10);
    l_emp_project        number;
    l_timesheet_detail_id number; 
	timesheet_details_id varchar2(20) := 'Timesheet_details_id';
	emp_id               varchar2(50) := 'Emp_id';
	project_id           varchar2(50) := 'Project_id';
	month                varchar2(10) := 'Month';
	year                 varchar2(10) := 'Year';
    l_day                varchar2(5)  := 'DAY';
    creation_date        varchar2(20) := 'creation_date';
    created_by           varchar2(20) := 'created_by';
    last_update_date     varchar2(20) := 'last_update_date';
    last_updated_by      varchar2(20) := 'last_updated_by';
    last_updated_login   varchar2(20) := 'last_updated_login';
	sql_stmt             varchar2(2000);
    sql_stmt2            varchar2(2000);
   begin
   
    xxgt_test_log_pkg.log('Calling Submit timecard Procedure:');
	xxgt_test_log_pkg.log('Emp ID: '||p_emp_id);
	xxgt_test_log_pkg.log('p_project_name: '||p_project_name);
	xxgt_test_log_pkg.log('p_week_start: '||p_week_start);
	xxgt_test_log_pkg.log('p_week_end: '||p_week_end);
	xxgt_test_log_pkg.log('p_monday: '||p_monday);
	xxgt_test_log_pkg.log('p_tuesday: '||p_tuesday);
	xxgt_test_log_pkg.log('p_wednesday: '||p_wednesday);
	xxgt_test_log_pkg.log('p_thursday: '||p_thursday);
	xxgt_test_log_pkg.log('p_friday: '||p_friday);
	xxgt_test_log_pkg.log('p_saturday: '||p_saturday);
	xxgt_test_log_pkg.log('p_sunday: '||p_sunday);
	xxgt_test_log_pkg.log('p_status: '||p_status);
	
    l_emp_count := emp_id_check(p_emp_id => p_emp_id);
    if l_emp_count > 0 then
	
	--if p_status = 'Saved' then
	
       select project_id 
       into l_project_id
       from tc_projects
       where upper(project_name) = upper(p_project_name);

       insert into tc_time_sheet values
       (tc_time_sheet_seq.nextval,           --time sheet id
       p_emp_id,                              --emp_id
       l_project_id,                          --project_id
       p_status,                           --status
       p_week_start,                          --week_start
       p_week_end,                            --week_end
       p_monday,                                  --monday
       p_tuesday,                                 --tuesday
       p_wednesday,                             --wednesday
       p_thursday,                               --thursday
       p_friday,                                --friday
       p_saturday,                                       --saturday
       p_sunday,                                       --sunday
       nvl(p_monday,0)+nvl(p_tuesday,0)+nvl(p_wednesday,0)+
	   nvl(p_thursday,0)+nvl(p_friday,0)+nvl(p_saturday,0)+nvl(p_sunday,0),      --total_hours
       sysdate,                               --creation_date
       1,                                      --created_by
       sysdate,                                 --last_update_date
       1,                                     --last_updated_by,
       1                                       --last_update_login
             );
	   commit;

       dbms_output.put_line('p_week_start '||p_week_start);
       dbms_output.put_line('p_week_end '||p_week_end);
	   
	  -- elsif p_status = 'Submitted' then
	   	   
	      submit_timecard_daily
          (
          p_emp_id       ,
          p_project_name ,
          p_week_start   ,
          p_week_end     ,
          p_monday       ,
          p_tuesday      ,
          p_wednesday    ,
          p_thursday     ,
          p_friday       ,
          p_saturday     ,
          p_sunday       ,
          p_status       
          );
	   commit; 	  
	   
	   --end if;
       
	   /*
       select to_number(to_char(p_week_start, 'MM'))   into l_week_start_month from dual;
       dbms_output.put_line('l_week_start_month '||l_week_start_month);
       select to_number(to_char(p_week_end, 'MM'))     into l_week_end_month from dual;
       dbms_output.put_line('l_week_end_month '||l_week_end_month);
       select to_number(to_char(p_week_start, 'YYYY')) into l_week_start_year from dual;
       dbms_output.put_line('l_week_start_year '||l_week_start_year);
       select to_number(to_char(p_week_end, 'YYYY'))   into l_week_end_year from dual;
       dbms_output.put_line('l_week_end_year '||l_week_end_year);
	   
       if p_status = 'Saved' then
	      null;
	   else
       if l_week_start_month = l_week_end_month then

           dbms_output.put_line('inside l_week_start_month = l_week_end_month '||l_week_start_month ||'='|| l_week_end_month);
		   l_emp_project := emp_project_combi_check(p_emp_id, l_project_id, l_week_start_month, l_week_start_year);

           dbms_output.put_line('l_emp_project '||l_emp_project);
		   if l_emp_project = 0 then 

           dbms_output.put_line('inside l_emp_project = 0 ');
		      select to_char(p_week_start, 'DD') into l_monday from dual;
              dbms_output.put_line('l_monday '||l_monday);
			  select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
              dbms_output.put_line('l_tuesday '||l_tuesday);
			  select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
              dbms_output.put_line('l_wednesday '||l_wednesday);
			  select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
              dbms_output.put_line('l_thursday '||l_thursday);
			  select to_char(p_week_start + 4, 'DD') into l_friday from dual;
              dbms_output.put_line('l_friday '||l_friday);
			  select to_char(p_week_start + 5, 'DD') into l_saturday from dual;
              dbms_output.put_line('l_saturday '||l_saturday);
			  select to_char(p_week_start + 6, 'DD') into l_sunday from dual;
              dbms_output.put_line('l_sunday '||l_sunday);

              dbms_output.put_line('timesheet_details_id '||timesheet_details_id);
              dbms_output.put_line('emp_id '||emp_id);
              dbms_output.put_line('project_id '||project_id);
              dbms_output.put_line('month '||month);
              dbms_output.put_line('year '||year);
			  l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
              dbms_output.put_line('l_timesheet_detail_id '||l_timesheet_detail_id);
			  sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                    || emp_id ||',' 
																|| project_id ||','
                                                                || month ||','
                                                                || year ||','																
			                                                    || l_day||l_monday ||','
			                                                    || l_day||l_tuesday ||','
																|| l_day||l_wednesday ||','
																|| l_day||l_thursday ||','
																|| l_day||l_friday ||','
																|| l_day||l_saturday ||','
																|| l_day||l_sunday ||','
                                                                || creation_date || ','
                                                                || created_by ||','
                                                                || last_update_date ||','
                                                                || last_updated_by ||','
                                                                || last_updated_login || ')
													    values(	:l_timesheet_detail_id,
														        :p_emp_id,
																:l_project_id,
																:l_month,
																:l_year,
														        :p_monday, 
														        :p_tuesday, 
																:p_wednesday, 
																:p_thursday, 
																:p_friday, 
																:p_saturday, 
																:p_sunday,
                                                                :creationdate,
                                                                :createdby,
                                                                :lastupdatedate,
                                                                :lastupdateby,
                                                                :lastupdatedlogin)';
              EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_start_month, l_week_start_year, p_monday, 
			                                   p_tuesday, p_wednesday, p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
              commit;	

		   else

           dbms_output.put_line('inside else of l_emp_project = 0 ');
		      select to_char(p_week_start, 'DD') into l_monday from dual;
              dbms_output.put_line('l_monday '||l_monday);
			  select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
              dbms_output.put_line('l_tuesday '||l_tuesday);
			  select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
              dbms_output.put_line('l_wednesday '||l_wednesday);
			  select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
              dbms_output.put_line('l_thursday '||l_thursday);
			  select to_char(p_week_start + 4, 'DD') into l_friday from dual;
              dbms_output.put_line('l_friday '||l_friday);
			  select to_char(p_week_start + 5, 'DD') into l_saturday from dual;
              dbms_output.put_line('l_saturday '||l_saturday);
			  select to_char(p_week_start + 6, 'DD') into l_sunday from dual;
              dbms_output.put_line('l_sunday '||l_sunday);

             sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                              || l_day||l_tuesday ||'= :num ,'
                                                              || l_day||l_wednesday ||'= :num ,'
                                                              || l_day||l_thursday ||'= :num ,'
                                                              || l_day||l_friday ||'= :num ,'
                                                              || l_day||l_saturday ||'= :num ,'
                                                              || l_day||l_sunday ||'= :num ,'
                                                              || last_update_date ||'= :num ,'
                                                              || last_updated_by ||'= :num ,'
                                                              || last_updated_login ||'= :num  
                                                       WHERE '|| emp_id ||'= :num 
                                                         and '|| project_id || '= :num 
                                                         and '|| month || '= :num 
                                                         and '|| year || '= :num';

			  EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, 
			                                    p_saturday, p_sunday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
              commit;												
		   end if;

       elsif l_week_start_month <> l_week_end_month then

       dbms_output.put_line('inside elsif l_week_start_month <> l_week_end_month '||l_week_start_month||'<>'|| l_week_end_month);
	         l_week_start1 := p_week_start;
             dbms_output.put_line('l_week_start1 '||l_week_start1);  
		     l_week_end1  := p_week_end;
             dbms_output.put_line('l_week_end1 '||l_week_end1);
		     select to_char(l_week_start1 , 'MM') into l_month from dual;
		     l_month1 := l_month;
             dbms_output.put_line('l_month1 '||l_month1);

		     while l_week_start1 < l_week_end1 + 1
		     loop

             dbms_output.put_line('inside while loop ');
		        select to_char(l_week_start1 , 'MM') into l_month from dual;
			    exit when l_month1 <> l_month;
			    l_week_start1 := l_week_start1 + 1;
                dbms_output.put_line('l_week_start1 '||l_week_start1);
		     end loop;

			 select to_char(l_week_start1 , 'DY') into l_new_month_day from dual;

			 if l_new_month_day = 'TUE' then

                dbms_output.put_line('l_new_month_day = TUE ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num  
                                                          WHERE '|| emp_id ||'= :num  
                                                            and '|| project_id || '= :num  
                                                            and '|| month || '= :num  
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

                select to_char(l_week_start1, 'DD') into l_tuesday from dual;
                select to_char(l_week_start1 + 1, 'DD') into l_wednesday from dual;
                select to_char(l_week_start1 + 2, 'DD') into l_thursday from dual;				
			    select to_char(l_week_start1 + 3, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 4, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 5, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_tuesday ||','
																  || l_day||l_wednesday ||','
																  || l_day||l_thursday ||','
																  || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_tuesday, 
																 :p_wednesday, 
																 :p_thursday, 
																 :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                   p_tuesday, p_wednesday, p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'WED' then

                dbms_output.put_line('l_new_month_day = WED ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num 
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

                select to_char(l_week_start1, 'DD') into l_wednesday from dual;
                select to_char(l_week_start1 + 1, 'DD') into l_thursday from dual;				
			    select to_char(l_week_start1 + 2, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 3, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 4, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_wednesday ||','
																  || l_day||l_thursday ||','
																  || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_wednesday, 
																 :p_thursday, 
																 :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_wednesday, p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'THU' then

                dbms_output.put_line('l_new_month_day = THU');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

                select to_char(l_week_start1, 'DD') into l_thursday from dual;				
			    select to_char(l_week_start1 + 1, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 2, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 3, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_thursday ||','
																  || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_thursday, 
																 :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'FRI' then

                dbms_output.put_line('l_new_month_day = FRI ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
				select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || l_day||l_thursday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

			    select to_char(l_week_start1, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 1, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 2, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'SAT' then

                dbms_output.put_line('l_new_month_day = SAT ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
				select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
				select to_char(p_week_start + 4, 'DD') into l_friday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || l_day||l_thursday ||'= :num ,'
                                                                 || l_day||l_friday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, sysdate, 1, 1,
			                                    p_emp_id, l_project_id, l_week_start_month, l_week_start_year;
				commit;

				select to_char(l_week_start1, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 1, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'SUN' then

                dbms_output.put_line('l_new_month_day = SUN ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
				select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
				select to_char(p_week_start + 4, 'DD') into l_friday from dual;
				select to_char(p_week_start + 5, 'DD') into l_saturday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || l_day||l_thursday ||'= :num ,'
                                                                 || l_day||l_friday ||'= :num ,'
                                                                 || l_day||l_saturday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, 
			                                    p_saturday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

				select to_char(l_week_start1, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, 
                                                 l_week_end_year, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;			 
			 end if;

	   end if;

       end if;
	   */
       end if;
    exception
    when others then
    --tc_test_log_pkg.log('tc_timecards_pkg.submit_timecard', SQLERRM);
   null;
   end submit_timecard;
   
   
   procedure submit_saved_timecard
   (
   p_emp_id       number,
   p_project_name varchar2,
   p_week_start   date,
   p_week_end     date,
   p_monday       number,
   p_tuesday      number,
   p_wednesday    number,
   p_thursday     number,
   p_friday       number,
   p_saturday     number,
   p_sunday       number,
   p_status       varchar2
   )
   is
    l_emp_count  number;
    l_project_id  number;
    l_month       number;
    l_year        number;
    l_week_start_month   number;
    l_week_end_month     number;
    l_week_start_year    number;
    l_week_end_year      number;
	l_week_start1        date;
	l_week_end1          date;
	l_month1             varchar2(10);
	l_monday             varchar2(5);
	l_tuesday            varchar2(5);
	l_wednesday          varchar2(5);
	l_thursday           varchar2(5);
	l_friday             varchar2(5);
	l_saturday           varchar2(5);
	l_sunday             varchar2(5);
	l_new_month_day      varchar2(10);
    l_emp_project        number;
    l_timesheet_detail_id number; 
	timesheet_details_id varchar2(20) := 'Timesheet_details_id';
	emp_id               varchar2(50) := 'Emp_id';
	project_id           varchar2(50) := 'Project_id';
	month                varchar2(10) := 'Month';
	year                 varchar2(10) := 'Year';
    l_day                varchar2(5)  := 'DAY';
    creation_date        varchar2(20) := 'creation_date';
    created_by           varchar2(20) := 'created_by';
    last_update_date     varchar2(20) := 'last_update_date';
    last_updated_by      varchar2(20) := 'last_updated_by';
    last_updated_login   varchar2(20) := 'last_updated_login';
	sql_stmt             varchar2(2000);
    sql_stmt2            varchar2(2000);
   begin
   
    xxgt_test_log_pkg.log('Calling Submit timecard Procedure:');
	xxgt_test_log_pkg.log('Emp ID: '||p_emp_id);
	xxgt_test_log_pkg.log('p_project_name: '||p_project_name);
	xxgt_test_log_pkg.log('p_week_start: '||p_week_start);
	xxgt_test_log_pkg.log('p_week_end: '||p_week_end);
	xxgt_test_log_pkg.log('p_monday: '||p_monday);
	xxgt_test_log_pkg.log('p_tuesday: '||p_tuesday);
	xxgt_test_log_pkg.log('p_wednesday: '||p_wednesday);
	xxgt_test_log_pkg.log('p_thursday: '||p_thursday);
	xxgt_test_log_pkg.log('p_friday: '||p_friday);
	xxgt_test_log_pkg.log('p_saturday: '||p_saturday);
	xxgt_test_log_pkg.log('p_sunday: '||p_sunday);
	xxgt_test_log_pkg.log('p_status: '||p_status);
	
    l_emp_count := emp_id_check(p_emp_id => p_emp_id);
    if l_emp_count > 0 then
	
	   update tc_time_sheet
	   set    status = 'Submitted',
	          last_update_date = sysdate
	   where emp_id = p_emp_id
	   and   to_char(WEEK_START, 'DD/MON/YY') = to_char(p_week_start, 'DD/MON/YY');
		   
	      /*submit_timecard_daily
          (
          p_emp_id       ,
          p_project_name ,
          p_week_start   ,
          p_week_end     ,
          p_monday       ,
          p_tuesday      ,
          p_wednesday    ,
          p_thursday     ,
          p_friday       ,
          p_saturday     ,
          p_sunday       ,
          p_status       
          );
	   commit; */
 
	   end if;

    exception
    when others then
    --tc_test_log_pkg.log('tc_timecards_pkg.submit_timecard', SQLERRM);
   null;
   end submit_saved_timecard;
   
   procedure submit_approved_timecard
   (
   p_emp_id       number,
   p_project_name varchar2,
   p_week_start   date,
   p_week_end     date,
   p_monday       number,
   p_tuesday      number,
   p_wednesday    number,
   p_thursday     number,
   p_friday       number,
   p_saturday     number,
   p_sunday       number,
   p_status       varchar2
   )
   is
    l_emp_count  number;
    l_project_id  number;
    l_month       number;
    l_year        number;
    l_week_start_month   number;
    l_week_end_month     number;
    l_week_start_year    number;
    l_week_end_year      number;
	l_week_start1        date;
	l_week_end1          date;
	l_month1             varchar2(10);
	l_monday             varchar2(5);
	l_tuesday            varchar2(5);
	l_wednesday          varchar2(5);
	l_thursday           varchar2(5);
	l_friday             varchar2(5);
	l_saturday           varchar2(5);
	l_sunday             varchar2(5);
	l_new_month_day      varchar2(10);
    l_emp_project        number;
    l_timesheet_detail_id number; 
	timesheet_details_id varchar2(20) := 'Timesheet_details_id';
	emp_id               varchar2(50) := 'Emp_id';
	project_id           varchar2(50) := 'Project_id';
	month                varchar2(10) := 'Month';
	year                 varchar2(10) := 'Year';
    l_day                varchar2(5)  := 'DAY';
    creation_date        varchar2(20) := 'creation_date';
    created_by           varchar2(20) := 'created_by';
    last_update_date     varchar2(20) := 'last_update_date';
    last_updated_by      varchar2(20) := 'last_updated_by';
    last_updated_login   varchar2(20) := 'last_updated_login';
	sql_stmt             varchar2(2000);
    sql_stmt2            varchar2(2000);
   begin
   
    xxgt_test_log_pkg.log('Calling Submit timecard Procedure:');
	xxgt_test_log_pkg.log('Emp ID: '||p_emp_id);
	xxgt_test_log_pkg.log('p_project_name: '||p_project_name);
	xxgt_test_log_pkg.log('p_week_start: '||p_week_start);
	xxgt_test_log_pkg.log('p_week_end: '||p_week_end);
	xxgt_test_log_pkg.log('p_monday: '||p_monday);
	xxgt_test_log_pkg.log('p_tuesday: '||p_tuesday);
	xxgt_test_log_pkg.log('p_wednesday: '||p_wednesday);
	xxgt_test_log_pkg.log('p_thursday: '||p_thursday);
	xxgt_test_log_pkg.log('p_friday: '||p_friday);
	xxgt_test_log_pkg.log('p_saturday: '||p_saturday);
	xxgt_test_log_pkg.log('p_sunday: '||p_sunday);
	xxgt_test_log_pkg.log('p_status: '||p_status);
	
    l_emp_count := emp_id_check(p_emp_id => p_emp_id);
    if l_emp_count > 0 then
		   
	      submit_timecard_daily
          (
          p_emp_id       ,
          p_project_name ,
          p_week_start   ,
          p_week_end     ,
          p_monday       ,
          p_tuesday      ,
          p_wednesday    ,
          p_thursday     ,
          p_friday       ,
          p_saturday     ,
          p_sunday       ,
          p_status       
          );
	   commit;
 
	   end if;

    exception
    when others then
    --tc_test_log_pkg.log('tc_timecards_pkg.submit_timecard', SQLERRM);
   null;
   end submit_approved_timecard;
   
   
   procedure submit_timecard_daily
   (
   p_emp_id       number,
   p_project_name varchar2,
   p_week_start   date,
   p_week_end     date,
   p_monday       number,
   p_tuesday      number,
   p_wednesday    number,
   p_thursday     number,
   p_friday       number,
   p_saturday     number,
   p_sunday       number,
   p_status       varchar2
   )
   is

    l_emp_count  number;
    l_project_id  number;
    l_month       number;
    l_year        number;
    l_week_start_month   number;
    l_week_end_month     number;
    l_week_start_year    number;
    l_week_end_year      number;
	l_week_start1        date;
	l_week_end1          date;
	l_month1             varchar2(10);
	l_monday             varchar2(5);
	l_tuesday            varchar2(5);
	l_wednesday          varchar2(5);
	l_thursday           varchar2(5);
	l_friday             varchar2(5);
	l_saturday           varchar2(5);
	l_sunday             varchar2(5);
	l_new_month_day      varchar2(10);
    l_emp_project        number;
    l_timesheet_detail_id number; 
	timesheet_details_id varchar2(20) := 'Timesheet_details_id';
	emp_id               varchar2(50) := 'Emp_id';
	project_id           varchar2(50) := 'Project_id';
	month                varchar2(10) := 'Month';
	year                 varchar2(10) := 'Year';
    l_day                varchar2(5)  := 'DAY';
    creation_date        varchar2(20) := 'creation_date';
    created_by           varchar2(20) := 'created_by';
    last_update_date     varchar2(20) := 'last_update_date';
    last_updated_by      varchar2(20) := 'last_updated_by';
    last_updated_login   varchar2(20) := 'last_updated_login';
	sql_stmt             varchar2(2000);
    sql_stmt2            varchar2(2000);
	lv_total_hours       number;

    begin
	
	   select project_id 
       into l_project_id
       from tc_projects
       where upper(project_name) = upper(p_project_name);

       select to_number(to_char(p_week_start, 'MM'))   into l_week_start_month from dual;
       dbms_output.put_line('l_week_start_month '||l_week_start_month);
       select to_number(to_char(p_week_end, 'MM'))     into l_week_end_month from dual;
       dbms_output.put_line('l_week_end_month '||l_week_end_month);
       select to_number(to_char(p_week_start, 'YYYY')) into l_week_start_year from dual;
       dbms_output.put_line('l_week_start_year '||l_week_start_year);
       select to_number(to_char(p_week_end, 'YYYY'))   into l_week_end_year from dual;
       dbms_output.put_line('l_week_end_year '||l_week_end_year);
	   
       if l_week_start_month = l_week_end_month then

           dbms_output.put_line('inside l_week_start_month = l_week_end_month '||l_week_start_month ||'='|| l_week_end_month);
		   l_emp_project := emp_project_combi_check(p_emp_id, l_project_id, l_week_start_month, l_week_start_year);

           dbms_output.put_line('l_emp_project '||l_emp_project);
		   if l_emp_project = 0 then 

           dbms_output.put_line('inside l_emp_project = 0 ');
		      select to_char(p_week_start, 'DD') into l_monday from dual;
              dbms_output.put_line('l_monday '||l_monday);
			  select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
              dbms_output.put_line('l_tuesday '||l_tuesday);
			  select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
              dbms_output.put_line('l_wednesday '||l_wednesday);
			  select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
              dbms_output.put_line('l_thursday '||l_thursday);
			  select to_char(p_week_start + 4, 'DD') into l_friday from dual;
              dbms_output.put_line('l_friday '||l_friday);
			  select to_char(p_week_start + 5, 'DD') into l_saturday from dual;
              dbms_output.put_line('l_saturday '||l_saturday);
			  select to_char(p_week_start + 6, 'DD') into l_sunday from dual;
              dbms_output.put_line('l_sunday '||l_sunday);

              dbms_output.put_line('timesheet_details_id '||timesheet_details_id);
              dbms_output.put_line('emp_id '||emp_id);
              dbms_output.put_line('project_id '||project_id);
              dbms_output.put_line('month '||month);
              dbms_output.put_line('year '||year);
			  l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
              dbms_output.put_line('l_timesheet_detail_id '||l_timesheet_detail_id);
			  sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                    || emp_id ||',' 
																|| project_id ||','
                                                                || month ||','
                                                                || year ||','																
			                                                    || l_day||l_monday ||','
			                                                    || l_day||l_tuesday ||','
																|| l_day||l_wednesday ||','
																|| l_day||l_thursday ||','
																|| l_day||l_friday ||','
																|| l_day||l_saturday ||','
																|| l_day||l_sunday ||','
                                                                || creation_date || ','
                                                                || created_by ||','
                                                                || last_update_date ||','
                                                                || last_updated_by ||','
                                                                || last_updated_login || ')
													    values(	:l_timesheet_detail_id,
														        :p_emp_id,
																:l_project_id,
																:l_month,
																:l_year,
														        :p_monday, 
														        :p_tuesday, 
																:p_wednesday, 
																:p_thursday, 
																:p_friday, 
																:p_saturday, 
																:p_sunday,
                                                                :creationdate,
                                                                :createdby,
                                                                :lastupdatedate,
                                                                :lastupdateby,
                                                                :lastupdatedlogin)';
              EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_start_month, l_week_start_year, p_monday, 
			                                   p_tuesday, p_wednesday, p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
              commit;	

		   else

           dbms_output.put_line('inside else of l_emp_project = 0 ');
		      select to_char(p_week_start, 'DD') into l_monday from dual;
              dbms_output.put_line('l_monday '||l_monday);
			  select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
              dbms_output.put_line('l_tuesday '||l_tuesday);
			  select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
              dbms_output.put_line('l_wednesday '||l_wednesday);
			  select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
              dbms_output.put_line('l_thursday '||l_thursday);
			  select to_char(p_week_start + 4, 'DD') into l_friday from dual;
              dbms_output.put_line('l_friday '||l_friday);
			  select to_char(p_week_start + 5, 'DD') into l_saturday from dual;
              dbms_output.put_line('l_saturday '||l_saturday);
			  select to_char(p_week_start + 6, 'DD') into l_sunday from dual;
              dbms_output.put_line('l_sunday '||l_sunday);

             sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                              || l_day||l_tuesday ||'= :num ,'
                                                              || l_day||l_wednesday ||'= :num ,'
                                                              || l_day||l_thursday ||'= :num ,'
                                                              || l_day||l_friday ||'= :num ,'
                                                              || l_day||l_saturday ||'= :num ,'
                                                              || l_day||l_sunday ||'= :num ,'
                                                              || last_update_date ||'= :num ,'
                                                              || last_updated_by ||'= :num ,'
                                                              || last_updated_login ||'= :num  
                                                       WHERE '|| emp_id ||'= :num 
                                                         and '|| project_id || '= :num 
                                                         and '|| month || '= :num 
                                                         and '|| year || '= :num';

			  EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, 
			                                    p_saturday, p_sunday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
              commit;												
		   end if;

       elsif l_week_start_month <> l_week_end_month then

       dbms_output.put_line('inside elsif l_week_start_month <> l_week_end_month '||l_week_start_month||'<>'|| l_week_end_month);
	         l_week_start1 := p_week_start;
             dbms_output.put_line('l_week_start1 '||l_week_start1);  
		     l_week_end1  := p_week_end;
             dbms_output.put_line('l_week_end1 '||l_week_end1);
		     select to_char(l_week_start1 , 'MM') into l_month from dual;
		     l_month1 := l_month;
             dbms_output.put_line('l_month1 '||l_month1);

		     while l_week_start1 < l_week_end1 + 1
		     loop

             dbms_output.put_line('inside while loop ');
		        select to_char(l_week_start1 , 'MM') into l_month from dual;
			    exit when l_month1 <> l_month;
			    l_week_start1 := l_week_start1 + 1;
                dbms_output.put_line('l_week_start1 '||l_week_start1);
		     end loop;

			 select to_char(l_week_start1 , 'DY') into l_new_month_day from dual;

			 if l_new_month_day = 'TUE' then

                dbms_output.put_line('l_new_month_day = TUE ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num  
                                                          WHERE '|| emp_id ||'= :num  
                                                            and '|| project_id || '= :num  
                                                            and '|| month || '= :num  
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

                select to_char(l_week_start1, 'DD') into l_tuesday from dual;
                select to_char(l_week_start1 + 1, 'DD') into l_wednesday from dual;
                select to_char(l_week_start1 + 2, 'DD') into l_thursday from dual;				
			    select to_char(l_week_start1 + 3, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 4, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 5, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_tuesday ||','
																  || l_day||l_wednesday ||','
																  || l_day||l_thursday ||','
																  || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_tuesday, 
																 :p_wednesday, 
																 :p_thursday, 
																 :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                   p_tuesday, p_wednesday, p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'WED' then

                dbms_output.put_line('l_new_month_day = WED ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num 
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

                select to_char(l_week_start1, 'DD') into l_wednesday from dual;
                select to_char(l_week_start1 + 1, 'DD') into l_thursday from dual;				
			    select to_char(l_week_start1 + 2, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 3, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 4, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_wednesday ||','
																  || l_day||l_thursday ||','
																  || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_wednesday, 
																 :p_thursday, 
																 :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_wednesday, p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'THU' then

                dbms_output.put_line('l_new_month_day = THU');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

                select to_char(l_week_start1, 'DD') into l_thursday from dual;				
			    select to_char(l_week_start1 + 1, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 2, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 3, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_thursday ||','
																  || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_thursday, 
																 :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_thursday, p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'FRI' then

                dbms_output.put_line('l_new_month_day = FRI ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
				select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || l_day||l_thursday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

			    select to_char(l_week_start1, 'DD') into l_friday from dual;
				select to_char(l_week_start1 + 1, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 2, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_friday ||','
																  || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_friday, 
																 :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_friday, p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'SAT' then

                dbms_output.put_line('l_new_month_day = SAT ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
				select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
				select to_char(p_week_start + 4, 'DD') into l_friday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || l_day||l_thursday ||'= :num ,'
                                                                 || l_day||l_friday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, sysdate, 1, 1,
			                                    p_emp_id, l_project_id, l_week_start_month, l_week_start_year;
				commit;

				select to_char(l_week_start1, 'DD') into l_saturday from dual;
				select to_char(l_week_start1 + 1, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_saturday ||','
																  || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_saturday, 
																 :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, l_week_end_year, 
			                                     p_saturday, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;

			 elsif l_new_month_day = 'SUN' then

                dbms_output.put_line('l_new_month_day = SUN ');
				select to_char(p_week_start, 'DD') into l_monday from dual;
				select to_char(p_week_start + 1, 'DD') into l_tuesday from dual;
				select to_char(p_week_start + 2, 'DD') into l_wednesday from dual;
				select to_char(p_week_start + 3, 'DD') into l_thursday from dual;
				select to_char(p_week_start + 4, 'DD') into l_friday from dual;
				select to_char(p_week_start + 5, 'DD') into l_saturday from dual;
                sql_stmt2 := 'UPDATE tc_time_sheet_details SET '|| l_day||l_monday ||'= :num ,'
                                                                 || l_day||l_tuesday ||'= :num ,'
                                                                 || l_day||l_wednesday ||'= :num ,'
                                                                 || l_day||l_thursday ||'= :num ,'
                                                                 || l_day||l_friday ||'= :num ,'
                                                                 || l_day||l_saturday ||'= :num ,'
                                                                 || last_update_date ||'= :num ,'
                                                                 || last_updated_by ||'= :num ,'
                                                                 || last_updated_login ||'= :num
                                                          WHERE '|| emp_id ||'= :num 
                                                            and '|| project_id || '= :num 
                                                            and '|| month || '= :num 
                                                            and '|| year || '= :num';

			    EXECUTE IMMEDIATE sql_stmt2 USING p_monday, p_tuesday, p_wednesday, p_thursday, p_friday, 
			                                    p_saturday, sysdate, 1, 1, p_emp_id, l_project_id, 
												l_week_start_month, l_week_start_year;
				commit;

				select to_char(l_week_start1, 'DD') into l_sunday from dual;

				l_timesheet_detail_id := tc_time_sheet_details_seq.nextval;
			    sql_stmt := 'insert into tc_time_sheet_details ('|| timesheet_details_id ||',' 
			                                                      || emp_id ||',' 
																  || project_id ||','
                                                                  || month ||','
                                                                  || year ||','																
			                                                      || l_day||l_sunday ||','
                                                                  || creation_date || ','
                                                                  || created_by ||','
                                                                  || last_update_date ||','
                                                                  || last_updated_by ||','
                                                                  || last_updated_login ||')
													     values( :l_timesheet_detail_id,
														         :p_emp_id,
																 :l_project_id,
																 :l_month,
																 :l_year,
														         :p_sunday,
                                                                 :creationdate,
                                                                 :createdby,
                                                                 :lastupdatedate,
                                                                 :lastupdatedby,
                                                                 :lastupdatelogin)';
                EXECUTE IMMEDIATE sql_stmt USING l_timesheet_detail_id, p_emp_id, l_project_id, l_week_end_month, 
                                                 l_week_end_year, p_sunday, sysdate, 1, sysdate, 1, 1;
                commit;			 
			 end if;

	   end if;
       
	   lv_total_hours := nvl(p_monday, 0) + nvl(p_tuesday, 0) + nvl(p_wednesday, 0) + nvl(p_thursday, 0) + nvl(p_friday, 0) + 
	                     nvl(p_saturday, 0) + nvl(p_sunday, 0);
	   
	   update tc_time_sheet_details
	   set    total_hours = lv_total_hours
	   where  emp_id      = p_emp_id
	   and    project_id  = l_project_id
	   and    month       = l_week_start_month
	   and    year        = l_week_start_year;
	   commit;
	   

    exception
    when others then
    --tc_test_log_pkg.log('tc_timecards_pkg.submit_timecard', SQLERRM);
   null;

   end submit_timecard_daily;
   
   
   /*
   function count_hours
   (
   p_employee_id  number,
   p_project_name varchar2,
   p_from   date,
   p_to   date
   )
   return number
   is
   l_employee_id        number;
   l_project_id         number;
   l_from               date;
   l_to                 date;
   l_from_week_start    date;
   l_from_week_end      date;
   l_from_week_start2   date;
   l_from_week_end2     date;
   l_to_week_start      date;
   l_to_week_end        date;
   l_week_start_start   date;
   l_week_end_start     date;
   l_from_day           varchar2(10);
   l_to_day             varchar2(10);
   l_total_hours        number := 0;
   l_week_hours         number;
   l_hours              number;
   l_week_start1        date;
   l_from_week_start_check number;
   l_to_week_start_check   number;

   begin
        select project_id 
        into l_project_id
        from tc_projects
        where upper(project_name) = upper(p_project_name);

        tc_timecards_pkg.week_start_end_date(p_from , l_from_week_start, l_from_week_end);
        tc_timecards_pkg.week_start_end_date(p_to, l_to_week_start, l_to_week_end);

        --dbms_output.put_line('l_from '||p_from);
        --dbms_output.put_line('l_to '||p_to);
        --dbms_output.put_line('l_from_week_start '||l_from_week_start);
        --dbms_output.put_line('l_from_week_end '||l_from_week_end);
        --dbms_output.put_line('l_to_week_start '||l_to_week_start);
        --dbms_output.put_line('l_to_week_end '||l_to_week_end);
   if l_from_week_start = l_to_week_start and l_from_week_end = l_to_week_end then
        --dbms_output.put_line('inside l_from_week_start = l_to_week_start and l_from_week_end = l_to_week_end ');
        select sum(total_hours) 
        into l_hours 
        from tc_time_sheet
        where week_start = l_from_week_start 
        and emp_id = p_employee_id
        and project_id = l_project_id;
        l_total_hours := l_total_hours + l_hours;
        --dbms_output.put_line('total hours '||l_total_hours);  
   else  
        l_from_week_start_check := week_start_check(p_employee_id, l_from_week_start);
        l_to_week_start_check   := week_start_check(p_employee_id, l_to_week_start);

      if l_from_week_start_check = 0 then
          --dbms_output.put_line('Inside l_from_week_start_check = 0 ');
          select min(week_start)
          into l_from_week_start
          from tc_time_sheet
          where emp_id = p_employee_id
          and  project_id = l_project_id;
          --dbms_output.put_line('Inside l_from_week_start_check = 0 l_from_week_start '||l_from_week_start);

          select sum(total_hours) 
          into l_hours 
          from tc_time_sheet 
          where week_start = l_from_week_start 
          and emp_id = p_employee_id
          and project_id = l_project_id;
          l_total_hours := l_total_hours + nvl(l_hours, 0);
          --dbms_output.put_line('l_hours '||l_hours);
          --dbms_output.put_line('total hours '||l_total_hours);

      else
          --dbms_output.put_line('inside else of l_from_week_start_check = 0 ');
          select to_char(p_from, 'DY') into l_from_day from dual;
          --dbms_output.put_line('l_from_day '||l_from_day);

          if l_from_day = 'MON' then
             select sum(total_hours) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_from_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_from_day = MON '||l_total_hours);

          elsif l_from_day = 'TUE' then
             select sum(tuesday) + sum(wednesday) + sum(thursday) + sum(friday) + sum(saturday) + sum(sunday) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_from_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             --dbms_output.put_line('total hours l_from_day = TUE '||l_total_hours);
             l_total_hours := l_total_hours + nvl(l_hours, 0);

          elsif l_from_day = 'WED' then
             select sum(wednesday) + sum(thursday) + sum(friday) + sum(saturday) + sum(sunday)
             into l_hours 
             from tc_time_sheet 
             where week_start = l_from_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             --dbms_output.put_line('total hours l_from_day = WED '||l_total_hours);
             l_total_hours := l_total_hours + nvl(l_hours, 0);

          elsif l_from_day = 'THU' then
             select sum(thursday) + sum(friday) + sum(saturday) + sum(sunday)
             into l_hours 
             from tc_time_sheet 
             where week_start = l_from_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             --dbms_output.put_line('total hours l_from_day = THU '||l_total_hours);
             l_total_hours := l_total_hours + nvl(l_hours, 0);

          elsif l_from_day = 'FRI' then
             select sum(friday) + sum(saturday) + sum(sunday)
             into l_hours 
             from tc_time_sheet 
             where week_start = l_from_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             --dbms_output.put_line('total hours l_from_day = FRI '||l_total_hours);
            l_total_hours := l_total_hours + nvl(l_hours, 0);
          else
            null;
          end if;     
     end if;

     if l_to_week_start_check = 0 then
          --dbms_output.put_line('Inside l_to_week_start_check = 0 ');

          select max(week_start)
          into l_to_week_start
          from tc_time_sheet
          where emp_id = p_employee_id;
          --dbms_output.put_line('Inside l_to_week_start_check = 0 l_to_week_start '||l_to_week_start); 

          select sum(total_hours) 
          into l_hours 
          from tc_time_sheet 
          where week_start = l_to_week_start 
          and emp_id = p_employee_id
          and project_id = l_project_id;
          l_total_hours := l_total_hours + nvl(l_hours, 0);
          --dbms_output.put_line('l_hours '||l_hours);
          --dbms_output.put_line('total hours '||l_total_hours);

     else
          --dbms_output.put_line('inside else of l_to_week_start_check = 0 ');
          select to_char(p_to, 'DY') into l_to_day from dual;
          --dbms_output.put_line('l_to_day '||l_to_day);

          if l_to_day = 'MON' then
             select sum(monday) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_to_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_to_day = MON '||l_total_hours);

          elsif l_to_day = 'TUE' then
             select sum(monday) + sum(tuesday) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_to_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_to_day = TUE '||l_total_hours);

          elsif l_to_day = 'WED' then
             select sum(monday) + sum(tuesday) + sum(wednesday) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_to_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_to_day = WED '||l_total_hours);

          elsif l_to_day = 'THU' then
             select sum(monday) + sum(tuesday) + sum(wednesday) + sum(thursday) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_to_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_to_day = THU '||l_total_hours);

          elsif l_to_day = 'FRI' then
             select sum(total_hours) 
             into l_hours from tc_time_sheet 
             where week_start = l_to_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_to_day = FRI '||l_total_hours);

          elsif l_to_day = 'SAT' then
             select sum(total_hours) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_to_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_to_day = SAT '||l_total_hours);

          elsif l_to_day = 'SUN' then
             select sum(total_hours) 
             into l_hours 
             from tc_time_sheet 
             where week_start = l_to_week_start 
             and emp_id = p_employee_id
             and project_id = l_project_id;
             l_total_hours := l_total_hours + nvl(l_hours, 0);
             --dbms_output.put_line('total hours l_to_day = SUN '||l_total_hours);
          else
             null;
          end if;      
     end if;

     l_week_start_start := l_from_week_start;
     l_week_end_start   := l_to_week_start;

        while l_week_start_start < l_week_end_start - 7
          loop
          --dbms_output.put_line('inside while loop');
          --dbms_output.put_line(l_week_start_start||'<'||l_week_end_start);
          select l_week_start_start + 7 into l_week_start1 from dual;
          --DBMS_OUTPUT.PUT_LINE('week start '||l_week_start1);
          select sum(total_hours) 
          into l_week_hours 
          from tc_time_sheet 
          where emp_id = p_employee_id
          and project_id = l_project_id
          and week_start = l_week_start1;
          --dbms_output.put_line('week hours: '||l_week_hours);
          l_total_hours := l_total_hours + nvl(l_week_hours,0);
          --l_all_hours := l_total_hours;
          --dbms_output.put_line('total hours '||l_total_hours);
          l_week_start_start := l_week_start1;

        end loop;    
   end if;  

     return l_total_hours;

     exception 
     when others then
     --tc_test_log_pkg.log('tc_timecards_pkg.count_hours', SQLERRM);
     null;
   end count_hours;
   */

   end tc_timecards_pkg2;
/
