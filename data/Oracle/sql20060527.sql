CREATE TABLE WFOpinionTableNames
(
	id integer not null ,	
	name varchar2(40) null
)
/

create sequence WFOpinionTableNames_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WFOpinionTableNames_Tri
before insert on WFOpinionTableNames
for each row
begin
select WFOpinionTableNames_id.nextval INTO :new.id from dual;
end;
/





ALTER TABLE WORKFLOW_REQUESTLOG add LOGID integer null 
/

create sequence WORKFLOW_REQUESTLOG_id
start with 1 
increment by 1
nomaxvalue
nocycle
/


create or replace PROCEDURE WORKFLOW_REQUESTLOG_ProTemp
as
maxlogid integer;
i integer;
begin
select count(*) into maxlogid from WORKFLOW_REQUESTLOG;
if(maxlogid>0) then 
i:=1;
while  i <= maxlogid
    loop
        update WORKFLOW_REQUESTLOG set LOGID=WORKFLOW_REQUESTLOG_id.nextval where LOGID is null and rownum=1;
        i:=i+1;
    end loop;
end if;

end;
/

call WORKFLOW_REQUESTLOG_ProTemp()
/
drop PROCEDURE WORKFLOW_REQUESTLOG_ProTemp
/


create or replace trigger WORKFLOW_REQUESTLOG_Tri
before insert on WORKFLOW_REQUESTLOG
for each row
begin
select WORKFLOW_REQUESTLOG_id.nextval INTO :new.LOGID from dual;
end;
/