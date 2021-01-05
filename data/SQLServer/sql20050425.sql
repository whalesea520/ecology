/*菜单自定义 label*/
INSERT INTO HtmlLabelIndex values(17721,'菜单自定义') 
GO
INSERT INTO HtmlLabelInfo VALUES(17721,'菜单自定义',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17721,'custom menu',8) 
GO

/*短语设置 label*/
INSERT INTO HtmlLabelIndex values(17722,'短语设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17722,'短语设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17722,'SysPhrase setting',8) 
GO

/*协作区设置 label*/
INSERT INTO HtmlLabelIndex values(17717,'协作区设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17717,'协作区设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17717,'Cowork set',8) 
GO

/*协作区管理 label*/
INSERT INTO HtmlLabelIndex values(17718,'协作区管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(17718,'协作区管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17718,'Cowork Management',8) 
GO

/*我的协作 label*/
INSERT INTO HtmlLabelIndex values(17716,'我的协作') 
GO
INSERT INTO HtmlLabelInfo VALUES(17716,'我的协作',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17716,'My cowork',8) 
GO

/*订阅历史 label*/
INSERT INTO HtmlLabelIndex values(17713,'订阅历史') 
GO
INSERT INTO HtmlLabelInfo VALUES(17713,'订阅历史',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17713,'Sub History',8) 
GO

/*订阅批准 label*/
INSERT INTO HtmlLabelIndex values(17714,'订阅批准') 
GO
INSERT INTO HtmlLabelInfo VALUES(17714,'订阅批准',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17714,'Sub Approve',8) 
GO

/*订阅收回 label*/
INSERT INTO HtmlLabelIndex values(17715,'订阅收回') 
GO
INSERT INTO HtmlLabelInfo VALUES(17715,'订阅收回',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17715,'Subscribe Reback',8) 
GO

/*流程代理 label*/
INSERT INTO HtmlLabelIndex values(17723,'流程代理') 
GO
INSERT INTO HtmlLabelInfo VALUES(17723,'流程代理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17723,'workflow agent',8) 
GO

/*上方的个人文档要调整消失 先在(11)上查询到个人文档菜单的id 或者用SQL在mainmenuinfo中查找 个人文档的id 是 25 更新 MainMenuInfo 中个人文档菜单的所属模块id 是不发布模块的id 11 */
UPDATE MainMenuInfo SET relatedModuleId = 11 WHERE id = 25
GO

/*人力资源的自定义组(私人组)去掉 先在(11)上查询到私人组菜单的id 或者用SQL在mainmenuinfo中查找 私人组的id 是 53 更新 MainMenuInfo 中私人组菜单的所属模块id 是不发布模块的id 11 */
UPDATE MainMenuInfo SET relatedModuleId = 11 WHERE id = 53
GO

/*知识文档的用户自定义也去掉 先在(11)上查询到知识文档的用户自定义菜单的id 或者用SQL在mainmenuinfo中查找 知识文档的用户自定义的id 是 16 更新 MainMenuInfo 中知识文档的用户自定义菜单的所属模块id 是不发布模块的id 11 */
UPDATE MainMenuInfo SET relatedModuleId = 11 WHERE id = 16
GO

/*工作流程的用户定义、短语设置、以及流程代理全部去掉*/
UPDATE MainMenuInfo SET relatedModuleId = 11 WHERE id = 124 or id = 126 or id = 127
GO

/*增加 协作区设置 菜单*/
EXECUTE MainMenuConfig_U_ByInfoInsert 11,7,'',''
GO
EXECUTE MainMenuInfo_Insert 359,17717,'','','mainFrame',11,1,7,0,'',0,'',0,'','',0,'','',10,'',''
GO

/*增加 类别设置 菜单*/
EXECUTE MainMenuConfig_U_ByInfoInsert 364,1,'',''
GO
EXECUTE MainMenuInfo_Insert 360,16493,'','/cowork/type/CoworkMainType.jsp','mainFrame',359,2,1,0,'',0,'',0,'','',0,'','',10,'',''
GO

/*增加 协作区管理 菜单*/
EXECUTE MainMenuConfig_U_ByInfoInsert 364,2,'',''
GO
EXECUTE MainMenuInfo_Insert 361,17718,'','/cowork/type/CoworkType.jsp','mainFrame',359,2,2,0,'',0,'',0,'','',0,'','',10,'',''
GO

/*左侧菜单增加 协作区 一级菜单*/
EXECUTE LeftMenuConfig_U_ByInfoInsert 1,NULL,1,'',''
GO
EXECUTE LeftMenuInfo_Insert 80,17694,NULL,NULL,1,NULL,1,10,'',''
GO

/*左侧菜单 协作区 一级菜单 中 增加 我的协作 现在菜单 id 不统一 要注意*/
EXECUTE LeftMenuConfig_U_ByInfoInsert 2,80,0,'',''
GO
EXECUTE LeftMenuInfo_Insert 81,17716,'/images_face/ecologyFace_1/LeftMenuIcon/WF_1.gif','/cowork/coworkview.jsp',2,80,0,9,'', '' 
GO

/*左侧菜单 我的知识 增加 个人文档*/
EXECUTE LeftMenuConfig_U_ByInfoInsert 2,2,3,'',''
GO
EXECUTE LeftMenuInfo_Insert 82,17600,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_2.gif','/docs/docs/PersonalDocMain.jsp',2,2,3,9,'', '' 
GO

/*左侧菜单 我的知识 增加 订阅历史*/
EXECUTE LeftMenuConfig_U_ByInfoInsert 2,2,4,'',''
GO
EXECUTE LeftMenuInfo_Insert 83,17713,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_3.gif','/docs/docsubscribe/DocSubscribeHistory.jsp',2,2,4,9,'', '' 
GO

/*左侧菜单 我的知识 增加 订阅批准*/
EXECUTE LeftMenuConfig_U_ByInfoInsert 2,2,5,'',''
GO
EXECUTE LeftMenuInfo_Insert 84,17714,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_3.gif','/docs/docsubscribe/DocSubscribeApprove.jsp',2,2,5,9,'', '' 
GO

/*左侧菜单 我的知识 增加 订阅收回*/
EXECUTE LeftMenuConfig_U_ByInfoInsert 2,2,6,'',''
GO
EXECUTE LeftMenuInfo_Insert 85,17715,'/images_face/ecologyFace_1/LeftMenuIcon/DOC_3.gif','/docs/docsubscribe/DocSubscribeBack.jsp',2,2,6,9,'', '' 
GO

/*左侧菜单 我的知识 去掉订阅知识 先在(11)上查询到订阅知识菜单的id 或者用SQL在leftmenuinfo中查找 订阅知识的id 是 18 更新 LeftMenuInfo 中订阅知识菜单的所属模块id 是不发布模块的id 11 */
UPDATE LeftMenuInfo SET relatedModuleId = 11 WHERE id = 18
GO

/*左侧菜单 我的流程 增加 流程代理*/
EXECUTE LeftMenuConfig_U_ByInfoInsert 2,1,4,'',''
GO
EXECUTE LeftMenuInfo_Insert 86,17723,'/images_face/ecologyFace_1/LeftMenuIcon/PLAN_3.gif','/workflow/workflow/WfAgentList.jsp',2,1,4,3,'', '' 
GO

/*上方菜单将工作流程调整到知识文档前边*/
UPDATE MainMenuInfo set defaultIndex = 3 where id = 2
GO
UPDATE MainMenuInfo set defaultIndex = 4 where id = 3
GO
UPDATE MainMenuInfo set defaultIndex = 2 where id = 4
GO

/*左侧的顺序调整为：
协作区、我的流程、我的知识、我的人事、我的客户、我的项目、我的资产、
我的会议、我的计划、我的报告、我的邮件、我的短信*/
UPDATE LeftMenuInfo set defaultIndex = 4 where id = 5
GO
UPDATE LeftMenuInfo set defaultIndex = 5 where id = 3
GO
UPDATE LeftMenuInfo set defaultIndex = 6 where id = 4
GO
UPDATE LeftMenuInfo set defaultIndex = 7 where id = 7
GO
DROP TABLE LeftMenuConfig
GO
CREATE TABLE LeftMenuConfig ( 
    id int NOT NULL IDENTITY (1, 1),
    userId int,
    infoId int,
    visible char(1),
    viewIndex int) 
GO

/*执行 LeftMenuConfig_Insert_All 的存储过程*/
EXEC LeftMenuConfig_Insert_All '',''

GO

/*上方的菜单的报表中心顺序调整为：
流程报表、知识报表、人事报表，工资报表调整到人事报表下边。
客户报表、项目报表、财务报表、资产报表、数据中心、会议报表、短信报表和登录日志*/
UPDATE MainMenuInfo SET defaultIndex = 1 WHERE id = 203
GO
UPDATE MainMenuInfo SET defaultIndex = 2 WHERE id = 207
GO
UPDATE MainMenuInfo SET defaultIndex = 3 WHERE id = 200
GO
UPDATE MainMenuInfo SET defaultIndex = 4 WHERE id = 204
GO
UPDATE MainMenuInfo SET defaultIndex = 5 WHERE id = 202
GO
UPDATE MainMenuInfo SET defaultIndex = 6 WHERE id = 205
GO
UPDATE MainMenuInfo SET defaultIndex = 7 WHERE id = 206
GO
UPDATE MainMenuInfo SET defaultIndex = 8 WHERE id = 209
GO
UPDATE MainMenuInfo SET defaultIndex = 9 WHERE id = 208
GO
UPDATE MainMenuInfo SET defaultIndex = 10 WHERE id = 210
GO
UPDATE MainMenuInfo SET defaultIndex = 11 WHERE id = 211
GO

UPDATE MainMenuInfo SET defaultParentId = 200 ,defaultIndex = 12 ,defaultLevel = 2 WHERE id = 201
GO
UPDATE MainMenuInfo SET defaultLevel = 3 WHERE defaultparentid = 201
GO

DROP TABLE MainMenuConfig 
GO

CREATE TABLE MainMenuConfig ( 
    id int NOT NULL IDENTITY (1, 1),
    userId int,
    infoId int,
    visible char(1),
    parentId int,
    viewIndex int,
    menuLevel int) 
GO

EXEC MainMenuConfig_Insert_All

GO

/*主菜单 增加 客户监控、客户资料Excel导入*/
EXECUTE MainMenuConfig_U_ByInfoInsert 5,9,'',''
GO
EXECUTE MainMenuInfo_Insert 362,17648,'','/system/systemmonitor/crm/CustomerMonitor.jsp','mainFrame',5,1,9,0,'',0,'',0,'','',0,'','',4,'',''
GO

EXECUTE MainMenuConfig_U_ByInfoInsert 5,10,'',''
GO
EXECUTE MainMenuInfo_Insert 363,17678,'','/CRM/CrmExcelToDB.jsp','mainFrame',5,1,10,0,'',0,'',0,'','',0,'','',4,'',''
GO
