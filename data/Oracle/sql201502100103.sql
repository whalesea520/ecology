alter TABLE workflow_requestlogAtInfo rename column forwardresource to forwardresource_temp
/
alter TABLE workflow_requestlogAtInfo add forwardresource clob
/
update workflow_requestlogAtInfo set forwardresource = forwardresource_temp
/

CREATE TABLE workflow_reqbrowextrainfo_bak
   (	ID        INTEGER,
  	REQUESTID INTEGER,
  	FIELDID   VARCHAR2(255),
  	TYPE      INTEGER,
  	TYPEID    INTEGER,
  	IDS       LONG,
  	MD5       VARCHAR2(255)
   ) 
/

create or replace procedure backupwf_reqbrowextrainfo(flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as 
cursor mycur is select id,ids  from workflow_reqbrowextrainfo ;
crow mycur%rowtype;
begin
open mycur;
loop
fetch mycur into crow;
exit when mycur%notfound;
     insert into workflow_reqbrowextrainfo_bak(id)            
     select crow.id from dual;                      
     update workflow_reqbrowextrainfo_bak set ids=crow.ids where id=crow.id;
end loop;
close mycur;
end;
/