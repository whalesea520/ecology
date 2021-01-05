delete from SystemLogItem where itemid=418
GO
insert into SystemLogItem(itemid,itemdesc,lableid,typeid) values('418','页面标签','81486','-1')
GO

delete from SystemLogItem where itemid=419
GO
insert into SystemLogItem(itemid,itemdesc,lableid,typeid) values('419','提示信息','24960','-1')
GO

delete from SystemLogItem where itemid=420
GO
insert into SystemLogItem(itemid,itemdesc,lableid,typeid) values('420','错误信息','25700','-1')
GO

create table labelManageLog(
	id int IDENTITY(1,1) NOT NULL,
	relatedid int,
	relatedname varchar(2000),
	operateuserid int,
	operateusertype int,
	operatetype int,
	operatedesc varchar(4000),
	operateitem varchar(10),
	operatedate char(10),
	operatetime char(8),
	clientaddress char(15),
	oldvalue varchar(2000),
	newvalue varchar(2000),
	languageid int,
	isTemplate int,
	operatesmalltype int
)

go

CREATE TRIGGER labelManageLog_trigger 
 ON labelManageLog FOR INSERT,UPDATE AS
 DECLARE @relatedid int
 DECLARE @relatedname varchar(440)
 DECLARE @operateuserid int 
 DECLARE @operateusertype int
 DECLARE @operatetype int
 DECLARE @operatedesc varchar(4000)
 DECLARE @operateitem varchar(10)
 DECLARE @operatedate char(10)
 DECLARE @operatetime char(8)
 DECLARE @operatesmalltype int
 DECLARE @clientaddress char(15)
 DECLARE @istemplate int
 select @relatedid=relatedid,
@relatedname=relatedname,
@operateuserid=operateuserid ,
@operateusertype=operateusertype,
@operatetype=operatetype,
@operatedesc=operatedesc,
@operateitem =operateitem,
@operatedate=operatedate,
@operatetime=operatetime,
@operatesmalltype=1,
@clientaddress=clientaddress,
@istemplate=0 from inserted

begin
EXECUTE  SysMaintenanceLog_proc
  @relatedid ,
  @relatedname ,
  @operateuserid ,
  @operateusertype ,
  @operatetype ,
  @operatedesc ,
  @operateitem ,
  @operatedate ,
  @operatetime ,
  @operatesmalltype ,
  @clientaddress ,
  @istemplate ;
end

GO