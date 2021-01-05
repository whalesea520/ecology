CREATE TABLE HrmSalaryItem
(
id	int IDENTITY (1, 1) NOT NULL ,
name	Varchar(50) null,
operationmark	Char(1) default 1,
isshow	Char(1) default 1,
showorder	int default 1 ,
history  Char(1) default 0
)
GO


CREATE TABLE HrmSalaryRank (
	id int IDENTITY (1, 1) NOT NULL ,
	itemid int   null ,
	rankname VarChar (50)   null,
	salary decimal (12,2)  default 0 
)
GO


CREATE TABLE HrmSalaryRate (
	id int IDENTITY (1, 1) NOT NULL ,
	ranknum int  default 1 ,
	ranklow decimal (12,2)  default 0 ,
	rankhigh decimal (12,2)  default 0 ,
	taxrate decimal (12,2)  default 0
)
GO



CREATE TABLE HrmSalaryRateBase (
id	int IDENTITY (1, 1) NOT NULL ,
name    varchar(50) null,
taxrate	decimal(12,2)
)
go






CREATE TABLE HrmSalaryPersonality (
id		int IDENTITY (1, 1) NOT NULL ,
itemid	int,
hrmid		int,
salary	decimal(12,2) default 0
)
go

ALTER TABLE HrmSalaryPersonality WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		id
	)  
GO

CREATE TABLE HrmSalaryResult (
id		int  IDENTITY (1, 1) NOT NULL ,
itemid	int,
hrmid		int,
salary	decimal(12,2) default 0,
yearmonth	varchar(7),
isvalidate int default 0
)
go

ALTER TABLE HrmSalaryResult WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		id
	)  
GO

CREATE TABLE HrmSalaryHistory(
id   int  IDENTITY(1,1) not null,
hrmid int ,
currentdate char(10),
itemid int,
salary decimal(12,2) default 0
)
go

 CREATE PROCEDURE HrmSalaryRate_SelectAll 
 (@flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM HrmSalaryRate order by ranknum set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRate_SelectByID 
 (@id_1 int, @flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM HrmSalaryRate WHERE id=@id_1 set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRate_Insert 
 (	@ranknum_1 int ,
	@ranklow_1 decimal (12,2)  ,
	@rankhigh_1 decimal (12,2)  ,
	@taxrate_1 decimal (12,2)  ,
 
 @flag	int	output, @msg	varchar(80)	output) 
 AS INSERT INTO HrmSalaryRate ( ranknum, ranklow, rankhigh,taxrate)  
 VALUES ( @ranknum_1, @ranklow_1, @rankhigh_1,@taxrate_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRate_Delete 
 (@id_1 	int, @flag	int	output, @msg	varchar(80)	output)  AS DELETE HrmSalaryRate  
 WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRate_Update 
 (
	@id_1	 	int, 
	@ranknum_1 int ,
	@ranklow_1 decimal (12,2)  ,
	@rankhigh_1 decimal (12,2)  ,
	@taxrate_1 decimal (12,2)  ,
	@flag	int	output, @msg	varchar(80)	output
 )  
 AS UPDATE HrmSalaryRate  SET  ranknum	 = @ranknum_1, ranklow	 = @ranklow_1, rankhigh = @rankhigh_1, taxrate=@taxrate_1  WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO




 CREATE PROCEDURE HrmSalaryRateBase_SelectAll 
 (@flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM HrmSalaryRateBase  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRateBase_Insert 
 (	@name_1 varchar(50) ,
	@taxrate_1 decimal (6,1)  ,
  @flag	int	output, @msg	varchar(80)	output) 
 AS INSERT INTO HrmSalaryRateBase ( name,taxrate)  
 VALUES ( @name_1,@taxrate_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRateBase_Delete 
 (@id_1 	int, @flag	int	output, @msg	varchar(80)	output)  AS DELETE HrmSalaryRateBase  
 WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRateBase_Update 
 (
	@id_1	 	int, 
	@name_1 varchar(50) ,
	@taxrate_1 decimal (6,1)  ,
	@flag	int	output, @msg	varchar(80)	output
 )  
 AS UPDATE HrmSalaryRateBase SET  name	 = @name_1,  taxrate=@taxrate_1  WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRateBase_SelectByID 
 (@id_1 int, @flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM HrmSalaryRateBase WHERE id=@id_1 set @flag = 1 set @msg = 'OK!' 
GO









 CREATE PROCEDURE HrmSalaryItem_SelectAll 
 (@flag	int	output, @msg	varchar(80)	output) 
 AS 
 SELECT * FROM HrmSalaryItem order by showorder  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryItem_Insert 
 (
 @name_1	Varchar(50)  , 
 @operationmark_1	Char(1)  ,
 @isshow_1	Char(1)   ,
 @showorder_1	int   ,
 @history_1     Char(1),
 @flag	int	output, @msg	varchar(80)	output) 
 AS
 INSERT INTO HrmSalaryItem ( name,operationmark,isshow,showorder,history)  
 VALUES ( @name_1,@operationmark_1,@isshow_1,@showorder_1,@history_1)
 set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryItem_Delete 
 (@id_1 	int, @flag	int	output, @msg	varchar(80)	output)  AS DELETE HrmSalaryItem  
 WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryItem_Update 
 (
   @id_1	int  ,
   @name_1	Varchar(50)  , 
   @operationmark_1	Char(1)  ,
   @isshow_1	Char(1)   ,
   @showorder_1	int   ,
   @history_1     Char(1),
	@flag	int	output, @msg	varchar(80)	output
 )  
 AS UPDATE HrmSalaryItem SET  name	 = @name_1,  operationmark=@operationmark_1, 
 isshow=@isshow_1,showorder=@showorder_1,history=@history_1
 WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryItem_SelectByID 
 (@id_1 int, @flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM HrmSalaryItem WHERE id=@id_1 set @flag = 1 set @msg = 'OK!' 
GO





/*工资基准等级表*/

 CREATE PROCEDURE HrmSalaryRank_SelectAll 
 (@flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM HrmSalaryRank order by itemid set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRank_Insert 
 (  @itemid_1  int,	
 @rankname_1 varchar(50) ,  
	@salary_1 decimal (12,2)  ,
  @flag	int	output, @msg	varchar(80)	output) 
 AS INSERT INTO HrmSalaryRank ( itemid,rankname,salary)  
 VALUES (@itemid_1, @rankname_1,@salary_1)
 set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRank_Delete 
 (@id_1 	int, @flag	int	output, @msg	varchar(80)	output)  AS DELETE HrmSalaryRank  
 WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRank_Update 
 (
	@id_1	 	int, 
	@itemid_1 int,
    @rankname_1 varchar(50) ,
	@salary_1 decimal (12,2)  ,
	@flag	int	output, @msg	varchar(80)	output
 )  
 AS UPDATE HrmSalaryRank SET  rankname	 = @rankname_1, itemid=@itemid_1, salary=@salary_1  WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryRank_SelectByID 
 (@id_1 int, @flag	int	output, @msg	varchar(80)	output) AS SELECT * FROM HrmSalaryRank WHERE id=@id_1 set @flag = 1 set @msg = 'OK!' 
GO



/*个人工资配置*/
 CREATE PROCEDURE HrmSalaryPersonality_SByHrmid
 (@id_1 int,
 @flag	int	output, @msg	varchar(80)	output) 
 AS
 SELECT * FROM HrmSalaryPersonality WHERE hrmid=@id_1
 set @flag = 1 set @msg = 'OK!' 
GO


 CREATE PROCEDURE HrmSalaryPersonality_Update 
 ( @id_1           int,
   @salary_1  	  decimal (12,2) ,
    @currentdate_1  char(10) ,
   	@flag	int	output, @msg	varchar(80)	output
 )
 AS 
 declare
		@itemid_1 int,
		@hrmid_1 int,
		@history_1 char(1)

 UPDATE HrmSalaryPersonality SET  salary=@salary_1  WHERE ( id = @id_1)  
 select @itemid_1=itemid, @hrmid_1 = hrmid from HrmSalaryPersonality  where id = @id_1 
 select @history_1 = history from HrmSalaryItem WHERE id = @itemid_1
 if @history_1 = '1' 
 begin
delete HrmSalaryHistory WHERE hrmid=@hrmid_1 AND itemid = @itemid_1 AND currentdate=@currentdate_1
insert INTO HrmSalaryHistory(hrmid,currentdate,itemid,salary) values(@hrmid_1,@currentdate_1,@itemid_1,@salary_1)
 end
GO


 CREATE PROCEDURE HrmSalaryPersonality_SByid
 (@id_1 int,
 @flag	int	output, @msg	varchar(80)	output) 
 AS
 SELECT itemid,salary FROM HrmSalaryPersonality WHERE id=@id_1 
 set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryPersonality_CByHrmid
 (@id_1 int,
 @flag	int	output, @msg	varchar(80)	output) 
 AS
 SELECT count(*) FROM HrmSalaryPersonality WHERE hrmid=@id_1
 set @flag = 1 set @msg = 'OK!' 
GO




 CREATE PROCEDURE HrmSalaryPersonality_Insert
 (@joblevel_1 int, 
  @hrmid_1 int,
  @currentdate_1 char(10),
  @flag	int	output, @msg	varchar(80)	output) 
 AS
   declare
		@itemid_1 int,
		@salary_1 decimal(12,2),
		@itemid_count int,
		@history_1 char(1)


  declare salary_cursor cursor for 
  select  id from HrmSalaryItem WHERE  (id>11) AND (id<18)
  open salary_cursor fetch next from salary_cursor into @itemid_1
  while @@fetch_status=0  
		begin
		select  @itemid_count=count(itemid) from HrmSalaryRank WHERE itemid=@itemid_1 AND rankname=@joblevel_1
			if (@itemid_count = 0) 
				begin 
				select @salary_1= min(salary) from HrmSalaryRank WHERE itemid=@itemid_1
				end
			else
			    begin
				select @salary_1=salary from HrmSalaryRank WHERE itemid=@itemid_1 AND rankname=@joblevel_1
				end
			    insert INTO HrmSalaryPersonality(itemid,hrmid,salary) values(@itemid_1,@hrmid_1,@salary_1)
				select @history_1 = history from HrmSalaryItem WHERE id = @itemid_1
				if @history_1 = '1' 
				insert INTO HrmSalaryHistory(hrmid,currentdate,itemid,salary) values(@hrmid_1,@currentdate_1,@itemid_1,@salary_1)
				fetch next from salary_cursor into @itemid_1
		end
		close salary_cursor deallocate salary_cursor 
		select * from HrmSalaryPersonality WHERE hrmid=@hrmid_1 order by itemid
GO	
	


 CREATE PROCEDURE HrmSalaryResult_Insert
 (@yearmonth_1 varchar(7),
 @flag	int	output, @msg	varchar(80)	output) 
 AS
  declare
		@itemid_1 int,
		@hrmid_1 int,
		@salary_1 decimal(12,2),
		@all_cursor	cursor
SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR	
select  itemid, hrmid, salary from HrmSalaryPersonality   
OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @itemid_1,@hrmid_1,@salary_1
WHILE @@FETCH_STATUS = 0 
begin 
	INSERT INTO HrmSalaryResult (  itemid, hrmid , salary, yearmonth)  VALUES (  @itemid_1, @hrmid_1, @salary_1, @yearmonth_1)
	FETCH NEXT FROM @all_cursor INTO @itemid_1,@hrmid_1,@salary_1
end 
CLOSE @all_cursor DEALLOCATE @all_cursor
 set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryResult_send 
 (@yearmonth_1 varchar(7),
 @flag	int	output, @msg	varchar(80)	output) 
 AS UPDATE HrmSalaryResult SET  	 isvalidate=1  WHERE ( yearmonth	 = @yearmonth_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryResult_SByHrmid
 (@hrmid_1 int,
 @yearmonth_1 varchar(7),
 @flag	int	output, @msg	varchar(80)	output) 
 AS
 SELECT * FROM HrmSalaryResult WHERE hrmid=@hrmid_1 AND yearmonth=@yearmonth_1 order by itemid
 set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryResult_SByid
 (@id_1 int,
 @flag	int	output, @msg	varchar(80)	output) 
 AS
 SELECT * FROM HrmSalaryResult WHERE id=@id_1 
 set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryResult_Update 
 ( @id_1           int,
   @salary_1  	  decimal (12,2) ,
   	@flag	int	output, @msg	varchar(80)	output
 )
 AS UPDATE HrmSalaryResult SET  	 salary=@salary_1  WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 
GO

 CREATE PROCEDURE HrmSalaryResult_delete
 (@yearmonth_1 varchar(7),
 @flag	int	output, @msg	varchar(80)	output) 
 AS delete HrmSalaryResult  WHERE ( yearmonth	 = @yearmonth_1)  set @flag = 1 set @msg = 'OK!' 
GO



CREATE PROCEDURE HrmSalaryPersonality_Delete
(@hrmid_1 int,
 @flag	int	output, @msg	varchar(80)	output) 
 AS
delete HrmSalaryPersonality  WHERE ( hrmid	 = @hrmid_1)  set @flag = 1 set @msg = 'OK!' 
GO





CREATE PROCEDURE HrmSalaryHistory_SByHrmid
(@hrmid_1 int,
 @flag	int	output, @msg	varchar(80)	output)
 AS
 SELECT * FROM HrmSalaryHistory WHERE hrmid=@hrmid_1 
 set @flag = 1 set @msg = 'OK!' 
GO

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2214,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2214,'个人所得税税率表',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2214,'个人所得税税率表')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2215,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2215,'参照费率',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2215,'参照费率')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2216,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2216,'基准等级',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2216,'基准等级')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2217,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2217,'工资项目表',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2217,'工资项目表')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2218,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2218,'个人工资设置',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2218,'个人工资设置')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2219,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2219,'个人工资变动历史记录',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2219,'个人工资变动历史记录')
GO


insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('姓名','','1',1,'3')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('部门','','1',2,'3')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('职务','','1',3,'3')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('缴费工资','','1',10,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('公积金','','1',11,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('养老金','','1',12,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('失业保险','','1',13,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('医疗保险','','1',14,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('应纳税所得额','','1',15,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('个人所得税','','1',16,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('实发工资','','1',17,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('基础工资','1','1',4,'1')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('岗位技能工资','1','1',5,'1')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('考勤扣款','0','1',6,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('考勤加薪','1','1',7,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('行政处罚','0','1',8,'0')
GO
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('行政奖励','1','1',9,'0')
GO

insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (1,.00,500.00,5.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (2,500.00,2000.00,10.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (3,2000.00,5000.00,15.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (4,5000.00,20000.00,20.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (5,20000.00,40000.00,25.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (6,40000.00,60000.00,30.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (7,60000.00,80000.00,35.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (8,80000.00,100000.00,40.00)
GO
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (9,100000.00,99999999.00,45.00)
GO

insert into HrmSalaryRateBase (name,taxrate) values ('个调税起征点',1000)
GO
insert into HrmSalaryRateBase (name,taxrate) values ('公积金',0)
GO
insert into HrmSalaryRateBase (name,taxrate) values ('养老金',0)
GO
insert into HrmSalaryRateBase (name,taxrate) values ('失业保险',0)
GO
insert into HrmSalaryRateBase (name,taxrate) values ('医疗保险',0)
GO

insert into HrmSalaryRank (itemid,rankname,salary) values (12,'0',1000)
GO
insert into HrmSalaryRank (itemid,rankname,salary) values (13,'0',1000)
GO
insert into HrmSalaryRank (itemid,rankname,salary) values (14,'0',0)
GO
insert into HrmSalaryRank (itemid,rankname,salary) values (15,'0',0)
GO
insert into HrmSalaryRank (itemid,rankname,salary) values (16,'0',0)
GO
insert into HrmSalaryRank (itemid,rankname,salary) values (17,'0',0)
GO

create table SMS_Message
(
id int IDENTITY(1,1) not null, 
message varchar(100) null,			/*短信内容*/
recievenumber varchar(7500) null,   /*接受人的手机号码*/
sendmark char(1) default 0,			/*是否发送成功或未发送：若为未发送短信为0*/
sendnumber varchar(12) default 0,   /*发送人的手机号码：若为系统发送为0*/
requestid int default 0,			/*工作流id：若是用户自编短信则为0*/
userid int default 0,				/*发送人的id对应人力资源中的hrmid；若是系统为0*/
usertype char(1) default 0,			/*发送人类型：0为公司员工，1为外部人员*/
mobilenumber int default 1	,		/*发送短信的个数：每次发送的手机号之和；若为系统发送为1*/
senddate varchar(12) null           /*发送日期*/
)
GO


/*用户自编写短信存到表的存储过程：sendmark参数不用传入，未发送则为系统默认值0*/
create Procedure SMS_Message_insert
	@message_1 varchar(100) ,
	@recievenumber_1 varchar(8000) ,
	@sendmark_1 char(1),
	@sendnumber_1 varchar(12),
	@requestid_1 int,
	@userid_1 int,
	@usertype_1 char(1),
	@mobilenumber_1 int,
	@senddate_1 varchar(12),
	@flag		int	output, 
	@msg		varchar(80) output
as
insert INTO SMS_Message
(message,recievenumber,sendmark,sendnumber,requestid,userid,usertype,mobilenumber,senddate)
values
(@message_1,@recievenumber_1,@sendmark_1,@sendnumber_1,@requestid_1,@userid_1,@usertype_1,@mobilenumber_1,@senddate_1)
GO



create Procedure SMS_Message_SelectAll
	@flag		int	output, 
	@msg		varchar(80) output
as
SELECT  userid,sendnumber,mobilenumber,senddate  from  SMS_Message WHERE userid<>0
go


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2220,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2220,'短信服务',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2220,'短信服务')

insert into HtmlLabelInfo (indexid,labelname,languageid) values (2221,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2221,'短信服务管理',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2221,'短信服务管理')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2222,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2222,'短信服务管理-用户自编短信统计',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2222,'短信服务管理－用户自编短信统计')
go
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2223,'',8)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2223,'短信服务管理-系统发送短信统计',7)
GO
insert into HtmlLabelIndex (id,indexdesc) values (2223,'短信服务管理－系统发送短信统计')
go



/* 会议 */
CREATE TABLE [Meeting_ShareDetail] (
	[meetingid] [int] NULL ,
	[userid] [int] NULL ,
	[usertype] [int] NULL ,
	[sharelevel] [int] NULL 
)
GO


CREATE TABLE [MeetingRoom] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (100)  NULL ,
	[roomdesc] [varchar] (100)  NULL ,
	[hrmid] [int] NULL 
)
GO

/* 资产入库 */
CREATE TABLE [CptStockInMain] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[invoice] [varchar] (80)  NULL ,
	[buyerid] [int] NULL ,
	[supplierid] [int] NULL ,
	[checkerid] [int] NULL ,
	[stockindate] [char] (10)  NULL ,
	[ischecked] [int] NULL 
)
GO

CREATE TABLE [CptStockInDetail] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[cptstockinid] [int] NULL ,
	[cpttype] [int] NULL ,
	[plannumber] [int] NULL ,
	[innumber] [int] NULL ,
	[price] [decimal](10, 2) NULL 
)
GO

/*会议*/

 CREATE PROCEDURE MeetingShareDetail_DById 
	(@meetingid_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [Meeting_ShareDetail] 
WHERE 
	( [meetingid]	 = @meetingid_1)

GO

CREATE PROCEDURE MeetingShareDetail_Insert 
	(@meetingid_1 int ,
	 @userid_1 int ,
	 @usertype_1 int ,
	 @sharelevel_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 
DECLARE	@count integer
select @count = count(userid) from Meeting_ShareDetail where meetingid=@meetingid_1 and userid=@userid_1 and usertype=@usertype_1
if @count=0 begin
		INSERT INTO [Meeting_ShareDetail] 
		 ([meetingid],
		 [userid],
		 [usertype],
		 [sharelevel]) 
		VALUES 
		(@meetingid_1,
		 @userid_1,
		 @usertype_1,
		 @sharelevel_1)
	   end
else begin
		update Meeting_ShareDetail 
		set sharelevel=@sharelevel_1 where meetingid=@meetingid_1 and userid=@userid_1 and usertype=@usertype_1 and sharelevel>@sharelevel_1  
     end 
GO



CREATE PROCEDURE MeetingRoom_Insert 
	(@name_1 [varchar](100) ,
	 @roomdesc_1 [varchar](100) ,
	 @hrmid_1 int ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS 

INSERT INTO [MeetingRoom] 
		 ([name],
		 [roomdesc],
		 [hrmid]) 
		VALUES 
		(@name_1,
		 @roomdesc_1,
		 @hrmid_1)

GO



 CREATE PROCEDURE MeetingRoom_DeleById 
	(@id_1 	[int] ,
	 @flag	[int]	output, 
	 @msg	[varchar](80)	output)
AS DELETE [MeetingRoom] 
WHERE 
	( [id]	 = @id_1)

GO


 CREATE PROCEDURE MeetingRoom_SelectAll 
 ( @flag	[int]	output, 
 @msg	[varchar](80)	output) 
 AS 
 SELECT * FROM [MeetingRoom] order by id 

GO


 CREATE PROCEDURE MeetingRoom_SelectById 
 (@id_1 	[int] ,
 @flag	[int]	output, 
 @msg	[varchar](80)	output) 
 AS 
 SELECT * FROM [MeetingRoom] where id= @id_1

GO

 CREATE PROCEDURE MeetingRoom_Update 
 (@id_1 	[int] ,
 @name_1 [varchar](100) ,
 @roomdesc_1 [varchar](100) ,
 @hrmid_1 int ,
 @flag	[int]	output, 
 @msg	[varchar](80)	output) 
 AS 

 Update [MeetingRoom] set  name=@name_1, roomdesc=@roomdesc_1, hrmid=@hrmid_1  where id= @id_1

GO


/* 资产入库 */
CREATE PROCEDURE CptStockInMain_Insert (
	@invoice_1 [varchar] (80) ,
	@buyerid_1 [int] ,
	@supplierid_1 [int] ,
	@checkerid_1 [int] ,
	@stockindate_1 [char] (10) ,
	@ischecked_1 [int] , 
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
INSERT INTO [CptStockInMain] 
		 ([invoice],
		 [buyerid],
		 [supplierid],
		 [checkerid],
		 [stockindate],
		 [ischecked]) 
	VALUES 
	(@invoice_1,
	@buyerid_1,
	@supplierid_1,
	@checkerid_1,
	@stockindate_1,
	@ischecked_1)
select max(id) from CptStockInMain
GO

CREATE PROCEDURE CptStockInMain_SelectByid (
	@id_1 [int] ,
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
select * from CptStockInMain where id = @id_1
GO

CREATE PROCEDURE CptStockInMain_Update (
	@id_1 [int] ,
	@invoice_1 [varchar] (80) ,
	@buyerid_1 [int] ,
	@supplierid_1 [int] ,
	@checkerid_1 [int] ,
	@stockindate_1 [char] (10) ,
	@ischecked_1 [int] , 
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
update CptStockInMain set invoice=@invoice_1, buyerid=@buyerid_1 , supplierid=@supplierid_1 , checkerid=@checkerid_1, stockindate=@stockindate_1 , ischecked=@ischecked_1  where id = @id_1
GO

CREATE PROCEDURE CptStockInDetail_Insert (
	@cptstockinid_1 [int]  ,
	@cpttype_1 [int]  ,
	@plannumber_1 [int]  ,
	@innumber_1 [int]  ,
	@price_1 [decimal](10, 2)  ,
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
INSERT INTO [CptStockInDetail] 
		 ([cptstockinid],
		 [cpttype],
		 [plannumber],
		 [innumber],
		 [price]) 
	VALUES 
	(@cptstockinid_1,
	@cpttype_1,
	@plannumber_1,
	@innumber_1 ,
	@price_1)
select max(id) from CptStockInDetail
GO

CREATE PROCEDURE CptStockInDetail_SByStockid (
	@cptstockinid_1 [int] ,
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
select * from CptStockInDetail where cptstockinid = @cptstockinid_1
GO

CREATE PROCEDURE CptStockInDetail_Update (
	@id_1 [int] ,
	@innumber_1 [int] , 
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
update CptStockInDetail set  innumber=@innumber_1  where id = @id_1
GO

CREATE PROCEDURE CptStockInDetail_Delete (
	@id_1 [int] ,
	@flag	[int]	output, 
	@msg	[varchar](80)	output
)
AS 
delete CptStockInDetail where id = @id_1
GO


/*修改的*/
 AlTER PROCEDURE CptUseLogInStock_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @checkerid 	[int],
	 @usecount_5 	[decimal](18,3),
	 @useaddress_6 	[varchar](200),
	 @userequest_7 	[int],
	 @maintaincompany_8 [varchar](100),
	 @fee_9 			[decimal](18,3),
	 @usestatus_10 		[varchar](2),
	 @remark_11 		[text],
	 @mark				[varchar](60),
	 @datatype			[int],
	 @startdate			[char](10),
	 @enddate			[char](10),
	 @deprestartdate	[char](10),
	 @depreenddate		[char](10),
	 @manudate			[char](10),
	 @lastmoderid		[int],
	 @lastmoddate		[char](10),
	 @lastmodtime    	[char](8),
	 @inprice		[decimal](18,3),
	 @crmid		[int],
	 @counttype		[char](1),
	 @isinner		[char](1),
	 @flag integer output,
	 @msg varchar(80) output)

AS
if @usestatus_10='2'
begin
	 INSERT INTO [CptUseLog] 
		 ( [capitalid],
		 [usedate],
		 [usedeptid],
		 [useresourceid],
		 [usecount],
		 [useaddress],
		 [userequest],
		 [maintaincompany],
		 [fee],
		 [usestatus],
		 [remark]) 
	 
	VALUES 
		( @capitalid_1,
		 @usedate_2,
		 @usedeptid_3,
		 @checkerid,
		 @usecount_5,
		 @useaddress_6,
		 @userequest_7,
		 @maintaincompany_8,
		 @fee_9,
		'1',
		 @remark_11)
end

 INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [useaddress],
	 [userequest],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @useaddress_6,
	 @userequest_7,
	 @maintaincompany_8,
	 @fee_9,
	@usestatus_10,
	 @remark_11)

declare @num decimal(18,3)
select @num=capitalnum from CptCapital where id = @capitalid_1

if @usestatus_10 = '1'
begin
    set @useresourceid_4 = 0
end

if @usedeptid_3 = 0 
begin
set @usedeptid_3 = null 
end

Update CptCapital
Set 
mark = @mark,
capitalnum = @usecount_5+@num,
location = @useaddress_6,
departmentid = @usedeptid_3,
resourceid   = @useresourceid_4,
stateid = @usestatus_10,
datatype = @datatype,
isdata = '2',
startdate = @startdate,
enddate = @enddate,
deprestartdate = @deprestartdate,
depreenddate = @depreenddate,
manudate = @manudate,
[lastmoderid] = @lastmoderid,
[lastmoddate] = @lastmoddate,
[lastmodtime] = @lastmodtime,
[startprice]  = @inprice,
[customerid]		  =	@crmid,
[counttype]    = @counttype,
[isinner]     = @isinner
where id = @capitalid_1

GO

/* 会议室维护 */
insert into SystemRights(id,rightdesc,righttype) values(350,'会议室维护','0')
GO

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(350,7,'会议室维护','会议室维护')
GO

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(350,8,'','')
GO

insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2050,'会议室添加','MeetingRoomAdd:Add',350)
GO
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2051,'会议室编辑','MeetingRoomEdit:Edit',350)
GO
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2052,'会议室删除','MeetingRoomDelete:Delete',350)
GO
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2053,'会议室日志','MeetingRoom:Log',350)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (350,11,'1')
GO

insert into SystemRightToGroup (groupid,rightid) values (10,350)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6050,'资产验收入库')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6050,'资产验收入库',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6050,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6051,'资产借用')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6051,'资产借用',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6051,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6052,'资产报废')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6052,'资产报废',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6052,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6053,'资产维修')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6053,'资产维修',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6053,'',8)
GO

insert into HtmlLabelIndex (id,indexdesc) values (6054,'资产减损')
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6054,'资产减损',7)
GO
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6054,'',8)
GO


create procedure Capital_Adjust
	(
	@capitalid_1 int,
	@usedate_1 varchar(12),
	@usedeptid_1 int,
	@useresourceid_1 int,
	@usecount_1 int,
	@useaddress_1 varchar(200),
	@usestatus_1 varchar(2),
	@remark_1 text,
	@olddeptid_1 int,
	@flag integer output,
	@msg varchar(80) output
	)
as
insert INTO CptUseLog
	( capitalid,
	  usedate,
	  usedeptid,
	  useresourceid,
	  usecount,
	  useaddress,
	  usestatus,
	  remark,
	  olddeptid)
  values
  (
	@capitalid_1  ,
	@usedate_1  ,
	@usedeptid_1  ,
	@useresourceid_1  ,
	@usecount_1  ,
	@useaddress_1   ,
	@usestatus_1   ,
	@remark_1  ,
	@olddeptid_1  )


update CptCapital
set
departmentid = @usedeptid_1  ,
resourceid = @useresourceid_1        
WHERE id=@capitalid_1
go



/*资产流程新增:资产领用*/
 ALTER PROCEDURE CptUseLogUse_Insert 
	(@capitalid_1 	[int],
	 @usedate_2 	[char](10),
	 @usedeptid_3 	[int],
	 @useresourceid_4 	[int],
	 @usecount_5 	decimal(18,3),
	 @maintaincompany_8 	[varchar](100),
	 @fee_9 	[decimal](18,3),
	 @usestatus_10 	[varchar](2),
	 @remark_11 	[text],
	 @sptcount	[char](1),

	 @flag integer output,
	 @msg varchar(80) output)

AS 
declare @num decimal(18,3)


/*判断数量是否足够(对于非单独核算的资产*/
if @sptcount<>'1'
begin
   select @num=capitalnum  from CptCapital where id = @capitalid_1
   if @num<@usecount_5
   begin
	select -1
	return
   end
   else
   begin
	select @num = @num-@usecount_5
   end
end

INSERT INTO [CptUseLog] 
	 ( [capitalid],
	 [usedate],
	 [usedeptid],
	 [useresourceid],
	 [usecount],
	 [maintaincompany],
	 [fee],
	 [usestatus],
	 [remark],
	 [olddeptid]) 
 
VALUES 
	( @capitalid_1,
	 @usedate_2,
	 @usedeptid_3,
	 @useresourceid_4,
	 @usecount_5,
	 @maintaincompany_8,
	 @fee_9,
	 '2',
	 @remark_11,
              0)

/*单独核算的资产*/
if @sptcount='1'
begin
	Update CptCapital
	Set 
	departmentid = @usedeptid_3,
	resourceid   = @useresourceid_4,
	stateid = @usestatus_10
	where id = @capitalid_1
end
/*非单独核算的资产*/
else 
begin
	Update CptCapital
	Set
	capitalnum = @num
	where id = @capitalid_1
end

select 1
GO