alter PROCEDURE SystemSet_DftSCUpdate(
	@dftsubcomid int ,
	@flag int output , 
	@msg varchar(80) output) 
AS 

update HrmRoles set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1
update workflow_formdict set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1
update workflow_formdictdetail set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1
update workflow_formbase set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1
update workflow_base set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1

GO

ALTER TABLE HrmOtherSettings ADD   needvalidate int
GO
ALTER TABLE HrmOtherSettings ADD   validatetype int
GO
ALTER TABLE HrmOtherSettings ADD   validatenum int
GO
update HrmOtherSettings set needvalidate=0
GO

insert into ErrorMsgIndex(id,indexdesc) values(52,'验证码错误')
GO
insert into ErrorMsgInfo(indexid,msgname,languageid) values(52,'验证码错误',7)
GO
insert into ErrorMsgInfo(indexid,msgname,languageid) values(52,'Validate code is not true',8)
GO