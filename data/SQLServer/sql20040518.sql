/*
BUG 399 议程如果添加多个客户就不能被保存
增加一个字段存客户ID字符串 crmids
原来的crmid无用
*/
ALTER TABLE Meeting_topic 
	ADD crmids VARCHAR(4000) null
GO

/*BUG 399, crmid -> crmids,参数类型改为varchar(4000)*/
  ALTER  PROCEDURE Meeting_Topic_Insert (@meetingid [int] , @hrmid [int] , @subject [varchar](255) , 
@hrmids [varchar](255) , @projid int, @crmid  VARCHAR(4000), @isopen [tinyint],
 @flag integer output, @msg varchar(80) output) AS 

INSERT INTO [Meeting_Topic] ( [meetingid] ,[hrmid] ,[subject],[hrmids], [isopen],projid,crmids) 
VALUES ( @meetingid , @hrmid, @subject , @hrmids, @isopen,@projid,@crmid) 
set @flag = 1 set @msg = 'OK!' 
GO

ALTER  PROCEDURE Meeting_Topic_Update (@id    int, @hrmid [int] , @subject [varchar](255) , 
@hrmids [varchar](255) , @projid int, @crmid  VARCHAR(4000), @isopen [tinyint], @flag integer output, @msg varchar(80) output) 
AS 
update [Meeting_Topic] set hrmid=@hrmid ,subject=@subject,hrmids=@hrmids,projid=@projid,crmids=@crmid,isopen=@isopen where id=@id set @flag = 1 set @msg = 'OK!' 
GO
