alter table workflow_nodehtmllayout add isactive integer
/

create or replace procedure WORKFLOW_LAYOUTSETACTIVE is
       vsql varchar2(1000);
       v_cur SYS_REFCURSOR;
       v_nodeid INTEGER;
       v_formid INTEGER;
       v_isbill INTEGER;
       v_type INTEGER;
       v_str varchar(1000);
       maxid INTEGER;
begin
  vsql := 'SELECT nodeid,formid,isbill,type FROM (SELECT nodeid,formid,isbill,type,count(*)
        AS num FROM workflow_nodehtmllayout where isactive is null GROUP BY nodeid,formid,isbill,type) a WHERE a.num>1';
  open v_cur for vsql;
  LOOP
    fetch v_cur into v_nodeid,v_formid,v_isbill,v_type;
    exit when v_cur%NOTFOUND;
     v_str := ' and nodeid='||v_nodeid||' and formid='||v_formid||' and isbill='||v_isbill||' and type='||v_type||' ';
     vsql := 'select max(id) from workflow_nodehtmllayout where 1=1 '||v_str;
     execute immediate vsql into maxid;
     vsql := 'update workflow_nodehtmllayout set isactive=0 where 1=1 '||v_str||' and id<>'||maxid;
     execute immediate vsql;
     vsql := 'update workflow_nodehtmllayout set isactive=1 where 1=1 '||v_str||' and id='||maxid;
     execute immediate vsql;
  END LOOP;
  vsql := 'update workflow_nodehtmllayout set isactive=1 where isactive is null ';
  execute immediate vsql;
  COMMIT;
end WORKFLOW_LAYOUTSETACTIVE;
/
call WORKFLOW_LAYOUTSETACTIVE()
/