create table T_InputReport (
inprepid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
inprepname    varchar(200) ,
inpreptablename       varchar(60) ,
inprepbugtablename	varchar(60) ,
inprepfrequence       char(1) ,
/* 输入周期 ：
0：不限
1：年报
2：月报
3：旬报
4：周报
5：日报
*/
inprepbudget         char(1) 			/*是否输入预算 0:不 ， 1： 是*/
)
GO



create table T_InputReportItemtype (
itemtypeid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
inprepid              int ,
itemtypename          varchar(100),
itemtypedesc          varchar(200)
)
GO

create table T_InputReportItem  (
itemid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
inprepid              int ,
itemtypeid           int,
itemdspname           varchar(60) ,
itemfieldname         varchar(60) ,
itemfieldtype         char(1),
/*输入项类型:
1:文本型
2:整数型
3:浮点型
4:选择型
*/
itemfieldscale       int,
/*输入项精度:
对于文本型, 为文本长度.
对于浮点型, 为小数位数
*/
itemexcelsheet       varchar(100),
itemexcelrow         int,
itemexcelcolumn      int
)
GO

create table T_InputReportItemDetail (
inprepitemdetailid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
itemid       int ,
itemdsp      varchar(100) ,
itemvalue    varchar(100)
)
GO

create table T_InputReportCrm (
inprepcrmid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/  
inprepid     int ,
crmid        int 
)
GO

create table T_InputReportConfirm (
confirmid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
inprepid              int ,
inprepbudget          char(1) ,
thetable             varchar(60) ,
inputid		     int ,
inprepdspdate         varchar(80) ,
crmid              int ,
confirmuserid           int
)
GO

create table T_Condition (
conditionid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
conditionname     varchar(100),
conditiondesc     varchar(100),
conditionitemfieldname       varchar(60) ,
conditiontype     char(1) ,
/* 条件种类 ：
1： 文本
2： 选择项
*/
issystemdef      char(1) default '0'			/*0:否 ， 1：是*/
)
GO

insert into T_Condition values('基层单位','基层单位','crm',null,'1')
GO
insert into T_Condition values('从年','从年','yearf',null,'1')
GO
insert into T_Condition values('从月','从月','monthf',null,'1')
GO
insert into T_Condition values('从日','从日','dayf',null,'1')
GO
insert into T_Condition values('到年','到年','yeart',null,'1')
GO
insert into T_Condition values('到月','到月','montht',null,'1')
GO
insert into T_Condition values('到日','到日','dayt',null,'1')
GO



create table T_ConditionDetail (
conditiondetailid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
conditionid       int ,
conditiondsp      varchar(100) ,
conditionvalue    varchar(100)
)
GO


create table T_OutReport (
outrepid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
outrepname    varchar(200) ,
outreprow     int ,
outrepcolumn     int ,
outrepdesc       varchar(255)
)
GO

create table T_OutReportCondition (
outrepconditionid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
outrepid       int ,
conditionid    int ,
)
GO

create table T_OutReportShare (
outrepshareid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
outrepid       int ,
userid         int ,
usertype       char(1)				/*共享用户种类 ：1 内部用户 ， 2： 门户用户 */
)
GO

create table T_OutReportItem (
itemid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
outrepid     int ,
itemrow      int ,
itemcolumn   int ,
itemtype char(1) ,
/* 报表项类型 ：
1：文本项
2：数据库取值
3：其它表格取值
*/
picstat       char(1) default 0 ,
itemexpress   text ,
itemtable    text ,
itemcondition  text
)
GO


create table T_OutReportItemTable (
itemtableid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
itemid     int ,
itemtable   varchar(60) ,
itemtablealter  varchar(20) 
)
GO



create table T_OutReportItemCondition (
itemconditionid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
itemid     int ,
conditionid   int ,
conditionvalue  varchar(100) 
)
GO


alter table T_OutReportItem add itemdesc varchar(200)
GO

alter table T_OutReportItem add itemexpresstype char(1)             /* 1:计算 2：非计算 */
GO

alter table T_OutReportItem add picstatbudget char(1)             /* 0:不包括 1:包括 */
GO

alter table T_OutReportItem add picstatlast char(1)             /* 0:不包括 1:包括 */
GO


create table T_OutReportItemCoordinate  (
itemcoordinateid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
itemid     int ,
coordinatename   varchar(100) ,
coordinatevalue  varchar(100) 
)
GO


alter table T_InputReport add inprepbudgetstatus char(1) default '1'    /* 1 : 打开 2： 关闭 */
GO



CREATE PROCEDURE T_InputReport_SelectAll
	(@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReport
GO



CREATE PROCEDURE T_InputReport_SelectByInprepid
	(@inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReport where inprepid = @inprepid_1
GO


CREATE PROCEDURE T_InputReport_Insert
	(@inprepname_1 	varchar(200),
	 @inpreptablename_2 	varchar(60),
	 @inprepbugtablename_3 	varchar(60),
	 @inprepfrequence_4 	char(1),
	 @inprepbudget_5 	char(1),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS INSERT INTO T_InputReport 
	 ( inprepname,
	 inpreptablename,
	 inprepbugtablename,
	 inprepfrequence,
	 inprepbudget) 
 
VALUES 
	( @inprepname_1,
	 @inpreptablename_2,
	 @inprepbugtablename_3,
	 @inprepfrequence_4,
	 @inprepbudget_5)
GO


CREATE PROCEDURE T_InputReport_Update
	(@inprepid_1 	int,
	 @inprepname_2 	varchar(200),
	 @inpreptablename_3 	varchar(60),
	 @inprepbugtablename_4 	varchar(60),
	 @inprepfrequence_5 	char(1),
	 @inprepbudget_6 	char(1),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS UPDATE T_InputReport 

SET  inprepname	 = @inprepname_2,
	 inpreptablename	 = @inpreptablename_3,
	 inprepbugtablename	 = @inprepbugtablename_4,
	 inprepfrequence	 = @inprepfrequence_5,
	 inprepbudget	 = @inprepbudget_6 

WHERE 
	( inprepid	 = @inprepid_1)
GO



CREATE PROCEDURE T_InputReport_Delete
	(@inprepid_1 	int,
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS DELETE T_InputReport 

WHERE 
	( inprepid	 = @inprepid_1)
GO


CREATE PROCEDURE T_InputReportItemtype_SelectByInprepid
	(@inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItemtype where inprepid = @inprepid_1
GO

CREATE PROCEDURE T_InputReportItemtype_SelectByItemtypeid
	(@itemtypeid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItemtype where itemtypeid = @itemtypeid_1
GO


CREATE PROCEDURE T_InputReportItemtype_Insert
	(@inprepid_1 	int,
	 @itemtypename_2 	varchar(100),
	 @itemtypedesc_3 	varchar(200) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_InputReportItemtype 
	 ( inprepid,
	 itemtypename,
	 itemtypedesc) 
 
VALUES 
	( @inprepid_1,
	 @itemtypename_2,
	 @itemtypedesc_3)
GO


CREATE PROCEDURE T_InputReportItemtype_Update
	(@itemtypeid_1 	int,
	 @itemtypename_2 	varchar(100),
	 @itemtypedesc_3 	varchar(200),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_InputReportItemtype 

SET  itemtypename	 = @itemtypename_2,
	 itemtypedesc	 = @itemtypedesc_3 

WHERE 
	( itemtypeid	 = @itemtypeid_1)
GO

CREATE PROCEDURE T_InputReportItemtype_Delete
	(@itemtypeid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
DELETE T_InputReportItemtype 
WHERE 
	( itemtypeid	 = @itemtypeid_1)

DELETE T_InputReportItem 
WHERE 
	( itemtypeid	 = @itemtypeid_1)
GO


CREATE PROCEDURE T_InputReportItem_SelectByInprepid
	(@inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItem where inprepid = @inprepid_1
GO


CREATE PROCEDURE T_InputReportItem_SelectByItemtypeid
	(@itemtypeid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItem where itemtypeid = @itemtypeid_1
GO

CREATE PROCEDURE T_InputReportItem_SelectByItemid
	(@itemid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItem where itemid = @itemid_1
GO


CREATE PROCEDURE T_InputReportItem_Insert
	(@inprepid_1 	int,
	 @itemdspname_2 	varchar(60),
	 @itemfieldname_3 	varchar(60),
	 @itemfieldtype_4 	char(1),
	 @itemfieldscale_5 	int,
	 @itemtypeid_6 	int,
	 @itemexcelsheet_7 	varchar(100),
	 @itemexcelrow_8 	int,
	 @itemexcelcolumn_9 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_InputReportItem 
	 ( inprepid,
	 itemdspname,
	 itemfieldname,
	 itemfieldtype,
	 itemfieldscale,
	 itemtypeid,
	 itemexcelsheet,
	 itemexcelrow,
	 itemexcelcolumn) 
 
VALUES 
	( @inprepid_1,
	 @itemdspname_2,
	 @itemfieldname_3,
	 @itemfieldtype_4,
	 @itemfieldscale_5,
	 @itemtypeid_6,
	 @itemexcelsheet_7,
	 @itemexcelrow_8,
	 @itemexcelcolumn_9)
GO



CREATE PROCEDURE T_InputReportItem_Update
	(@itemid_1 	int,
	 @itemdspname_2 	varchar(60),
	 @itemfieldname_3 	varchar(60),
	 @itemfieldtype_4 	char(1),
	 @itemfieldscale_5 	int,
	 @itemtypeid_6 	int,
	 @itemexcelsheet_7 	varchar(100),
	 @itemexcelrow_8 	int,
	 @itemexcelcolumn_9 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_InputReportItem 

SET  itemdspname	 = @itemdspname_2,
	 itemfieldname	 = @itemfieldname_3,
	 itemfieldtype	 = @itemfieldtype_4,
	 itemfieldscale	 = @itemfieldscale_5,
	 itemtypeid	 = @itemtypeid_6,
	 itemexcelsheet	 = @itemexcelsheet_7,
	 itemexcelrow	 = @itemexcelrow_8,
	 itemexcelcolumn	 = @itemexcelcolumn_9 

WHERE 
	( itemid	 = @itemid_1)
GO

CREATE PROCEDURE T_InputReportItem_Delete
	(@itemid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS DELETE 
T_InputReportItem 

WHERE 
	( itemid	 = @itemid_1)
GO


CREATE PROCEDURE T_InputReportItemDetail_SelectByItemid
	(@itemid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItemDetail where itemid = @itemid_1
GO


CREATE PROCEDURE T_InputReportItemDetail_Insert
	(@itemid_1 	int,
	 @itemdsp_2 	varchar(100),
	 @itemvalue_3 	varchar(100) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_InputReportItemDetail 
	 ( itemid,
	 itemdsp,
	 itemvalue) 
 
VALUES 
	( @itemid_1,
	 @itemdsp_2,
	 @itemvalue_3)
GO


CREATE PROCEDURE T_InputReportItemDetail_Delete
	(@itemid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output)

AS DELETE T_InputReportItemDetail 

WHERE 
	( itemid	 = @itemid_1)
GO


CREATE PROCEDURE T_InputReportCrm_SelectByInprepid
	(@inprepid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportCrm where inprepid = @inprepid_1
GO



CREATE PROCEDURE T_InputReportCrm_Insert
	(@inprepid_1 	int,
	 @crmid_2 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_InputReportCrm 
	 ( inprepid,
	 crmid) 
 
VALUES 
	( @inprepid_1,
	 @crmid_2)
GO


CREATE PROCEDURE T_InputReportCrm_Delete
	(@inprepcrmid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output)

AS DELETE T_InputReportCrm 

WHERE 
	( inprepcrmid	 = @inprepcrmid_1)
GO


CREATE PROCEDURE T_InputReport_SelectByCrmid
	(@crmid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select a.inprepid, a.inprepname from T_InputReport a, T_InputReportCrm b 
where a.inprepid = b.inprepid and b.crmid = @crmid_1
GO



CREATE PROCEDURE T_InputReportConfirm_Insert
	(@inprepid_1 	int,
	 @inprepbudget_2 	char(1),
	 @thetable_2 	varchar(60),
	 @inputid_3      int ,
	 @inprepdspdate_3 	varchar(80),
	 @crmid_4 	int,
	 @confirmuserid_5 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_InputReportConfirm 
	 ( inprepid,
	 inprepbudget,
	 thetable ,
	 inputid ,
	 inprepdspdate,
	 crmid,
	 confirmuserid) 
 
VALUES 
	( @inprepid_1,
	 @inprepbudget_2,
	 @thetable_2 ,
	 @inputid_3 ,
	 @inprepdspdate_3,
	 @crmid_4,
	 @confirmuserid_5)
GO


CREATE PROCEDURE T_InputReportConfirm_Delete
	(@confirmid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS DELETE T_InputReportConfirm 

WHERE 
	( confirmid	 = @confirmid_1)
GO


CREATE PROCEDURE T_InputReportConfirm_SelectByUserid
	(@confirmuserid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select b.confirmid ,b.inputid ,a.inprepname ,b.inprepdspdate, b.inprepbudget , b.crmid ,b.thetable from T_InputReport a, T_InputReportConfirm b 
where a.inprepid = b.inprepid and b.confirmuserid = @confirmuserid_1
GO




CREATE PROCEDURE T_InputReportConfirm_SelectByConfirmid
	(@confirmid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select b.* , a.inprepname from T_InputReport a,  T_InputReportConfirm b 
where a.inprepid = b.inprepid and confirmid = @confirmid_1
GO


CREATE PROCEDURE T_Condition_SelectAll
	(@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_Condition
GO



CREATE PROCEDURE T_Condition_SelectByConditionid
	(@conditionid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_Condition where conditionid = @conditionid_1
GO


CREATE PROCEDURE T_ConditionDetail_SelectByConditionid
	(@conditionid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_ConditionDetail where conditionid = @conditionid_1
GO



CREATE PROCEDURE T_Condition_Insert
	(@conditionname_1 	varchar(100),
	 @conditiondesc_2 	varchar(100),
	 @conditionitemfieldname_3 	varchar(60),
	 @conditiontype_4 	char(1) ,
	 @flag	int	output, 
	 @msg	varchar(80)	output) 

AS INSERT INTO T_Condition 
	 ( conditionname,
	 conditiondesc,
	 conditionitemfieldname,
	 conditiontype) 
 
VALUES 
	( @conditionname_1,
	 @conditiondesc_2,
	 @conditionitemfieldname_3,
	 @conditiontype_4)
Go

CREATE PROCEDURE T_Condition_Update
	(@conditionid_1 	int,
	 @conditionname_2 	varchar(100),
	 @conditiondesc_3 	varchar(100),
	 @conditionitemfieldname_4 	varchar(60),
	 @conditiontype_5 	char(1) ,
	 @flag	int	output, 
	 @msg	varchar(80)	output) 

AS UPDATE T_Condition 

SET  conditionname	 = @conditionname_2,
	 conditiondesc	 = @conditiondesc_3,
	 conditionitemfieldname	 = @conditionitemfieldname_4,
	 conditiontype	 = @conditiontype_5 

WHERE 
	( conditionid	 = @conditionid_1)

GO

CREATE PROCEDURE T_Condition_Delete
	(@conditionid_1 	int ,
	 @flag	int	output, 
	 @msg	varchar(80)	output) 

AS DELETE T_Condition 

WHERE 
	( conditionid	 = @conditionid_1)

GO

CREATE PROCEDURE T_ConditionDetail_Insert
	(@conditionid_1 	int,
	 @conditiondsp_2 	varchar(100),
	 @conditionvalue_3 	varchar(100) ,
	 @flag	int	output, 
	 @msg	varchar(80)	output) 

AS INSERT INTO T_ConditionDetail 
	 ( conditionid,
	 conditiondsp,
	 conditionvalue) 
 
VALUES 
	( @conditionid_1,
	 @conditiondsp_2,
	 @conditionvalue_3)
GO

CREATE PROCEDURE T_ConditionDetail_Delete
	(@conditionid_1 	int ,
	 @flag	int	output, 
	 @msg	varchar(80)	output) 

AS DELETE T_ConditionDetail 

WHERE 
	( conditionid	 = @conditionid_1)
GO


CREATE PROCEDURE T_OutReport_SelectAll
	(@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReport
GO

CREATE PROCEDURE T_OutReport_SelectByOutrepid
	(@outrepid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReport where outrepid = @outrepid
GO

CREATE PROCEDURE T_OutReportCondition_SelectByOutrepid
	(@outrepid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportCondition where outrepid = @outrepid
GO


CREATE PROCEDURE T_OutReportShare_SelectByOutrepid
	(@outrepid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportShare where outrepid = @outrepid
GO


CREATE PROCEDURE T_OutReport_Insert
	(@outrepname_1 	varchar(200),
	 @outreprow_2 	int,
	 @outrepcolumn_3 	int,
	 @outrepdesc_4 	varchar(255) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReport 
	 ( outrepname,
	 outreprow,
	 outrepcolumn,
	 outrepdesc) 
 
VALUES 
	( @outrepname_1,
	 @outreprow_2,
	 @outrepcolumn_3,
	 @outrepdesc_4)
GO


CREATE PROCEDURE T_OutReport_Update
	(@outrepid_1 	int,
	 @outrepname_2 	varchar(200),
	 @outrepdesc_3 	varchar(255) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_OutReport 

SET  outrepname	 = @outrepname_2,
	 outrepdesc	 = @outrepdesc_3 

WHERE 
	( outrepid	 = @outrepid_1)
GO


CREATE PROCEDURE T_OutReport_Delete
	(@outrepid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
DELETE T_OutReport WHERE ( outrepid	 = @outrepid_1)
DELETE T_OutReportCondition WHERE ( outrepid	 = @outrepid_1)
DELETE T_OutReportShare WHERE ( outrepid	 = @outrepid_1)
DELETE T_OutReportItem WHERE ( outrepid	 = @outrepid_1)
GO


CREATE PROCEDURE T_OutReportCondition_Insert
	(@outrepid_1 	int,
	 @conditionid_2 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReportCondition 
	 ( outrepid,
	 conditionid) 
 
VALUES 
	( @outrepid_1,
	 @conditionid_2)
GO


CREATE PROCEDURE T_OutReportCondition_Delete
	(@outrepconditionid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS DELETE T_OutReportCondition 

WHERE 
	( outrepconditionid	 = @outrepconditionid_1)
GO


CREATE PROCEDURE T_OutReportShare_Insert
	(@outrepid_1 	int,
	 @userid_2 	int,
	 @usertype_3 	char(1) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_OutReportShare 
	 ( outrepid,
	 userid,
	 usertype) 
 
VALUES 
	( @outrepid_1,
	 @userid_2,
	 @usertype_3)
GO


CREATE PROCEDURE T_OutReportShare_Delete
	(@outrepshareid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS DELETE T_OutReportShare 

WHERE 
	( outrepshareid	 = @outrepshareid_1)
GO



CREATE PROCEDURE T_OutReportItem_SelectByRowCol
	(@outrepid int ,
	@itemrow int ,
	@itemcolumn int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportItem where outrepid = @outrepid and itemrow = @itemrow and itemcolumn= @itemcolumn
GO


CREATE PROCEDURE T_OutReportItem_SelectByOutrepid
	(@outrepid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportItem where outrepid = @outrepid 
GO



CREATE PROCEDURE T_OutReportItem_SelectByItemid
	(@itemid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportItem where itemid = @itemid 
GO


CREATE PROCEDURE T_OutReportItem_DeleteByRowCol
	(@outrepid int ,
	@itemrow int ,
	@itemcolumn int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @itemid int
select @itemid = itemid from T_OutReportItem where outrepid = @outrepid and itemrow = @itemrow and itemcolumn= @itemcolumn
delete T_OutReportItem where itemid = @itemid 
delete T_OutReportItemTable where itemid = @itemid
delete T_OutReportItemCondition where itemid = @itemid
delete T_OutReportItemCoordinate where itemid = @itemid
GO



CREATE PROCEDURE T_OutReportItem_DeleteByRow
	(@outrepid int ,
	@itemrow int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @itemid int
declare itemid_cursor cursor for 
select itemid from T_OutReportItem where outrepid = @outrepid and itemrow = @itemrow

open itemid_cursor 
fetch next from itemid_cursor into @itemid
while @@fetch_status=0 
begin 
	delete T_OutReportItem where itemid = @itemid
	delete T_OutReportItemTable where itemid = @itemid
	delete T_OutReportItemCondition where itemid = @itemid
	delete T_OutReportItemCoordinate where itemid = @itemid
fetch next from itemid_cursor into @itemid
end 
close itemid_cursor 
deallocate itemid_cursor

GO


CREATE PROCEDURE T_OutReportItem_DeleteByCol
	(@outrepid int ,
	@itemcolumn int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @itemid int
declare itemid_cursor cursor for 
select itemid from T_OutReportItem where outrepid = @outrepid and itemcolumn= @itemcolumn 

open itemid_cursor 
fetch next from itemid_cursor into @itemid
while @@fetch_status=0 
begin 
	delete T_OutReportItem where itemid = @itemid
	delete T_OutReportItemTable where itemid = @itemid
	delete T_OutReportItemCondition where itemid = @itemid
	delete T_OutReportItemCoordinate where itemid = @itemid
fetch next from itemid_cursor into @itemid
end 
close itemid_cursor 
deallocate itemid_cursor

GO

CREATE PROCEDURE T_OutReportItemTable_SelectByItemid
	(@itemid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportItemTable where itemid = @itemid 
GO


CREATE PROCEDURE T_OutReportItemCondition_SelectByItemid
	(@itemid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportItemCondition where itemid = @itemid 
GO


CREATE PROCEDURE T_OutReportItemTable_Insert
	(@itemid_1 	int,
	 @itemtable     varchar(60),
	 @itemtablealter  varchar(20),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 

INSERT INTO T_OutReportItemTable 
	 ( itemid,
	 itemtable,
	 itemtablealter) 
 
VALUES 
	( @itemid_1,
	 @itemtable,
	 @itemtablealter)

GO


CREATE PROCEDURE T_OutReportItemCondition_Insert
	(@itemid_1 	int,
	 @conditionid     int,
	 @conditionvalue  varchar(100),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 

INSERT INTO T_OutReportItemCondition 
	 ( itemid,
	 conditionid,
	 conditionvalue) 
 
VALUES 
	( @itemid_1,
	 @conditionid,
	 @conditionvalue)

GO



CREATE PROCEDURE T_OutReportItem_Insert
	(@itemid_1 	int,
	 @outrepid_2 	int,
	 @itemrow_2 	int,
	 @itemcolumn_2 	int,
	 @itemtype       char(1),
	 @itemexpress    text ,
	 @itemdesc       varchar(200),
	 @itemexpresstype char(1) ,
	 @picstatbudget char(1) ,
	 @picstatlast   char(1) ,
	 @picstat       char(1) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
if @itemid_1 = 0
begin
insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,itemtable,itemcondition) values(@outrepid_2,@itemrow_2,@itemcolumn_2,@itemtype,@itemexpress ,@itemdesc, @itemexpresstype, @picstatbudget, @picstatlast, @picstat,'','')
select @itemid_1 = max(itemid) from T_OutReportItem
end

else 
begin
update T_OutReportItem set itemtype = @itemtype , itemexpress = @itemexpress , itemdesc = @itemdesc , itemexpresstype = @itemexpresstype , picstatbudget = @picstatbudget , picstatlast = @picstatlast , picstat = @picstat  , itemtable = ''  , itemcondition = ''  where itemid = @itemid_1
end

DELETE T_OutReportItemTable WHERE  ( itemid	 = @itemid_1)
DELETE T_OutReportItemCondition WHERE  ( itemid	 = @itemid_1)
DELETE T_OutReportItemCoordinate WHERE  ( itemid	 = @itemid_1)

select @itemid_1 
GO



CREATE PROCEDURE T_OutReportItem_Copy
	(@outrepid_2 	int,
	 @itemrow_2 	int,
	 @itemcolumn_2 	int,
	 @fromitemrow_2      int,
	 @fromitemcolumn_2    int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 
AS
declare @itemid int , @itemid1 int , @itemtype char(1)

select @itemid = itemid , @itemtype = itemtype from T_OutReportItem where itemrow = @fromitemrow_2 and itemcolumn = @fromitemcolumn_2 and outrepid = @outrepid_2

if @itemid is null
return

select @itemid1 = itemid from T_OutReportItem where itemrow = @itemrow_2 and itemcolumn = @itemcolumn_2 and outrepid = @outrepid_2

if @itemid1 is not null
begin
delete T_OutReportItem where itemid = @itemid1
delete T_OutReportItemTable where itemid = @itemid1
delete T_OutReportItemCondition where itemid = @itemid1
delete T_OutReportItemCoordinate where itemid = @itemid1
end

insert into T_OutReportItem( outrepid, itemrow, itemcolumn, itemtype, itemexpress, itemtable, itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat) select outrepid, @itemrow_2, @itemcolumn_2, itemtype, itemexpress, itemtable, itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat from T_OutReportItem where itemid = @itemid

if @itemtype = '2' 
begin
	select @itemid1 = max(itemid) from T_OutReportItem

	insert into T_OutReportItemTable(itemid,itemtable,itemtablealter) select @itemid1, itemtable, itemtablealter from T_OutReportItemTable where itemid = @itemid 

	insert into T_OutReportItemCondition(itemid,conditionid,conditionvalue) select @itemid1, conditionid, conditionvalue from T_OutReportItemCondition where itemid = @itemid 

	insert into T_OutReportItemCoordinate(itemid,coordinatename,coordinatevalue) select @itemid1, coordinatename, coordinatevalue from T_OutReportItemCoordinate where itemid = @itemid 
end

GO







CREATE PROCEDURE T_OutReportItemTable_Delete
	(@itemid 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS DELETE T_OutReportItemTable 

WHERE 
	( itemid	 = @itemid)
GO



CREATE PROCEDURE T_OutReportItemCondition_Delete
	(@itemid 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS DELETE T_OutReportItemCondition 

WHERE 
	( itemid	 = @itemid)
GO



CREATE PROCEDURE T_OutReportItem_Delete
	(@itemid 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
delete T_OutReportItem where itemid = @itemid
delete T_OutReportItemTable where itemid = @itemid
delete T_OutReportItemCondition where itemid = @itemid
delete T_OutReportItemCoordinate where itemid = @itemid
GO



CREATE PROCEDURE T_OutReport_SelectByUserid
	(@userid int ,
	@usertype char(1),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select a.* from T_OutReport a, T_OutReportShare b 
where a.outrepid = b.outrepid and b.userid=@userid and b.usertype = @usertype 
GO




CREATE PROCEDURE T_OutReportItemCoordinate_Delete
	(@itemid 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS DELETE T_OutReportItemCoordinate 

WHERE 
	( itemid	 = @itemid)
GO


CREATE PROCEDURE T_OutReportItemCoordinate_SelectByItemid
	(@itemid int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_OutReportItemCoordinate where itemid = @itemid 
GO


CREATE PROCEDURE T_OutReportItemCoordinate_Insert
	(@itemid_1 	int,
	 @coordinatename     varchar(100),
	 @coordinatevalue  varchar(100),
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 

INSERT INTO T_OutReportItemCoordinate 
	 ( itemid,
	 coordinatename,
	 coordinatevalue) 
 
VALUES 
	( @itemid_1,
	 @coordinatename,
	 @coordinatevalue)

GO


alter table T_InputReportItem add itemfieldunit varchar(60)
GO

alter table T_InputReportItem add dsporder int
GO

alter PROCEDURE T_InputReportItem_Insert
	(@inprepid_1 	int,
	 @itemdspname_2 	varchar(60),
	 @itemfieldname_3 	varchar(60),
	 @itemfieldtype_4 	char(1),
	 @itemfieldscale_5 	int,
	 @itemtypeid_6 	int,
	 @itemexcelsheet_7 	varchar(100),
	 @itemexcelrow_8 	int,
	 @itemexcelcolumn_9 	int ,
	 @itemfieldunit   varchar(60) ,
	 @dsporder        int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 

INSERT INTO T_InputReportItem 
	 ( inprepid,
	 itemdspname,
	 itemfieldname,
	 itemfieldtype,
	 itemfieldscale,
	 itemtypeid,
	 itemexcelsheet,
	 itemexcelrow,
	 itemexcelcolumn,
	 itemfieldunit,
	 dsporder) 
 
VALUES 
	( @inprepid_1,
	 @itemdspname_2,
	 @itemfieldname_3,
	 @itemfieldtype_4,
	 @itemfieldscale_5,
	 @itemtypeid_6,
	 @itemexcelsheet_7,
	 @itemexcelrow_8,
	 @itemexcelcolumn_9,
	 @itemfieldunit,
	 @dsporder)
GO


alter PROCEDURE T_InputReportItem_Update
	(@itemid_1 	int,
	 @itemdspname_2 	varchar(60),
	 @itemfieldname_3 	varchar(60),
	 @itemfieldtype_4 	char(1),
	 @itemfieldscale_5 	int,
	 @itemtypeid_6 	int,
	 @itemexcelsheet_7 	varchar(100),
	 @itemexcelrow_8 	int,
	 @itemexcelcolumn_9 	int ,
	 @itemfieldunit   varchar(60) ,
	 @dsporder        int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS UPDATE T_InputReportItem 

SET  itemdspname	 = @itemdspname_2,
	 itemfieldname	 = @itemfieldname_3,
	 itemfieldtype	 = @itemfieldtype_4,
	 itemfieldscale	 = @itemfieldscale_5,
	 itemtypeid	 = @itemtypeid_6,
	 itemexcelsheet	 = @itemexcelsheet_7,
	 itemexcelrow	 = @itemexcelrow_8,
	 itemexcelcolumn	 = @itemexcelcolumn_9 ,
	 itemfieldunit = @itemfieldunit ,
	 dsporder = @dsporder 

WHERE 
	( itemid	 = @itemid_1)
GO


alter PROCEDURE T_InputReportItem_SelectByItemtypeid
	(@itemtypeid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select * from T_InputReportItem where itemtypeid = @itemtypeid_1 order by dsporder 
GO


/* new modi 2002-12-02*/

alter table T_OutReportItem add itemmodtype char(1)             /* 0:不修正 1:月修正 2：年修正 */
GO
update T_OutReportItem set itemmodtype = '0'
GO

insert into T_Condition values('修正','修正','modify',null,'1')
GO

create table T_InputReportItemClose (
closeid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
inprepid    int ,
itemid     int ,   
crmid    int
)
GO

/* new modi 2002-12-02*/

alter PROCEDURE T_OutReportItem_Insert
	(@itemid_1 	int,
	 @outrepid_2 	int,
	 @itemrow_2 	int,
	 @itemcolumn_2 	int,
	 @itemtype       char(1),
	 @itemexpress    text ,
	 @itemdesc       varchar(200),
	 @itemexpresstype char(1) ,
	 @picstatbudget char(1) ,
	 @picstatlast   char(1) ,
	 @picstat       char(1) ,
	 @itemmodtype       char(1) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
if @itemid_1 = 0
begin
insert into T_OutReportItem(outrepid,itemrow,itemcolumn,itemtype,itemexpress,itemdesc, itemexpresstype, picstatbudget, picstatlast, picstat,itemtable,itemcondition,itemmodtype) values(@outrepid_2,@itemrow_2,@itemcolumn_2,@itemtype,@itemexpress ,@itemdesc, @itemexpresstype, @picstatbudget, @picstatlast, @picstat,'','',@itemmodtype)
select @itemid_1 = max(itemid) from T_OutReportItem
end

else 
begin
update T_OutReportItem set itemtype = @itemtype , itemexpress = @itemexpress , itemdesc = @itemdesc , itemexpresstype = @itemexpresstype , picstatbudget = @picstatbudget , picstatlast = @picstatlast , picstat = @picstat  , itemtable = ''  , itemcondition = '' , itemmodtype=@itemmodtype where itemid = @itemid_1
end

DELETE T_OutReportItemTable WHERE  ( itemid	 = @itemid_1)
DELETE T_OutReportItemCondition WHERE  ( itemid	 = @itemid_1)
DELETE T_OutReportItemCoordinate WHERE  ( itemid	 = @itemid_1)

select @itemid_1 
GO

CREATE PROCEDURE T_InputReportItemClose_Insert
	(@inprepid_1 	int,
	 @itemid_2 	int,
	 @crmid_3 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output)

AS INSERT INTO T_InputReportItemClose 
	 ( inprepid,
	 itemid,
	 crmid) 
 
VALUES 
	( @inprepid_1,
	 @itemid_2,
	 @crmid_3)
GO

CREATE PROCEDURE T_InputReportItemClose_Delete
	(@closeid_1 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output)

AS DELETE T_InputReportItemClose 

WHERE 
	( closeid	 = @closeid_1)
GO



/*  new alter 2002-12-09  加入预测 */

alter table T_InputReport add inprepforecast char(1) default '0'            /* 0:不需预测， 需要预测 */
GO

update T_InputReport set inprepforecast='0'
GO


alter PROCEDURE T_InputReport_Insert
	(@inprepname_1 	varchar(200),
	 @inpreptablename_2 	varchar(60),
	 @inprepbugtablename_3 	varchar(60),
	 @inprepfrequence_4 	char(1),
	 @inprepbudget_5 	char(1),
	 @inprepforecast	char(1),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS INSERT INTO T_InputReport 
	 ( inprepname,
	 inpreptablename,
	 inprepbugtablename,
	 inprepfrequence,
	 inprepbudget,
	 inprepforecast) 
 
VALUES 
	( @inprepname_1,
	 @inpreptablename_2,
	 @inprepbugtablename_3,
	 @inprepfrequence_4,
	 @inprepbudget_5,
	 @inprepforecast)
GO


alter PROCEDURE T_InputReport_Update
	(@inprepid_1 	int,
	 @inprepname_2 	varchar(200),
	 @inpreptablename_3 	varchar(60),
	 @inprepbugtablename_4 	varchar(60),
	 @inprepfrequence_5 	char(1),
	 @inprepbudget_6 	char(1),
	 @inprepforecast	char(1),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS UPDATE T_InputReport 

SET  inprepname	 = @inprepname_2,
	 inpreptablename	 = @inpreptablename_3,
	 inprepbugtablename	 = @inprepbugtablename_4,
	 inprepfrequence	 = @inprepfrequence_5,
	 inprepbudget	 = @inprepbudget_6 ,
	 inprepforecast	 = @inprepforecast 

WHERE 
	( inprepid	 = @inprepid_1)
GO



create table T_OutReportItemRow (
rowid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
outrepid     int ,
itemrow      int 
)
GO

/* 2003, 5 , 9 */
create table T_DatacenterUser (
id int IDENTITY(1,1) primary key CLUSTERED,     /*id*/
crmid  int ,
contacterid int ,
loginid  varchar(60) ,
password varchar(60) ,
status   char(1)
)
GO

CREATE PROCEDURE T_DatacenterUser_Insert
	(@crmid_1 	int,
	 @contacterid_2 	int,
	 @loginid_3 	varchar(60),
	 @password_4 	varchar(60),
	 @status_5 	char(1),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS INSERT INTO T_DatacenterUser 
	 ( crmid,
	 contacterid,
	 loginid,
	 password,
	 status) 
 
VALUES 
	( @crmid_1,
	 @contacterid_2,
	 @loginid_3,
	 @password_4,
	 @status_5)
GO

CREATE PROCEDURE T_DatacenterUser_Delete
	(@flag	int	output, 
	 @msg	varchar(80)	output) 

AS 
DELETE T_DatacenterUser 
GO


alter table T_InputReportConfirm add reportuserid int
GO


alter PROCEDURE T_InputReportConfirm_Insert
	(@inprepid_1 	int,
	 @inprepbudget_2 	char(1),
	 @thetable_2 	varchar(60),
	 @inputid_3      int ,
	 @inprepdspdate_3 	varchar(80),
	 @crmid_4 	int,
	 @confirmuserid_5 	int ,
     @reportuserid_6 	int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS INSERT INTO T_InputReportConfirm 
	 ( inprepid,
	 inprepbudget,
	 thetable ,
	 inputid ,
	 inprepdspdate,
	 crmid,
	 confirmuserid,
     reportuserid) 
 
VALUES 
	( @inprepid_1,
	 @inprepbudget_2,
	 @thetable_2 ,
	 @inputid_3 ,
	 @inprepdspdate_3,
	 @crmid_4,
	 @confirmuserid_5,
     @reportuserid_6)
GO



CREATE PROCEDURE T_InputReportConfirm_SelectByCrmid
	(@crmid_1  int ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select b.* ,a.inprepname from T_InputReport a, T_InputReportConfirm b 
where a.inprepid = b.inprepid and b.crmid = @crmid_1
GO


alter table T_InputReport add startdate char(10) , enddate char(10)
GO

update T_InputReport set startdate = '' , enddate = ''
GO

alter PROCEDURE T_InputReport_Insert
	(@inprepname_1 	varchar(200),
	 @inpreptablename_2 	varchar(60),
	 @inprepbugtablename_3 	varchar(60),
	 @inprepfrequence_4 	char(1),
	 @inprepbudget_5 	char(1),
	 @inprepforecast_6	char(1),
     @startdate_7	char(10),
     @enddate_8	char(10),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS INSERT INTO T_InputReport 
	 ( inprepname,
	 inpreptablename,
	 inprepbugtablename,
	 inprepfrequence,
	 inprepbudget,
	 inprepforecast,
     startdate,
     enddate) 
 
VALUES 
	( @inprepname_1,
	 @inpreptablename_2,
	 @inprepbugtablename_3,
	 @inprepfrequence_4,
	 @inprepbudget_5,
	 @inprepforecast_6,
     @startdate_7,
     @enddate_8)
GO

alter PROCEDURE T_InputReport_Update
	(@inprepid_1 	int,
	 @inprepname_2 	varchar(200),
	 @inpreptablename_3 	varchar(60),
	 @inprepbugtablename_4 	varchar(60),
	 @inprepfrequence_5 	char(1),
	 @inprepbudget_6 	char(1),
	 @inprepforecast_7	char(1),
     @startdate_8	char(10),
     @enddate_9	char(10),
	 @flag	int	output, 
	 @msg	varchar(80)	output)

AS UPDATE T_InputReport 

SET  inprepname	 = @inprepname_2,
	 inpreptablename	 = @inpreptablename_3,
	 inprepbugtablename	 = @inprepbugtablename_4,
	 inprepfrequence	 = @inprepfrequence_5,
	 inprepbudget	 = @inprepbudget_6 ,
	 inprepforecast	 = @inprepforecast_7 , 
     startdate	 = @startdate_8 , 
     enddate	 = @enddate_9  

WHERE 
	( inprepid	 = @inprepid_1)
GO


alter PROCEDURE T_InputReport_SelectByCrmid
	(@crmid_1  int ,
     @currentdate_2 char(10) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select a.inprepid, a.inprepname from T_InputReport a, T_InputReportCrm b 
where a.inprepid = b.inprepid and b.crmid = @crmid_1 and 
(a.startdate = '' or a.startdate is null or a.startdate <= @currentdate_2 ) and 
(a.enddate = '' or a.enddate is null or a.enddate >= @currentdate_2 )
GO


insert into T_Condition values('基层单位1','基层单位1','crm1',null,'1')
GO
insert into T_Condition values('基层单位2','基层单位2','crm2',null,'1')
GO
insert into T_Condition values('基层单位3','基层单位3','crm3',null,'1')
GO
insert into T_Condition values('基层单位4','基层单位4','crm4',null,'1')
GO
insert into T_Condition values('基层单位5','基层单位5','crm5',null,'1')
GO
insert into T_Condition values('基层单位6','基层单位6','crm6',null,'1')
GO
insert into T_Condition values('基层单位7','基层单位7','crm7',null,'1')
GO
insert into T_Condition values('基层单位8','基层单位8','crm8',null,'1')
GO
insert into T_Condition values('基层单位9','基层单位9','crm9',null,'1')
GO
insert into T_Condition values('基层单位10','基层单位10','crm10',null,'1')
GO


create PROCEDURE T_OutReport_Copy
	(@outrepid_1 	int,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
declare @newoutrepid_1 int
declare @itemid_1 int
declare @newitemid_1 int

INSERT INTO T_OutReport( outrepname,  outreprow , outrepcolumn , outrepdesc )
( select '复制_'+outrepname,  outreprow , outrepcolumn , outrepdesc from T_OutReport where outrepid = @outrepid_1 ) 

select @newoutrepid_1 = max(outrepid) from T_OutReport 

INSERT INTO T_OutReportCondition( outrepid,  conditionid )
( select @newoutrepid_1,  conditionid from T_OutReportCondition where outrepid = @outrepid_1 ) 

INSERT INTO T_OutReportShare( outrepid,  userid , usertype )
( select @newoutrepid_1,  userid,  usertype from T_OutReportShare where outrepid = @outrepid_1 ) 

INSERT INTO T_OutReportItemRow( outrepid,  itemrow )
( select @newoutrepid_1,  itemrow from T_OutReportItemRow where outrepid = @outrepid_1 ) 

declare itemid_cursor cursor for 
select itemid from T_OutReportItem where outrepid = @outrepid_1
open itemid_cursor 
fetch next from itemid_cursor into @itemid_1 
while @@fetch_status=0 
begin 
    INSERT INTO T_OutReportItem( outrepid,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
    itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype )
    ( select @newoutrepid_1,  itemrow , itemcolumn , itemtype , picstat, itemexpress, itemtable,
    itemcondition, itemdesc, itemexpresstype, picstatbudget, picstatlast , itemmodtype 
    from T_OutReportItem where itemid = @itemid_1 ) 

    select @newitemid_1 = max( itemid ) from T_OutReportItem 
    
    INSERT INTO T_OutReportItemTable( itemid,  itemtable , itemtablealter )
    ( select @newitemid_1,  itemtable,  itemtablealter from T_OutReportItemTable where itemid = @itemid_1 ) 

    INSERT INTO T_OutReportItemCondition( itemid,  conditionid , conditionvalue )
    ( select @newitemid_1,  conditionid,  conditionvalue from T_OutReportItemCondition where itemid = @itemid_1 ) 

    INSERT INTO T_OutReportItemCoordinate( itemid,  coordinatename , coordinatevalue )
    ( select @newitemid_1,  coordinatename,  coordinatevalue from T_OutReportItemCoordinate where itemid = @itemid_1 ) 
    
    fetch next from itemid_cursor into @itemid_1 
end 
close itemid_cursor 
deallocate itemid_cursor
GO



/* 5月25日 */

create table T_InputReportCrmContacter (
inprepcontacterid  int IDENTITY(1,1) primary key CLUSTERED,     /*id*/  
inprepcrmid     int ,
contacterid        int 
)
GO


create PROCEDURE T_InputReport_SelectByContacterid
	(@contacter_1  int ,
     @currentdate_2 char(10) ,
	@flag	int	output, 
	@msg	varchar(80)	output) 

AS 
select a.inprepid, a.inprepname from T_InputReport a, T_InputReportCrm b , T_InputReportCrmContacter c 
where a.inprepid = b.inprepid and b.inprepcrmid = c.inprepcrmid and c.contacterid = @contacter_1 and 
(a.startdate = '' or a.startdate is null or a.startdate <= @currentdate_2 ) and 
(a.enddate = '' or a.enddate is null or a.enddate >= @currentdate_2 )
GO



/* 6 月30日 */

insert into T_Condition values('分别汇总','分别汇总','isonebyone',null,'1')
GO
