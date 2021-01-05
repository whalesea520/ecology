create or replace procedure p_update_hplayoutcode
as 
type  ref_cursor  is ref cursor;
t_cur ref_cursor;
s_id hpbaselayout.id%type;
s_layoutcode hpbaselayout.layoutcode%type;
s_layoutimage hpbaselayout.layoutimage%type;
v_sql varchar2(1000);  
begin  
  v_sql := 'select id,layoutcode,layoutimage from hpbaselayout';
  open t_cur for v_sql;
  loop
    fetch  t_cur into s_id,s_layoutcode,s_layoutimage;
    update pagelayout set layoutcode=s_layoutcode,layoutimage=s_layoutimage where  id = s_id; 
    exit when  t_cur %notfound;
  end loop;
  close t_cur;
  commit;
end;
/
call p_update_hplayoutcode()
/