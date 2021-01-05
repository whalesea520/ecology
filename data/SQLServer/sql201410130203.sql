create TRIGGER workplanviewlog_trigger 
 ON workplanviewlog FOR INSERT AS
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
 select @relatedid=workPlanId,
@operateuserid=userId ,
@operateusertype=usertype,
@operatetype=viewType,
@operatedesc='日程前台操作',
@operateitem ='91',
@operatedate=logDate,
@operatetime=logTime,
@operatesmalltype=1,
@clientaddress=ipAddress,
@istemplate=0 from inserted
select @relatedname=name from workplan where id=@relatedid

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
go
