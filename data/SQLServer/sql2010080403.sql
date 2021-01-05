alter table CRM_ShareInfo add  contents int
go
update CRM_ShareInfo set contents=userid where sharetype=1
go

update CRM_ShareInfo set contents=departmentid where sharetype=2
go

update CRM_ShareInfo set contents=roleid where sharetype=3
go

update CRM_ShareInfo set contents=1 where sharetype=4
go

update CRM_ShareInfo set contents=crmid where sharetype=9
go

alter PROCEDURE CRM_ShareInfo_Insert (@relateditemid int, @sharetype tinyint, @seclevel  tinyint, @rolelevel tinyint, @sharelevel tinyint, @userid int, @departmentid int, @roleid int, @foralluser tinyint, @contents int, @flag integer output, @msg varchar(80) output ) AS INSERT INTO CRM_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,contents ) VALUES ( @relateditemid , @sharetype , @seclevel , @rolelevel , @sharelevel, @userid, @departmentid, @roleid, @foralluser, @contents  ) set @flag=1 set @msg='ok'

GO

alter PROCEDURE WF_CRM_ShareInfo_Add (@crmid_1		int, @sharelevel_1		int, @userid_1		int, @usertype_1		int, @flag                             integer output, @msg                             varchar(80) output ) as declare @count_2 int select @count_2=count(*)  from CRM_ShareInfo where relateditemid=@crmid_1 and sharelevel=@sharelevel_1 and userid= @userid_1 if @count_2=0 begin if @usertype_1=0 begin insert CRM_ShareInfo(relateditemid,sharetype,sharelevel,userid,contents) values(@crmid_1,'1',@sharelevel_1,@userid_1,@userid_1) end if @usertype_1=1 begin insert CRM_ShareInfo(relateditemid,sharetype,sharelevel,crmid,contents) values(@crmid_1,'9',@sharelevel_1,@userid_1,@userid_1) end end  
go

alter PROCEDURE CRM_ShareEditToManager( @crmId int, @managerId int, @flag integer output,@msg varchar(80) output) AS 
IF EXISTS(SELECT id FROM CRM_ShareInfo WHERE relateditemid = @crmId AND sharetype = 1 AND userid = @managerId) 
UPDATE CRM_ShareInfo SET sharelevel = 2 WHERE relateditemid = @crmId AND sharetype = 1 AND userid = @managerId 
ELSE INSERT INTO CRM_ShareInfo(relateditemid, sharetype, sharelevel, userid,contents) VALUES(@crmId, 1, 2, @managerId,@managerId)
GO
