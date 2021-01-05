alter table HrmSchedule add 
validedatefrom char(10),
validedateto char(10)
GO

CREATE TABLE HrmArrangeShift (
	id int IDENTITY (1, 1) NOT NULL ,
	shiftname varchar (60)  NULL ,
    shiftbegintime char (5)  NULL ,
    shiftendtime char (5)  NULL ,	
    validedatefrom char (10)  NULL ,
    validedateto   char (10)  NULL,
    ishistory  char(1) default '0'
)
GO


CREATE TABLE HrmArrangeShiftInfo (                  
	id int IDENTITY (1, 1) NOT NULL ,
	resourceid int ,
    shiftdate char (10) ,
    shiftid int	
)
GO

CREATE TABLE HrmArrangeShifttype (
	resourceid int IDENTITY (1, 1) NOT NULL ,
	currentdate char (10)  NULL ,
    shifttypeid int null
)
GO


create table HrmTimecardUser ( 
resourceid int primary key ,
usercode varchar(60),
)
GO

/* 打卡信息表*/
create table HrmTimecardInfo ( 
resourceid int ,
timecarddate char(10) ,
intime char(5) ,
outtime char(5)
)
GO


/*关联考勤表*/
create table HrmSalarySchedule(
id	int IDENTITY (1, 1) NOT NULL  primary key,
itemid  int ,                           /*工资项目id*/
diffid  int                            /*考勤种类id*/
)
GO



/*工作时间偏差管理表*/
create table HrmWorkTimeWarp(
 id int identity(1,1) not null primary key,
 diffid int ,               /*相关考勤*/
 resourceid int ,
 diffdate char(10) ,        /*差异日期*/
 difftype  char(1) ,        /*差异类型 0：增加 1：减少*/
 intime char(5) ,           /*入公司时间*/
 outtime char(5) ,          /*出公司时间*/
 theintime  char(5) ,           /*应该入公司时间*/
 theouttime char(5) ,           /*应该出公司时间*/
 counttime int default 0,    /*实际计算时间(分钟)*/
 diffcounttime int default 0)    /*考勤计算时间(分钟)*/
GO

/* 对考勤记录表增加实际计算时间和考勤类型字段 */
alter table HrmScheduleMaintance add realdifftime int default 0, realcarddifftime int default 0, difftype char(1)
GO

update HrmScheduleMaintance set realdifftime = 0 , realcarddifftime = 0
GO

/* 员工出勤统计表 */
create table HrmWorkTimeCount (
id int identity(1,1) not null primary key,
resourceid int ,                /* 人力资源 */
workdate char(7) ,              /* 统计月份 如 2003-07 */
shiftid int,                    /* 工作时间类型 , 0: 一般工作时间 ,其它 : 排班种类id */
workcount int                   /* 出勤次数 当天只要有一次打卡,也作为一次出勤*/
)
GO


/* 人力资源工资项目关联出勤津贴信息表 */
create table HrmSalaryShiftPay(
id	int IDENTITY (1, 1) NOT NULL  primary key,
itemid  int ,                           /*工资项目id*/
shiftid  int ,                          /*出勤种类id 0:一般工作时间 其它:排班种类id*/
shiftpay  decimal(10,2)                 /*出勤种类id 0:一般工作时间 其它:排班种类id*/
)
GO


/* 人力资源工资项目关联考勤计算信息详细 */
create table HrmSalaryDiffDetail (
itemid  int ,                               /* 关联工资项目 */
resourceid  int ,                           /* 关联人力资源 */
payid  int ,                                /* 关联工资单 id */
diffid int ,                                /* 关联的考勤 id */
difftypeid  int ,                           /* 关联考勤种类id */ 
startdate  char(10) ,                        /* 关联考勤开始日期 */ 
enddate  char(10) ,                        /* 关联考勤开始日期 */ 
realcounttime int  ,                        /* 实际计算时间 */
realcountpay decimal(10,2)                  /* 实际计算工资 */
)
GO


create NONCLUSTERED INDEX HrmSalaryDiffDetail_in on HrmSalaryDiffDetail(payid , resourceid , itemid)
GO



update HtmlLabelInfo set labelname = '注意： 代码只能为英文字母和阿拉伯数值，并以字母开头，英文字母大小写敏感！' where indexid = 15830 and languageid = 7   
GO




/*打卡机信息表*/
/*Create by Wangxiaoyi 2003-10-30*/
CREATE TABLE HrmCardInfo (
	id int identity(1,1) not null primary key ,
    stationid char(2) null, /*卡钟的台号*/
    carddate char(10) null , /*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
    cardtime char(5) null ,  /*打卡时间，格式：hh:nn(08:12)*/
    workshift  char(1) null , /*班组,最多可设置16个班组，即0~9,A~F*/
    Cardid   char(10) null  /*卡号*/
    /*islegal char(1) default '1', 是否是合法的卡，默认为1(合法）（厂家用于扩充之用）*/
)
GO


/*无效打卡机信息表*/
CREATE TABLE HrmValidateCardInfo (
	id int identity(1,1) not null primary key ,
    stationid char(2) null, /*卡钟的台号*/
    carddate char(10) null , /*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
    cardtime char(5) null ,  /*打卡时间，格式：hh:nn(08:12)*/
    workshift  char(1) null , /*班组,最多可设置16个班组，即0~9,A~F*/
    Cardid   char(10) null  /*卡号*/
    /*islegal char(1) default '1', 是否是合法的卡，默认为1(合法）（厂家用于扩充之用）*/
)
GO


alter PROCEDURE HrmSchedule_Select_Default 
 (@id_1 int ,
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select * from HrmSchedule where id = @id_1
GO


create PROCEDURE HrmSchedule_SelectAll
(@flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select id , validedatefrom ,validedateto from HrmSchedule order by validedatefrom desc 
GO


alter PROCEDURE HrmSchedule_Update 
 (@id_1 	int, 
  @monstarttime1_3 	char(5), 
  @monendtime1_4 	char(5), 
  @monstarttime2_5 	char(5), 
  @monendtime2_6 	char(5), 
  @tuestarttime1_7 	char(5), 
  @tueendtime1_8 	char(5), 
  @tuestarttime2_9 	char(5), 
  @tueendtime2_10 	char(5), 
  @wedstarttime1_11 	char(5), 
  @wedendtime1_12 	char(5), 
  @wedstarttime2_13 	char(5), 
  @wedendtime2_14 	char(5), 
  @thustarttime1_15 	char(5), 
  @thuendtime1_16 	char(5), 
  @thustarttime2_17 	char(5), 
  @thuendtime2_18 	char(5), 
  @fristarttime1_19 	char(5), 
  @friendtime1_20 	char(5), 
  @fristarttime2_21 	char(5), 
  @friendtime2_22 	char(5), 
  @satstarttime1_23 	char(5), 
  @satendtime1_24 	char(5), 
  @satstarttime2_25 	char(5), 
  @satendtime2_26 	char(5), 
  @sunstarttime1_27 	char(5), 
  @sunendtime1_28 	char(5), 
  @sunstarttime2_29 	char(5), 
  @sunendtime2_30 	char(5), 
  @totaltime_31    char(5), 
  @validedatefrom_32 	char(10), 
  @validedateto_33 	char(10), 
  @flag        integer output, 
  @msg         varchar(80) output) 
AS 
UPDATE HrmSchedule  
SET  
monstarttime1= @monstarttime1_3, 
monendtime1	 = @monendtime1_4, 
monstarttime2= @monstarttime2_5, 
monendtime2	 = @monendtime2_6, 
tuestarttime1= @tuestarttime1_7, 
tueendtime1	 = @tueendtime1_8, 
tuestarttime2= @tuestarttime2_9, 
tueendtime2	 = @tueendtime2_10,
wedstarttime1= @wedstarttime1_11, 
wedendtime1	 = @wedendtime1_12, 
wedstarttime2= @wedstarttime2_13, 
wedendtime2	 = @wedendtime2_14, 
thustarttime1= @thustarttime1_15, 
thuendtime1	 = @thuendtime1_16, 
thustarttime2= @thustarttime2_17, 
thuendtime2	 = @thuendtime2_18,
fristarttime1= @fristarttime1_19, 
friendtime1	 = @friendtime1_20, 
fristarttime2= @fristarttime2_21, 
friendtime2	 = @friendtime2_22, 
satstarttime1= @satstarttime1_23, 
satendtime1	 = @satendtime1_24, 
satstarttime2= @satstarttime2_25, 
satendtime2	 = @satendtime2_26, 
sunstarttime1= @sunstarttime1_27, 
sunendtime1	 = @sunendtime1_28, 
sunstarttime2= @sunstarttime2_29, 
sunendtime2	 = @sunendtime2_30, 
totaltime    = @totaltime_31, 
validedatefrom= @validedatefrom_32,  
validedateto= @validedateto_33  
WHERE ( id	 = @id_1)   
GO

alter PROCEDURE HrmSchedule_Insert 
 (@monstarttime1_2 	char(5), 
 @monendtime1_3 	char(5), 
 @monstarttime2_4 	char(5), 
 @monendtime2_5 	char(5), 
 @tuestarttime1_6 	char(5), 
 @tueendtime1_7 	char(5), 
 @tuestarttime2_8 	char(5), 
 @tueendtime2_9 	char(5), 
 @wedstarttime1_10 	char(5), 
 @wedendtime1_11 	char(5), 
 @wedstarttime2_12 	char(5), 
 @wedendtime2_13 	char(5), 
 @thustarttime1_14 	char(5), 
 @thuendtime1_15 	char(5), 
 @thustarttime2_16 	char(5),
 @thuendtime2_17 	char(5), 
 @fristarttime1_18 	char(5), 
 @friendtime1_19 	char(5), 
 @fristarttime2_20 	char(5), 
 @friendtime2_21 	char(5), 
 @satstarttime1_22 	char(5), 
 @satendtime1_23 	char(5), 
 @satstarttime2_24 	char(5), 
 @satendtime2_25 	char(5), 
 @sunstarttime1_26 	char(5), 
 @sunendtime1_27 	char(5), 
 @sunstarttime2_28 	char(5), 
 @sunendtime2_29 	char(5), 
 @totaltime_30    char(5), 
 @validedatefrom_31 	char(10), 
 @validedateto_32 	char(10),
 @flag    integer output, 
 @msg    varchar(80) output)  
AS 
INSERT INTO HrmSchedule ( 
            monstarttime1, 
            monendtime1, 
            monstarttime2, 
            monendtime2, 
            tuestarttime1, 
            tueendtime1, 
            tuestarttime2, 
            tueendtime2, 
            wedstarttime1, 
            wedendtime1, 
            wedstarttime2, 
            wedendtime2, 
            thustarttime1, 
            thuendtime1, 
            thustarttime2, 
            thuendtime2, 
            fristarttime1, 
            friendtime1, 
            fristarttime2, 
            friendtime2, 
            satstarttime1, 
            satendtime1, 
            satstarttime2, 
            satendtime2, 
            sunstarttime1, 
            sunendtime1, 
            sunstarttime2, 
            sunendtime2, 
            totaltime, 
            validedatefrom,
            validedateto)  
VALUES ( 
            @monstarttime1_2, 
            @monendtime1_3, 
            @monstarttime2_4, 
            @monendtime2_5, 
            @tuestarttime1_6, 
            @tueendtime1_7, 
            @tuestarttime2_8, 
            @tueendtime2_9, 
            @wedstarttime1_10, 
            @wedendtime1_11, 
            @wedstarttime2_12, 
            @wedendtime2_13, 
            @thustarttime1_14, 
            @thuendtime1_15, 
            @thustarttime2_16, 
            @thuendtime2_17, 
            @fristarttime1_18, 
            @friendtime1_19, 
            @fristarttime2_20, 
            @friendtime2_21, 
            @satstarttime1_22, 
            @satendtime1_23, 
            @satstarttime2_24, 
            @satendtime2_25, 
            @sunstarttime1_26, 
            @sunendtime1_27,
            @sunstarttime2_28, 
            @sunendtime2_29, 
            @totaltime_30, 
            @validedatefrom_31,
            @validedateto_32)  
select max(id) from HrmSchedule 
GO

create PROCEDURE HrmArrangeShift_SelectAll
(@ishistory_1 char(1),
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select id , shiftname , shiftbegintime, shiftendtime from HrmArrangeShift where ishistory = @ishistory_1 order by id
GO

create PROCEDURE HrmArrangeShift_UHistory (
 @id_1 	int,
 @validedatefrom_5 char(10),
 @flag        integer output,
 @msg         varchar(80) output) 
 AS 
 UPDATE HrmArrangeShift
 SET  validedateto = @validedatefrom_5,
      ishistory = '1' 
     WHERE ( id	 = @id_1)   
go

CREATE PROCEDURE HrmArrangeShift_Insert (
 @shiftname_2 	 varchar(60),
 @shiftbegintime_3 char(5),
 @shiftendtime_4 char(5),
 @validedatefrom_5  char(10),
 @validedateto_6 char(10),
 @flag        integer output,
 @msg         varchar(80) output)  
  AS 
  INSERT INTO HrmArrangeShift (
 shiftname ,	
 shiftbegintime,
 shiftendtime,
 validedatefrom,
 validedateto)
VALUES (
 @shiftname_2,
 @shiftbegintime_3,
 @shiftendtime_4,
 @validedatefrom_5,
 @validedateto_6)
 select max(id) from HrmArrangeShift  
GO

create PROCEDURE HrmArrangeShift_Update (
 @id_1 	int,
 @shiftname_2 	 varchar(60),
 @shiftbegintime_3 char(5),
 @shiftendtime_4   char(5),
 @validedatefrom_5  char(10),
 @flag        integer output,
 @msg         varchar(80) output) 
 AS 
 UPDATE HrmArrangeShift
 SET  shiftname = @shiftname_2,
      shiftbegintime = @shiftbegintime_3,
      shiftendtime = @shiftendtime_4 ,
      validedatefrom = @validedatefrom_5 
     WHERE ( id	 = @id_1)   
go

 
CREATE PROCEDURE HrmArrangeShift_Delete 
 (@id_1 	int,
 @flag        integer output,
 @msg         varchar(80) output)
 AS DELETE HrmArrangeShift 
 WHERE ( id	 = @id_1)   
GO

create PROCEDURE HrmArrangeShift_Select_Default 
 (@id_1 int ,
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select * from HrmArrangeShift where id = @id_1
GO

create PROCEDURE HrmArrangeShift_SelectById
(@flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select id , shiftname , shiftbegintime, shiftendtime,validedatefrom,validedateto 
 from HrmArrangeShift where ishistory='0' order by id desc 
GO

create PROCEDURE HrmArrangeShift_Updatehistory (
 @id_1 	int,
 @shiftname_2 	 varchar(60),
 @shiftbegintime_3 char(5),
 @shiftendtime_4   char(5),
 @validedatefrom_5 char(10),
 @validedateto_6   char(10),
 @flag        integer output,
 @msg         varchar(80) output) 
 AS 
 UPDATE HrmArrangeShift
 SET  shiftname = @shiftname_2,
      shiftbegintime = @shiftbegintime_3,
      shiftendtime = @shiftendtime_4,
      validedatefrom = @validedatefrom_5 ,
      validedateto = '9999-12-31' 
     WHERE ( id	 = @id_1)   
    go


 CREATE PROCEDURE HrmSalaryScheduleDec_Insert(
 @diffid_1 int ,	
 @itemid_2 char (1) ,
 @flag	int	output, 
 @msg	varchar(80)	output) 
 AS INSERT INTO HrmSalarySchedule(
 diffid , itemid)  
 VALUES(
 @diffid_1 , @itemid_2)
 set @flag = 1 set @msg = 'OK!' 

GO

CREATE PROCEDURE HrmSalaryScheduleAdd_Insert(
 @diffid_1 int ,	
 @itemid_2 char (1) ,
 @flag	int	output, 
 @msg	varchar(80)	output) 
 AS INSERT INTO HrmSalarySchedule(
 diffid , itemid)  
 VALUES(
 @diffid_1 , @itemid_2)
 set @flag = 1 set @msg = 'OK!' 

GO

CREATE PROCEDURE HrmArrangeShiftInfo_Insert(
 @resourceid_1 int ,
 @shiftdate_2 char (10) ,
 @shiftid_3 int	,
 @flag        integer output ,
 @msg         varchar(80) output)  
  AS 
  INSERT INTO HrmArrangeShiftInfo (
 resourceid ,	
 shiftdate,
 shiftid)
VALUES (
 @resourceid_1,
 @shiftdate_2,
 @shiftid_3)
 select max(id) from HrmArrangeShiftInfo
 GO

create PROCEDURE HrmArrangeShiftInfo_Save (
 @resourceid_2 int ,
 @shiftdate_3 char (10) ,
 @shiftid_4 int	,
 @flag        integer output,
 @msg         varchar(80) output)  
 AS 
 declare @count int
 select @count = count(shiftid) from HrmArrangeShiftInfo 
 where  resourceid=@resourceid_2 and shiftdate = @shiftdate_3
 if @count is null or @count = 0
    INSERT INTO HrmArrangeShiftInfo(resourceid,shiftdate,shiftid) 
    VALUES(@resourceid_2,@shiftdate_3, @shiftid_4)
 else
    UPDATE HrmArrangeShiftInfo 
    SET  shiftid = @shiftid_4 
    where  resourceid=@resourceid_2 and shiftdate = @shiftdate_3 
go


create PROCEDURE HrmArrangeShiftProcess_Save (
 @resourceid_2 int ,
 @shiftdate_3 char (10) ,
 @shiftid_4 int	,
 @flag        integer output,
 @msg         varchar(80) output)  
 AS 
 declare @count int
 select @count = count(shiftid) from HrmArrangeShiftInfo 
 where  resourceid=@resourceid_2 and shiftdate = @shiftdate_3
 if @count is null or @count = 0
    INSERT INTO HrmArrangeShiftInfo(resourceid,shiftdate,shiftid) 
    VALUES(@resourceid_2,@shiftdate_3, @shiftid_4)
 else
    UPDATE HrmArrangeShiftInfo 
    SET  shiftid = @shiftid_4 
    where  resourceid=@resourceid_2 and shiftdate = @shiftdate_3 
go


/*增加考勤扣款和扣款加薪之后编辑操作的存储过程*/
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
create NONCLUSTERED INDEX HrmTimecardInfo_in on HrmTimecardInfo(resourceid , timecarddate)
GO

CREATE PROCEDURE HrmTimecardUser_Update
	(@resourceid_1 	int,
	 @usercode_2 	varchar(60),
	 @flag		int	output, 
	 @msg		varchar(80) output)

AS 
declare @count int

select @count= count(usercode) from HrmTimecardUser 
where resourceid != @resourceid_1 and usercode = @usercode_2
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

CREATE PROCEDURE HrmTimecardInfo_Update
	(@resourceid_1 	int,
	 @timecarddate_3 	char(10),
	 @intime_4 	char(5),
	 @outtime_5 	char(5),
	 @flag		int	output, 
	 @msg		varchar(80) output)

AS 
declare @count int
select @count= count(resourceid) from HrmTimecardInfo 
where resourceid = @resourceid_1 and timecarddate = @timecarddate_3

if @count is not null and @count > 0 
    UPDATE HrmTimecardInfo 
    SET  intime	 = @intime_4,
         outtime	 = @outtime_5 
    WHERE 
        ( resourceid	 = @resourceid_1 and
         timecarddate	 = @timecarddate_3)
else
    insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime) 
    values(@resourceid_1,@timecarddate_3,@intime_4,@outtime_5 )
GO


create PROCEDURE HrmSchedule_Select_Current 
 (@currentdate_1 varchar(10) ,
 @flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select * from HrmSchedule where validedatefrom <= @currentdate_1 and validedateto >= @currentdate_1
GO


create PROCEDURE HrmArrangeShift_Select
(@flag integer output, 
 @msg varchar(80) output ) 
 AS 
 select id , shiftbegintime, shiftendtime from HrmArrangeShift order by id
GO



CREATE PROCEDURE HrmWorkTimeWarp_Insert
	(@diffid_1 	int,
	 @resourceid_2 	int,
	 @diffdate_3 	char(10),
	 @difftype_4 	char(1),
	 @intime_5 	char(5),
	 @outtime_6 	char(5),
	 @theintime_7 	char(5),
	 @theouttime_8 	char(5),
	 @counttime_9 	int,
     @diffcounttime_10 	int,
     @flag integer output, 
     @msg varchar(80) output ) 

AS INSERT INTO HrmWorkTimeWarp 
	 ( diffid,
	 resourceid,
	 diffdate,
	 difftype,
	 intime,
	 outtime,
	 theintime,
	 theouttime,
	 counttime,
     diffcounttime) 
 
VALUES 
	( @diffid_1,
	 @resourceid_2,
	 @diffdate_3,
	 @difftype_4,
	 @intime_5,
	 @outtime_6,
	 @theintime_7,
	 @theouttime_8,
	 @counttime_9,
     @diffcounttime_10)
GO


create PROCEDURE HrmScheduleMaintance_UStype
as
declare @diffid_1 int , @difftype_2 char(1) 
update HrmScheduleMaintance set difftype = 'A' 

declare diffid_cursor cursor for 
select id , difftype from HrmScheduleDiff 
open diffid_cursor 
fetch next from diffid_cursor into @diffid_1 , @difftype_2
while @@fetch_status=0 
begin 
    update HrmScheduleMaintance set difftype = @difftype_2 where diffid = @diffid_1  
    fetch next from diffid_cursor into @diffid_1 , @difftype_2
end 
close diffid_cursor 
deallocate diffid_cursor
GO

exec HrmScheduleMaintance_UStype
GO

drop PROCEDURE HrmScheduleMaintance_UStype
GO






alter PROCEDURE HrmScheduleMain_Insert
	(@diffid_1 	int,
	 @resourceid_2 	int,
	 @startdate_3 	char(10),
	 @starttime_4 	char(8),
	 @enddate_5 	char(10),
	 @endtime_6 	char(8),
	 @memo_7 	text,
	 @createtype_8 	int,
	 @createrid_9 	int,
	 @createdate_10 	char(10),
     @realdifftime_11  int ,
     @difftype_12 char(1),
	 @flag int output, @msg varchar(60) output)

AS INSERT INTO HrmScheduleMaintance 
	 ( diffid,
	 resourceid,
	 startdate,
	 starttime,
	 enddate,
	 endtime,
	 memo,
	 createtype,
	 createrid,
	 createdate,
     realdifftime,
     difftype) 
 
VALUES 
	( @diffid_1,
	 @resourceid_2,
	 @startdate_3,
	 @starttime_4,
	 @enddate_5,
	 @endtime_6,
	 @memo_7,
	 @createtype_8,
	 @createrid_9,
	 @createdate_10,
     @realdifftime_11,
     @difftype_12)
select max(id) from HrmScheduleMaintance
GO


alter PROCEDURE HrmScheduleMain_Update
	(@id_1 	int,
	 @diffid_2 	int,
	 @resourceid_3 	int,
	 @startdate_4 	char(10),
	 @starttime_5 	char(8),
	 @enddate_6 	char(10),
	 @endtime_7 	char(8),
	 @memo_8 	text,
     @realdifftime_11  int ,
     @difftype_12 char(1),
	 @flag int output, @msg varchar(60) output)
AS UPDATE HrmScheduleMaintance SET  
         diffid	 = @diffid_2,
	 resourceid	 = @resourceid_3,
	 startdate	 = @startdate_4,
	 starttime	 = @starttime_5,
	 enddate	 = @enddate_6,
	 endtime	 = @endtime_7,
	 memo        = @memo_8 ,
     realdifftime = @realdifftime_11 ,
     difftype    = @difftype_12 
WHERE 
	( id	 = @id_1)
go





alter PROCEDURE HrmSalaryScheduleDec_Insert(
 @itemid_2 int ,
 @diffid_1 int ,	
 @flag	int	output, 
 @msg	varchar(80)	output) 
 AS INSERT INTO HrmSalarySchedule(
 diffid , itemid)  
 VALUES(
 @diffid_1 , @itemid_2)
 set @flag = 1 set @msg = 'OK!' 

GO

alter PROCEDURE HrmSalaryScheduleAdd_Insert(
 @itemid_2 int ,
 @diffid_1 int ,	
 @flag	int	output, 
 @msg	varchar(80)	output) 
 AS INSERT INTO HrmSalarySchedule(
 diffid , itemid)  
 VALUES(
 @diffid_1 , @itemid_2)
 set @flag = 1 set @msg = 'OK!' 

GO


CREATE PROCEDURE HrmWorkTimeCount_Insert
	(@resourceid_1 	int,
	 @workdate_2 	char(7),
	 @shiftid_3 	int,
	 @workcount_4 	int,	
     @flag	int	output, 
     @msg	varchar(80)	output) 

AS INSERT INTO HrmWorkTimeCount 
	 ( resourceid,
	 workdate,
	 shiftid,
	 workcount) 
 
VALUES 
	( @resourceid_1,
	 @workdate_2,
	 @shiftid_3,
	 @workcount_4)
GO

CREATE PROCEDURE HrmSalaryShiftPay_SByItemid
	(@itemid_1 	int,
     @flag	int	output, 
     @msg	varchar(80)	output)

AS 
Select * from HrmSalaryShiftPay where itemid = @itemid_1 
GO

CREATE PROCEDURE HrmSalaryShiftPay_Insert
	(@itemid_1 	int,
	 @shiftid_2 	int,
	 @shiftpay_3 	decimal,	
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


CREATE PROCEDURE HrmSalaryShiftPay_Delete
	(@itemid_1 	int,	
     @flag	int	output, 
     @msg	varchar(80)	output)

AS DELETE HrmSalaryShiftPay 
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



CREATE PROCEDURE HrmSalaryDiffDetail_Insert
	(@itemid_1 	int,
	 @resourceid_2 	int,
	 @payid_3 	int,
	 @diffid_4 	int,
	 @difftypeid_5 	int,
	 @startdate_6 	char(10),
	 @enddate_7 	char(10),
	 @realcounttime_8 	int,
	 @realcountpay_9 	decimal(10,2) ,
     @flag          integer output, 
     @msg           varchar(80) output)

AS INSERT INTO HrmSalaryDiffDetail 
	 ( itemid,
	 resourceid,
	 payid,
	 diffid,
	 difftypeid,
	 startdate,
	 enddate,
	 realcounttime,
	 realcountpay) 
 
VALUES 
	( @itemid_1,
	 @resourceid_2,
	 @payid_3,
	 @diffid_4,
	 @difftypeid_5,
	 @startdate_6,
	 @enddate_7,
	 @realcounttime_8,
	 @realcountpay_9)
GO

/*查询打卡机数据 
 create by Wangxiaoyi 2003-10-30
 */

CREATE PROCEDURE HrmCardInfo_SelectCount (
@carddate_3 char(10),/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
@workshift_5  char(1) ,/*班组,最多可设置16个班组，即0~9,A~F*/
@Cardid_6  char(10) , /*card id*/
@flag        integer output ,
@msg         varchar(80) output)  

 AS 

 select count(id) from HrmCardInfo where carddate = @carddate_3 and workshift = @workshift_5 and Cardid = @Cardid_6 
 
GO


/*将打卡机数据储存到数据库表中 
 create by Wangxiaoyi 2003-10-30
 */


CREATE PROCEDURE HrmCardInfo_Insert (
@stationid_2 char(2) , /*卡钟的台号*/
@carddate_3 char(10),/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
@cardtime_4 char(5) , /*打卡时间，格式：hh:nn(08:12)*/
@workshift_5  char(1) ,/*班组,最多可设置16个班组，即0~9,A~F*/
@Cardid_6  char(10) , /*card id*/
@flag        integer output ,
@msg         varchar(80) output)  

 AS 
 INSERT INTO HrmCardInfo (
 stationid , 
 carddate , 
 cardtime , 
 workshift , 
 Cardid ) 
 
 VALUES (
 @stationid_2 , 
 @carddate_3 , 
 @cardtime_4 , 
 @workshift_5 , 
 @Cardid_6 
) 
GO





CREATE PROCEDURE HrmValidateCardInfo_Insert (
@stationid_2 char(2) , /*卡钟的台号*/
@carddate_3 char(10),/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
@cardtime_4 char(5) , /*打卡时间，格式：hh:nn(08:12)*/
@workshift_5  char(1) ,/*班组,最多可设置16个班组，即0~9,A~F*/
@Cardid_6  char(10) , /*card id*/
@flag        integer output ,
@msg         varchar(80) output)  

 AS 
 INSERT INTO HrmValidateCardInfo (
 stationid , 
 carddate , 
 cardtime , 
 workshift , 
 Cardid ) 
 
 VALUES (
 @stationid_2 , 
 @carddate_3 , 
 @cardtime_4 , 
 @workshift_5 , 
 @Cardid_6 
) 
GO



alter PROCEDURE HrmTimecardInfo_Update
	(@resourceid_1 	int,
	 @timecarddate_3 	char(10),
	 @intime_4 	char(5),
	 @outtime_5 	char(5),
	 @flag		int	output, 
	 @msg		varchar(80) output)

AS 
declare @count int
select @count= count(resourceid) from HrmTimecardInfo 
where resourceid = @resourceid_1 and timecarddate = @timecarddate_3

if @count is not null and @count > 0 
    UPDATE HrmTimecardInfo 
    SET  outtime = @outtime_5 
    WHERE 
        ( resourceid	 = @resourceid_1 and
         timecarddate	 = @timecarddate_3)
else
    insert into HrmTimecardinfo(resourceid,timecarddate,intime) 
    values(@resourceid_1,@timecarddate_3,@intime_4 )
GO


/*考勤系统设置*/
CREATE TABLE HrmkqSystemSet (
tosomeone varchar (60)  NULL , /*收件人地址*/
timeinterval int /*采集数据时间间隔*/
)
GO


CREATE PROCEDURE HrmkqSystemSet_Select(
@flag int output, 
@msg varchar(80) output
) 
AS select * from HrmkqSystemSet 
GO

 CREATE PROCEDURE HrmkqSystem_Insert(
 @tosomeone_1 varchar(60) ,	
 @timeinterval_2 int ,
 @flag	int	output, 
 @msg	varchar(80)	output) 
 AS INSERT INTO HrmkqSystemSet(tosomeone , timeinterval)  
 VALUES(@tosomeone_1 , @timeinterval_2)
GO

CREATE PROCEDURE HrmkqSystemSet_Update(
@tosomeone_1  varchar(60) ,
@timeinterval_2  int , 
@flag int output, 
@msg varchar(80) output) 
AS 
update HrmkqSystemSet 
set 
tosomeone = @tosomeone_1 , 
timeinterval = @timeinterval_2 
GO



insert into 
SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (3070,'默认时间表新建','HrmDefaultScheduleAdd:Add',35)
GO



INSERT INTO HtmlLabelIndex values(16689,'上午') 
GO
INSERT INTO HtmlLabelInfo VALUES(16689,'上午',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16689,'morning',8) 
GO

INSERT INTO HtmlLabelIndex values(16690,'下午') 
GO
INSERT INTO HtmlLabelInfo VALUES(16690,'下午',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16690,'afternoon',8) 
GO

INSERT INTO HtmlLabelIndex values(16691,'历史列表') 
GO
INSERT INTO HtmlLabelInfo VALUES(16691,'历史列表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16691,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16692,'排班管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(16692,'排班管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16692,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16693,'排班批处理') 
GO
INSERT INTO HtmlLabelInfo VALUES(16693,'排班批处理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16693,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16694,'排班日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(16694,'排班日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16694,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16695,'排班设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(16695,'排班设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16695,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16696,'开始时间和结束时间没有成对出现！') 
GO
INSERT INTO HtmlLabelInfo VALUES(16696,'开始时间和结束时间没有成对出现！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16696,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16697,'一般工作时间历史') 
GO
INSERT INTO HtmlLabelInfo VALUES(16697,'一般工作时间历史',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16697,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16698,'打卡数据Excel表') 
GO
INSERT INTO HtmlLabelInfo VALUES(16698,'打卡数据Excel表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16698,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16699,'Excel文件') 
GO
INSERT INTO HtmlLabelInfo VALUES(16699,'Excel文件',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16699,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16700,'打卡数据导入错误') 
GO
INSERT INTO HtmlLabelInfo VALUES(16700,'打卡数据导入错误',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16700,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16701,'导入无对应用户数据') 
GO
INSERT INTO HtmlLabelInfo VALUES(16701,'导入无对应用户数据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16701,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16702,'外部打卡用户编号') 
GO
INSERT INTO HtmlLabelInfo VALUES(16702,'外部打卡用户编号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16702,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16703,'打卡日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(16703,'打卡日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16703,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16704,'入公司时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(16704,'入公司时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16704,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16705,'出公司时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(16705,'出公司时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16705,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16706,'导出设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(16706,'导出设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16706,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16707,'导出开始日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(16707,'导出开始日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16707,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16708,'导出结束日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(16708,'导出结束日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16708,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16709,'是否计算薪资') 
GO
INSERT INTO HtmlLabelInfo VALUES(16709,'是否计算薪资',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16709,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16710,'薪资计算方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(16710,'薪资计算方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16710,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16711,'计算值') 
GO
INSERT INTO HtmlLabelInfo VALUES(16711,'计算值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16711,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16712,'基准工资项') 
GO
INSERT INTO HtmlLabelInfo VALUES(16712,'基准工资项',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16712,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16713,'最小计算时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(16713,'最小计算时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16713,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16714,'时间计算方式') 
GO
INSERT INTO HtmlLabelInfo VALUES(16714,'时间计算方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16714,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16715,'以考勤时间计算') 
GO
INSERT INTO HtmlLabelInfo VALUES(16715,'以考勤时间计算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16715,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16716,'以打卡时间计算') 
GO
INSERT INTO HtmlLabelInfo VALUES(16716,'以打卡时间计算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16716,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16717,'以较大时间计算') 
GO
INSERT INTO HtmlLabelInfo VALUES(16717,'以较大时间计算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16717,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16718,'以较小时间计算') 
GO
INSERT INTO HtmlLabelInfo VALUES(16718,'以较小时间计算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16718,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16719,'考勤计算时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(16719,'考勤计算时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16719,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16720,'打卡计算时间') 
GO
INSERT INTO HtmlLabelInfo VALUES(16720,'打卡计算时间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16720,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16721,'开始日期不能大于结束日期！') 
GO
INSERT INTO HtmlLabelInfo VALUES(16721,'开始日期不能大于结束日期！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16721,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16722,'开始时间不能大于结束时间！') 
GO
INSERT INTO HtmlLabelInfo VALUES(16722,'开始时间不能大于结束时间！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16722,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16723,'打卡数据文件下载：') 
GO
INSERT INTO HtmlLabelInfo VALUES(16723,'打卡数据文件下载：',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16723,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16724,'打卡用户编码管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(16724,'打卡用户编码管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16724,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16725,'本系统ID') 
GO
INSERT INTO HtmlLabelInfo VALUES(16725,'本系统ID',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16725,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16726,'打卡用户编码冲突！！！') 
GO
INSERT INTO HtmlLabelInfo VALUES(16726,'打卡用户编码冲突！！！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16726,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16727,'用户编码信息') 
GO
INSERT INTO HtmlLabelInfo VALUES(16727,'用户编码信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16727,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16728,'本系统用户ID') 
GO
INSERT INTO HtmlLabelInfo VALUES(16728,'本系统用户ID',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16728,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16729,'生成出勤统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(16729,'生成出勤统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16729,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16730,'出勤生成日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(16730,'出勤生成日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16730,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16731,'员工出勤管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(16731,'员工出勤管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16731,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16732,'出勤统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(16732,'出勤统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16732,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16733,'编辑出勤统计') 
GO
INSERT INTO HtmlLabelInfo VALUES(16733,'编辑出勤统计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16733,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16734,'生成偏差') 
GO
INSERT INTO HtmlLabelInfo VALUES(16734,'生成偏差',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16734,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16735,'偏差生成日期') 
GO
INSERT INTO HtmlLabelInfo VALUES(16735,'偏差生成日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16735,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16736,'考勤关联') 
GO
INSERT INTO HtmlLabelInfo VALUES(16736,'考勤关联',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16736,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16737,'获取打卡数据') 
GO
INSERT INTO HtmlLabelInfo VALUES(16737,'获取打卡数据',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16737,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16738,'考勤系统设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(16738,'考勤系统设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16738,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16739,'实际计算金额') 
GO
INSERT INTO HtmlLabelInfo VALUES(16739,'实际计算金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16739,'',8) 
GO

 INSERT INTO HtmlLabelIndex values(16740,'出勤津贴') 
GO
INSERT INTO HtmlLabelInfo VALUES(16740,'出勤津贴',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16740,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16741,'出勤种类') 
GO
INSERT INTO HtmlLabelInfo VALUES(16741,'出勤种类',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16741,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16742,'考勤打卡数据正在采集，离开该页面会导致数据采集停止，真的要离开吗？') 
GO
INSERT INTO HtmlLabelInfo VALUES(16742,'考勤打卡数据正在采集，离开该页面会导致数据采集停止，真的要离开吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16742,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16743,'考勤系统管理员邮件设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(16743,'考勤系统管理员邮件设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16743,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16744,'数据采集时间间隔') 
GO
INSERT INTO HtmlLabelInfo VALUES(16744,'数据采集时间间隔',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16744,'',8) 
GO
 
INSERT INTO HtmlLabelIndex values(16745,'收件人地址') 
GO
INSERT INTO HtmlLabelInfo VALUES(16745,'收件人地址',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16745,'',8) 
GO

INSERT INTO HtmlLabelIndex values(16746,'设置成功!') 
GO
INSERT INTO HtmlLabelInfo VALUES(16746,'设置成功!',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(16746,'',8) 
GO
 
