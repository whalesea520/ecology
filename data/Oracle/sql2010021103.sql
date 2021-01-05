CREATE TABLE MailSign (
	id integer primary key NOT NULL ,
	userId integer NULL ,
	signName varchar2(100),
	signDesc varchar2(200),
	signContent varchar2(4000)
)
/
CREATE SEQUENCE MailSign_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger MailSign_Tri
  before insert on MailSign
  for each row
begin
  select MailSign_seq.nextval into :new.id from dual;
end;
/
