INSERT INTO HtmlLabelIndex values(18812,'流程计划') 
/
INSERT INTO HtmlLabelInfo VALUES(18812,'流程计划',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18812,'flow plan',8) 
/


insert into SystemRights (id,rightdesc,righttype) values (642,'流程计划设置','5') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (642,7,'流程计划设置','流程计划设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (642,8,'flow plan set','flow plan set') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4142,'流程计划设置','WorkFlowPlanSet:All',642) 
/

CREATE TABLE WorkFlowPlanSet(
	id integer NOT NULL,
	status char(1)  NULL,
	frequencyt char(1)  NULL,
	dateType char(1)  NULL,
	dateSum integer NULL,
	timeSet varchar2(8) NULL,
	alertType char(1)  NULL,
	flowId integer NULL
) 
/
create sequence WorkFlowPlanSet_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkFlowPlanSet_Trigger
before insert on WorkFlowPlanSet
for each row
begin
select WorkFlowPlanSet_id.nextval into :new.id from dual;
end;
/

CREATE TABLE WorkFlowPlanDetail(
	id integer  NOT NULL,
	userId integer  NULL,
	autoType char(1)  NULL,
	flowDate varchar2(6)  NULL,
	flowId integer NULL
) 
/
create sequence WorkFlowPlanDetail_id
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WorkFlowPlanDetail_Trigger
before insert on WorkFlowPlanDetail
for each row
begin
select WorkFlowPlanDetail_id.nextval into :new.id from dual;
end;
/
INSERT INTO HtmlLabelIndex values(18813,'频率') 
/
INSERT INTO HtmlLabelInfo VALUES(18813,'频率',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18813,'frequency',8) 
/

INSERT INTO HtmlLabelIndex values(18814,'日期设置') 
/
INSERT INTO HtmlLabelInfo VALUES(18814,'日期设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18814,'set date',8) 
/

INSERT INTO HtmlLabelIndex values(18815,'点') 
/
INSERT INTO HtmlLabelInfo VALUES(18815,'点',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18815,'point',8) 
/
 
INSERT INTO HtmlLabelIndex values(18816,'倒数') 
/
INSERT INTO HtmlLabelIndex values(18817,'正数') 
/
INSERT INTO HtmlLabelInfo VALUES(18816,'倒数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18816,'down list',8) 
/
INSERT INTO HtmlLabelInfo VALUES(18817,'正数',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18817,'up list',8) 
/

INSERT INTO HtmlLabelIndex values(18819,'日期设置不合理') 
/
INSERT INTO HtmlLabelInfo VALUES(18819,'日期设置不合理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18819,'date set not availability',8) 
/
