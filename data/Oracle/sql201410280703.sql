delete from SystemLogItem where itemid=418
/
insert into SystemLogItem(itemid,itemdesc,lableid,typeid) values('418','页面标签','81486','-1')
/

delete from SystemLogItem where itemid=419
/
insert into SystemLogItem(itemid,itemdesc,lableid,typeid) values('419','提示信息','24960','-1')
/

delete from SystemLogItem where itemid=420
/
insert into SystemLogItem(itemid,itemdesc,lableid,typeid) values('420','错误信息','25700','-1')
/

create table labelManageLog(
	id int  NOT NULL primary key,
	relatedid int,
	relatedname varchar2(2000),
	operateuserid int,
	operateusertype int,
	operatetype int,
	operatedesc varchar2(4000),
	operateitem varchar2(10),
	operatedate char(10),
	operatetime char(8),
	clientaddress char(15),
	oldvalue varchar2(2000),
	newvalue varchar2(2000),
	languageid int,
	isTemplate int,
	operatesmalltype int
)

/

create sequence labelManageLog_id
	 minvalue 1
	 maxvalue 999999999999999999999999999
	 start with 1
	 increment by 1
	 cache 20
/

create or replace trigger   labelManageLog_id_TRIGGER  
  before insert on labelManageLog
  for each row 
begin
  select labelManageLog_id.nextval into :new.id from dual;
end;

/

CREATE OR REPLACE  TRIGGER  labelManageLog_trigger 
  before insert on labelManageLog
  for each row 
  begin
 SysMaintenanceLog_proc(:new.relatedid,
:new.relatedname,
:new.operateuserid ,
:new.operateusertype,
:new.operatetype,
:new.operatedesc,
:new.operateitem,
:new.operatedate,
:new.operatetime,
1,
:new.clientaddress,
0 );

end;
/
