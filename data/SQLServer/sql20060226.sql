CREATE PROCEDURE CRM_Share_WorkPlan_AllCheck (
@flag integer output , @msg varchar(80) output)
AS 
DECLARE @crmId_1 varchar(100)
DECLARE @m_workid int
DECLARE @m_userid int
DECLARE @m_usertype int
DECLARE crm_cursor CURSOR FOR
select id from CRM_CustomerInfo
OPEN crm_cursor
FETCH NEXT FROM crm_cursor INTO @crmId_1
WHILE (@@FETCH_STATUS = 0)
BEGIN
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
	FETCH NEXT FROM crm_cursor INTO @crmId_1
END
CLOSE crm_cursor
DEALLOCATE crm_cursor
GO

CRM_Share_WorkPlan_AllCheck '',''
GO

DROP PROCEDURE CRM_Share_WorkPlan_AllCheck
GO