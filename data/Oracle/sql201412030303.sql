CREATE TABLE WR_ReportShare(
id               integer NOT NULL ,
reportid         integer NULL ,      
sharetype        integer NULL ,   
seclevel         integer NULL ,
roleid           integer NULL ,
rolelevel        integer NULL ,
sharelevel       integer NULL ,
userid           VARCHAR2(1000) NULL,
deptid           VARCHAR2(1000) NULL,
mutiuserid       VARCHAR2(1000) NULL,
mutideptid       VARCHAR2(1000) NULL, 
muticpyid        VARCHAR2(1000) NULL
)
/
create sequence WR_ReportShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WR_ReportShare_id_trigger
before insert on WR_ReportShare
for each row
begin
select WR_ReportShare_id.nextval into :new.id from dual;
end;
/
