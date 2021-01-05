alter PROCEDURE CRM_Share_WorkPlan (
@crmId_1 varchar(100), @flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_workid int
DECLARE @m_userid int
DECLARE @m_usertype int
DECLARE all_cursor CURSOR FOR
SELECT id FROM WorkPlan WHERE type_n = '3' AND (','+crmid+',') LIKE ('%,'+@crmId_1+',%')
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_workid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
DECLARE m_cursor CURSOR FOR
SELECT userid, usertype FROM CrmShareDetail WHERE crmid = @crmId_1
OPEN m_cursor
FETCH NEXT FROM m_cursor INTO @m_userid, @m_usertype
WHILE (@@FETCH_STATUS = 0)
BEGIN
IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @m_workid 
AND userid = @m_userid AND usertype = @m_usertype)
INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
@m_workid, @m_userid, @m_usertype, 0)
FETCH NEXT FROM m_cursor INTO @m_userid, @m_usertype
END
CLOSE m_cursor 
DEALLOCATE m_cursor
FETCH NEXT FROM all_cursor INTO @m_workid
END
CLOSE all_cursor 
DEALLOCATE all_cursor

GO


alter PROCEDURE CRM_ShareByHrm_WorkPlan (
@crmId_1 int, @userId_1 int, @flag integer output , @msg varchar(80) output)
AS 
DECLARE @m_workid int
DECLARE all_cursor CURSOR FOR
SELECT id FROM WorkPlan WHERE type_n = '3' AND (','+crmid+',') LIKE ('%,'+@crmId_1+',%')
OPEN all_cursor 
FETCH NEXT FROM all_cursor INTO @m_workid
WHILE (@@FETCH_STATUS = 0)
BEGIN 
IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @m_workid 
AND userid = @userId_1 AND usertype = 1)
INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
@m_workid, @userId_1, 1, 0)
FETCH NEXT FROM all_cursor INTO @m_workid
END
CLOSE all_cursor 
DEALLOCATE all_cursor

GO
