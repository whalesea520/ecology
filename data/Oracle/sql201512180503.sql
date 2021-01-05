create or replace procedure p_synchrmenu_left(rescid integer,resctype integer,targets varchar2,configtbname varchar2)
as 
type  ref_cursor  is ref cursor;
t_cur ref_cursor;
s_id LeftMenuConfig.id%type;
s_visible LeftMenuConfig.visible%type;
s_viewindex LeftMenuConfig.viewindex%type;
v_sql varchar2(1000); 
sqlstr varchar2(1000); 
begin  
  sqlstr :='update '||configtbname||' set visible=:1,viewindex=:2 where  id =:3';
  v_sql := 'select a.id,b.visible,b.viewindex from '||configtbname||' a,'||configtbname||' b  where a.infoid=b.infoid and b.resourceid='||rescid||' and b.resourcetype='||resctype||'  and a.resourceid in ('||targets||')';
  open t_cur for v_sql;
  loop
    fetch  t_cur into s_id,s_visible,s_viewindex;
    execute immediate sqlstr using s_visible,s_viewindex,s_id;
    exit when  t_cur %notfound;
  end loop;
  close t_cur;
  commit;
end;
/
create index idx_mainmenuconfig_id on mainmenuconfig (id)
/

