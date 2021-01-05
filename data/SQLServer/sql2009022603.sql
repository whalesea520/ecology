alter PROCEDURE CRM_ShareByHrm_WorkPlan (
@crmId_1 varchar(100), @userId_1 int, @flag integer output , @msg varchar(80) output)
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
