alter procedure [CRM_ShareByHrm_WorkPlan] ( @crmId_1 varchar(4000), @userId_1 int, @flag integer output , @msg varchar(4000) output) AS DECLARE @m_workid int DECLARE all_cursor CURSOR FOR SELECT id FROM WorkPlan WHERE type_n = '3' AND (','+crmid+',') LIKE ('%,'+@crmId_1+',%') OPEN all_cursor FETCH NEXT FROM all_cursor INTO @m_workid WHILE (@@FETCH_STATUS = 0) BEGIN IF NOT EXISTS (SELECT workid FROM WorkPlanShareDetail WHERE workid = @m_workid AND userid = @userId_1 AND usertype = 1) INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel , sharetype , objid) VALUES ( @m_workid, @userId_1, 1, 0 , 1 , @userId_1) FETCH NEXT FROM all_cursor INTO @m_workid END CLOSE all_cursor DEALLOCATE all_cursor
GO
alter procedure [WorkPlanShare_Insert] ( @workid_1 [int]  , @userid_1 [int]   , @usertype_1 [int]   , @sharelevel_1 [int]   , @flag integer output, @msg varchar(4000) output)  AS  INSERT INTO [WorkPlanShareDetail] (workid , userid , usertype , sharelevel , sharetype , objid) VALUES (@workid_1 , @userid_1 , @usertype_1 , @sharelevel_1 , 1 , @userid_1)
GO
