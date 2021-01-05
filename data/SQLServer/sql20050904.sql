/*Prj_Template 项目的模板表*/
CREATE TABLE Prj_Template (
    id int IDENTITY (1, 1) NOT NULL ,
    isSelected  char(1) NULL ,
    templetName  Varchar(50)  null,
    templetDesc   Varchar(500)  null,
    proTypeId  Int  null,
    workTypeId  int  null,
    proMember  varchar(500)  null,
    isMemberSee  Char(1)  null,
    proCrm  Varchar(500) null,
    isCrmSee   Char(1) null,
    parentProId int null,
    commentDoc int null,
    confirmDoc int null,
    adviceDoc int null,
    Manager int null,
    relationXml text null ,
    Datefield1 varchar(10)  null,
    Datefield2 varchar(10)  null,
    Datefield3 varchar(10)  null,
    Datefield4 varchar(10)  null,
    Datefield5 varchar(10)  null,
    numberfield1 float null,
    Numberfield2 float null,
    Numberfield3 float null,
    Numberfield4 float null,
    Numberfield5 float null,
    Textfield1 varchar(100) null, 
    Textfield2 varchar(100) null,
    Textfield3 varchar(100) null,
    Textfield4 varchar(100) null,
    Textfield5 varchar(100) null,
    tinyintfield1 tinyint null,
    Tinyintfield2 tinyint null,
    Tinyintfield3 tinyint null,
    Tinyintfield4 tinyint null,
    Tinyintfield5 tinyint null
)
GO

/*Prj_TemplateTask 项目的模板的任务表*/
CREATE TABLE Prj_TemplateTask (
    id int IDENTITY (1, 1) NOT NULL ,
    templetId int  null,
    templetTaskId int null ,
    taskName Varchar(200)  null,
    taskManager  int  null,
    begindate Char(10) null,
    enddate Char(10) null,
    workday Int  null,
    budget Decimal(15,3)  null,
    parentTaskId int  null,
    befTaskId int null,
    taskDesc Varchar(500) null
)
GO


/*编码原则配置表*/
CREATE TABLE Prj_codepara (
    id int IDENTITY (1, 1) NOT NULL ,
    codePrefix	Varchar(50)	,
    isNeedProjTypeCode	Char(1)	,
    strYear	Char(1)	,
    strMonth	Char(1)	,
    strDate	Char(1)	,
    glideNum	int	,
    isUseCode	Char(1)
)
GO


/*增加项目类型的项目类型代码字段*/
alter table Prj_ProjectType add  protypecode	Varchar(50)
GO
alter table Prj_TaskProcess add   taskIndex int
Go
alter table Prj_ProjectInfo add  proCode	varchar(50)
GO
alter table Prj_ProjectInfo add  proTemplateId	int
GO
alter table Prj_ProjectInfo add  factBeginDate	Char(10)
GO
alter table Prj_ProjectInfo add  factEndDate	Char(10)
GO
alter table Prj_ProjectInfo add  relationXml text
GO

/*插入项目编码标签*/
INSERT INTO HtmlLabelIndex values(17852,'项目编码') 
GO
INSERT INTO HtmlLabelInfo VALUES(17852,'项目编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17852,'project code',8) 
GO


INSERT INTO HtmlLabelIndex values(17857,'模板管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(17857,'模板管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17857,'templet manager',8) 
GO



INSERT INTO HtmlLabelIndex values(17858,'模板列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(17858,'模板列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17858,'templet list',8) 
GO


/*插入项目编码标签*/
INSERT INTO HtmlLabelIndex values(17852,'项目编码') 
GO
INSERT INTO HtmlLabelInfo VALUES(17852,'项目编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17852,'project code',8) 
GO




/*项目菜单修改*/
EXECUTE MMConfig_U_ByInfoInsert 6,1
GO
EXECUTE MMInfo_Insert 377,16484,'基础设置','','',6,1,1,0,'',0,'',0,'','',0,'','',5
GO

EXECUTE MMConfig_U_ByInfoInsert 377,1
GO
EXECUTE MMInfo_Insert 378,17852,'项目编码','/proj/CodeFormat/CodeFormatView.jsp','mainFrame',377,2,1,0,'',0,'',0,'','',0,'','',5
GO


EXECUTE MMConfig_U_ByInfoInsert 6,2
GO
EXECUTE MMInfo_Insert 379,17857,'模板管理','','mainFrame',6,1,2,0,'',0,'',0,'','',0,'','',5
GO

EXECUTE MMConfig_U_ByInfoInsert 379,2
GO
EXECUTE MMInfo_Insert 381,17858,'模板列表','/proj/templet/ProjTempletList.jsp','mainFrame',379,2,2,0,'',0,'',0,'','',0,'','',5
GO

EXECUTE MMConfig_U_ByInfoInsert 379,1
GO
EXECUTE MMInfo_Insert 380,16388,'新建模板','/proj/Templet/ProjTempletAdd.jsp','mainFrame',379,2,1,0,'',0,'',0,'','',0,'','',5
GO

/*左边功能区:新建项目*/
update LeftMenuInfo set linkAddress='/proj/templet/ProjTempletSele.jsp' where linkAddress='/proj/data/AddProject.jsp'
Go



/*项目编码维护权限*/
insert into SystemRights (id,rightdesc,righttype) values (584,'项目编码维护权限','6') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (584,7,'项目编码维护权限','项目编码维护权限') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (584,8,'project code maintenance','project code maintenance') 
GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4083,'项目编码维护权限','ProjCode:Maintenance',584) 
GO
insert into SystemRightToGroup (groupid, rightid) values (7,584)
GO
insert into systemrightroles(rightid,roleid,rolelevel) values (584,9,2)
GO

/*项目模板维护*/
insert into SystemRights (id,rightdesc,righttype) values (585,'项目模板维护','6') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (585,7,'项目模板维护','项目模板维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (585,8,'project templet maintenance','project templet maintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4084,'项目模板维护','ProjTemplet:Maintenance',585) 
GO

insert into SystemRightToGroup (groupid, rightid) values (7,585)
GO
insert into systemrightroles(rightid,roleid,rolelevel) values (585,9,2)
GO


Alter  PROCEDURE Prj_ProjectInfo_Insert (
	@name_1 	varchar(50),
	@description_2 	varchar(1000),
	@prjtype_3 	int,
	@worktype_4 	int, 
	@securelevel_5 	int, 
	@status_6 	int, 
	@isblock_7 	tinyint,
	@managerview_8 	tinyint, 
	@parentview_9 	tinyint,
	@budgetmoney_10 	varchar(50), 
	@moneyindeed_11 	varchar(50), 
	@budgetincome_12 	varchar(50),
	@imcomeindeed_13 	varchar(50), 
	@planbegindate_14 	varchar(10), 
	@planbegintime_15 	varchar(5),
	@planenddate_16 	varchar(10),
	@planendtime_17 	varchar(5),
	@truebegindate_18 	varchar(10),
	@truebegintime_19 	varchar(5), 
	@trueenddate_20 	varchar(10), 
	@trueendtime_21 	varchar(5), 
	@planmanhour_22 	int, 
	@truemanhour_23 	int, 
	@picid_24 	int, 
	@intro_25 	varchar(255),
	@parentid_26 	int,
	@envaluedoc_27 	int, 
	@confirmdoc_28 	int, 
	@proposedoc_29 	int, 
	@manager_30 	int, 
	@department_31 	int, 
	@subcompanyid1 	int, 
	@creater_32 	int, 
	@createdate_33 	varchar(10),
	@createtime_34 	varchar(8), 
	@isprocessed_35 	tinyint,
	@processer_36 	int, 
	@processdate_37 	varchar(10),
	@processtime_38 	varchar(8), 
    @proCode   varchar(50), 
    @proTemplateId  int,  
	@relationXml   text, 
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


AS 

INSERT INTO Prj_ProjectInfo ( name, description, prjtype, worktype, securelevel, status, isblock, managerview, 
parentview, budgetmoney, moneyindeed, budgetincome, imcomeindeed, planbegindate, planbegintime, planenddate,
 planendtime, truebegindate, truebegintime, trueenddate, trueendtime, planmanhour, truemanhour, picid, intro, 
 parentid, envaluedoc, confirmdoc, proposedoc, manager, department, subcompanyid1, creater, createdate, createtime, 
 isprocessed, processer, processdate, processtime,proCode,proTemplateId,relationXml, datefield1, datefield2, datefield3, datefield4, datefield5,
  numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1, textfield2, textfield3,
   textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5) 
    VALUES ( @name_1, @description_2, @prjtype_3, @worktype_4, @securelevel_5, @status_6, @isblock_7,
     @managerview_8, @parentview_9, convert(money,@budgetmoney_10), convert(money,@moneyindeed_11), 
     convert(money,@budgetincome_12), convert(money,@imcomeindeed_13), @planbegindate_14, @planbegintime_15,
      @planenddate_16, @planendtime_17, @truebegindate_18, @truebegintime_19, @trueenddate_20, @trueendtime_21,
       @planmanhour_22, @truemanhour_23, @picid_24, @intro_25, @parentid_26, @envaluedoc_27, @confirmdoc_28, 
       @proposedoc_29, @manager_30, @department_31, @subcompanyid1, @creater_32, @createdate_33, @createtime_34, 
       @isprocessed_35, @processer_36, @processdate_37, @processtime_38,@proCode,@proTemplateId, @relationXml,@datefield1_39, @datefield2_40,
        @datefield3_41, @datefield4_42, @datefield5_43, @numberfield1_44, @numberfield2_45, @numberfield3_46,
         @numberfield4_47, 
       @numberfield5_48, @textfield1_49, @textfield2_50, @textfield3_51, @textfield4_52,
        @textfield5_53, @boolfield1_54, @boolfield2_55, @boolfield3_56, @boolfield4_57, @boolfield5_58) 
GO




Alter   PROCEDURE Prj_ProjectInfo_Update (
    @id_1   int, 
    @name_2     varchar(50), 
    @description_3  varchar(1000),
    @prjtype_4  int, 
    @worktype_5     int, 
    @securelevel_6  int,
    @status_7   int,
    @isblock_8  tinyint,
    @managerview_9  tinyint,
    @parentview_10  tinyint,
    @budgetmoney_11     varchar(50),
    @moneyindeed_12     varchar(50),
    @budgetincome_13    varchar(50), 
    @imcomeindeed_14    varchar(50),
    @planbegindate_15   varchar(10), 
    @planbegintime_16   varchar(5), 
    @planenddate_17     varchar(10), 
    @planendtime_18     varchar(5),
    @truebegindate_19   varchar(10),
    @truebegintime_20   varchar(5),
    @trueenddate_21     varchar(10), 
    @trueendtime_22     varchar(5), 
    @planmanhour_23     int, 
    @truemanhour_24     int,
    @picid_25   int, 
    @intro_26   varchar(255), 
    @parentid_27    int, 
    @envaluedoc_28  int, 
    @confirmdoc_29  int, 
    @proposedoc_30  int, 
    @manager_31     int, 
    @department_32  int, 
    @subcompanyid1  int, 
    @procode  varchar(50),
    @protemplateid  int,
    @relationXml text,
    @datefield1_40  varchar(10), 
    @datefield2_41  varchar(10), 
    @datefield3_42  varchar(10), 
    @datefield4_43  varchar(10), 
    @datefield5_44  varchar(10), 
    @numberfield1_45    float,
    @numberfield2_46    float,
    @numberfield3_47    float,
    @numberfield4_48    float, 
    @numberfield5_49    float, 
    @textfield1_50  varchar(100),
    @textfield2_51  varchar(100),
    @textfield3_52  varchar(100), 
    @textfield4_53  varchar(100),
    @textfield5_54  varchar(100), 
    @boolfield1_55  tinyint, 
    @boolfield2_56  tinyint, 
    @boolfield3_57  tinyint,
    @boolfield4_58  tinyint,
    @boolfield5_59  tinyint, 
    @flag   int output,
    @msg    varchar(80) output
)  
    AS
    UPDATE Prj_ProjectInfo  SET  name    = @name_2, description  = @description_3, 
    prjtype  = @prjtype_4, worktype  = @worktype_5, securelevel  = @securelevel_6,
    status   = @status_7, isblock    = @isblock_8, managerview   = @managerview_9,
    parentview   = @parentview_10, budgetmoney   = convert(money,@budgetmoney_11), 
    moneyindeed  = convert(money,@moneyindeed_12), budgetincome  = convert(money,@budgetincome_13),
    imcomeindeed     = convert(money,@imcomeindeed_14), planbegindate    = @planbegindate_15,
    planbegintime    = @planbegintime_16, planenddate    = @planenddate_17, 
    planendtime  = @planendtime_18, truebegindate    = @truebegindate_19,
    truebegintime    = @truebegintime_20, trueenddate    = @trueenddate_21, 
    trueendtime  = @trueendtime_22, planmanhour  = @planmanhour_23,
    truemanhour  = @truemanhour_24, picid    = @picid_25, intro  = @intro_26,
    parentid     = @parentid_27, envaluedoc  = @envaluedoc_28, confirmdoc    = @confirmdoc_29,
    proposedoc   = @proposedoc_30, manager   = @manager_31, department   = @department_32,
    subcompanyid1 = @subcompanyid1,procode=@procode,protemplateid=@protemplateid,relationXml=@relationXml, datefield1   = @datefield1_40,
    datefield2   = @datefield2_41, datefield3    = @datefield3_42,
    datefield4   = @datefield4_43, datefield5    = @datefield5_44, 
    numberfield1     = @numberfield1_45, numberfield2    = @numberfield2_46, numberfield3
    = @numberfield3_47, numberfield4     = @numberfield4_48,
    numberfield5     = @numberfield5_49, textfield1  = @textfield1_50,
    textfield2   = @textfield2_51, textfield3    = @textfield3_52,
    textfield4   = @textfield4_53, textfield5    = @textfield5_54,
    tinyintfield1= @boolfield1_55, tinyintfield2     = @boolfield2_56,
    tinyintfield3    = @boolfield3_57, tinyintfield4     = @boolfield4_58, 
    tinyintfield5    = @boolfield5_59  WHERE ( id    = @id_1) 
GO


alter PROCEDURE Prj_ProjectType_Insert (
    @fullname  varchar(50),
    @description    varchar(150),
    @wfid       int,
    @protypecode varchar(50),
    @flag   int output,
    @msg    varchar(80) output) 
 AS 

    INSERT INTO Prj_ProjectType 
    ( fullname, description, wfid,protypecode) 
    VALUES ( @fullname, @description, @wfid,@protypecode)  

    set @flag = 1 set @msg = 'OK!'
GO


Alter PROCEDURE Prj_ProjectType_Update
(
	@id	 	int, 
	@fullname 	varchar(50),
	@description 	varchar(150), 
	@protypecode varchar(50), 
	@wfid	 	int, @flag	int	output,
	@msg	varchar(80)	output
)  AS
	UPDATE Prj_ProjectType  
	SET  fullname	 = @fullname, description	 = @description, wfid	 = @wfid ,protypecode=@protypecode
	WHERE ( id	 = @id)  
set @flag = 1 
set @msg = 'OK!'

GO



ALTER PROCEDURE Prj_TaskProcess_Insert 
	 (@prjid 	int,
	 @taskid 	int, 
	 @wbscoding 	varchar(20),
	 @subject 	varchar(80) , 
	 @version 	tinyint, 
	 @begindate 	varchar(10),
	 @enddate 	varchar(10), 
	 @workday decimal (10,1),
	 @content 	varchar(255),
	 @fixedcost decimal (10,2),
	 @parentid int, 
	 @parentids varchar (255), 
	 @parenthrmids varchar (255), 
	 @level_n tinyint,
	 @hrmid int,
	 @prefinish_1 varchar(4000),
	 @realManDays decimal (6,1), 
     	@taskIndex int,
	 @flag integer output, @msg varchar(80) output  ) 
	AS 
	declare @dsporder_9 int, @current_maxid int
	
	select @current_maxid = max(dsporder) from Prj_TaskProcess 
	where prjid = @prjid and version = @version and parentid = @parentid and isdelete<>'1' 
	if @current_maxid is null set @current_maxid = 0 
	set @dsporder_9 = @current_maxid + 1
	
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
	( @prjid, @taskid , @wbscoding, @subject , @version , @begindate, @enddate,
	@workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'0',@prefinish_1,@dsporder_9, @realManDays,@taskIndex) 
	Declare @id int, @maxid varchar(10), @maxhrmid varchar(255)
	select @id = max(id) from Prj_TaskProcess 
	set @maxid = convert(varchar(10), @id) + ','
	set @maxhrmid = '|' + convert(varchar(10), @id) + ',' + convert(varchar(10), @hrmid) + '|'
	update Prj_TaskProcess set parentids=parentids+@maxid, parenthrmids=parenthrmids+@maxhrmid  where id=@id
	/*modified by hubo,20051013*/
	set @flag = @@identity 
	set @msg = 'OK!'
GO







