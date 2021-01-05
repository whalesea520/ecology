drop TRIGGER docdetaillog_trigger

GO

CREATE TRIGGER docdetaillogins_trigger 
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
