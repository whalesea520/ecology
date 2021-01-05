CREATE TABLE workflow_requestexception(
  keyid NUMBER NOT NULL,
  requestid INTEGER,
  nodeid INTEGER,
  destnodeid INTEGER,
  exceptiontype char(1),
  signtype char(1),
  flowoperator VARCHAR2(500)
)
/
    create sequence workflow_requestexception_seq minvalue 1 maxvalue 99999999
    increment by 1
    start with 1
/
create or replace trigger workflow_requestexception_tri
 before insert on workflow_requestexception
 for each row      
 begin      
     select workflow_requestexception_seq.nextval into :new.keyid from DUAL;
 END;
/

create index workflow_exception_index on workflow_requestexception(requestid)
/