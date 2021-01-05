CREATE TABLE workflow_track (
	id int IDENTITY (1, 1) NOT NULL ,	/*修改日志字段id，自增长*/
	optKind varchar(20),	/*日志操作类型*/
	requestId int  NULL ,		/*请求对应的ID*/
	nodeId int  NULL ,		/*节点名称*/
	isBill int  NULL ,		/*是否是单据:0:表单	1:单据*/
	fieldLableId int, 	/*单据用的LEABLE*/
	fieldId int NULL ,			/*修改字段对应的ID*/
	fieldHtmlType char (1) NULL,		/*修改字段的浏览类型*/
	fieldType varchar (40)  NULL ,		/*修改字段的类型*/
	fieldNameCn varchar (100)  NULL ,	/*修改字段的中文名称 Lable Name*/
	fieldNameEn varchar (100)  NULL ,	/*修改字段的英文名称 Lable Name*/
	fieldOldText varchar (8000)  NULL ,			/*修改字段的原内容*/
	fieldNewText varchar (8000)  NULL ,			/*修改字段的新内容*/
	modifierType int NULL ,			/*修改人类型*/
	agentId	int default '-1',
	modifierId int NULL ,			/*修改人对应的ID*/
	modifierIP varchar (20)  NULL ,		/*修改人的IP地址*/
	modifyTime varchar (20)  NULL		/*修改人时间*/
)
GO

CREATE TABLE workflow_trackdetail (
	id int IDENTITY (1, 1) NOT NULL ,	/*修改日志明细字段id，自增长*/
	sn int 	NULL,	/*判断记录修改前后*/
	optKind varchar(20),	/*日志操作类型*/
	optType int  NULL ,		/*操作类型:1:新增; 2:修改; 3:删除*/
	requestId int  NULL ,		/*请求对应的ID*/
	nodeId int  NULL ,		/*节点名称*/
	isBill int  NULL ,		/*是否是单据:0:表单	1:单据*/
	fieldLableId int, 	/*单据用的LEABLE*/
	fieldGroupId int  NULL ,		/*明细所对应的组*/
	fieldId int NULL ,			/*修改字段对应的ID*/
	fieldHtmlType char (1) NULL,		/*修改字段的浏览类型*/
	fieldType varchar (40)  NULL ,		/*修改字段的类型*/
	fieldNameCn varchar (100)  NULL ,	/*修改字段的中文名称 Lable Name*/
	fieldNameEn varchar (100)  NULL ,	/*修改字段的英文名称 Lable Name*/
	fieldOldText varchar (8000)  NULL ,			/*修改字段的原内容*/
	fieldNewText varchar (8000)  NULL ,			/*修改字段的新内容*/
	modifierType int NULL ,			/*修改人类型*/
	agentId	int default '-1',
	modifierId int NULL ,			/*修改人对应的ID*/
	modifierIP varchar (20)  NULL ,		/*修改人的IP地址*/
	modifyTime varchar (20)  NULL		/*修改人时间*/
)
GO

alter table workflow_base add isModifyLog char(1) default '0'
GO

