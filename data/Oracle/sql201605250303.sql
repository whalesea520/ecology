create table workflow_requestoperatelog(    
    id integer primary key,
    requestid integer, 
    nodeid integer, 
    isremark integer, 
    operatorid integer, 
    operatortype integer, 
    operatedate varchar2(10), 
    operatetime varchar2(8), 
    operatetype varchar2(25), 
    operatename varchar2(100), 
    operatecode integer, 
    isinvalid char(1), 
    invalidid integer,
    invaliddate varchar2(10), 
    invalidtime varchar2(8)
)
/
create  SEQUENCE workflow_requestoperatelog_seq
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_requestoperatelog_tri before insert on workflow_requestoperatelog for each row when(new.id is null)
begin
select workflow_requestoperatelog_seq.nextval into :new.id from dual;
end;
/
create table workflow_requestoperatelog_dtl (    
    requestid integer, 
    optlogid integer, 
    entitytype integer,
    entityid integer,
    ismodify char(1),
    fieldname varchar2(100), 
    ovalue varchar2(100), 
    nvalue varchar2(100)
)
/
CREATE INDEX workflow_requestoperatelog_IX ON workflow_requestoperatelog (requestid, isinvalid)
/
CREATE INDEX workflow_requestoperatelog_DIX ON workflow_requestoperatelog_dtl (requestid, optlogid)
/