
INSERT INTO HtmlLabelIndex values(17905,'所需') 
/
INSERT INTO HtmlLabelInfo VALUES(17905,'所需',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17905,'',8) 
/

INSERT INTO HtmlLabelIndex values(17906,'必要') 
/
INSERT INTO HtmlLabelInfo VALUES(17906,'必要',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17906,'',8) 
/

INSERT INTO HtmlLabelIndex values(17907,'空模板') 
/
INSERT INTO HtmlLabelInfo VALUES(17907,'空模板',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17907,'',8) 
/

INSERT INTO HtmlLabelIndex values(17908,'指定') 
/
INSERT INTO HtmlLabelInfo VALUES(17908,'指定',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17908,'',8) 
/

INSERT INTO HtmlLabelIndex values(17909,'改变项目类型将会丢失当前页面的数据，是否继续？') 
/
INSERT INTO HtmlLabelInfo VALUES(17909,'改变项目类型将会丢失当前页面的数据，是否继续？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17909,'',8) 
/ 

INSERT INTO HtmlLabelIndex values(17910,'不导入任何项目、任务信息') 
/
INSERT INTO HtmlLabelInfo VALUES(17910,'不导入任何项目、任务信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17910,'',8) 
/

CREATE TABLE Prj_task_referdoc (
	id integer  NOT NULL ,
	taskId integer NULL ,
	templetTaskId integer NULL ,
	docid integer NULL ,
	isTempletTask char (1) NULL 
)
/
create sequence Prj_task_referdoc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_task_referdoc_Trigger
before insert on Prj_task_referdoc
for each row
begin
select Prj_task_referdoc_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_task_needwf (
	id integer  NOT NULL ,
	taskId integer NULL ,
	templetTaskId integer NULL ,
	workflowId integer NULL ,
	isNecessary char (1) NULL ,
	isTempletTask char (1) NULL 
)
/
create sequence Prj_task_needwf_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_task_needwf_Trigger
before insert on Prj_task_referdoc
for each row
begin
select Prj_task_needwf_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_task_needdoc (
	id integer  NOT NULL ,
	taskId integer NULL ,
	templetTaskId integer NULL ,
	docMainCategory integer NULL ,
	docSubCategory integer NULL ,
	docSecCategory integer NULL ,
	isNecessary char (1) NULL ,
	isTempletTask char (1) NULL 
)
/
create sequence Prj_task_needdoc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_task_needdoc_Trigger
before insert on Prj_task_needdoc
for each row
begin
select Prj_task_needdoc_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_TempletTask_referdoc (
	id integer  NOT NULL ,
	templetTaskId integer NULL ,
	docid integer NULL 
)
/
create sequence Prj_TTask_redoc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_TTask_redoc_Trigger
before insert on Prj_TempletTask_referdoc
for each row
begin
select Prj_TTask_redoc_id.nextval into :new.id from dual;
end;
/


CREATE TABLE Prj_TempletTask_needwf (
	id integer  NOT NULL ,
	templetTaskId integer NULL ,
	workflowId integer NULL ,
	isNecessary char (1) NULL 
)
/
create sequence Prj_TTask_nwf_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_TTask_nwf_Trigger
before insert on Prj_TempletTask_needwf
for each row
begin
select Prj_TTask_nwf_id.nextval into :new.id from dual;
end;
/

CREATE TABLE Prj_TempletTask_needdoc (
	id integer  NOT NULL ,
	templetTaskId integer NULL ,
	docMainCategory integer NULL ,
	docSubCategory integer NULL ,
	docSecCategory integer NULL ,
	isNecessary char (1) NULL 
)
/
create sequence Prj_TTask_ndoc_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Prj_TempletTask_ndoc_Trigger
before insert on Prj_TempletTask_needdoc
for each row
begin
select Prj_TTask_ndoc_id.nextval into :new.id from dual;
end;
/

ALTER TABLE Prj_Request ADD workflowid integer NULL
/

ALTER TABLE Prj_Doc ADD secid integer NULL
/

ALTER TABLE Prj_TaskProcess ADD actualBeginDate char (10) NULL
/
ALTER TABLE Prj_TaskProcess ADD actualEndDate char (10) NULL
/


CREATE or REPLACE PROCEDURE Prj_Doc_Insert 
 (prjid1	integer,
 taskid1	integer, 
 docid1 	integer,
 secid_1 	integer,
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  )
AS
begin
INSERT INTO Prj_Doc ( prjid, taskid, docid,secid)  VALUES ( prjid1, taskid1, docid1,secid_1);
end;
/

CREATE or REPLACE PROCEDURE Prj_Request_Insert 
 (prjid1 	integer, 
 taskid1 	integer, 
 requestid1 integer,
 workflowid_1 integer, 
 flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor  ) 
AS 
	begin
INSERT INTO Prj_Request ( prjid, taskid, requestid,workflowid)  VALUES ( prjid1, taskid1, requestid1,workflowid_1) ;
end;
/

create or replace  PROCEDURE Prj_TaskProcess_Update 
 (id_1	integer,
 wbscoding_2 varchar2,
 subject_3 	varchar2 ,
 begindate_4 	varchar2,
 enddate_5 	varchar2, 
 /* added by hubo, 2005/09/01 */
 actualbegindate_15 	varchar2,
 actualenddate_16 	varchar2, 
 workday_6     number, 
 content_7 	varchar2,
 fixedcost_8 number, 
 hrmid_9 integer, 
 oldhrmid_10 integer, 
 finish_11 smallint, 
 taskconfirm_12 char,
 islandmark_13 char,
 prefinish_1 varchar2,
 realManDays_14 number ,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
currenthrmid varchar2(255);
currentoldhrmid varchar2(255);

begin
UPDATE Prj_TaskProcess  
SET  
wbscoding = wbscoding_2, 
subject = subject_3 ,
begindate = begindate_4,
enddate = enddate_5 	,
/* added by hubo, 2005/09/01 */
actualbegindate = actualbegindate_15,
actualenddate = actualenddate_16 ,
workday = workday_6, 
content = content_7,
fixedcost = fixedcost_8,
hrmid = hrmid_9, 
finish = finish_11 ,
taskconfirm = taskconfirm_12,
islandmark = islandmark_13,
prefinish = prefinish_1,
realManDays = realManDays_14 
WHERE ( id = id_1) ;

if hrmid_9 <>oldhrmid_10 then
currenthrmid := concat(concat(concat(concat('|' ,to_char(id_1)) ,',') ,to_char(hrmid_9)) ,'|');
currentoldhrmid:= concat(concat(concat(concat('|' ,to_char(id_1)) , ',' ) , to_char(oldhrmid_10)) , '|');

UPDATE Prj_TaskProcess set parenthrmids = replace(parenthrmids,currentoldhrmid,currenthrmid) 
where (parenthrmids like concat(concat('%',currentoldhrmid),'%'));
end if;
end;
/

create or replace  PROCEDURE Prj_SaveAsTemplet(
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

	/*TaskXML	added by dongping*/
    	relationXml_14	varchar2,

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
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor  ) 
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
	/*TaskXML	added by dongping*/
    	relationXml,
	/*ProjectFreeField*/
	datefield1, datefield2, datefield3, datefield4, datefield5,
  	numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, 
	textfield1, textfield2, textfield3,textfield4, textfield5, 
	tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5
)VALUES( 
	/*ProjectBaseInfo*/
	isSelected_1,
	templetName_2,
	proTypeId_3,
	workTypeId_4,
	proMember_5,
	isMemberSee_6,
	proCrm_7,
	isCrmSee_8,
	parentProId_9,
	commentDoc_10,
	confirmDoc_11,
	adviceDoc_12,
	Manager_13,
	/*TaskXML	added by dongping*/
   	relationXml_14,
	/*ProjectFreeField*/
	datefield1_39, datefield2_40, datefield3_41, datefield4_42, datefield5_43, 
	numberfield1_44, numberfield2_45, numberfield3_46, numberfield4_47, numberfield5_48, 
	textfield1_49, textfield2_50, textfield3_51, textfield4_52, textfield5_53, 
	boolfield1_54, boolfield2_55, boolfield3_56, boolfield4_57, boolfield5_58
);
end;
/