CREATE TABLE  CommunicateLog (
[id] int NOT NULL IDENTITY(1,1) PRIMARY key,
[relatedid] int NOT NULL ,
[relatedname] varchar(440) NULL ,
[operatetype] varchar(2) NOT NULL ,
[operatedesc] VARCHAR(2000) NULL ,
[operateitem] varchar(20) NULL ,
[operateuserid] int NOT NULL ,
[operatedate] char(10) NOT NULL ,
[operatetime] char(8) NOT NULL ,
[clientaddress] char(15) NULL ,
[istemplate] int NULL ,
[operatesmalltype] int NULL ,
[operateusertype] int NULL 
)
go

CREATE TRIGGER CommunicateLog_trigger 
 ON CommunicateLog FOR INSERT AS
 DECLARE @relatedid int
 DECLARE @relatedname varchar(440)
 DECLARE @operateuserid int 
 DECLARE @operateusertype int
 DECLARE @operatetype int
 DECLARE @operatedesc VARCHAR(2000)
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
@operatesmalltype=operatesmalltype,
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
go
