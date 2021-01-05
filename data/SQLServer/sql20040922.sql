/*开发者：刘煜 功能：人力资源的工资与考勤功能*/
alter PROCEDURE HrmArrangeShift_SelectAll
(@ishistory_1 char(1),
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select * from HrmArrangeShift where ishistory = @ishistory_1 order by id
GO

/* 人力资源排班人员表 记录属于排班的人*/

create table HrmArrangeShiftSet (
id int IDENTITY (1, 1) NOT NULL ,
resourceid int
)
GO

CREATE PROCEDURE HrmArrangeShiftSet_Insert 
(
 @resourceid_2 	 varchar(60),
 @flag        integer output,
 @msg         varchar(80) output
)  
AS 
 INSERT INTO HrmArrangeShiftSet (resourceid) VALUES (@resourceid_2)
GO

CREATE PROCEDURE HrmArrangeShiftSet_Delete 
(
 @flag        integer output,
 @msg         varchar(80) output
)  
AS 
 delete HrmArrangeShiftSet 
GO


/* 公众假日，改为工作时间调整 */

alter table HrmPubHoliday add 
changetype int,   /* 调整类型 ： 1：设置为法定假日 2： 设置为工作日 3： 设置为休息日 */
relateweekday int  /* 设置为工作日的时候对应的星期 1: 星期日 2:星期一 .... 7:星期六 */
GO

update HrmPubHoliday set changetype = 1
GO

alter PROCEDURE HrmPubHoliday_Insert 
(@countryid_1 	int, 
 @holidaydate_2 	char(10), 
 @holidayname_3 	varchar(200), 
 @changetype_4  int ,
 @relateweekday_5 int ,
 @flag integer output, 
 @msg varchar(80) output)  
AS 
 if  not exists( select * from hrmpubholiday where countryid=@countryid_1 and holidaydate=@holidaydate_2) 
 begin 
     INSERT INTO HrmPubHoliday ( countryid, holidaydate, holidayname,changetype,relateweekday)  
     VALUES ( @countryid_1, @holidaydate_2, @holidayname_3,@changetype_4,@relateweekday_5) 
 end 
 select max(id) from hrmpubholiday 
GO


alter PROCEDURE HrmPubHoliday_Update 
 (@id_1 int, 
  @holidayname_2 	varchar(200), 
  @changetype_4  int ,
  @relateweekday_5 int ,
  @flag integer output, 
  @msg varchar(80) output)  
  AS 
  update HrmPubHoliday set 
  holidayname=@holidayname_2 ,
  changetype=@changetype_4 ,
  relateweekday=@relateweekday_5 
  where id=@id_1 
GO


alter table HrmkqSystemSet add 
getdatatype int,   /* 数据采集方式 */
getdatavalue varchar(200) ,  /* 各个方式的值 */
avgworkhour int  /* 平均每月工作时间(小时) */
GO

delete HrmkqSystemSet
GO

insert into HrmkqSystemSet values('',60,1,'1',172)
GO

alter PROCEDURE HrmkqSystemSet_Update(
@tosomeone_1  varchar(60) ,
@timeinterval_2  int , 
@getdatatype_3  int , 
@getdatavalue_4  varchar(200) , 
@avgworkhour_5  int , 
@flag int output, 
@msg varchar(80) output) 
AS 
update HrmkqSystemSet 
set 
tosomeone = @tosomeone_1 , 
timeinterval = @timeinterval_2 ,
getdatatype = @getdatatype_3 , 
getdatavalue = @getdatavalue_4 , 
avgworkhour = @avgworkhour_5  
GO



/* 对打卡记录增加一个有效的记录列表, 以便进行统计 */

CREATE TABLE HrmRightCardInfo (
	id int identity(1,1) not null primary key ,
    resourceid int, /*人力资源id*/
    carddate char(10) null , /*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
    cardtime char(5) null ,  /*打卡时间，格式：hh:nn(08:12)*/
    inorout  int ,           /*出公司还是入公司 0:出 1:入 现在暂时不用 */
    islegal int default 1 /* 考勤的合法性, 合法 1, 不合法 2 */
)
GO


CREATE PROCEDURE HrmRightCardInfo_Insert (
@resourceid_2 int , /*卡钟的台号*/
@carddate_3 char(10),/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
@cardtime_4 char(5) , /*打卡时间，格式：hh:nn(08:12)*/
@inorout_5  int ,           /*出公司还是入公司 0:出 1:入 现在暂时不用 */
@flag        integer output ,
@msg         varchar(80) output)  

 AS

 INSERT INTO HrmRightCardInfo (
 resourceid , 
 carddate , 
 cardtime , 
 inorout            
 ) 
 VALUES (
 @resourceid_2 , 
 @carddate_3 , 
 @cardtime_4 , 
 @inorout_5 
 ) 
 
 declare @cardcount int , @reccount int 
 select @cardcount = count(id) from HrmRightCardInfo where carddate = @carddate_3 and resourceid = @resourceid_2 

 if @cardcount > 2  /* 一天打卡超过3次 */
 begin
    select @reccount = count(id) from HrmArrangeShiftSet where resourceid = @resourceid_2
    if @reccount = 0   /* 是按照一般工作时间计算, 认为不正常 */
    begin
        update HrmRightCardInfo set islegal = 2 where carddate = @carddate_3 and resourceid = @resourceid_2 
    end
    else /* 按照排班计算, 计算当天的排班数量 */
    begin
        select @reccount = count(id) from HrmArrangeShiftInfo where resourceid = @resourceid_2 and shiftdate = @carddate_3
        if @reccount * 2 < @cardcount   /* 打卡次数超过排班次数*2 , 认为不正常 */
        begin
            update HrmRightCardInfo set islegal = 2 where carddate = @carddate_3 and resourceid = @resourceid_2 
        end
    end
 end
GO


alter PROCEDURE HrmArrangeShiftInfo_Save (
 @resourceid_2 int ,
 @shiftdate_3 char (10) ,
 @shiftid_4 int	,
 @flag        integer output,
 @msg         varchar(80) output)  
 AS 
 declare @count int
 select @count = count(shiftid) from HrmArrangeShiftInfo 
 where  resourceid=@resourceid_2 and shiftdate = @shiftdate_3 and shiftid=@shiftid_4
 if @count is null or @count = 0
    INSERT INTO HrmArrangeShiftInfo(resourceid,shiftdate,shiftid) 
    VALUES(@resourceid_2,@shiftdate_3, @shiftid_4)
go

drop PROCEDURE HrmArrangeShiftProcess_Save
GO


CREATE PROCEDURE HrmRightCardInfo_Delete (
@id_1 int ,
@flag        integer output ,
@msg         varchar(80) output)  

 AS

 declare @resourceid_2 int , @carddate_3 char(10) 

 select @resourceid_2 = resourceid , @carddate_3 = carddate from HrmRightCardInfo where id = @id_1

 delete HrmRightCardInfo where id = @id_1

 declare @cardcount int , @reccount int 
 select @cardcount = count(id) from HrmRightCardInfo where carddate = @carddate_3 and resourceid = @resourceid_2 

 if @cardcount <= 2  /* 一天打卡不超过2次 认为正常*/
 begin
    update HrmRightCardInfo set islegal = 1 where carddate = @carddate_3 and resourceid = @resourceid_2 
 end
 else 
 begin
    select @reccount = count(id) from HrmArrangeShiftSet where resourceid = @resourceid_2
    if @reccount > 0   /* 按照排班计算, 计算当天的排班数量 */
    begin
        select @reccount = count(id) from HrmArrangeShiftInfo where resourceid = @resourceid_2 and shiftdate = @carddate_3
        if @reccount * 2 >= @cardcount   /* 打卡次数不超过排班次数*2 , 认为正常 */
        begin
            update HrmRightCardInfo set islegal = 1 where carddate = @carddate_3 and resourceid = @resourceid_2 
        end
     end
 end
GO


alter table HrmTimecardInfo add relateshiftid int 
GO

alter PROCEDURE HrmTimecardInfo_Update
	(@resourceid_1 	int,
	 @timecarddate_3 	char(10),
	 @intime_4 	char(5),
	 @outtime_5 	char(5),
     @relateshiftid_6  int ,
	 @flag		int	output, 
	 @msg		varchar(80) output)

AS 
insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
values(@resourceid_1,@timecarddate_3,@intime_4 , @outtime_5 ,@relateshiftid_6)
GO

alter PROCEDURE HrmArrangeShift_Select
(@flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select id , shiftbegintime, shiftendtime from HrmArrangeShift order by shiftbegintime
GO

alter table HrmRightCardInfo add workout int default 0  /* 是否为加班 (在无效页面转入加班) 0 : 否 1 : 是 */
GO

update HrmRightCardInfo set workout = 0 
GO

/* 修改打卡记入录入, 增加转入加班的判断 */

alter PROCEDURE HrmRightCardInfo_Insert (   
@resourceid_2 int , /*卡钟的台号*/
@carddate_3 char(10),/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
@cardtime_4 char(5) , /*打卡时间，格式：hh:nn(08:12)*/
@inorout_5  int ,           /*出公司还是入公司 0:出 1:入 现在暂时不用 */
@flag        integer output ,
@msg         varchar(80) output)  

 AS
 declare @cardcount int , @reccount int 
 select @cardcount = count(id) from HrmRightCardInfo where carddate = @carddate_3 and resourceid = @resourceid_2 and cardtime = @cardtime_4 
 if @cardcount = 0
 begin      /* 只有不相同的打卡才录入 开始*/
 
     INSERT INTO HrmRightCardInfo (
     resourceid , 
     carddate , 
     cardtime , 
     inorout            
     ) 
     VALUES (
     @resourceid_2 , 
     @carddate_3 , 
     @cardtime_4 , 
     @inorout_5 
     ) 
     
     
     select @cardcount = count(id) from HrmRightCardInfo where carddate = @carddate_3 and resourceid = @resourceid_2 and workout = 0 

     if @cardcount > 2  /* 一天非加班打卡超过3次 */
     begin
        select @reccount = count(id) from HrmArrangeShiftSet where resourceid = @resourceid_2
        if @reccount = 0   /* 是按照一般工作时间计算, 认为不正常 */
        begin
            update HrmRightCardInfo set islegal = 2 where carddate = @carddate_3 and resourceid = @resourceid_2 
        end
        else /* 按照排班计算, 计算当天的排班数量 */
        begin
            select @reccount = count(id) from HrmArrangeShiftInfo where resourceid = @resourceid_2 and shiftdate = @carddate_3
            if @reccount * 2 < @cardcount   /* 打卡次数超过排班次数*2 , 认为不正常 */
            begin
                update HrmRightCardInfo set islegal = 2 where carddate = @carddate_3 and resourceid = @resourceid_2 
            end
        end
     end

 end   /* 只有不相同的打卡才录入 结束*/
GO

/* 修改删除无效打卡记入, 增加转入加班的判断 */
alter PROCEDURE HrmRightCardInfo_Delete (
@id_1 int ,
@flag        integer output ,
@msg         varchar(80) output)  

 AS

 declare @resourceid_2 int , @carddate_3 char(10) 

 select @resourceid_2 = resourceid , @carddate_3 = carddate from HrmRightCardInfo where id = @id_1

 delete HrmRightCardInfo where id = @id_1

 declare @cardcount int , @reccount int 
 select @cardcount = count(id) from HrmRightCardInfo where carddate = @carddate_3 and resourceid = @resourceid_2 and workout = 0 

 if @cardcount <= 2  /* 一天非加班打卡不超过2次 认为正常*/
 begin
    update HrmRightCardInfo set islegal = 1 where carddate = @carddate_3 and resourceid = @resourceid_2 
 end
 else 
 begin
    select @reccount = count(id) from HrmArrangeShiftSet where resourceid = @resourceid_2
    if @reccount > 0   /* 按照排班计算, 计算当天的排班数量 */
    begin
        select @reccount = count(id) from HrmArrangeShiftInfo where resourceid = @resourceid_2 and shiftdate = @carddate_3
        if @reccount * 2 >= @cardcount   /* 打卡次数不超过排班次数*2 , 认为正常 */
        begin
            update HrmRightCardInfo set islegal = 1 where carddate = @carddate_3 and resourceid = @resourceid_2 
        end
     end
 end
GO

/* 转入加班的无效打卡记入, 增加转入加班的判断 */
CREATE PROCEDURE HrmRightCardInfo_AddWork (
@id_1 int ,
@flag        integer output ,
@msg         varchar(80) output)  

 AS

 declare @resourceid_2 int , @carddate_3 char(10) 

 select @resourceid_2 = resourceid , @carddate_3 = carddate from HrmRightCardInfo where id = @id_1

 update HrmRightCardInfo set workout = 2 where id = @id_1

 declare @cardcount int , @reccount int 
 select @cardcount = count(id) from HrmRightCardInfo where carddate = @carddate_3 and resourceid = @resourceid_2 and workout = 0 

 if @cardcount <= 2  /* 一天非加班打卡不超过2次 认为正常*/
 begin
    update HrmRightCardInfo set islegal = 1 where carddate = @carddate_3 and resourceid = @resourceid_2 
 end
 else 
 begin
    select @reccount = count(id) from HrmArrangeShiftSet where resourceid = @resourceid_2
    if @reccount > 0   /* 按照排班计算, 计算当天的排班数量 */
    begin
        select @reccount = count(id) from HrmArrangeShiftInfo where resourceid = @resourceid_2 and shiftdate = @carddate_3
        if @reccount * 2 >= @cardcount   /* 打卡次数不超过排班次数*2 , 认为正常 */
        begin
            update HrmRightCardInfo set islegal = 1 where carddate = @carddate_3 and resourceid = @resourceid_2 
        end
     end
 end
GO

alter PROCEDURE HrmTimecardUser_Update
	(@resourceid_1 	int,
	 @usercode_2 	varchar(60),
	 @flag		int	output, 
	 @msg		varchar(80) output)

AS 
declare @count int

select @count= count(usercode) from HrmTimecardUser 
where resourceid != @resourceid_1 and usercode = @usercode_2 and usercode is not null and usercode != '' 
if @count is not null and @count > 0 
begin
    select -1 
    return 
end

select @count= count(resourceid) from HrmTimecardUser where resourceid = @resourceid_1
if @count is not null and @count > 0 
    update HrmTimecardUser set usercode = @usercode_2 where resourceid = @resourceid_1
else
    insert into HrmTimecardUser(resourceid,usercode) values(@resourceid_1,@usercode_2 )

select 1

GO


/* 人力资源工资项目关联出勤杂费信息表 */
create table HrmSalaryResourcePay(
id	int IDENTITY (1, 1) NOT NULL  primary key,
itemid  int ,                           /*工资项目id*/
resourceid  int ,                          /*人力资源id*/
resourcepay  decimal(10,2)                 /*金额*/
)
GO


CREATE PROCEDURE HrmSalaryResourcePay_SByItemid
	(@itemid_1 	int,
     @flag	int	output, 
     @msg	varchar(80)	output)

AS 
Select * from HrmSalaryResourcePay where itemid = @itemid_1 
GO

CREATE PROCEDURE HrmSalaryResourcePay_Insert
	(@itemid_1 	int,
	 @resourceid_2 	int,
	 @resourcepay_3 	decimal(10,2),	
     @flag	int	output, 
     @msg	varchar(80)	output)

AS INSERT INTO HrmSalaryResourcePay 
	 ( itemid,
	 resourceid,
	 resourcepay) 
 
VALUES 
	( @itemid_1,
	 @resourceid_2,
	 @resourcepay_3)
GO


CREATE PROCEDURE HrmSalaryResourcePay_Delete
	(@itemid_1 	int,	
     @flag	int	output, 
     @msg	varchar(80)	output)

AS DELETE HrmSalaryResourcePay 
WHERE ( itemid	 = @itemid_1)

GO


alter PROCEDURE HrmSalaryItem_Update
	(@id_1 	int,
	 @itemname_2 	varchar(50),
	 @itemcode_3 	varchar(50),
	 @itemtype_4 	char(1),
	 @personwelfarerate_5 	int,
	 @companywelfarerate_6 	int,
	 @taxrelateitem_7 	int,
	 @amountecp_8 	varchar(200),
	 @feetype_9 	int,
	 @isshow_10 	char(1),
	 @showorder_11 	int,
	 @ishistory_12 	char(1) ,
     @flag          integer output, 
     @msg           varchar(80) output)

AS 
declare @olditemtype_1 char(1) 
declare @benchid_1 int

select @olditemtype_1 = itemtype from HrmSalaryItem where id = @id_1 
UPDATE HrmSalaryItem 
SET  itemname	 = @itemname_2,
	 itemcode	 = @itemcode_3,
	 itemtype	 = @itemtype_4,
	 personwelfarerate	 = @personwelfarerate_5,
	 companywelfarerate	 = @companywelfarerate_6,
	 taxrelateitem	 = @taxrelateitem_7,
	 amountecp	 = @amountecp_8,
	 feetype	 = @feetype_9,
	 isshow	 = @isshow_10,
	 showorder	 = @showorder_11,
	 ishistory	 = @ishistory_12 

WHERE 
	( id	 = @id_1)

if @olditemtype_1 = '1' or @olditemtype_1 = '2'
    delete from HrmSalaryRank where itemid = @id_1
else if @olditemtype_1 = '5' or @olditemtype_1 = '6'
    delete from HrmSalarySchedule where itemid = @id_1
else if @olditemtype_1 = '7'
    delete from HrmSalaryShiftPay where itemid = @id_1
else if @olditemtype_1 = '8'
    delete from HrmSalaryResourcePay where itemid = @id_1
else if @olditemtype_1 = '3'
begin
    declare benchid_cursor cursor for
    select id from HrmSalaryTaxbench where itemid = @id_1 
    open benchid_cursor 
    fetch next from benchid_cursor into @benchid_1
    while @@fetch_status=0
    begin 
        delete from HrmSalaryTaxrate where benchid = @benchid_1
        delete from HrmSalaryTaxbench where id = @benchid_1
        fetch next from benchid_cursor into @benchid_1
    end
    close benchid_cursor deallocate benchid_cursor
end
GO


alter PROCEDURE HrmSalaryItem_Delete
	(@id_1 	int ,
     @flag          integer output, 
     @msg           varchar(80) output)
AS 
declare @olditemtype_1 char(1) 
declare @benchid_1 int
select @olditemtype_1 = itemtype from HrmSalaryItem where id = @id_1 

DELETE HrmSalaryItem 
WHERE ( id	 = @id_1)

if @olditemtype_1 = '1'
    delete from HrmSalaryRank where itemid = @id_1 
else if @olditemtype_1 = '5' or @olditemtype_1 = '6'
    delete from HrmSalarySchedule where itemid = @id_1
else if @olditemtype_1 = '7'
    delete from HrmSalaryShiftPay where itemid = @id_1
else if @olditemtype_1 = '8'
    delete from HrmSalaryResourcePay where itemid = @id_1
else if @olditemtype_1 = '2'
begin
    delete from HrmSalaryRank where itemid = @id_1 
    delete from HrmSalaryWelfarerate where itemid = @id_1 
end
else if @olditemtype_1 = '3'
begin
    declare benchid_cursor cursor for
    select id from HrmSalaryTaxbench where itemid = @id_1 
    open benchid_cursor 
    fetch next from benchid_cursor into @benchid_1
    while @@fetch_status=0
    begin 
        delete from HrmSalaryTaxrate where benchid = @benchid_1
        delete from HrmSalaryTaxbench where id = @benchid_1
        fetch next from benchid_cursor into @benchid_1
    end
    close benchid_cursor deallocate benchid_cursor
end
GO

alter PROCEDURE HrmSalaryShiftPay_Insert
	(@itemid_1 	int,
	 @shiftid_2 	int,
	 @shiftpay_3 	decimal(10,2),	
     @flag	int	output, 
     @msg	varchar(80)	output)

AS INSERT INTO HrmSalaryShiftPay 
	 ( itemid,
	 shiftid,
	 shiftpay) 
 
VALUES 
	( @itemid_1,
	 @shiftid_2,
	 @shiftpay_3)
GO

/* 未执行 */

alter table HrmScheduleDiff alter column countnum decimal(10, 2) 
GO

alter PROCEDURE HrmScheduleDiff_Insert 
 (@diffname_1 	varchar(60), 
  @diffdesc_2 	varchar(200), 
  @difftype_3 	char(1), 
  @difftime_4 	char(1), 
  @mindifftime_5 	smallint, 
  @workflowid_6 	int, 
  @salaryable_7 	char(1), 
  @counttype_8 	char(1), 
  @countnum_9 	varchar(10),  
  @salaryitem_11 	int, 
  @diffremark_12 	text,
  @color_13 varchar(30),
  @flag integer output,   @msg  varchar(80) output)  
AS 
declare  @countnum_10 decimal(10,2) if @countnum_9 <>'' set @countnum_10 = convert(decimal(10,2),@countnum_9) 
  else set  @countnum_10 = 0  

INSERT INTO HrmScheduleDiff 
( diffname, 
  diffdesc, 
  difftype, 
  difftime, 
  mindifftime, 
  workflowid, 
  salaryable, 
  counttype, 
  countnum,  
  salaryitem, 
  diffremark,
  color)  
VALUES 
( @diffname_1, 
  @diffdesc_2, 
  @difftype_3, 
  @difftime_4, 
  @mindifftime_5, 
  @workflowid_6, 
  @salaryable_7, 
  @counttype_8, 
  @countnum_10,   /* 注意， 这里由 countnum_9 变成了 countnum_10 */
  @salaryitem_11, 
  @diffremark_12,
  @color_13) 
select max(id) from HrmScheduleDiff 
GO

alter PROCEDURE HrmScheduleDiff_Update 
 (@id_1 	int, 
  @diffname_2 	varchar(60), 
  @diffdesc_3 	varchar(200), 
  @difftype_4 	char(1), 
  @difftime_5 	char(1), 
  @mindifftime_6 	smallint, 
  @workflowid_7 	int, 
  @salaryable_8 	char(1), 
  @counttype_9 	char(1), 
  @countnum_11      varchar(10), 
  @salaryitem_12 	int, 
  @diffremark_13 	text, 
  @color_14 varchar(30),
  @flag integer output, @msg varchar(80) output) 
AS declare  @countnum_10 decimal(10,2) if @countnum_11 <>'' set @countnum_10 = convert(decimal(10,2),@countnum_11) 
  else set  @countnum_10 = 0  
UPDATE HrmScheduleDiff  SET  
  diffname	 = @diffname_2, 
  diffdesc	 = @diffdesc_3, 
  difftype	 = @difftype_4, 
  difftime	 = @difftime_5, 
  mindifftime	 = @mindifftime_6, 
  workflowid	 = @workflowid_7, 
  salaryable	 = @salaryable_8, 
  counttype	 = @counttype_9, 
  countnum	 = @countnum_10, 
  salaryitem	 = @salaryitem_12, 
  diffremark	 = @diffremark_13,
  color = @color_14
WHERE 
( id	 = @id_1)  
GO



insert into SystemRights (id,rightdesc,righttype) values (399,'排班维护','3') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3088,'排班维护','HrmArrangeShiftMaintance:Maintance',399) 
GO

insert into SystemRightToGroup (groupid,rightid) values (3,399)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (399,4,'1')
GO


insert into SystemRights (id,rightdesc,righttype) values (400,'排班种类维护','3') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3089,'排班种类维护','HrmArrangeShift:Maintance',400) 
GO

insert into SystemRightToGroup (groupid,rightid) values (3,400)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (400,4,'1')
GO


insert into SystemRights (id,rightdesc,righttype) values (401,'考勤系统设置','3') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3090,'考勤系统设置','HrmkqSystemSetEdit:Edit',401) 
GO

insert into SystemRightToGroup (groupid,rightid) values (3,401)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (401,4,'1')
GO

insert into SystemRights (id,rightdesc,righttype) values (402,'打卡用户接口维护','3') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3091,'打卡用户接口维护','HrmTimecardUser:Maintenance',402) 
GO
insert into SystemRightToGroup (groupid,rightid) values (3,402)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (402,4,'1')
GO

insert into SystemRights (id,rightdesc,righttype) values (403,'出勤与偏差维护','3') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3092,'出勤与偏差维护','HrmWorktimeWarp:Maintenance',403) 
GO

insert into SystemRightToGroup (groupid,rightid) values (3,403)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (403,4,'1')
GO

alter PROCEDURE HrmSalaryItem_Update
	(@id_1 	int,
	 @itemname_2 	varchar(50),
	 @itemcode_3 	varchar(50),
	 @itemtype_4 	char(1),
	 @personwelfarerate_5 	int,
	 @companywelfarerate_6 	int,
	 @taxrelateitem_7 	int,
	 @amountecp_8 	varchar(200),
	 @feetype_9 	int,
	 @isshow_10 	char(1),
	 @showorder_11 	int,
	 @ishistory_12 	char(1) ,
     @flag          integer output, 
     @msg           varchar(80) output)

AS 
declare @olditemtype_1 char(1) 
declare @benchid_1 int

select @olditemtype_1 = itemtype from HrmSalaryItem where id = @id_1 
UPDATE HrmSalaryItem 
SET  itemname	 = @itemname_2,
	 itemcode	 = @itemcode_3,
	 itemtype	 = @itemtype_4,
	 personwelfarerate	 = @personwelfarerate_5,
	 companywelfarerate	 = @companywelfarerate_6,
	 taxrelateitem	 = @taxrelateitem_7,
	 amountecp	 = @amountecp_8,
	 feetype	 = @feetype_9,
	 isshow	 = @isshow_10,
	 showorder	 = @showorder_11,
	 ishistory	 = @ishistory_12 

WHERE 
	( id	 = @id_1)

if @olditemtype_1 = '1' 
begin
    delete from HrmSalaryRank where itemid = @id_1 
    delete from HrmSalaryResourcePay where itemid = @id_1 
end
else if @olditemtype_1 = '2'
begin
    delete from HrmSalaryRank where itemid = @id_1
    delete from HrmSalaryWelfarerate where itemid = @id_1
    delete from HrmSalaryResourcePay where itemid = @id_1
end
else if @olditemtype_1 = '5' or @olditemtype_1 = '6'
    delete from HrmSalarySchedule where itemid = @id_1
else if @olditemtype_1 = '7'
    delete from HrmSalaryShiftPay where itemid = @id_1
else if @olditemtype_1 = '8'
    delete from HrmSalaryResourcePay where itemid = @id_1
else if @olditemtype_1 = '3'
begin
    declare benchid_cursor cursor for
    select id from HrmSalaryTaxbench where itemid = @id_1 
    open benchid_cursor 
    fetch next from benchid_cursor into @benchid_1
    while @@fetch_status=0
    begin 
        delete from HrmSalaryTaxrate where benchid = @benchid_1
        delete from HrmSalaryTaxbench where id = @benchid_1
        fetch next from benchid_cursor into @benchid_1
    end
    close benchid_cursor deallocate benchid_cursor
end
GO

alter PROCEDURE HrmSalaryItem_Delete
	(@id_1 	int ,
     @flag          integer output, 
     @msg           varchar(80) output)
AS 
declare @olditemtype_1 char(1) 
declare @benchid_1 int
select @olditemtype_1 = itemtype from HrmSalaryItem where id = @id_1 

DELETE HrmSalaryItem 
WHERE ( id	 = @id_1)

if @olditemtype_1 = '1'
begin
    delete from HrmSalaryRank where itemid = @id_1 
    delete from HrmSalaryResourcePay where itemid = @id_1 
end
else if @olditemtype_1 = '5' or @olditemtype_1 = '6'
    delete from HrmSalarySchedule where itemid = @id_1
else if @olditemtype_1 = '7'
    delete from HrmSalaryShiftPay where itemid = @id_1
else if @olditemtype_1 = '8'
    delete from HrmSalaryResourcePay where itemid = @id_1
else if @olditemtype_1 = '2'
begin
    delete from HrmSalaryRank where itemid = @id_1 
    delete from HrmSalaryWelfarerate where itemid = @id_1 
    delete from HrmSalaryResourcePay where itemid = @id_1
end
else if @olditemtype_1 = '3'
begin
    declare benchid_cursor cursor for
    select id from HrmSalaryTaxbench where itemid = @id_1 
    open benchid_cursor 
    fetch next from benchid_cursor into @benchid_1
    while @@fetch_status=0
    begin 
        delete from HrmSalaryTaxrate where benchid = @benchid_1
        delete from HrmSalaryTaxbench where id = @benchid_1
        fetch next from benchid_cursor into @benchid_1
    end
    close benchid_cursor deallocate benchid_cursor
end
GO


alter table  HrmSalaryWelfarerate alter column personwelfarerate   decimal(10,2) 
GO

alter table  HrmSalaryWelfarerate alter column companywelfarerate  decimal(10,2) 
GO


alter PROCEDURE HrmSalaryWelfarerate_Insert
    (@itemid_1 	int,
     @cityid_2 	int,
     @personwelfarerate_3 	decimal(10,2),
     @companywelfarerate_4 	decimal(10,2),
     @flag          integer output, 
     @msg           varchar(80) output)

AS INSERT INTO HrmSalaryWelfarerate 
	 ( itemid,
	 cityid,
	 personwelfarerate,
	 companywelfarerate) 
 
VALUES 
	( @itemid_1,
	 @cityid_2,
	 @personwelfarerate_3,
	 @companywelfarerate_4)
GO

alter table HrmkqSystemSet add 
salaryenddate int   /* 薪资计算截至日期（包含当天） */
GO

update HrmkqSystemSet set salaryenddate=31 
GO

alter PROCEDURE HrmkqSystemSet_Update(
@tosomeone_1  varchar(60) ,
@timeinterval_2  int , 
@getdatatype_3  int , 
@getdatavalue_4  varchar(200) , 
@avgworkhour_5  int , 
@salaryenddate_6  int , 
@flag int output, 
@msg varchar(80) output) 
AS 
update HrmkqSystemSet 
set 
tosomeone = @tosomeone_1 , 
timeinterval = @timeinterval_2 ,
getdatatype = @getdatatype_3 , 
getdatavalue = @getdatavalue_4 , 
avgworkhour = @avgworkhour_5 , 
salaryenddate = @salaryenddate_6  
GO

alter table HrmSalaryRank add jobactivityid int /*工资和福利项目选项加入职务选择*/
GO 

alter PROCEDURE HrmSalaryRank_Insert
	(@itemid_1 	int,
	 @jobid_2 	int,
	 @joblevelfrom_3 	int,
	 @joblevelto_4 	int,
	 @amount_5 	decimal(10,2),
     @jobactivityid_6 	int,
     @flag          integer output, 
     @msg           varchar(80) output)

AS INSERT INTO HrmSalaryRank 
	 ( itemid,
	 jobid,
	 joblevelfrom,
	 joblevelto,
	 amount,
     jobactivityid) 
 
VALUES 
	( @itemid_1,
	 @jobid_2,
	 @joblevelfrom_3,
	 @joblevelto_4,
	 @amount_5,
     @jobactivityid_6)
GO

alter PROCEDURE HrmTimecardInfo_Update
	(@resourceid_1 	int,
	 @timecarddate_3 	char(10),
	 @intime_4 	char(5),
	 @outtime_5 	char(5),
     @relateshiftid_6  int ,
	 @flag		int	output, 
	 @msg		varchar(80) output)

AS 
declare @reccount int
select @reccount = count(resourceid) from HrmTimecardinfo where resourceid = @resourceid_1 and timecarddate = @timecarddate_3

if @reccount = 0 
    insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
    values(@resourceid_1,@timecarddate_3,@intime_4 , @outtime_5 ,@relateshiftid_6)
else if @intime_4 = '' 
    update HrmTimecardinfo set outtime = @outtime_5 where resourceid = @resourceid_1 and timecarddate = @timecarddate_3
else if @outtime_5 = ''
    update HrmTimecardinfo set intime = @intime_4 where resourceid = @resourceid_1 and timecarddate = @timecarddate_3
else 
    update HrmTimecardinfo set intime = @intime_4 , outtime = @outtime_5 where resourceid = @resourceid_1 and timecarddate = @timecarddate_3
GO


alter PROCEDURE HrmRightCardInfo_Insert (   
@resourceid_2 int , /*卡钟的台号*/
@carddate_3 char(10),/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
@cardtime_4 char(5) , /*打卡时间，格式：hh:nn(08:12)*/
@inorout_5  int ,           /*出公司还是入公司 0:出 1:入 现在暂时不用 */
@flag        integer output ,
@msg         varchar(80) output)  

 AS
 declare @cardcount int , @reccount int 
 select @cardcount = count(id) from HrmRightCardInfo where carddate = @carddate_3 and resourceid = @resourceid_2 and cardtime = @cardtime_4 
 if @cardcount = 0
 begin      /* 只有不相同的打卡才录入 开始*/
 
     INSERT INTO HrmRightCardInfo (
         resourceid , 
         carddate , 
         cardtime , 
         inorout ,
         islegal ,
         workout 
     ) 
     VALUES (
         @resourceid_2 , 
         @carddate_3 , 
         @cardtime_4 , 
         @inorout_5 ,
         0 ,
         0
     ) 
 end   /* 只有不相同的打卡才录入 结束*/
GO

/* 修改删除无效打卡记入, 增加转入加班的判断 */
alter PROCEDURE HrmRightCardInfo_Delete (
@id_1 int ,
@flag        integer output ,
@msg         varchar(80) output)  

 AS

 declare @resourceid_2 int , @carddate_3 char(10) 
 select @resourceid_2 = resourceid , @carddate_3 = carddate from HrmRightCardInfo where id = @id_1
 delete HrmRightCardInfo where id = @id_1
 update HrmRightCardInfo set islegal = 0 where carddate = @carddate_3 and resourceid = @resourceid_2 
 select @resourceid_2, @carddate_3
GO

/* 转入加班的无效打卡记入, 增加转入加班的判断 */
alter PROCEDURE HrmRightCardInfo_AddWork (
@id_1 int ,
@flag        integer output ,
@msg         varchar(80) output)  

 AS

 declare @resourceid_2 int , @carddate_3 char(10) 
 select @resourceid_2 = resourceid , @carddate_3 = carddate from HrmRightCardInfo where id = @id_1
 update HrmRightCardInfo set workout = 2 where id = @id_1
 update HrmRightCardInfo set islegal = 0 where carddate = @carddate_3 and resourceid = @resourceid_2 
 select @resourceid_2, @carddate_3
GO



update HrmRightCardInfo set islegal = 0 
GO

delete HrmTimecardinfo 
GO

INSERT INTO HtmlLabelIndex values(17091,'现在') 
GO
INSERT INTO HtmlLabelInfo VALUES(17091,'现在',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17091,'Now',8) 
GO


create table HrmSalaryCreateInfo (
id int identity(1,1) primary key not null,
currentdate char(7),            /* 需要创建工资的月份 */
salarybegindate char(10) ,      /* 该月开始的日期 */
salaryenddate char(10) ,      /* 该月结束的日期 */
payid varchar(6) ,              /* 工资单id ,如果第一次生成, payid 为 0 ,否则为原来的 payid */
plandate char(10) ,             /* 计划处理日期 */
hasdone  char(1) default '0'    /* 是否已经处理 */
)
GO

CREATE PROCEDURE HrmSalaryCreateInfo_Insert
	(@currentdate_1 	char(7),
	 @salarybegindate_2 	char(10),
	 @salaryenddate_3 	char(10),
	 @payid_4 	varchar(6),
	 @plandate_5 	char(10),
	 @flag int output, 
     @msg varchar(60) output)

AS INSERT INTO HrmSalaryCreateInfo 
	 ( currentdate,
	 salarybegindate,
	 salaryenddate,
	 payid,
	 plandate) 
 
VALUES 
	( @currentdate_1,
	 @salarybegindate_2,
	 @salaryenddate_3,
	 @payid_4,
	 @plandate_5)
GO



CREATE PROCEDURE HrmSalaryCreateInfo_Delete
	(@id_1 	int,
	 @flag int output, 
     @msg varchar(60) output)

AS DELETE HrmSalaryCreateInfo 

WHERE 
	( id	 = @id_1)
GO


CREATE PROCEDURE HrmSalaryCreateInfo_Select
	(@hasdone_1 	char(1),
	 @flag int output, 
     @msg varchar(60) output)

AS 

select * from HrmSalaryCreateInfo where hasdone = @hasdone_1
GO

alter PROCEDURE HrmTimecardInfo_Update
	(@resourceid_1 	int,
	 @timecarddate_3 	char(10),
	 @intime_4 	char(5),
	 @outtime_5 	char(5),
     @relateshiftid_6  int ,
     @cardtimetype int ,  /* 1: 昨日连班 2: 今日连班 0: 正常 */
	 @flag		int	output, 
	 @msg		varchar(80) output)

AS 
declare @reccount int 

select @reccount = count(resourceid) from HrmTimecardinfo 
where resourceid = @resourceid_1 and timecarddate = @timecarddate_3 and relateshiftid = @relateshiftid_6

if @cardtimetype = 0 
begin
    if @reccount = 0 
        insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
        values(@resourceid_1,@timecarddate_3,@intime_4 , @outtime_5 ,@relateshiftid_6)
    else if @relateshiftid_6 = -1  
    begin
        select @reccount = count(resourceid) from HrmTimecardinfo 
        where resourceid = @resourceid_1 and timecarddate = @timecarddate_3 and intime = @intime_4 and outtime = @outtime_5
        if @reccount = 0 
            insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
            values(@resourceid_1,@timecarddate_3,@intime_4 , @outtime_5 ,@relateshiftid_6)
    end 
end
else if @cardtimetype = 1  
begin
    if @reccount = 0 
        insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
        values(@resourceid_1,@timecarddate_3,@intime_4 , @outtime_5 ,@relateshiftid_6)
    else 
        update HrmTimecardinfo set outtime = @outtime_5 where resourceid = @resourceid_1 and timecarddate = @timecarddate_3 and relateshiftid = @relateshiftid_6 
end
else if @cardtimetype = 2  
begin
    if @reccount = 0 
        insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
        values(@resourceid_1,@timecarddate_3,@intime_4 , @outtime_5 ,@relateshiftid_6)
    else 
        update HrmTimecardinfo set intime = @intime_4 where resourceid = @resourceid_1 and timecarddate = @timecarddate_3 and relateshiftid = @relateshiftid_6 
end
GO

INSERT INTO HtmlLabelIndex values(17092,'计划时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(17092,'计划时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17092,'Plan time',8) 
GO