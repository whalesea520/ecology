drop table MailBlacklist
/
DROP SEQUENCE mailblacklist_tb_seq
/
CREATE TABLE MailBlacklist(
	 id                   int                  not null,
	 userid               int                  not null,
	 name                 varchar(100)         null,
	 postfix	      varchar(50)          null, 
	 constraint PK_MAIL_MailBlacklist primary key (id)
)
/
create sequence mailblacklist_tb_seq 
increment by 1
start with 1
nomaxvalue
nocycle
/
create or replace trigger mailblacklist_tb_tri	
before insert on MailBlacklist     
for each row                     
begin                            
      select mailblacklist_tb_seq.nextval into :new.id from dual;
end;
/
alter table MailBlacklist add constraint  UNIQUE_mailblacelist_n_postfix unique (name, postfix)
/