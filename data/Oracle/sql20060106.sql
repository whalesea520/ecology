/*表单模板*/
CREATE TABLE workflow_formmode ( 
    id integer not null ,	/*自增长ID*/
    formid integer,	/*表单id*/
    isbill varchar2(1),	/*是否为单据*/
    isprint varchar2(1),	/*是否打印模板*/
    modename varchar2(200),/*模板名称*/
    modedesc clob	/*模板内容*/)

/
create sequence workflow_formmode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_formmode_Trigger
before insert on workflow_formmode
for each row
begin
select workflow_formmode_id.nextval into :new.id from dual;
end;
/

/*节点模板*/
CREATE TABLE workflow_nodemode ( 
    id integer not null ,	/*自增长ID*/
    workflowid integer,/*工作流id*/
    formid integer,/*表单id*/
    nodeid integer,	/*节点id*/
    isprint varchar2(1),	/*是否打印模板*/
    modename varchar2(200),/*模板名称*/
    modedesc  clob		/*模板内容*/
)
/
create sequence workflow_nodemode_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger workflow_nodemode_Trigger
before insert on workflow_nodemode
for each row
begin
select workflow_nodemode_id.nextval into :new.id from dual;
end;
/
/*显示类型*/
alter table workflow_flownode add ismode varchar2(1)
/
/*不引用显示模板*/
alter table workflow_flownode add showdes varchar2(1)
/
/*不引用打印模板*/
alter table workflow_flownode add printdes varchar2(1)
/

INSERT INTO HtmlLabelIndex values(18016,'普通模式') 
/
INSERT INTO HtmlLabelIndex values(18017,'模板模式') 
/
INSERT INTO HtmlLabelInfo VALUES(18016,'普通模式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18016,'generic mode',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18017,'模板模式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18017,'templet mode',8) 
/
INSERT INTO HtmlLabelIndex values(18018,'可编辑') 
/
INSERT INTO HtmlLabelIndex values(18019,'必填') 
/
INSERT INTO HtmlLabelInfo VALUES(18018,'可编辑',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18018,'can be edited',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18019,'必填',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18019,'must input',8) 
/
INSERT INTO HtmlLabelIndex values(18020,'主表字段') 
/
INSERT INTO HtmlLabelIndex values(18021,'明细表字段') 
/
INSERT INTO HtmlLabelInfo VALUES(18020,'主表字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18020,'main table field',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18021,'明细表字段',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18021,'detail table field',8) 
/
INSERT INTO HtmlLabelIndex values(18023,'是否使用模板') 
/
INSERT INTO HtmlLabelInfo VALUES(18023,'是否使用模板',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18023,'use mode or not',8) 
/
INSERT INTO HtmlLabelIndex values(17139,'显示类型') 
/
INSERT INTO HtmlLabelInfo VALUES(17139,'显示类型',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17139,'show type',8) 
/
INSERT INTO HtmlLabelIndex values(18015,'流程') 
/
INSERT INTO HtmlLabelInfo VALUES(18015,'流程',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18015,'Workflow',8) 
/
INSERT INTO HtmlLabelIndex values(18173,'显示/隐藏表头') 
/
INSERT INTO HtmlLabelInfo VALUES(18173,'显示/隐藏表头',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18173,'show or hidden system head',8) 
/