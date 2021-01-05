CREATE TABLE workflow_track (
	id number NOT NULL ,	/*修改日志字段id，自增长*/
	optKind varchar2(20),	/*日志操作类型*/
	requestId number  NULL ,		/*请求对应的ID*/
	nodeId number  NULL ,		/*节点名称*/
	isBill number  NULL ,		/*是否是单据:0:表单	1:单据*/
	fieldLableId number, 	/*单据用的LEABLE*/
	fieldId number NULL ,			/*修改字段对应的ID*/
	fieldHtmlType char (1) NULL,		/*修改字段的浏览类型*/
	fieldType varchar2(40)  NULL ,		/*修改字段的类型*/
	fieldNameCn varchar2(100)  NULL ,	/*修改字段的中文名称 Lable Name*/
	fieldNameEn varchar2(100)  NULL ,	/*修改字段的英文名称 Lable Name*/
	fieldOldText varchar2(4000)  NULL ,			/*修改字段的原内容*/
	fieldNewText varchar2(4000)  NULL ,			/*修改字段的新内容*/
	modifierType number NULL ,			/*修改人类型*/
	agentId	int default '-1',
	modifierId number NULL ,			/*修改人对应的ID*/
	modifierIP varchar2(20)  NULL ,		/*修改人的IP地址*/
	modifyTime varchar2(20)  NULL		/*修改人时间*/
)
/
create sequence Workflow_track_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger Workflow_track_Tri
before insert on Workflow_track
for each row
begin
select Workflow_track_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_trackdetail (
	id number NOT NULL ,	/*修改日志明细字段id，自增长*/
	sn number 	NULL,	/*判断记录修改前后*/
	optKind varchar2(20),	/*日志操作类型*/
	optType number  NULL ,		/*操作类型:1:新增; 2:修改; 3:删除*/
	requestId number  NULL ,		/*请求对应的ID*/
	nodeId number  NULL ,		/*节点名称*/
	isBill number  NULL ,		/*是否是单据:0:表单	1:单据*/
	fieldLableId number, 	/*单据用的LEABLE*/
	fieldGroupId number  NULL ,		/*明细所对应的组*/
	fieldId number NULL ,			/*修改字段对应的ID*/
	fieldHtmlType char (1) NULL,		/*修改字段的浏览类型*/
	fieldType varchar2(40)  NULL ,		/*修改字段的类型*/
	fieldNameCn varchar2(100)  NULL ,	/*修改字段的中文名称 Lable Name*/
	fieldNameEn varchar2(100)  NULL ,	/*修改字段的英文名称 Lable Name*/
	fieldOldText varchar2(4000)  NULL ,			/*修改字段的原内容*/
	fieldNewText varchar2(4000)  NULL ,			/*修改字段的新内容*/
	modifierType number NULL ,			/*修改人类型*/
	agentId	int default '-1',
	modifierId number NULL ,			/*修改人对应的ID*/
	modifierIP varchar2(20)  NULL ,		/*修改人的IP地址*/
	modifyTime varchar2(20)  NULL		/*修改人时间*/
)
/
create sequence Workflow_trackdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger Workflow_trackdetail_Tri
before insert on Workflow_trackdetail
for each row
begin
select Workflow_trackdetail_id.nextval into :new.id from dual;
end;
/

alter table workflow_base add isModifyLog char(1) default '0'
/