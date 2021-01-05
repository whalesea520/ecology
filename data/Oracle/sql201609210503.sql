create or replace procedure p_update_hpallowArea
as 
type  ref_cursor  is ref cursor;
t_cur ref_cursor;
s_id hpbaselayout.id%type;
s_allowArea hpbaselayout.allowArea%type;
s_ftl hpbaselayout.ftl%type;
v_sql varchar2(1000);  
begin  
  v_sql := 'select id,allowArea,ftl from hpbaselayout';
  open t_cur for v_sql;
  loop
    fetch  t_cur into s_id,s_allowArea,s_ftl;
    update pagelayout set allowArea=s_allowArea,ftl=s_ftl where  id = s_id; 
    exit when  t_cur %notfound;
  end loop;
  close t_cur;
  commit;
end;
/
call p_update_hpallowArea()
/