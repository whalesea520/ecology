ALTER PROCEDURE SystemSet_DftSCUpdate
(
	@dftsubcomid int ,
	@flag int output , 
	@msg varchar(80) output
) 
AS 

UPDATE MeetingRoom 
SET subcompanyId = @dftsubcomid 
WHERE subcompanyId IS null 
OR subcompanyId = 0 
OR subcompanyId = -1 
OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany)

UPDATE Meeting_Type 
SET subcompanyId = @dftsubcomid 
WHERE subcompanyId IS null 
OR subcompanyId = 0 
OR subcompanyId = -1 
OR subcompanyid NOT IN (SELECT id FROM hrmSubcompany)


update HrmRoles 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_formdict 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_formdictdetail 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_formbase 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)

update workflow_base 
set subcompanyid=@dftsubcomid 
where subcompanyid is null or subcompanyid=0 or subcompanyid=-1 
or subcompanyid not in (select id from hrmsubcompany)
GO

