CREATE TABLE workplan_attention (
id integer NOT NULL,
userid integer NOT NULL ,
usertype integer NOT NULL ,
touserid integer NOT NULL ,
createtime varchar2(19) NOT NULL 
)
/

create sequence seq_workplan_attention
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger workplan_attention_tri
before insert on workplan_attention
for each row
begin
select seq_workplan_attention.nextval into :new.id from dual;
end;
/
