/* 左侧菜单自定义信息 顶级菜单
   我的流程，我的知识，我的客户，我的项目，我的人事，我的会议，我的资产，我的计划，我的报告，我的邮件，我的短信
 */
INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (1,16391,1,1,3)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (2,16394,1,2,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (3,6059,1,3,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (4,1211,1,4,5)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (5,16414,1,5,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (6,2102,1,6,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (7,1209,1,7,7)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (8,2101,1,8,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (9,6015,1,9,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (10,1213,1,10,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,menuLevel,defaultIndex,relatedModuleId) VALUES (11,16443,1,11,9)
GO

/*我的流程 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (12,16392,'/images_face/ecologyFace_1/LeftMenuIcon/WF_1.gif','/workflow/request/RequestType.jsp',2,1,1,3)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (13,1207,'/images_face/ecologyFace_1/LeftMenuIcon/WF_2.gif','/workflow/request/RequestView.jsp',2,1,2,3)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (14,1210,'/images_face/ecologyFace_1/LeftMenuIcon/WF_3.gif','/workflow/request/MyRequestView.jsp',2,1,3,3)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (15,16393,'/images_face/ecologyFace_1/LeftMenuIcon/WF_4.gif','/workflow/search/WFSearch.jsp',2,1,4,3)
GO

/*我的知识 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (16,1986,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_1.gif','/docs/docs/DocList.jsp?isuserdefault=1',2,2,1,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (17,1212,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/docs/search/DocView.jsp',2,2,2,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (18,16395,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_3.gif','javascript:nullLink()',2,2,3,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (19,2069,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_4.gif','/docs/docs/ApproveDocList.jsp',2,2,4,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (20,16396,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_5.gif','/docs/docs/DocShareView.jsp',2,2,5,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (21,16397,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_6.gif','/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=1&containreply=1',2,2,6,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (22,16398,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_7.gif','/docs/search/DocSummary.jsp',2,2,7,1)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (23,16399,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_8.gif','/docs/search/DocSearch.jsp',2,2,8,1)
GO

/*我的客户 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (24,15006,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_1.gif','/CRM/data/AddCustomerExist.jsp',2,3,1,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (25,16400,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_2.gif','/CRM/data/NewCustomerList.jsp',2,3,2,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (26,16401,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_3.gif','/CRM/search/CRMCategory.jsp',2,3,3,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (27,16402,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_4.gif','/CRM/report/CRMContactLogRp.jsp?finished=0',2,3,4,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (28,16403,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_5.gif','/CRM/data/CRMContactRemind.jsp',2,3,5,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (29,2227,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_6.gif','/CRM/sellchance/SellChanceReport.jsp',2,3,6,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (30,16404,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_7.gif','/CRM/report/ContractReport.jsp',2,3,7,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (31,6073,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_8.gif','/CRM/report/CRMEvaluationRp.jsp',2,3,8,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (32,16405,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_9.gif','/CRM/report/CRMContactLogRp.jsp',2,3,9,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (33,16406,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_10.gif','/CRM/data/ApproveCustomerList.jsp',2,3,10,4)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (34,16407,'/images_face/ecologyFace_1/LeftMenuIcon/CRM_11.gif','/CRM/search/SearchSimple.jsp?actionKey=common',2,3,11,4)
GO


/*我的项目 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (35,15007,'/images_face/ecologyFace_1/LeftMenuIcon/PROJ_1.gif','/proj/data/AddProject.jsp',2,4,1,5)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (36,16408,'/images_face/ecologyFace_1/LeftMenuIcon/PROJ_2.gif','/proj/data/MyProject.jsp',2,4,2,5)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (37,16409,'/images_face/ecologyFace_1/LeftMenuIcon/PROJ_3.gif','/proj/data/ProjectApproval.jsp',2,4,3,5)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (38,16410,'/images_face/ecologyFace_1/LeftMenuIcon/PROJ_4.gif','/proj/process/ProjectTaskApproval.jsp',2,4,4,5)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (39,16411,'/images_face/ecologyFace_1/LeftMenuIcon/PROJ_5.gif','/proj/data/CurrentTask.jsp',2,4,5,5)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (40,16412,'/images_face/ecologyFace_1/LeftMenuIcon/PROJ_6.gif','/proj/data/OverdueTask.jsp',2,4,6,5)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (41,16413,'/images_face/ecologyFace_1/LeftMenuIcon/PROJ_7.gif','/proj/search/Search.jsp',2,4,7,5)
GO


/*我的人事 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (42,15005,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_1.gif','/hrm/resource/HrmResourceAdd.jsp',2,5,1,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (43,16415,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_2.gif','/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>',2,5,2,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (44,15089,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_3.gif','/hrm/search/HrmResourceView.jsp?id=<%=user.getUID()%>',2,5,3,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (45,15916,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_4.gif','/hrm/resource/HrmResourceTrainRecord.jsp?resourceid=<%=user.getUID()%>',2,5,4,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (46,6156,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_5.gif','/hrm/resource/HrmResourceTrainRecord.jsp?resourceid=<%=user.getUID()%>',2,5,5,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (47,16416,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_6.gif','/hrm/resource/HrmResourceFinanceView.jsp?id=<%=user.getUID()%>&isView=1',2,5,6,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (48,16417,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_7.gif','/hrm/resource/HrmResourceRewardsRecord.jsp?resourceid=<%=user.getUID()%>',2,5,7,2)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (49,16418,'/images_face/ecologyFace_1/LeftMenuIcon/HRM_8.gif','/hrm/search/HrmResourceSearch.jsp',2,5,8,2)
GO

/*我的会议 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (50,15008,'/images_face/ecologyFace_1/LeftMenuIcon/MEET_1.gif','/meeting/data/AddMeeting.jsp',2,6,1,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (51,16419,'/images_face/ecologyFace_1/LeftMenuIcon/MEET_2.gif','/meeting/data/MeetingApproval.jsp',2,6,2,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (52,16420,'/images_face/ecologyFace_1/LeftMenuIcon/MEET_3.gif','/meeting/data/NewMeetings.jsp',2,6,3,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (53,16421,'/images_face/ecologyFace_1/LeftMenuIcon/MEET_4.gif','/meeting/data/OldMeetings.jsp',2,6,4,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (54,16423,'/images_face/ecologyFace_1/LeftMenuIcon/MEET_6.gif','/meeting/report/MeetingRoomPlan.jsp',2,6,5,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (55,16424,'/images_face/ecologyFace_1/LeftMenuIcon/MEET_7.gif','/meeting/search/Search.jsp',2,6,6,9)
GO



/*我的资产 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (56,16509,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_1.gif','/cpt/capital/CptCapitalAdd.jsp',2,7,1,7)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (57,1209,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_2.gif','/cpt/search/CptMyCapital.jsp?addorsub=3',2,7,2,7)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (58,16425,'/images_face/ecologyFace_1/LeftMenuIcon/CPT_3.gif','/cpt/search/CptSearch.jsp?isdata=2',2,7,3,7)
GO


/*我的计划 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (59,16426,'/images_face/ecologyFace_1/LeftMenuIcon/PLAN_1.gif','/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>&add=1',2,8,1,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (60,2101,'/images_face/ecologyFace_1/LeftMenuIcon/PLAN_1.gif','/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>',2,8,2,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (61,16427,'/images_face/ecologyFace_1/LeftMenuIcon/PLAN_1.gif','/workplan/search/WorkPlanSearchTerm.jsp',2,8,3,9)
GO



/*我的报告 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (62,16428,'/images_face/ecologyFace_1/LeftMenuIcon/REPORT_1.gif','/workplan/report/WorkPlanReport.jsp?type=1',2,9,1,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (63,16429,'/images_face/ecologyFace_1/LeftMenuIcon/REPORT_2.gif','/workplan/report/WorkPlanReport.jsp?type=2',2,9,2,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (64,16430,'/images_face/ecologyFace_1/LeftMenuIcon/REPORT_3.gif','/workplan/report/WorkPlanReport.jsp?type=3',2,9,3,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (65,16431,'/images_face/ecologyFace_1/LeftMenuIcon/REPORT_4.gif','/workplan/report/WorkPlanReport.jsp?type=4',2,9,4,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (66,16432,'/images_face/ecologyFace_1/LeftMenuIcon/REPORT_5.gif','/workplan/report/WorkPlanReport.jsp?type=5',2,9,5,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (67,16433,'/images_face/ecologyFace_1/LeftMenuIcon/REPORT_6.gif','/workplan/report/WorkPlanReport.jsp?type=6',2,9,6,9)
GO


/*我的邮件 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (68,2029,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_1.gif','/email/WeavermailAdd.jsp',2,10,1,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (69,16435,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_2.gif','/email/Weavermail.jsp',2,10,2,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (70,16436,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_3.gif','/email/WeavermailLocation.jsp?mailtype=1',2,10,3,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (71,16437,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_4.gif','/email/WeavermailLocation.jsp?mailtype=2',2,10,4,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (72,16438,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_5.gif','/email/WeavermailLocation.jsp?mailtype=3',2,10,5,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (73,16439,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_6.gif','/email/WeavermailLocation.jsp?mailtype=0',2,10,6,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (74,16440,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_7.gif','javascript:nullLink()',2,10,7,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (75,16441,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_8.gif','/sendmail/SendMailPlanSearch.jsp',2,10,8,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (76,16442,'/images_face/ecologyFace_1/LeftMenuIcon/MAIL_9.gif','/system/SystemSetEdit.jsp',2,10,9,9)
GO


/*我的短信 子菜单 */
INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (77,16443,'/images_face/ecologyFace_1/LeftMenuIcon/MESSAGE_1.gif','/sms/ViewMessage.jsp',2,11,1,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (78,16444,'/images_face/ecologyFace_1/LeftMenuIcon/MESSAGE_2.gif','/sms/SmsMessageEdit.jsp',2,11,2,9)
GO

INSERT INTO LeftMenuInfo (id,labelId,iconUrl,linkAddress,menuLevel,parentId,defaultIndex,relatedModuleId) VALUES (79,16891,'/images_face/ecologyFace_1/LeftMenuIcon/MESSAGE_3.gif','/sms/SmsManage.jsp',2,11,3,9)
GO

/*初始化每个用户的左侧菜单配置*/
CREATE PROCEDURE LeftMenuConfig_Insert_All(
    @flag	int	output, 
    @msg	varchar(80)	output) 
AS
DECLARE @id_1 int,
        @defaultIndex_1 int,
        @userId int

    DECLARE leftMenuInfo_cursor CURSOR FOR
    SELECT id, defaultIndex FROM LeftMenuInfo

    OPEN leftMenuInfo_cursor
    FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1

    /*系统管理员*/
    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(1,@id_1,1,@defaultIndex_1)
        FETCH NEXT FROM leftMenuInfo_cursor INTO @id_1,@defaultIndex_1
        
    END

    CLOSE leftMenuInfo_cursor
    DEALLOCATE leftMenuInfo_cursor

    /*用户*/
    DECLARE hrmResource_cursor CURSOR FOR
    SELECT id FROM HrmResource order by id

    OPEN hrmResource_cursor
    FETCH NEXT FROM hrmResource_cursor INTO @userId

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE leftMenuInfo_cursor_1 CURSOR FOR
        SELECT id, defaultIndex FROM LeftMenuInfo
        
        OPEN leftMenuInfo_cursor_1
        FETCH NEXT FROM leftMenuInfo_cursor_1 INTO @id_1,@defaultIndex_1

        WHILE @@FETCH_STATUS = 0
        BEGIN
            INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(@userId,@id_1,1,@defaultIndex_1)
            FETCH NEXT FROM leftMenuInfo_cursor_1 INTO @id_1,@defaultIndex_1
        END

        CLOSE leftMenuInfo_cursor_1
        DEALLOCATE leftMenuInfo_cursor_1
        
        FETCH NEXT FROM hrmResource_cursor INTO @userId
    END
    CLOSE hrmResource_cursor
    DEALLOCATE hrmResource_cursor

GO

/*执行 LeftMenuConfig_Insert_All 的存储过程*/
EXEC LeftMenuConfig_Insert_All '',''

GO
