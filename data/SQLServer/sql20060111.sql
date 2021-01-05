/*==============================目标绩效==============================*/
/*目标绩效*/
EXECUTE LMConfig_U_ByInfoInsert 1,NULL,2
GO
EXECUTE LMInfo_Insert 94,18027,NULL,NULL,1,NULL,2,9
GO
update LeftMenuInfo SET iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/KPI.gif' where id=94
GO
/*我的目标*/
EXECUTE LMConfig_U_ByInfoInsert 2,94,1
GO
EXECUTE LMInfo_Insert 95,18028,'/images_face/ecologyFace_2/LeftMenuIcon/MyKPI.gif','',2,94,1,9 
GO
/*我的考核*/
EXECUTE LMConfig_U_ByInfoInsert 2,94,0
GO
EXECUTE LMInfo_Insert 96,18029,'/images_face/ecologyFace_2/LeftMenuIcon/MyAssess.gif','',2,94,0,9 
GO
/*我的计划*/
EXECUTE LMConfig_U_ByInfoInsert 2,94,2
GO
EXECUTE LMInfo_Insert 97,2101,'/images_face/ecologyFace_2/LeftMenuIcon/MyPlan.gif','/workplan/data/WorkPlan.jsp',2,94,2,9 
GO
/*我的报告*/
EXECUTE LMConfig_U_ByInfoInsert 2,94,3
GO
EXECUTE LMInfo_Insert 98,6015,'/images_face/ecologyFace_2/LeftMenuIcon/MyReport.gif','',2,94,3,9 
GO
/*将我的日报...动态报告菜单移至我的报告下，更新为三级菜单*/
update leftMenuInfo set parentid=98 where id=62 or id=63 or id=64 or id=65 or id=66 or id=67
GO
update leftMenuInfo set menuLevel=3 where id=62 or id=63 or id=64 or id=65 or id=66 or id=67
GO
/*将新建计划...查询计划移至我的计划下，更新为三级菜单*/
update LeftMenuInfo Set parentId=97 where id=60 or id=59 or id=61
GO
update leftMenuInfo SET menuLevel=3 where id=60 or id=59 or id=61
GO
/*我的计划、我的报告为上级菜单，没有链接*/
UPDATE LeftMenuInfo SET linkAddress='javascript:void(0);' WHERE id=98 OR id=97
GO



/*==============================信息中心==============================*/
/*信息中心*/
EXECUTE LMConfig_U_ByInfoInsert 1,NULL,2
GO
EXECUTE LMInfo_Insert 111,18051,NULL,NULL,1,NULL,2,9
GO
UPDATE LeftMenuInfo SET iconurl='/images_face/ecologyFace_2/LeftMenuIcon/InformationCenter.gif' WHERE id=111
GO
/*我的收藏*/
EXECUTE LMConfig_U_ByInfoInsert 2,111,1
GO
EXECUTE LMInfo_Insert 116,18030,'/images_face/ecologyFace_2/LeftMenuIcon/MyFavourite.gif','javascript:void(0);',2,111,1,9 
GO
/*外部情报*/
EXECUTE LMConfig_U_ByInfoInsert 2,111,0
GO
EXECUTE LMInfo_Insert 117,18031,'/images_face/ecologyFace_2/LeftMenuIcon/OuterAdviced.gif','javascript:void(0);',2,111,0,9 
GO




/*==============================我的协助==============================*/
/*将原菜单名称改为我的协助*/
update LeftMenuInfo set labelid=18032 where id=80 or id=81
Go
/*新建协助*/
EXECUTE LMConfig_U_ByInfoInsert 2,80,1
GO
EXECUTE LMInfo_Insert 99,18034,'/images_face/ecologyFace_2/LeftMenuIcon/AddAssistance.gif','',2,80,1,9 
GO
/*新建协助菜单链接*/
UPDATE LeftmenuInfo SET linkAddress='/cowork/coworkview.jsp?flag=add' WHERE id=99
GO
EXECUTE LMConfig_U_ByInfoInsert 2,80,2
GO
EXECUTE LMInfo_Insert 100,18035,'/images_face/ecologyFace_2/LeftMenuIcon/SearchAssistance.gif','',2,80,2,9 
GO
/*查询协助菜单链接*/
UPDATE LeftmenuInfo SET linkAddress='/cowork/coworkview.jsp?flag=search' WHERE id=100
GO



/*==============================我的流程==============================*/
/*流程监控*/
EXECUTE LMConfig_U_ByInfoInsert 2,1,7
GO
EXECUTE LMInfo_Insert 101,16758,'/images_face/ecologyFace_2/LeftMenuIcon/WorkflowWatch.gif','',2,1,7,3 
GO
/*流程监控菜单路径*/
UPDATE LeftMenuInfo SET linkAddress='/system/systemmonitor/workflow/WorkflowMonitor.jsp' where id=101
GO



/*==============================我的知识==============================*/
/*文档监控*/
EXECUTE LMConfig_U_ByInfoInsert 2,2,13
GO
EXECUTE LMInfo_Insert 102,16757,'/images_face/ecologyFace_2/LeftMenuIcon/DocWatch.gif','',2,2,13,1 
GO
/*文档监控菜单链接*/
update leftmenuInfo set linkAddress='/system/systemmonitor/docs/DocMonitor.jsp' where id=102
GO
/*批量共享(doc)*/
EXECUTE LMConfig_U_ByInfoInsert 2,2,9
GO
EXECUTE LMInfo_Insert 112,18037,'/images_face/ecologyFace_2/LeftMenuIcon/DocBatchShare.gif','/docs/search/DocSearch.jsp?from=shareMutiDoc',2,2,9,1 
GO
/*移动复制(doc)*/
EXECUTE LMConfig_U_ByInfoInsert 2,2,11
GO
EXECUTE LMInfo_Insert 113,18052,'/images_face/ecologyFace_2/LeftMenuIcon/DocMoveCopy.gif','/docs/tools/DocCopyMove.jsp?Action=INPUT',2,2,11,1 
GO



/*==============================我的客户==============================*/
/*联系人查询*/
EXECUTE LMConfig_U_ByInfoInsert 2,3,8
GO
EXECUTE LMInfo_Insert 103,18036,'/images_face/ecologyFace_2/LeftMenuIcon/LinkmanSearch.gif','',2,3,8,4 
GO
/*联系人查询菜单路径*/
UPDATE LeftMenuInfo SET linkAddress='/CRM/search/ContacterSearch.jsp' where id=103
GO
/*批量共享*/
EXECUTE LMConfig_U_ByInfoInsert 2,3,12
GO
EXECUTE LMInfo_Insert 104,18037,'/images_face/ecologyFace_2/LeftMenuIcon/BatchShare.gif','',2,3,12,4 
GO
/*批量共享菜单路径*/
UPDATE LeftMenuInfo SET linkAddress='/CRM/search/SearchSimple.jsp?actionKey=batchShare' where id=104
GO
/*客户监控*/
EXECUTE LMConfig_U_ByInfoInsert 2,3,13
GO
EXECUTE LMInfo_Insert 105,17648,'/images_face/ecologyFace_2/LeftMenuIcon/CRMWatch.gif','',2,3,13,4 
GO
/*客户监控菜单路径*/
update leftmenuInfo set linkAddress='/system/systemmonitor/crm/CustomerMonitor.jsp' where id=105
go
/*客户导入*/
EXECUTE LMConfig_U_ByInfoInsert 2,3,14
GO
EXECUTE LMInfo_Insert 106,18038,'/images_face/ecologyFace_2/LeftMenuIcon/CRMImport.gif','',2,3,14,4 
GO
/*客户导入菜单路径*/
UPDATE LeftMenuInfo SET linkAddress='/CRM/CrmExcelToDB.jsp' where id=106
GO



/*==============================我的人事==============================*/


/*==============================我的项目==============================*/


/*==============================我的资产==============================*/


/*==============================我的会议==============================*/


/*==============================我的通信==============================*/
/*我的通信*/
EXECUTE LMConfig_U_ByInfoInsert 1,NULL,9
GO
EXECUTE LMInfo_Insert 107,18033,NULL,NULL,1,NULL,9,9
GO
UPDATE LeftMenuInfo SET iconurl='/images_face/ecologyFace_2/LeftMenuIcon/MyContact.gif' WHERE id=107
GO
/*我的邮件加入我的通信*/
update LeftMenuInfo SET parentId=107 where id=10
GO
update leftMenuInfo SET menuLevel=3 where parentId=10
GO

/*我的短信*/
Update LeftMenuInfo SET parentid=107 WHERE id=77
GO
UPDATE LeftMenuInfo SET iconurl='/images_face/ecologyFace_2/LeftMenuIcon/MyNote.gif' WHERE id=77
GO



/*==============================我的报表==============================*/
/* 我的报表 */
EXECUTE LMConfig_U_ByInfoInsert 1,NULL,12
GO
EXECUTE LMInfo_Insert 110,18040,NULL,NULL,1,NULL,12,9
GO





/**/
update leftmenuInfo set linkAddress='javascript:void(0)' where id=95 or id=96 or id=97 or id=98 or id=10 or id=108
GO
