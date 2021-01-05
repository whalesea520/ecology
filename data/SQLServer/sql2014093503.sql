alter table SysMaintenanceLog add operateusertype int 

GO
alter table SysMaintenanceLog alter column operateitem varchar(10)

go
alter table SystemLogItem alter column itemid varchar(10)

GO
delete from SystemLogItem where itemid='301'
go
insert into SystemLogItem values('301',30041,'文档',1)

GO

CREATE TABLE ecology_log_operatetype(
	id int IDENTITY(1,1) NOT NULL,
	operatetype int,
	mouldid int,
	operatetypelabel varchar(20) not null,
	operatetypedesc varchar(200)
)

GO
delete from ecology_log_operatetype where operatetype=0 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(0,1,260,'阅读')

GO
delete from ecology_log_operatetype where operatetype=1
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(1,82,'新建')
GO
delete from ecology_log_operatetype where operatetype=2
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(2,103,'修改')
GO
delete from ecology_log_operatetype where operatetype=3
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(3,91,'删除')
GO
delete from ecology_log_operatetype where operatetype=4
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(4,1,142,'批准')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(4,78,'移动')
GO
delete from ecology_log_operatetype where operatetype=5
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(5,1,236,'退回')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(5,77,'复制')
GO
delete from ecology_log_operatetype where operatetype=6
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(6,1,21477,'重打开')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(6,674,'登陆')
GO
delete from ecology_log_operatetype where operatetype=7
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(7,1,251,'归档')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(7,17589,'加密')
GO
delete from ecology_log_operatetype where operatetype=8
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(8,1,256,'重载')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(8,17590,'取消加密')
GO
delete from ecology_log_operatetype where operatetype=9
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(9,1,220,'草稿')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(9,236,'退回')
GO
delete from ecology_log_operatetype where operatetype=10
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(10,1,117,'回复')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(10,22151,'封存')
GO
delete from ecology_log_operatetype where operatetype=11
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(11,1,78,'移动')
GO
insert into ecology_log_operatetype(operatetype,operatetypelabel,operatetypedesc) values(11,22152,'解封')
GO
delete from ecology_log_operatetype where operatetype=12 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(12,1,77,'复制')
GO
delete from ecology_log_operatetype where operatetype=13 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(13,1,114,'发布')
GO
delete from ecology_log_operatetype where operatetype=14 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(14,1,15750,'失效')
GO
delete from ecology_log_operatetype where operatetype=15 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(15,1,15358,'作废')
GO
delete from ecology_log_operatetype where operatetype=16 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(16,1,'611,22008','为文档添加新版本')
GO
delete from ecology_log_operatetype where operatetype=17 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(17,1,21806,'强制签出')
GO
delete from ecology_log_operatetype where operatetype=18 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(18,1,21807,'自动签出')
GO
delete from ecology_log_operatetype where operatetype=19 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(19,1,19688,'强制签入')
GO
delete from ecology_log_operatetype where operatetype=20 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(20,1,21808,'自动签入')
GO
delete from ecology_log_operatetype where operatetype=21 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(21,1,257,'打印')
GO
delete from ecology_log_operatetype where operatetype=22 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(22,1,31156,'下载')
GO
delete from ecology_log_operatetype where operatetype=23 and mouldid=1
GO
insert into ecology_log_operatetype(operatetype,mouldid,operatetypelabel,operatetypedesc) values(23,1,24357,'更改文档状态')
GO

CREATE TABLE ecology_log_history(
	id int IDENTITY(1,1) NOT NULL,
	tableName varchar(100) not null,
	modifyDate varchar(10) not null,
	tableDesc varchar(200)
)

GO

Create  procedure SysMaintenanceLog_proc 
@relatedid int,
@relatedname varchar(440),
@operateuserid int ,
@operateusertype int,
@operatetype varchar(2),
@operatedesc text,
@operateitem varchar(10),
@operatedate char(10),
@operatetime char(8),
@operatesmalltype int,
@clientaddress char(15),
@isTemplate int
as
insert into SysMaintenanceLog 
(relatedid,
 relatedname,
 operateuserid,
 operateusertype,
 operatetype,
 operatedesc,
 operateitem,
 operatedate,
 operatetime,
 operatesmalltype,
 clientaddress,
 isTemplate)
values(
@relatedid,
@relatedname,
@operateuserid,
@operateusertype,
@operatetype,
@operatedesc,
@operateitem,
@operatedate,
@operatetime,
@operatesmalltype,
@clientaddress,
@isTemplate)

GO

alter table docdetaillog add operateitem varchar(10)

GO

alter table docdetaillog add constraint df_docdetailog_operateitem default('301') for operateitem;

go

update DocDetailLog set operateitem = '301' 

GO

CREATE TRIGGER docdetaillog_trigger 
 ON docdetaillog FOR INSERT,UPDATE AS
 DECLARE @relatedid int
 DECLARE @relatedname varchar(440)
 DECLARE @operateuserid int 
 DECLARE @operateusertype int
 DECLARE @operatetype int
 DECLARE @operatedesc varchar(2000)
 DECLARE @operateitem varchar(10)
 DECLARE @operatedate char(10)
 DECLARE @operatetime char(8)
 DECLARE @operatesmalltype int
 DECLARE @clientaddress char(15)
 DECLARE @istemplate int
 select @relatedid=docid,
@relatedname=docsubject,
@operateuserid=operateuserid ,
@operateusertype=usertype,
@operatetype=operatetype,
@operatedesc='',
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



