alter PROCEDURE SystemSet_DftSCUpdate(
	@dftsubcomid int ,
	@flag int output , 
	@msg varchar(80) output) 
AS 

update HrmRoles set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)
update workflow_formdict set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)
update workflow_formdictdetail set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)
update workflow_formbase set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)
update workflow_base set subcompanyid=@dftsubcomid where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 or subcompanyid not in (select id from hrmsubcompany)
GO

INSERT INTO HtmlNoteIndex values(88,'无法删除：分部已在角色中使用！') 
GO
INSERT INTO HtmlNoteInfo VALUES(88,'无法删除：分部已在角色中使用！',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(88,'Unable to delete:Used in roles!',8) 
GO

INSERT INTO HtmlNoteIndex values(89,'默认分部无法被删除！') 
GO
INSERT INTO HtmlNoteInfo VALUES(89,'默认分部无法被删除！',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(89,'Default subcompany can not be deleted!',8) 
GO
