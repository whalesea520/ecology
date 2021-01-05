CREATE TABLE MailDeleteFile(
  id int not null,
	 mailfileid               int              not null,
	 timeMillis           varchar(200)         null,
	 filerealpath         varchar(200)         null,
	 constraint PK_MAIL_MailDeleteFile primary key (id)
)
/
create sequence MailDeleteFile_tb_seq
increment by 1
start with 1
nomaxvalue
nocycle
/
create or replace trigger MailDeleteFile_tb_tri
before insert on MailDeleteFile
for each row
begin
      select MailDeleteFile_tb_seq.nextval into :new.id from dual;
end;
/