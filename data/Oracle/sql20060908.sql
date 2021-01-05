INSERT INTO HtmlLabelIndex values(19664,'报表列') 
/
INSERT INTO HtmlLabelInfo VALUES(19664,'报表列',7) 
/
INSERT INTO HtmlLabelInfo VALUES(19664,'Report Column',8) 
/

update HtmlLabelInfo set labelName='Report Condition'  where indexId=15505 and languageId=8
/

insert into SequenceIndex(indexDesc,currentId) values('WorkflowRptCondMouldId',1)
/


CREATE TABLE WorkflowRptCondMould (
	id integer  NOT NULL ,
        mouldName varchar2(200) NULL , 
        userId integer NULL ,
        reportId integer NULL 
) 
/


CREATE TABLE WorkflowRptCondMouldDetail (
	id integer  NOT NULL ,
        mouldId integer NULL , 
        fieldId integer NULL ,
	isMain char(1)  NULL,
	isShow char(1)  NULL,
	isCheckCond char(1)  NULL,
	colName varchar2(60)  NULL,
	htmlType char(1)  NULL,
        type integer NULL ,
	optionFirst char(1)  NULL,
	valueFirst  varchar2(60) NULL,
	nameFirst  varchar2(60) NULL,
	optionSecond char(1)  NULL,
	valueSecond  varchar2(60) NULL
) 
/
create sequence WorkRptMD_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkRptMD_id_Trigger
before insert on WorkflowRptCondMouldDetail
for each row
begin
select WorkRptMD_id.nextval into :new.id from dual;
end;
/
