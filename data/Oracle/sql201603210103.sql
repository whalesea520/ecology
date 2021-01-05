create or replace procedure Hplayout_eid_update(hpid integer,ebaseid varchar2) as 
type  ref_cursor  is ref cursor;
t_cur ref_cursor;
s_id hpElement.id%type;
v_sql varchar2(1000); 
sqlstr varchar2(1000); 
begin
  v_sql := 'areaElements';
  sqlstr:='select id from hpElement where isuse=1 and ebaseid='''||ebaseid||''' and hpid='||hpid;
  open t_cur for sqlstr;
  loop
    fetch  t_cur into s_id;
    exit when  t_cur %notfound;
    v_sql := 'replace(' || v_sql  ||','''||s_id||','','''')';
    
  end loop;
  close t_cur;
  execute immediate 'update hpElement set isuse = 0 where ebaseid='''||ebaseid||''' and hpid='||hpid;
  execute immediate 'update hpLayout set areaElements = '||v_sql||' where hpid='||hpid;
  commit;
end;
/