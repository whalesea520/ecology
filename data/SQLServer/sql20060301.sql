
ALTER TABLE Prj_Template ADD status CHAR(1)
GO

UPDATE Prj_Template SET status='1'
GO



CREATE table ProjTemplateMaint(
     id int IDENTITY (1, 1) NOT NULL ,
     isNeedAppr char(1), /*0:不需要审批 1：需要审批*/
     wfid int
)
GO

INSERT INTO  ProjTemplateMaint (isNeedAppr) VALUES ('0')
GO



CREATE TABLE BillProjTemplateApprove ( 
    id int IDENTITY,
    projTemplateId int,
    requestid int) 
GO
INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(152,18374,'BillProjTemplateApprove','','','','','','BillProjTemplateApproveOperation.jsp') 
GO
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (152,'projTemplateId',18375,'int',3,0,0,0)
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 129,18375,'int','/systeminfo/BrowserMain.jsp?url=/proj/Templet/TempletBrowser.jsp','Prj_Template','templetName','id','/proj/Templet/ProjTempletView.jsp?templetId=')
GO
update workflow_billfield set type=129 where billid=152
GO



INSERT INTO HtmlLabelIndex values(18374,'项目模板审批') 
GO
INSERT INTO HtmlLabelIndex values(18375,'项目模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(18374,'项目模板审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18375,'项目模板',7) 
GO

INSERT INTO HtmlLabelIndex values(18392,'项目模板审批流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(18392,'项目模板审批流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18392,'Project Template Approve Workflow',8) 
GO

INSERT INTO HtmlLabelIndex values(18371,'模板审批设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(18371,'模板审批设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18371,'Project Template Approvement',8) 
GO

INSERT INTO HtmlLabelIndex values(18393,'是否需要审批') 
GO
INSERT INTO HtmlLabelInfo VALUES(18393,'是否需要审批',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18393,'if it need approve',8) 
GO

INSERT INTO HtmlLabelIndex values(18043,'审批流程关联') 
GO
INSERT INTO HtmlLabelInfo VALUES(18043,'审批流程关联',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18043,'CHECKFLOWCONNECTION',8) 
GO

EXECUTE MMConfig_U_ByInfoInsert 379,3
GO
EXECUTE MMInfo_Insert 466,18371,'模板审批设置','/proj/Templet/TempletSetting.jsp','mainFrame',379,2,3,0,'',0,'',0,'','',0,'','',5
GO



insert into SystemRights (id,rightdesc,righttype) values (638,'项目模板审批设置权限维护','6') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (638,8,'ProjTemplateSettingMaint','Project Template Setting Maint') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (638,7,'项目模板审批设置权限维护','项目模板审批设置权限维护') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4138,'项目模板审批设置权限维护','projTemplateSetting:Maint',638) 
GO




ALTER PROCEDURE Prj_SaveAsTemplet (
	/*ProjectBaseInfo*/
	@isSelected	char(1),
	@templetName 	varchar(50),
	@proTypeId	int,
	@workTypeId	int,
	@proMember	varchar(500),
	@isMemberSee	char(1),
	@proCrm		varchar(500),
	@isCrmSee	char(1),
	@parentProId	int,
	@commentDoc	int,
	@confirmDoc	int,
	@adviceDoc	int,
	@Manager	int,
    @relationXml	text,
    	@status		char(1),

	/*ProjectFreeField*/
	@datefield1_39 	varchar(10),
	@datefield2_40 	varchar(10), 
	@datefield3_41 	varchar(10), 
	@datefield4_42 	varchar(10), 
	@datefield5_43 	varchar(10), 
	@numberfield1_44 	float, 
	@numberfield2_45 	float,
	@numberfield3_46 	float, 
	@numberfield4_47 	float, 
	@numberfield5_48 	float, 
	@textfield1_49 	varchar(100),
	@textfield2_50 	varchar(100), 
	@textfield3_51 	varchar(100),
	@textfield4_52 	varchar(100), 
	@textfield5_53 	varchar(100), 
	@boolfield1_54 	tinyint, 
	@boolfield2_55 	tinyint, 
	@boolfield3_56 	tinyint, 
	@boolfield4_57 	tinyint, 
	@boolfield5_58 	tinyint,

	@flag	int	output, 
	@msg	varchar(80)	output)
AS INSERT INTO Prj_Template (
	/*ProjectBaseInfo*/
	isSelected, 
	templetName, 
	proTypeId, 
	workTypeId, 
	proMember, 
	isMemberSee, 
	proCrm, 
	isCrmSee, 
	parentProId, 
	commentDoc,
	confirmDoc,
	adviceDoc,
	Manager,
    relationXml,
	status,
	
	/*ProjectFreeField*/
	datefield1, datefield2, datefield3, datefield4, datefield5,
  	numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, 
	textfield1, textfield2, textfield3,textfield4, textfield5, 
	tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5
)VALUES( 
	/*ProjectBaseInfo*/
	@isSelected	,
	@templetName 	,
	@proTypeId	,
	@workTypeId	,
	@proMember	,
	@isMemberSee	,
	@proCrm		,
	@isCrmSee	,
	@parentProId	,
	@commentDoc	,
	@confirmDoc	,
	@adviceDoc	,
	@Manager	,
    @relationXml,
	@status,

	/*ProjectFreeField*/
	@datefield1_39, @datefield2_40, @datefield3_41, @datefield4_42, @datefield5_43, 
	@numberfield1_44, @numberfield2_45, @numberfield3_46, @numberfield4_47, @numberfield5_48, 
	@textfield1_49, @textfield2_50, @textfield3_51, @textfield4_52, @textfield5_53, 
	@boolfield1_54, @boolfield2_55, @boolfield3_56, @boolfield4_57, @boolfield5_58
)

set @flag = @@identity
GO
INSERT INTO HtmlLabelIndex values(18396,'项目模板审批单') 
GO
INSERT INTO HtmlLabelInfo VALUES(18396,'项目模板审批单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18396,'Project Template Approve Bill',8) 
GO

UPDATE workflow_bill SET namelabel=18396 WHERE id=152
GO


INSERT INTO HtmlLabelIndex values(18394,'已完成项目管理权限设置') 
GO
INSERT INTO HtmlLabelIndex values(18395,'项目审批权限维护') 
GO
INSERT INTO HtmlLabelInfo VALUES(18394,'已完成项目管理权限设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18394,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18395,'项目审批权限维护',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18395,'',8) 
GO