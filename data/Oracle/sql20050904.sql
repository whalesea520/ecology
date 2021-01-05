/*Prj_Template 项目的模板表*/
CREATE TABLE Prj_Template (
    id integer  NOT NULL ,
    isSelected  char(1) NULL ,
    templetName  Varchar2(50)  null,
    templetDesc   Varchar2(500)  null,
    proTypeId  integer  null,
    workTypeId  integer  null,
    proMember  Varchar2(500)  null,
    isMemberSee  Char(1)  null,
    proCrm  Varchar2(500) null,
    isCrmSee   Char(1) null,
    parentProId integer null,
    commentDoc integer null,
    confirmDoc integer null,
    adviceDoc integer null,
    Manager integer null,
    relationXml Varchar2(4000) null ,
    Datefield1 Varchar2(10)  null,
    Datefield2 Varchar2(10)  null,
    Datefield3 Varchar2(10)  null,
    Datefield4 Varchar2(10)  null,
    Datefield5 Varchar2(10)  null,
    numberfield1 float null,
    Numberfield2 float null,
    Numberfield3 float null,
    Numberfield4 float null,
    Numberfield5 float null,
    Textfield1 Varchar2(100) null, 
    Textfield2 Varchar2(100) null,
    Textfield3 Varchar2(100) null,
    Textfield4 Varchar2(100) null,
    Textfield5 Varchar2(100) null,
    tinyintfield1 smallint null,
    Tinyintfield2 smallint null,
    Tinyintfield3 smallint null,
    Tinyintfield4 smallint null,
    Tinyintfield5 smallint null
)
/
create sequence Prj_Template_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_Template_Trigger
before insert on Prj_Template
for each row
begin
select Prj_Template_id.nextval into :new.id from dual;
end;
/

/*Prj_TemplateTask 项目的模板的任务表*/
CREATE TABLE Prj_TemplateTask (
    id integer  NOT NULL ,
    templetId integer  null,
    templetTaskId integer null ,
    taskName Varchar2(200)  null,
    taskManager  integer  null,
    begindate Char(10) null,
    enddate Char(10) null,
    workday integer  null,
    budget number(15,3)  null,
    parentTaskId integer  null,
    befTaskId integer null,
    taskDesc Varchar2(500) null
)
/
create sequence Prj_TemplateTask_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_TemplateTask_Trigger
before insert on Prj_TemplateTask
for each row
begin
select Prj_TemplateTask_id.nextval into :new.id from dual;
end;
/

/*编码原则配置表*/
CREATE TABLE Prj_codepara (
    id integer  NOT NULL ,
    codePrefix	Varchar2(50)	,
    isNeedProjTypeCode	Char(1)	,
    strYear	Char(1)	,
    strMonth	Char(1)	,
    strDate	Char(1)	,
    glideNum	integer	,
    isUseCode	Char(1)
)
/
create sequence Prj_codepara_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_codepara_Trigger
before insert on Prj_codepara
for each row
begin
select Prj_codepara_id.nextval into :new.id from dual;
end;
/

/*增加项目类型的项目类型代码字段*/
alter table Prj_ProjectType add  protypecode	Varchar2(50)
/
alter table Prj_TaskProcess add   taskIndex integer
/
alter table Prj_ProjectInfo add  proCode	Varchar2(50)
/
alter table Prj_ProjectInfo add  proTemplateId	integer
/
alter table Prj_ProjectInfo add  factBeginDate	Char(10)
/
alter table Prj_ProjectInfo add  factEndDate	Char(10)
/
alter table Prj_ProjectInfo add  relationXml Varchar2(4000)
/

/*插入项目编码标签*/
INSERT INTO HtmlLabelIndex values(17852,'项目编码') 
/
INSERT INTO HtmlLabelInfo VALUES(17852,'项目编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17852,'project code',8) 
/


INSERT INTO HtmlLabelIndex values(17857,'模板管理') 
/
INSERT INTO HtmlLabelInfo VALUES(17857,'模板管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17857,'templet manager',8) 
/



INSERT INTO HtmlLabelIndex values(17858,'模板列表') 
/
INSERT INTO HtmlLabelInfo VALUES(17858,'模板列表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17858,'templet list',8) 
/


/*插入项目编码标签*/
INSERT INTO HtmlLabelIndex values(17852,'项目编码') 
/
INSERT INTO HtmlLabelInfo VALUES(17852,'项目编码',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17852,'project code',8) 
/
/*项目菜单修改*/
call MMConfig_U_ByInfoInsert (6,1)
/
call MMInfo_Insert (377,16484,'基础设置','','',6,1,1,0,'',0,'',0,'','',0,'','',5)
/

call MMConfig_U_ByInfoInsert (377,1)
/
call MMInfo_Insert (378,17852,'项目编码','/proj/CodeFormat/CodeFormatView.jsp','mainFrame',377,2,1,0,'',0,'',0,'','',0,'','',5)
/


call MMConfig_U_ByInfoInsert (6,2)
/
call MMInfo_Insert (379,17857,'模板管理','','mainFrame',6,1,2,0,'',0,'',0,'','',0,'','',5)
/

call MMConfig_U_ByInfoInsert (379,2)
/
call MMInfo_Insert (381,17858,'模板列表','/proj/templet/ProjTempletList.jsp','mainFrame',379,2,2,0,'',0,'',0,'','',0,'','',5)
/

call MMConfig_U_ByInfoInsert (379,1)
/
call MMInfo_Insert (380,16388,'新建模板','/proj/Templet/ProjTempletAdd.jsp','mainFrame',379,2,1,0,'',0,'',0,'','',0,'','',5)
/

/*左边功能区:新建项目*/
update LeftMenuInfo set linkAddress='/proj/templet/ProjTempletSele.jsp' where linkAddress='/proj/data/AddProject.jsp'
/

/*项目编码维护权限*/
insert into SystemRights (id,rightdesc,righttype) values (584,'项目编码维护权限','6') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (584,7,'项目编码维护权限','项目编码维护权限') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (584,8,'project code maintenance','project code maintenance') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4083,'项目编码维护权限','ProjCode:Maintenance',584) 
/
insert into SystemRightToGroup (groupid, rightid) values (7,584)
/
insert into systemrightroles(rightid,roleid,rolelevel) values (584,9,2)
/

/*项目模板维护*/
insert into SystemRights (id,rightdesc,righttype) values (585,'项目模板维护','6') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (585,7,'项目模板维护','项目模板维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (585,8,'project templet maintenance','project templet maintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4084,'项目模板维护','ProjTemplet:Maintenance',585) 
/

insert into SystemRightToGroup (groupid, rightid) values (7,585)
/
insert into systemrightroles(rightid,roleid,rolelevel) values (585,9,2)
/

CREATE or REPLACE PROCEDURE Prj_ProjectInfo_Insert 
 (name_1 	varchar2, description_2 	varchar2,
 prjtype_3 	integer, worktype_4 	integer, securelevel_5 integer, 
 status_6 	integer, isblock_7 	smallint, managerview_8 	smallint, 
 parentview_9 	smallint, budgetmoney_10 	varchar2, moneyindeed_11 	varchar2, 
 budgetincome_12 	varchar2, imcomeindeed_13 	varchar2, planbegindate_14 	varchar2, 
 planbegintime_15 	varchar2, planenddate_16 	varchar2, planendtime_17 	varchar2,
 truebegindate_18 	varchar2, truebegintime_19 	varchar2, trueenddate_20 	varchar2,
 trueendtime_21 	varchar2, planmanhour_22 	integer, truemanhour_23 	integer, 
 picid_24 	integer, intro_25 	varchar2, parentid_26 	integer, envaluedoc_27 	integer,
 confirmdoc_28 	integer, proposedoc_29 	integer, manager_30 	integer, department_31 	integer, 
 subcompanyid1 	integer, creater_32 	integer, createdate_33 	varchar2, createtime_34 	varchar2,
 isprocessed_35 	smallint, processer_36 	integer, processdate_37 	varchar2, processtime_38 	varchar2,
 proCode_59   varchar2, 
 proTemplateId_60  integer,  
 relationXml_61   varchar2, 
 datefield1_39 	varchar2, datefield2_40 	varchar2, datefield3_41 	varchar2, datefield4_42 	varchar2, 
 datefield5_43 	varchar2, numberfield1_44 	float, numberfield2_45 	float, numberfield3_46 	float,
 numberfield4_47 	float, numberfield5_48 	float, textfield1_49 	varchar2,
 textfield2_50 	varchar2, textfield3_51 	varchar2, textfield4_52 	varchar2, textfield5_53 	varchar2, 
 boolfield1_54 	smallint, boolfield2_55 	smallint, boolfield3_56 	smallint, boolfield4_57 	smallint, 
 boolfield5_58 	smallint, 	 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS 
	begin
	INSERT INTO Prj_ProjectInfo ( name, description, prjtype, worktype, securelevel, status, isblock, managerview, parentview,
	budgetmoney, moneyindeed, budgetincome, imcomeindeed, planbegindate, planbegintime, planenddate, planendtime, truebegindate,
	truebegintime, trueenddate, trueendtime, planmanhour, truemanhour, picid, intro, parentid, envaluedoc, confirmdoc, proposedoc,
	manager, department, subcompanyid1, creater, createdate, createtime, isprocessed, processer, processdate, processtime, proCode, proTemplateId, relationXml, datefield1,datefield2, datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1,
	textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5) 
	VALUES ( name_1, description_2, prjtype_3, worktype_4, securelevel_5, status_6, isblock_7, managerview_8, parentview_9,
	to_number(budgetmoney_10), to_number(moneyindeed_11), to_number(budgetincome_12), to_number(imcomeindeed_13),
planbegindate_14, planbegintime_15, planenddate_16, planendtime_17, truebegindate_18, truebegintime_19, trueenddate_20,
trueendtime_21, planmanhour_22, truemanhour_23, picid_24, intro_25, parentid_26, envaluedoc_27, confirmdoc_28, proposedoc_29, manager_30, department_31, subcompanyid1, creater_32, createdate_33, createtime_34, isprocessed_35, processer_36, processdate_37,processtime_38,proCode_59 ,  proTemplateId_60 , relationXml_61, datefield1_39, datefield2_40, datefield3_41, datefield4_42, datefield5_43, numberfield1_44, numberfield2_45,numberfield3_46, numberfield4_47, numberfield5_48, textfield1_49, textfield2_50, textfield3_51, textfield4_52, textfield5_53,
boolfield1_54, boolfield2_55, boolfield3_56, boolfield4_57, boolfield5_58) ;
end;
/

 CREATE or REPLACE PROCEDURE Prj_ProjectInfo_Update 
 (id_1 	integer, name_2 	varchar2, description_3 	varchar2, prjtype_4 	integer, worktype_5 	integer, 
 securelevel_6 	integer, status_7 	integer, isblock_8 	smallint, managerview_9 	smallint, parentview_10 	smallint,
 budgetmoney_11 	varchar2, moneyindeed_12 	varchar2, budgetincome_13 	varchar2, imcomeindeed_14 	varchar2, 
 planbegindate_15 	varchar2, planbegintime_16 	varchar2, planenddate_17 	varchar2, planendtime_18 	varchar2,
 truebegindate_19 	varchar2, truebegintime_20 	varchar2, trueenddate_21 	varchar2, trueendtime_22 	varchar2, 
 planmanhour_23 	integer, truemanhour_24 	integer, picid_25 	integer, intro_26 	varchar2, parentid_27 	integer,
 envaluedoc_28 	integer, confirmdoc_29 	integer, proposedoc_30 	integer, manager_31 	integer, department_32 	integer, 
 subcompanyid12 	integer,
 proCode_60   varchar2, 
 proTemplateId_61  integer,  
relationXml_62   varchar2, 
 datefield1_40 	varchar2, datefield2_41 	varchar2, datefield3_42 	varchar2, 
 datefield4_43 	varchar2, datefield5_44 	varchar2, numberfield1_45 	float, numberfield2_46 	float, 
 numberfield3_47 	float, numberfield4_48 	float, numberfield5_49 	float, textfield1_50 	varchar2,
 textfield2_51 	varchar2, textfield3_52 	varchar2, textfield4_53 	varchar2, textfield5_54 	varchar2, boolfield1_55 	smallint, boolfield2_56 	smallint, boolfield3_57 	smallint, boolfield4_58 	smallint, boolfield5_59 	smallint, 	 
 flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
	AS 
	begin
	UPDATE Prj_ProjectInfo  SET  name	 = name_2, description	 = description_3, prjtype	 = prjtype_4, 
	worktype	 = worktype_5, securelevel	 = securelevel_6, status	 = status_7, isblock	 = isblock_8,
	managerview	 = managerview_9, parentview	 = parentview_10, 
	budgetmoney	 = to_number(budgetmoney_11), 
	moneyindeed	 = to_number(moneyindeed_12),
	budgetincome	 = to_number(budgetincome_13), 
	imcomeindeed	 = to_number(imcomeindeed_14),
	planbegindate	 = planbegindate_15, 
	planbegintime	 = planbegintime_16, planenddate	 = planenddate_17, 
	planendtime	 = planendtime_18, truebegindate	 = truebegindate_19, truebegintime	 = truebegintime_20, 
	trueenddate	 = trueenddate_21, trueendtime	 = trueendtime_22, planmanhour	 = planmanhour_23, 
	truemanhour	 = truemanhour_24, picid	 = picid_25, intro	 = intro_26, parentid	 = parentid_27, envaluedoc	 = envaluedoc_28, 
	confirmdoc	 = confirmdoc_29, proposedoc	 = proposedoc_30, manager	 = manager_31, department	 = department_32, 
	subcompanyid1 = subcompanyid12,
	procode = proCode_60,
	protemplateid = proTemplateId_61,
	relationXml = relationXml_62,
	datefield1	 = datefield1_40, datefield2	 = datefield2_41, 
	datefield3	 = datefield3_42, datefield4	 = datefield4_43, datefield5	 = datefield5_44, 
	numberfield1	 = numberfield1_45, numberfield2	 = numberfield2_46, numberfield3	 = numberfield3_47, 
	numberfield4	 = numberfield4_48, numberfield5	 = numberfield5_49, textfield1	 = textfield1_50, 
	textfield2	 = textfield2_51, textfield3	 = textfield3_52, textfield4	 = textfield4_53,
	textfield5	 = textfield5_54, tinyintfield1	 = boolfield1_55, tinyintfield2	 = boolfield2_56, 
	tinyintfield3	 = boolfield3_57, tinyintfield4	 = boolfield4_58, tinyintfield5	 = boolfield5_59
	WHERE ( id	 = id_1); 
end;
/

CREATE or REPLACE PROCEDURE Prj_ProjectType_Insert 
 (fullname1 	varchar2,
 description1 	varchar2, 
 wfid1	 	integer,
 protypecode_1 Varchar2,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
begin
INSERT INTO Prj_ProjectType ( fullname, description, wfid,protypecode)  
	VALUES ( fullname1, description1, wfid1,protypecode_1);
end;
/

 CREATE or REPLACE PROCEDURE Prj_ProjectType_Update 
 (id1	 	integer,
 fullname1 	varchar2,
 description1 	varchar2,
 wfid1	 	integer, 
 protypecode_1 Varchar2,
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
	UPDATE Prj_ProjectType  SET  fullname	 = fullname1, description	 = description1, wfid	 = wfid1,protypecode=protypecode_1  WHERE ( id	 = id1) ;
end;
/

create or replace  PROCEDURE Prj_TaskProcess_Insert 
 (prjid_1 	integer,
 taskid_2 	integer, 
 wbscoding_3 	varchar2,
 subject_4 	varchar2 , 
 version_5 	smallint, 
 begindate_6 	varchar2,
 enddate_7 	varchar2, 
 workday_8  number,
 content_9 	varchar2,
 fixedcost_10  number ,
 parentid_11  integer, 
 parentids_12 varchar2, 
 parenthrmids_13 varchar2, 
 level_n_14 smallint,
 hrmid_15 integer,
 prefinish_1 varchar2,
 realManDays_16 number ,
 taskIndex_17 integer,
 flag out integer  , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
dsporder_9 integer;
current_maxid integer;
id_1 integer;
maxid_1 varchar2(10);
maxhrmid_1 varchar2(255);
begin
select max(dsporder) into current_maxid from Prj_TaskProcess 
    where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete<>'1' ;
if current_maxid is null then  
     current_maxid := 0;
     dsporder_9 := current_maxid + 1;
end if;

INSERT INTO Prj_TaskProcess 
( prjid, 
taskid , 
wbscoding,
subject , 
version , 
begindate, 
enddate, 
workday, 
content, 
fixedcost,
parentid, 
parentids, 
parenthrmids,
level_n, 
hrmid,
islandmark,
prefinish,
dsporder,
realManDays,
taskIndex
)  
VALUES 
( prjid_1, taskid_2 , wbscoding_3, subject_4 , version_5 , begindate_6, enddate_7,
workday_8, content_9, fixedcost_10, parentid_11, parentids_12, parenthrmids_13, level_n_14, 
hrmid_15,'0',prefinish_1,dsporder_9, realManDays_16,taskIndex_17) ;

select max(id) into id_1 from Prj_TaskProcess ;
 maxid_1 := concat(to_char(id_1) , ',');
 maxhrmid_1 := concat(concat(concat(concat('|' , to_char(id_1)) , ',' ),to_char(hrmid_15) ), '|');
 update Prj_TaskProcess set parentids =parentids_12 +maxid_1, parenthrmids = parenthrmids_13+maxhrmid_1  where 
id=id_1;
end;
/