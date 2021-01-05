
INSERT INTO HtmlLabelIndex values(17905,'所需') 
GO
INSERT INTO HtmlLabelInfo VALUES(17905,'所需',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17905,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17906,'必要') 
GO
INSERT INTO HtmlLabelInfo VALUES(17906,'必要',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17906,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17907,'空模板') 
GO
INSERT INTO HtmlLabelInfo VALUES(17907,'空模板',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17907,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17908,'指定') 
GO
INSERT INTO HtmlLabelInfo VALUES(17908,'指定',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17908,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17909,'改变项目类型将会丢失当前页面的数据，是否继续？') 
GO
INSERT INTO HtmlLabelInfo VALUES(17909,'改变项目类型将会丢失当前页面的数据，是否继续？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17909,'',8) 
GO 

INSERT INTO HtmlLabelIndex values(17910,'不导入任何项目、任务信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(17910,'不导入任何项目、任务信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17910,'',8) 
GO

CREATE TABLE [Prj_task_referdoc] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[taskId] [int] NULL ,
	[templetTaskId] [int] NULL ,
	[docid] [int] NULL ,
	[isTempletTask] [char] (1) NULL 
)
GO

CREATE TABLE [Prj_task_needwf] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[taskId] [int] NULL ,
	[templetTaskId] [int] NULL ,
	[workflowId] [int] NULL ,
	[isNecessary] [char] (1) NULL ,
	[isTempletTask] [char] (1) NULL 
)
GO

CREATE TABLE [Prj_task_needdoc] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[taskId] [int] NULL ,
	[templetTaskId] [int] NULL ,
	[docMainCategory] [int] NULL ,
	[docSubCategory] [int] NULL ,
	[docSecCategory] [int] NULL ,
	[isNecessary] [char] (1) NULL ,
	[isTempletTask] [char] (1) NULL 
)
GO

CREATE TABLE [Prj_TempletTask_referdoc] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[templetTaskId] [int] NULL ,
	[docid] [int] NULL 
)
GO

CREATE TABLE [Prj_TempletTask_needwf] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[templetTaskId] [int] NULL ,
	[workflowId] [int] NULL ,
	[isNecessary] [char] (1) NULL 
)
GO

CREATE TABLE [Prj_TempletTask_needdoc] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[templetTaskId] [int] NULL ,
	[docMainCategory] [int] NULL ,
	[docSubCategory] [int] NULL ,
	[docSecCategory] [int] NULL ,
	[isNecessary] [char] (1) NULL 
)
GO

ALTER TABLE [Prj_Request]
ADD [workflowid] int NULL
GO

ALTER TABLE [Prj_Doc]
ADD [secid] int NULL
GO

ALTER TABLE [Prj_TaskProcess]
ADD [actualBeginDate] [char] (10) NULL, [actualEndDate] [char] (10) NULL
go


alter PROCEDURE Prj_Doc_Insert (
	@prjid 		[int], 
	@taskid 	[int], 
	@docid 		[int], 
	@secid 		[int],
	@flag 		integer output, 
	@msg 		varchar(80) output  
)AS 
INSERT INTO [Prj_Doc] (prjid, taskid, docid, secid) VALUES (@prjid, @taskid, @docid, @secid) 
set @flag = 1 
set @msg = 'OK!'
GO

alter PROCEDURE Prj_Request_Insert(
	@prjid 		[int], 
	@taskid 	[int], 
	@requestid 	[int],
	@workflowid 	[int], 
	@flag 		integer output, 
	@msg 		varchar(80) output  
)AS 
INSERT INTO [Prj_Request] (prjid, taskid, requestid, workflowid) VALUES (@prjid, @taskid, @requestid, @workflowid) 
set @flag = 1 
set @msg = 'OK!'
GO

alter PROCEDURE Prj_TaskProcess_Update (
	@id		int,
	@wbscoding 	varchar(20),
	@subject 	varchar(80) ,
	@begindate 	varchar(10),
	@enddate 	varchar(10), 

	/* added by hubo, 2005/09/01 */
	@actualbegindate 	varchar(10),
	@actualenddate 	varchar(10), 
	
	@workday 	decimal (10,1), 
	@content 	varchar(255),
	@fixedcost 	decimal (10,2), 
	@hrmid 		int, 
	@oldhrmid 	int, 
	@finish 	tinyint, 
	@taskconfirm 	char(1),
	@islandmark 	char(1),
	@prefinish_1 	varchar(4000),
	@realManDays 	decimal (6,1),
	@flag 		integer output, 
	@msg 		varchar(80) output
)AS 
	UPDATE Prj_TaskProcess  
	SET  
	wbscoding = @wbscoding, 
	subject = @subject ,
	begindate = @begindate,
	enddate = @enddate 	, 
	
	/* added by hubo, 2005/09/01 */
	actualbegindate = @actualbegindate,
	actualenddate = @actualenddate 	,
 
	workday = @workday, 
	content = @content,
	fixedcost = @fixedcost,
	hrmid = @hrmid, 
	finish = @finish ,
	taskconfirm = @taskconfirm,
	islandmark = @islandmark,
	prefinish = @prefinish_1,
	realManDays = @realManDays
	WHERE(id= @id) 

if @hrmid<>@oldhrmid
begin
	Declare @currenthrmid varchar(255), @currentoldhrmid varchar(255)
	set @currenthrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
	set @currentoldhrmid='|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @oldhrmid) + '|'
	UPDATE Prj_TaskProcess set parenthrmids=replace(parenthrmids,@currentoldhrmid,@currenthrmid) where (parenthrmids like '%'+@currentoldhrmid+'%')
end
set @flag = 1 set @msg = 'OK!'
GO

CREATE  PROCEDURE Prj_SaveAsTemplet(
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

	/*TaskXML	added by dongping*/
    	@relationXml	text,

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

	/*TaskXML	added by dongping*/
    	relationXml,

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

	/*TaskXML	added by dongping*/
    	@relationXml	,

	/*ProjectFreeField*/
	@datefield1_39, @datefield2_40, @datefield3_41, @datefield4_42, @datefield5_43, 
	@numberfield1_44, @numberfield2_45, @numberfield3_46, @numberfield4_47, @numberfield5_48, 
	@textfield1_49, @textfield2_50, @textfield3_51, @textfield4_52, @textfield5_53, 
	@boolfield1_54, @boolfield2_55, @boolfield3_56, @boolfield4_57, @boolfield5_58
)
set @flag = @@identity
GO
