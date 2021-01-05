alter table menushareinfo add jobtitlelevel varchar(1000)
/
alter table menushareinfo add jobtitlesharevalue varchar(1000)
/
alter table shareinnerhp add jobtitlelevel varchar(1000)
/
alter table shareinnerhp add jobtitlesharevalue varchar(1000)
/
alter table ptaccesscontrollist add jobtitle varchar(1000)
/
alter table ptaccesscontrollist add jobtitlelevel varchar(1000)
/
alter table ptaccesscontrollist add jobtitlesharevalue varchar(1000)
/
create table elementshareinfo (
	id int not null,
	eid int,
	sharetype varchar(1000),
	sharevalue varchar(1000),
	seclevel varchar(1000),
	seclevelmax varchar(1000),
	rolelevel varchar(1000),
	includeSub varchar(1),
	jobtitlelevel varchar(1000),
	jobtitlesharevalue varchar(1000)
)
/
create sequence elementshareinfo_seq increment by 1 start with 1 nomaxvalue nocycle cache 10
/
create or replace trigger elementshareinfo_trigger
before insert on elementshareinfo for each row
begin
select elementshareinfo_seq.nextval into :new.id from dual;
end;
/


