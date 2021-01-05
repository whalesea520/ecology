ALTER TABLE Prj_Template ADD status CHAR(1)
/

UPDATE Prj_Template SET status='1'
/

CREATE table ProjTemplateMaint(
     id integer NOT NULL ,
     isNeedAppr char(1), /*0:不需要审批 1：需要审批*/
     wfid integer
)
/
create sequence PjTempMaint_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger PjTempMaint_Trigger
before insert on ProjTemplateMaint
for each row
begin
select PjTempMaint_id.nextval into :new.id from dual;
end;
/

INSERT INTO  ProjTemplateMaint (isNeedAppr) VALUES ('0')
/

CREATE TABLE BillProjTemplateApprove( 
    id integer ,
    projTemplateId integer,
    requestid integer) 
/
create sequence BProjTempApprove_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger BProjTempApprove_Trigger
before insert on BillProjTemplateApprove
for each row
begin
select BProjTempApprove_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_bill ( id, namelabel, tablename, createpage, managepage, viewpage, detailtablename, detailkeyfield,operationpage) VALUES(152,18374,'BillProjTemplateApprove','','','','','','BillProjTemplateApproveOperation.jsp') 
/
INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (152,'projTemplateId',18375,'integer',3,0,0,0)
/
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 129,18375,'integer','/systeminfo/BrowserMain.jsp?url=/proj/Templet/TempletBrowser.jsp','Prj_Template','templetName','id','/proj/Templet/ProjTempletView.jsp?templetId=')
/
update workflow_billfield set type=129 where billid=152
/

INSERT INTO HtmlLabelIndex values(18374,'项目模板审批') 
/
INSERT INTO HtmlLabelIndex values(18375,'项目模板') 
/
INSERT INTO HtmlLabelInfo VALUES(18374,'项目模板审批',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18375,'项目模板',7) 
/

INSERT INTO HtmlLabelIndex values(18392,'项目模板审批流程') 
/
INSERT INTO HtmlLabelInfo VALUES(18392,'项目模板审批流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18392,'Project Template Approve Workflow',8) 
/

INSERT INTO HtmlLabelIndex values(18371,'模板审批设置') 
/
INSERT INTO HtmlLabelInfo VALUES(18371,'模板审批设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18371,'Project Template Approvement',8) 
/

INSERT INTO HtmlLabelIndex values(18393,'是否需要审批') 
/
INSERT INTO HtmlLabelInfo VALUES(18393,'是否需要审批',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18393,'if it need approve',8) 
/

INSERT INTO HtmlLabelIndex values(18043,'审批流程关联') 
/
INSERT INTO HtmlLabelInfo VALUES(18043,'审批流程关联',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18043,'CHECKFLOWCONNECTION',8) 
/

call MMConfig_U_ByInfoInsert (379,3)
/
call MMInfo_Insert (466,18371,'模板审批设置','/proj/Templet/TempletSetting.jsp','mainFrame',379,2,3,0,'',0,'',0,'','',0,'','',5)
/

insert into SystemRights (id,rightdesc,righttype) values (638,'项目模板审批设置权限维护','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (638,8,'ProjTemplateSettingMaint','Project Template Setting Maint') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (638,7,'项目模板审批设置权限维护','项目模板审批设置权限维护') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4138,'项目模板审批设置权限维护','projTemplateSetting:Maint',638) 
/

create or replace  PROCEDURE Prj_SaveAsTemplet (
	/*ProjectBaseInfo*/
	isSelected_1	char,
	templetName_2 	varchar2,
	proTypeId_3	integer,
	workTypeId_4	integer,
	proMember_5	varchar2,
	isMemberSee_6	char,
	proCrm_7		varchar2,
	isCrmSee_8	char,
	parentProId_9	integer,
	commentDoc_10	integer,
	confirmDoc_11	integer,
	adviceDoc_12	integer,
	Manager_13	integer,
    relationXml_14	varchar2,
    status_15		char,

	/*ProjectFreeField*/
	datefield1_39 	varchar2,
	datefield2_40 	varchar2, 
	datefield3_41 	varchar2, 
	datefield4_42 	varchar2, 
	datefield5_43 	varchar2, 
	numberfield1_44 	float, 
	numberfield2_45 	float,
	numberfield3_46 	float, 
	numberfield4_47 	float, 
	numberfield5_48 	float, 
	textfield1_49 	varchar2,
	textfield2_50 	varchar2, 
	textfield3_51 	varchar2,
	textfield4_52 	varchar2, 
	textfield5_53 	varchar2, 
	boolfield1_54 	smallint, 
	boolfield2_55 	smallint, 
	boolfield3_56 	smallint, 
	boolfield4_57 	smallint, 
	boolfield5_58 	smallint,
	flag out 	integer,
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor)
AS 
	begin
		INSERT INTO Prj_Template (
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
			isSelected_1	,
			templetName_2 	,
			proTypeId_3	,
			workTypeId_4	,
			proMember_5	,
			isMemberSee_6	,
			proCrm_7		,
			isCrmSee_8	,
			parentProId_9	,
			commentDoc_10	,
			confirmDoc_11	,
			adviceDoc_12	,
			Manager_13	,
			relationXml_14,
			status_15,
			/*ProjectFreeField*/
			datefield1_39, datefield2_40, datefield3_41, datefield4_42, datefield5_43, 
			numberfield1_44, numberfield2_45, numberfield3_46, numberfield4_47, numberfield5_48, 
			textfield1_49, textfield2_50, textfield3_51, textfield4_52, textfield5_53, 
			boolfield1_54, boolfield2_55, boolfield3_56, boolfield4_57, boolfield5_58
		);
end;
/

INSERT INTO HtmlLabelIndex values(18396,'项目模板审批单') 
/
INSERT INTO HtmlLabelInfo VALUES(18396,'项目模板审批单',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18396,'Project Template Approve Bill',8) 
/

UPDATE workflow_bill SET namelabel=18396 WHERE id=152
/

INSERT INTO HtmlLabelIndex values(18394,'已完成项目管理权限设置') 
/
INSERT INTO HtmlLabelIndex values(18395,'项目审批权限维护') 
/
INSERT INTO HtmlLabelInfo VALUES(18394,'已完成项目管理权限设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18394,'',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18395,'项目审批权限维护',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18395,'',8) 
/