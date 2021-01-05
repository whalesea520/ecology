alter table HrmSchedule add validedatefrom char(10)
/

alter table HrmSchedule add validedateto char(10)
/

CREATE TABLE HrmArrangeShift (
    id integer NOT NULL ,
    shiftname varchar2 (60)  NULL ,
    shiftbegintime char (5)  NULL ,
    shiftendtime char (5)  NULL ,	
    validedatefrom char (10)  NULL ,
    validedateto   char (10)  NULL,
    ishistory  char(1) default '0'
)
/

create sequence HrmArrangeShift_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmArrangeShift_Trigger
before insert on HrmArrangeShift
for each row
begin
select HrmArrangeShift_id.nextval into :new.id from dual;
end;
/


CREATE TABLE HrmArrangeShiftInfo (                  
	id integer NOT NULL ,
	resourceid integer ,
    shiftdate char (10) ,
    shiftid integer	
)
/

create sequence HrmArrangeShiftInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmArrangeShiftInfo_Trigger
before insert on HrmArrangeShiftInfo
for each row
begin
select HrmArrangeShiftInfo_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmArrangeShifttype (
	resourceid integer NOT NULL ,
	currentdate char (10)  NULL ,
    shifttypeid integer null
)
/

create sequence HrmArrangeShifttype_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmArrangeShifttype_Trigger
before insert on HrmArrangeShifttype
for each row
begin
select HrmArrangeShifttype_id.nextval into :new.resourceid from dual;
end;
/


create table HrmTimecardUser ( 
resourceid integer primary key ,
usercode varchar2(60)
)
/

/* 打卡信息表*/
create table HrmTimecardInfo ( 
resourceid integer ,
timecarddate char(10) ,
intime char(5) ,
outtime char(5)
)
/


/*关联考勤表*/
create table HrmSalarySchedule(
id	integer NOT NULL  primary key,
itemid  integer ,                           /*工资项目id*/
diffid  integer                            /*考勤种类id*/
)
/

create sequence HrmSalarySchedule_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmSalarySchedule_Trigger
before insert on HrmSalarySchedule
for each row
begin
select HrmSalarySchedule_id.nextval into :new.id from dual;
end;
/


/*工作时间偏差管理表*/
create table HrmWorkTimeWarp(
 id integer not null primary key,
 diffid integer ,               /*相关考勤*/
 resourceid integer ,
 diffdate char(10) ,        /*差异日期*/
 difftype  char(1) ,        /*差异类型 0：增加 1：减少*/
 intime char(5) ,           /*入公司时间*/
 outtime char(5) ,          /*出公司时间*/
 theintime  char(5) ,           /*应该入公司时间*/
 theouttime char(5) ,           /*应该出公司时间*/
 counttime integer default 0,    /*实际计算时间(分钟)*/
 diffcounttime integer default 0)    /*考勤计算时间(分钟)*/
/


create sequence HrmWorkTimeWarp_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmWorkTimeWarp_Trigger
before insert on HrmWorkTimeWarp
for each row
begin
select HrmWorkTimeWarp_id.nextval into :new.id from dual;
end;
/

/* 对考勤记录表增加实际计算时间和考勤类型字段 */
alter table HrmScheduleMaintance add realdifftime integer default 0
/
alter table HrmScheduleMaintance add realcarddifftime integer default 0
/
alter table HrmScheduleMaintance add difftype char(1)
/

update HrmScheduleMaintance set realdifftime = 0 , realcarddifftime = 0
/

/* 员工出勤统计表 */
create table HrmWorkTimeCount (
id integer not null primary key,
resourceid integer ,                /* 人力资源 */
workdate char(7) ,              /* 统计月份 如 2003-07 */
shiftid integer,                    /* 工作时间类型 , 0: 一般工作时间 ,其它 : 排班种类id */
workcount integer                   /* 出勤次数 当天只要有一次打卡,也作为一次出勤*/
)
/

create sequence HrmWorkTimeCount_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmWorkTimeCount_Trigger
before insert on HrmWorkTimeCount
for each row
begin
select HrmWorkTimeCount_id.nextval into :new.id from dual;
end;
/



/* 人力资源工资项目关联出勤津贴信息表 */
create table HrmSalaryShiftPay(
id	integer  NOT NULL  primary key,
itemid  integer ,                           /*工资项目id*/
shiftid  integer ,                          /*出勤种类id 0:一般工作时间 其它:排班种类id*/
shiftpay  number(10,2)                 /*出勤种类id 0:一般工作时间 其它:排班种类id*/
)
/
create sequence HrmSalaryShiftPay_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmSalaryShiftPay_Trigger
before insert on HrmSalaryShiftPay
for each row
begin
select HrmSalaryShiftPay_id.nextval into :new.id from dual;
end;
/


/* 人力资源工资项目关联考勤计算信息详细 */
create table HrmSalaryDiffDetail (
itemid  integer ,                               /* 关联工资项目 */
resourceid  integer ,                           /* 关联人力资源 */
payid  integer ,                                /* 关联工资单 id */
diffid integer ,                                /* 关联的考勤 id */
difftypeid  integer ,                           /* 关联考勤种类id */ 
startdate  char(10) ,                        /* 关联考勤开始日期 */ 
enddate  char(10) ,                        /* 关联考勤开始日期 */ 
realcounttime integer  ,                        /* 实际计算时间 */
realcountpay number(10,2)                  /* 实际计算工资 */
)
/


create INDEX HrmSalaryDiffDetail_in on HrmSalaryDiffDetail(payid , resourceid , itemid)
/



update HtmlLabelInfo set labelname = '注意： 代码只能为英文字母和阿拉伯数值，并以字母开头，英文字母大小写敏感！' 
where indexid = 15830 and languageid = 7   
/




/*打卡机信息表*/
/*Create by Wangxiaoyi 2003-10-30*/
CREATE TABLE HrmCardInfo (
	id integer  not null primary key ,
    stationid char(2) null, /*卡钟的台号*/
    carddate char(10) null , /*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
    cardtime char(5) null ,  /*打卡时间，格式：hh:nn(08:12)*/
    workshift  char(1) null , /*班组,最多可设置16个班组，即0~9,A~F*/
    Cardid   char(10) null  /*卡号*/
)
/
create sequence HrmCardInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmCardInfo_Trigger
before insert on HrmCardInfo
for each row
begin
select HrmCardInfo_id.nextval into :new.id from dual;
end;
/

/*无效打卡机信息表*/
CREATE TABLE HrmValidateCardInfo (
	id integer not null primary key ,
    stationid char(2) null, /*卡钟的台号*/
    carddate char(10) null , /*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
    cardtime char(5) null ,  /*打卡时间，格式：hh:nn(08:12)*/
    workshift  char(1) null , /*班组,最多可设置16个班组，即0~9,A~F*/
    Cardid   char(10) null  /*卡号*/
)
/
create sequence HrmValidateCardInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmValidateCardInfo_Trigger
before insert on HrmValidateCardInfo
for each row
begin
select HrmValidateCardInfo_id.nextval into :new.id from dual;
end;
/

CREATE or REPLACE PROCEDURE HrmSchedule_Select_Default 
 (id_1 integer ,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 select * from HrmSchedule where id = id_1;
 end;
/


CREATE or REPLACE PROCEDURE HrmSchedule_SelectAll
( flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
 AS 
 begin
 open thecursor for
 select id , validedatefrom ,validedateto from HrmSchedule order by validedatefrom desc;
 end;
/


create or replace PROCEDURE HrmSchedule_Update 
 (id_1 	integer, 
  monstarttime1_3 	char, 
  monendtime1_4 	char, 
  monstarttime2_5 	char, 
  monendtime2_6 	char, 
  tuestarttime1_7 	char, 
  tueendtime1_8 	char, 
  tuestarttime2_9 	char, 
  tueendtime2_10 	char, 
  wedstarttime1_11 	char, 
  wedendtime1_12 	char, 
  wedstarttime2_13 	char, 
  wedendtime2_14 	char, 
  thustarttime1_15 	char, 
  thuendtime1_16 	char, 
  thustarttime2_17 	char, 
  thuendtime2_18 	char, 
  fristarttime1_19 	char, 
  friendtime1_20 	char, 
  fristarttime2_21 	char, 
  friendtime2_22 	char, 
  satstarttime1_23 	char, 
  satendtime1_24 	char, 
  satstarttime2_25 	char, 
  satendtime2_26 	char, 
  sunstarttime1_27 	char, 
  sunendtime1_28 	char, 
  sunstarttime2_29 	char, 
  sunendtime2_30 	char, 
  totaltime_31    char, 
  validedatefrom_32 	char, 
  validedateto_33 	char, 
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin
UPDATE HrmSchedule  
SET  
monstarttime1= monstarttime1_3, 
monendtime1	 = monendtime1_4, 
monstarttime2= monstarttime2_5, 
monendtime2	 = monendtime2_6, 
tuestarttime1= tuestarttime1_7, 
tueendtime1	 = tueendtime1_8, 
tuestarttime2= tuestarttime2_9, 
tueendtime2	 = tueendtime2_10,
wedstarttime1= wedstarttime1_11, 
wedendtime1	 = wedendtime1_12, 
wedstarttime2= wedstarttime2_13, 
wedendtime2	 = wedendtime2_14, 
thustarttime1= thustarttime1_15, 
thuendtime1	 = thuendtime1_16, 
thustarttime2= thustarttime2_17, 
thuendtime2	 = thuendtime2_18,
fristarttime1= fristarttime1_19, 
friendtime1	 = friendtime1_20, 
fristarttime2= fristarttime2_21, 
friendtime2	 = friendtime2_22, 
satstarttime1= satstarttime1_23, 
satendtime1	 = satendtime1_24, 
satstarttime2= satstarttime2_25, 
satendtime2	 = satendtime2_26, 
sunstarttime1= sunstarttime1_27, 
sunendtime1	 = sunendtime1_28, 
sunstarttime2= sunstarttime2_29, 
sunendtime2	 = sunendtime2_30, 
totaltime    = totaltime_31, 
validedatefrom= validedatefrom_32,  
validedateto= validedateto_33  
WHERE ( id	 = id_1);
end;
/

create or replace PROCEDURE HrmSchedule_Insert 
 (monstarttime1_2 	char, 
 monendtime1_3 	char, 
 monstarttime2_4 	char, 
 monendtime2_5 	char, 
 tuestarttime1_6 	char, 
 tueendtime1_7 	char, 
 tuestarttime2_8 	char, 
 tueendtime2_9 	char, 
 wedstarttime1_10 	char, 
 wedendtime1_11 	char, 
 wedstarttime2_12 	char, 
 wedendtime2_13 	char, 
 thustarttime1_14 	char, 
 thuendtime1_15 	char, 
 thustarttime2_16 	char,
 thuendtime2_17 	char, 
 fristarttime1_18 	char, 
 friendtime1_19 	char, 
 fristarttime2_20 	char, 
 friendtime2_21 	char, 
 satstarttime1_22 	char, 
 satendtime1_23 	char, 
 satstarttime2_24 	char, 
 satendtime2_25 	char, 
 sunstarttime1_26 	char, 
 sunendtime1_27 	char, 
 sunstarttime2_28 	char, 
 sunendtime2_29 	char, 
 totaltime_30    char, 
 validedatefrom_31 	char, 
 validedateto_32 	char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
AS 
begin
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
            monstarttime1_2, 
            monendtime1_3, 
            monstarttime2_4, 
            monendtime2_5, 
            tuestarttime1_6, 
            tueendtime1_7, 
            tuestarttime2_8, 
            tueendtime2_9, 
            wedstarttime1_10, 
            wedendtime1_11, 
            wedstarttime2_12, 
            wedendtime2_13, 
            thustarttime1_14, 
            thuendtime1_15, 
            thustarttime2_16, 
            thuendtime2_17, 
            fristarttime1_18, 
            friendtime1_19, 
            fristarttime2_20, 
            friendtime2_21, 
            satstarttime1_22, 
            satendtime1_23, 
            satstarttime2_24, 
            satendtime2_25, 
            sunstarttime1_26, 
            sunendtime1_27,
            sunstarttime2_28, 
            sunendtime2_29, 
            totaltime_30, 
            validedatefrom_31,
            validedateto_32);
open thecursor for
select max(id) from HrmSchedule ;
end;
/

create or replace PROCEDURE HrmArrangeShift_SelectAll
(ishistory_1 char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 select id , shiftname , shiftbegintime, shiftendtime from HrmArrangeShift where ishistory = ishistory_1 order by id;
 end;
/

create or replace PROCEDURE HrmArrangeShift_UHistory (
 id_1 	integer,
 validedatefrom_5 char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 UPDATE HrmArrangeShift
 SET  validedateto = validedatefrom_5,
      ishistory = '1' 
     WHERE ( id	 = id_1);
end;
/

create or replace PROCEDURE HrmArrangeShift_Insert (
 shiftname_2 	 varchar2,
 shiftbegintime_3 char,
 shiftendtime_4 char,
 validedatefrom_5  char,
 validedateto_6 char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS 
  begin
  INSERT INTO HrmArrangeShift (
 shiftname ,	
 shiftbegintime,
 shiftendtime,
 validedatefrom,
 validedateto)
VALUES (
 shiftname_2,
 shiftbegintime_3,
 shiftendtime_4,
 validedatefrom_5,
 validedateto_6);
 open thecursor for
 select max(id) from HrmArrangeShift  ;
 end;
/

create or replace PROCEDURE HrmArrangeShift_Update (
 id_1 	integer,
 shiftname_2 	 varchar2,
 shiftbegintime_3 char,
 shiftendtime_4   char,
 validedatefrom_5  char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 UPDATE HrmArrangeShift
 SET  shiftname = shiftname_2,
      shiftbegintime = shiftbegintime_3,
      shiftendtime = shiftendtime_4 ,
      validedatefrom = validedatefrom_5 
     WHERE ( id	 = id_1);
 end;
/

 
create or replace PROCEDURE HrmArrangeShift_Delete 
 (id_1 	integer,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
 AS 
 begin
 DELETE HrmArrangeShift 
 WHERE ( id	 = id_1);
 end;
/

create or replace PROCEDURE HrmArrangeShift_Select_Default 
 (id_1 integer ,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
  open thecursor for
 select * from HrmArrangeShift where id = id_1;
 end;
/

create or replace PROCEDURE HrmArrangeShift_SelectById
(id_1 integer ,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
 AS 
 begin
 open thecursor for
 select id , shiftname , shiftbegintime, shiftendtime,validedatefrom,validedateto 
 from HrmArrangeShift where ishistory='0' order by id desc ;
 end;
/

create or replace PROCEDURE HrmArrangeShift_Updatehistory (
 id_1 	integer,
 shiftname_2 	 varchar2,
 shiftbegintime_3 char,
 shiftendtime_4   char,
 validedatefrom_5 char,
 validedateto_6   char,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 UPDATE HrmArrangeShift
 SET  shiftname = shiftname_2,
      shiftbegintime = shiftbegintime_3,
      shiftendtime = shiftendtime_4,
      validedatefrom = validedatefrom_5 ,
      validedateto = '9999-12-31' 
     WHERE ( id	 = id_1);
end;
/

 create or replace PROCEDURE HrmSalaryScheduleDec_Insert(
 diffid_1 integer ,	
 itemid_2 char,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 INSERT INTO HrmSalarySchedule(
 diffid , itemid)  
 VALUES(
 diffid_1 , itemid_2);
 end;
/



create or replace PROCEDURE HrmArrangeShiftInfo_Insert(
 resourceid_1 integer ,
 shiftdate_2 char ,
 shiftid_3 integer	,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
  AS 
  begin
  INSERT INTO HrmArrangeShiftInfo (
 resourceid ,	
 shiftdate,
 shiftid)
VALUES (
 resourceid_1,
 shiftdate_2,
 shiftid_3);
  open thecursor for
 select max(id) from HrmArrangeShiftInfo;
end;
/

create or replace PROCEDURE HrmArrangeShiftInfo_Save (
 resourceid_2 integer ,
 shiftdate_3 char ,
 shiftid_4 integer	,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS 
 count_1 integer;
 begin
 select count(shiftid) into count_1  from HrmArrangeShiftInfo 
 where  resourceid=resourceid_2 and shiftdate = shiftdate_3;
 if count_1 is null or count_1 = 0 then
    INSERT INTO HrmArrangeShiftInfo(resourceid,shiftdate,shiftid) 
    VALUES(resourceid_2,shiftdate_3, shiftid_4);
 else
    UPDATE HrmArrangeShiftInfo 
    SET  shiftid = shiftid_4 
    where  resourceid=resourceid_2 and shiftdate = shiftdate_3;
    end if;
end;
/


create or replace PROCEDURE HrmArrangeShiftProcess_Save (
 resourceid_2 integer ,
 shiftdate_3 char,
 shiftid_4 integer	,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS 
 count_1 integer;
 begin
 select count(shiftid) into count_1 from HrmArrangeShiftInfo 
 where  resourceid=resourceid_2 and shiftdate = shiftdate_3;
 if count_1 is null or count_1 = 0 then
    INSERT INTO HrmArrangeShiftInfo(resourceid,shiftdate,shiftid) 
    VALUES(resourceid_2,shiftdate_3, shiftid_4);
 else
    UPDATE HrmArrangeShiftInfo 
    SET  shiftid = shiftid_4 
    where  resourceid=resourceid_2 and shiftdate = shiftdate_3;
end if;    
end;
/


create or replace PROCEDURE HrmSalaryItem_Update
	(id_1 	integer,
	 itemname_2 	varchar2,
	 itemcode_3 	varchar2,
	 itemtype_4 	char,
	 personwelfarerate_5 	integer,
	 companywelfarerate_6 	integer,
	 taxrelateitem_7 	integer,
	 amountecp_8 	varchar2,
	 feetype_9 	integer,
	 isshow_10 	char,
	 showorder_11 	integer,
	 ishistory_12 	char ,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 

olditemtype_1 char(1) ;
benchid_1 integer;
begin
select itemtype into olditemtype_1 from HrmSalaryItem where id = id_1 ;
UPDATE HrmSalaryItem 
SET  itemname	 = itemname_2,
	 itemcode	 = itemcode_3,
	 itemtype	 = itemtype_4,
	 personwelfarerate	 = personwelfarerate_5,
	 companywelfarerate	 = companywelfarerate_6,
	 taxrelateitem	 = taxrelateitem_7,
	 amountecp	 = amountecp_8,
	 feetype	 = feetype_9,
	 isshow	 = isshow_10,
	 showorder	 = showorder_11,
	 ishistory	 = ishistory_12 

WHERE 
	( id	 = id_1);

if olditemtype_1 = '1' or olditemtype_1 = '2' then
    delete from HrmSalaryRank where itemid = id_1;
else 
    if olditemtype_1 = '5' or olditemtype_1 = '6' then
        delete from HrmSalarySchedule where itemid = id_1;

    else 
        if olditemtype_1 = '3' then
        for benchid_cursor in
        (select id from HrmSalaryTaxbench where itemid = id_1)
        loop
            delete from HrmSalaryTaxrate where benchid = benchid_1;
            delete from HrmSalaryTaxbench where id = benchid_1;
        end loop;
        end if;
    end if;
end if;
end;
/




create  INDEX HrmTimecardInfo_in on HrmTimecardInfo(resourceid , timecarddate)
/

create or replace PROCEDURE HrmTimecardUser_Update
	(resourceid_1 	integer,
	 usercode_2 	varchar2,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
count_1 integer;
begin
select count(usercode) into count_1 from HrmTimecardUser
where resourceid != resourceid_1 and usercode = usercode_2;
if count_1 is not null and count_1 > 0 then
    open thecursor for
    select -1 from dual;
    return ;
end if;

select count(resourceid) into count_1 from HrmTimecardUser where resourceid = resourceid_1;
if count_1 is not null and count_1 > 0 then
    update HrmTimecardUser set usercode = usercode_2 where resourceid = resourceid_1;
else
    insert into HrmTimecardUser(resourceid,usercode) values(resourceid_1,usercode_2 );
    open thecursor for
    select 1 from dual;
end if;
end;
/

create or replace PROCEDURE HrmTimecardInfo_Update
	(resourceid_1 	integer,
	 timecarddate_3 	char,
	 intime_4 	char,
	 outtime_5 	char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
count_1 integer;
begin
select count(resourceid) into count_1 from HrmTimecardInfo 
where resourceid = resourceid_1 and timecarddate = timecarddate_3;
if count_1 is not null and count_1 > 0 then
    UPDATE HrmTimecardInfo 
    SET  intime	 = intime_4,
         outtime	 = outtime_5 
    WHERE 
        ( resourceid	 = resourceid_1 and
         timecarddate	 = timecarddate_3);
else
    insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime) 
    values(resourceid_1,timecarddate_3,intime_4,outtime_5 );
end if;
end;
/


create or replace PROCEDURE HrmSchedule_Select_Current 
 (currentdate_1 varchar2,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 select * from HrmSchedule where validedatefrom <= currentdate_1 and validedateto >= currentdate_1;
 end;
/


create or replace PROCEDURE HrmArrangeShift_Select
( flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
 AS
 begin
  open thecursor for
 select id , shiftbegintime, shiftendtime from HrmArrangeShift order by id;
 end;
/



create or replace PROCEDURE HrmWorkTimeWarp_Insert
	(diffid_1 	integer,
	 resourceid_2 	integer,
	 diffdate_3 	char,
	 difftype_4 	char,
	 intime_5 	char,
	 outtime_6 	char,
	 theintime_7 	char,
	 theouttime_8 	char,
	 counttime_9 	integer,
     diffcounttime_10 	integer,
    flag out integer, 
    msg out varchar2 ,
    thecursor IN OUT cursor_define.weavercursor) 

AS 
begin
INSERT INTO HrmWorkTimeWarp 
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
	( diffid_1,
	 resourceid_2,
	 diffdate_3,
	 difftype_4,
	 intime_5,
	 outtime_6,
	 theintime_7,
	 theouttime_8,
	 counttime_9,
     diffcounttime_10);
end;
/


create or replace PROCEDURE HrmScheduleMaintance_UStype
as
diffid_1 integer ;
difftype_2 char(1);
begin
update HrmScheduleMaintance set difftype = 'A' ;

for diffid_cursor in
    (select id , difftype from HrmScheduleDiff)
loop
    update HrmScheduleMaintance set difftype = difftype_2 where diffid = diffid_1 ;
end loop;
end;
/

call HrmScheduleMaintance_UStype()
/

drop PROCEDURE HrmScheduleMaintance_UStype
/






create or replace PROCEDURE HrmScheduleMain_Insert
	(diffid_1 	integer,
	 resourceid_2 	integer,
	 startdate_3 	char,
	 starttime_4 	char,
	 enddate_5 	char,
	 endtime_6 	char,
	 memo_7 	Varchar2,
	 createtype_8 	integer,
	 createrid_9 	integer,
	 createdate_10 	char,
     realdifftime_11  integer ,
     difftype_12 char,
	  flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmScheduleMaintance 
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
	( diffid_1,
	 resourceid_2,
	 startdate_3,
	 starttime_4,
	 enddate_5,
	 endtime_6,
	 memo_7,
	 createtype_8,
	 createrid_9,
	 createdate_10,
     realdifftime_11,
     difftype_12);
     open thecursor for
select max(id) from HrmScheduleMaintance;
end;
/


create or replace PROCEDURE HrmScheduleMain_Update
	(id_1 	integer,
	 diffid_2 	integer,
	 resourceid_3 	integer,
	 startdate_4 	char,
	 starttime_5 	char,
	 enddate_6 	char,
	 endtime_7 	char,
	 memo_8 	Varchar2,
     realdifftime_11  integer ,
     difftype_12 char,
	  flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE HrmScheduleMaintance SET  
         diffid	 = diffid_2,
	 resourceid	 = resourceid_3,
	 startdate	 = startdate_4,
	 starttime	 = starttime_5,
	 enddate	 = enddate_6,
	 endtime	 = endtime_7,
	 memo        = memo_8 ,
     realdifftime = realdifftime_11 ,
     difftype    = difftype_12 
WHERE 
	( id	 = id_1);
end;
/





create or replace PROCEDURE HrmSalaryScheduleDec_Insert(
 itemid_2 integer ,
 diffid_1 integer ,	
	  flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 INSERT INTO HrmSalarySchedule(
 diffid , itemid)  
 VALUES(
 diffid_1 , itemid_2);
 end;
/



create or replace PROCEDURE HrmSalaryScheduleAdd_Insert(
 itemid_2 char,
 diffid_1 integer ,
  flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 INSERT INTO HrmSalarySchedule(
 diffid , itemid)  
 VALUES(
 diffid_1 , itemid_2);
 end;
/

CREATE or REPLACE PROCEDURE HrmWorkTimeCount_Insert
(resourceid_1 	integer,
 workdate_2 	char,
 shiftid_3 	integer,
 workcount_4 	integer,	
 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO HrmWorkTimeCount 
	 ( resourceid,
	 workdate,
	 shiftid,
	 workcount) 
 
VALUES 
	( resourceid_1,
	 workdate_2,
	 shiftid_3,
	 workcount_4) ;
end ;
/

CREATE or REPLACE PROCEDURE HrmSalaryShiftPay_SByItemid
(itemid_1 	integer,
 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )
AS 
begin 
open thecursor for
Select * from HrmSalaryShiftPay where itemid = itemid_1 ;
end ;
/

CREATE PROCEDURE HrmSalaryShiftPay_Insert
	(itemid_1 	integer,
	 shiftid_2 	integer,
	 shiftpay_3 	number,	
     flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO HrmSalaryShiftPay 
	 ( itemid,
	 shiftid,
	 shiftpay) 
 
VALUES 
	( itemid_1,
	 shiftid_2,
	 shiftpay_3) ;
end ;
/


CREATE or REPLACE PROCEDURE HrmSalaryShiftPay_Delete
	(itemid_1 	integer,	
     flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )

AS 
begin
DELETE HrmSalaryShiftPay 
WHERE ( itemid	 = itemid_1) ;
end ;
/



create or replace PROCEDURE HrmSalaryItem_Update
	(id_1 	integer,
	 itemname_2 	varchar2,
	 itemcode_3 	varchar2,
	 itemtype_4 	char,
	 personwelfarerate_5 	integer,
	 companywelfarerate_6 	integer,
	 taxrelateitem_7 	integer,
	 amountecp_8 	varchar2,
	 feetype_9 	integer,
	 isshow_10 	char,
	 showorder_11 	integer,
	 ishistory_12 	char ,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )

AS 

olditemtype_1 char(1) ;
benchid_1 integer;
begin
select itemtype into olditemtype_1 from HrmSalaryItem where id = id_1 ;
UPDATE HrmSalaryItem 
SET  itemname	 = itemname_2,
	 itemcode	 = itemcode_3,
	 itemtype	 = itemtype_4,
	 personwelfarerate	 = personwelfarerate_5,
	 companywelfarerate	 = companywelfarerate_6,
	 taxrelateitem	 = taxrelateitem_7,
	 amountecp	 = amountecp_8,
	 feetype	 = feetype_9,
	 isshow	 = isshow_10,
	 showorder	 = showorder_11,
	 ishistory	 = ishistory_12 

WHERE 
	( id	 = id_1);

if olditemtype_1 = '1' or olditemtype_1 = '2' then
    delete from HrmSalaryRank where itemid = id_1;
else 
    if olditemtype_1 = '5' or olditemtype_1 = '6' then
        delete from HrmSalarySchedule where itemid = id_1;
    else 
        if olditemtype_1 = '7' then
            delete from HrmSalaryShiftPay where itemid = id_1 ;
        else 
            if olditemtype_1 = '3' then
            for benchid_cursor in
            (select id from HrmSalaryTaxbench where itemid = id_1)
            loop
                delete from HrmSalaryTaxrate where benchid = benchid_1;
                delete from HrmSalaryTaxbench where id = benchid_1;
            end loop;
            end if;
        end if;
    end if;
end if;
end;
/



create or replace PROCEDURE HrmSalaryItem_Delete
	(id_1 	integer ,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
olditemtype_1 char(1) ;
benchid_1 integer;
begin
select itemtype into olditemtype_1 from HrmSalaryItem where id = id_1 ;

DELETE HrmSalaryItem 
WHERE ( id	 = id_1);

if olditemtype_1 = '1' then
    delete from HrmSalaryRank where itemid = id_1 ;
else 
    if olditemtype_1 = '5' or olditemtype_1 = '6' then
        delete from HrmSalarySchedule where itemid = id_1;
    else 
        if olditemtype_1 = '7' then
            delete from HrmSalaryShiftPay where itemid = id_1 ;
        else 
            if olditemtype_1 = '2' then
                delete from HrmSalaryRank where itemid = id_1;
                delete from HrmSalaryWelfarerate where itemid = id_1;
            else 
                if olditemtype_1 = '3' then
                    for benchid_cursor in
                    (select id from HrmSalaryTaxbench where itemid = id_1)
                    loop
                        delete from HrmSalaryTaxrate where benchid = benchid_1;
                        delete from HrmSalaryTaxbench where id = benchid_1;
                    end loop;
                end if;
            end if;
        end if;
    end if ;
end if;
end;
/



CREATE or REPLACE PROCEDURE  HrmSalaryDiffDetail_Insert
	(itemid_1 	integer,
	 resourceid_2 	integer,
	 payid_3 	integer,
	 diffid_4 	integer,
	 difftypeid_5 	integer,
	 startdate_6 	char,
	 enddate_7 	char,
	 realcounttime_8 	integer,
	 realcountpay_9 	number ,
         flag	out integer, 
         msg   out	varchar2, 
         thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO HrmSalaryDiffDetail 
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
	( itemid_1,
	 resourceid_2,
	 payid_3,
	 diffid_4,
	 difftypeid_5,
	 startdate_6,
	 enddate_7,
	 realcounttime_8,
	 realcountpay_9) ;
end ;
/


/*查询打卡机数据 
 create by Wangxiaoyi 2003-10-30
 */

CREATE or REPLACE PROCEDURE HrmCardInfo_SelectCount (
carddate_3 char,/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
workshift_5  char ,/*班组,最多可设置16个班组，即0~9,A~F*/
Cardid_6  char , /*card id*/
flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor ) 
 AS
 begin
 open thecursor for
 select count(id) from HrmCardInfo where carddate = carddate_3 and workshift = workshift_5 and Cardid = Cardid_6 ;
 end ;
/




CREATE or REPLACE PROCEDURE HrmCardInfo_Insert (
stationid_2 char , /*卡钟的台号*/
carddate_3 char,/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
cardtime_4 char , /*打卡时间，格式：hh:nn(08:12)*/
workshift_5  char ,/*班组,最多可设置16个班组，即0~9,A~F*/
Cardid_6  char , /*card id*/
flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )

 AS 
 begin
 INSERT INTO HrmCardInfo (
 stationid , 
 carddate , 
 cardtime , 
 workshift , 
 Cardid ) 
 
 VALUES (
 stationid_2 , 
 carddate_3 , 
 cardtime_4 , 
 workshift_5 , 
 Cardid_6 
) ;
end;
/





CREATE or REPLACE PROCEDURE HrmValidateCardInfo_Insert (
 stationid_2 char , /*卡钟的台号*/
 carddate_3 char,/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
 cardtime_4 char , /*打卡时间，格式：hh:nn(08:12)*/
 workshift_5  char ,/*班组,最多可设置16个班组，即0~9,A~F*/
 Cardid_6  char , /*card id*/
 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )

 AS 
 begin
 INSERT INTO HrmValidateCardInfo (
 stationid , 
 carddate , 
 cardtime , 
 workshift , 
 Cardid ) 
 
 VALUES (
 stationid_2 , 
 carddate_3 , 
 cardtime_4 , 
 workshift_5 , 
 Cardid_6 
) ;
end ;
/



create or replace PROCEDURE HrmTimecardInfo_Update
	(resourceid_1 	integer,
	 timecarddate_3 	char,
	 intime_4 	char,
	 outtime_5 	char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS 
count_1 integer;
begin
select count(resourceid) into count_1 from HrmTimecardInfo 
where resourceid = resourceid_1 and timecarddate = timecarddate_3;
if count_1 is not null and count_1 > 0 then
    UPDATE HrmTimecardInfo 
    SET  outtime	 = outtime_5 
    WHERE 
        ( resourceid	 = resourceid_1 and
         timecarddate	 = timecarddate_3);
else
    insert into HrmTimecardinfo(resourceid,timecarddate,intime) 
    values(resourceid_1,timecarddate_3,intime_4 );
end if;
end;
/


/*考勤系统设置*/
CREATE TABLE HrmkqSystemSet (
tosomeone varchar2 (60)  NULL , /*收件人地址*/
timeinterval integer /*采集数据时间间隔*/
)
/


CREATE PROCEDURE HrmkqSystemSet_Select(
 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )
AS 
begin
open thecursor for
select * from HrmkqSystemSet ;
end ;
/


CREATE or REPLACE PROCEDURE HrmkqSystem_Insert(
 tosomeone_1 varchar2 ,	
 timeinterval_2 integer ,
 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 INSERT INTO HrmkqSystemSet(tosomeone , timeinterval)  
 VALUES(tosomeone_1 , timeinterval_2) ;
 end ;
/


CREATE or REPLACE PROCEDURE  HrmkqSystemSet_Update(
tosomeone_1  varchar2 ,
timeinterval_2  integer , 
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
update HrmkqSystemSet set tosomeone = tosomeone_1 , timeinterval = timeinterval_2 ;
end ;
/

insert into 
SystemRightDetail (id,rightdetailname,rightdetail,rightid) 
values (3070,'默认时间表新建','HrmDefaultScheduleAdd:Add',35)
/

INSERT INTO HtmlLabelIndex values(16689,'上午') 
/
INSERT INTO HtmlLabelInfo VALUES(16689,'上午',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16689,'morning',8) 
/

INSERT INTO HtmlLabelIndex values(16690,'下午') 
/
INSERT INTO HtmlLabelInfo VALUES(16690,'下午',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16690,'afternoon',8) 
/

INSERT INTO HtmlLabelIndex values(16691,'历史列表') 
/
INSERT INTO HtmlLabelInfo VALUES(16691,'历史列表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16691,'',8) 
/

INSERT INTO HtmlLabelIndex values(16692,'排班管理') 
/
INSERT INTO HtmlLabelInfo VALUES(16692,'排班管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16692,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16693,'排班批处理') 
/
INSERT INTO HtmlLabelInfo VALUES(16693,'排班批处理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16693,'',8) 
/

INSERT INTO HtmlLabelIndex values(16694,'排班日期') 
/
INSERT INTO HtmlLabelInfo VALUES(16694,'排班日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16694,'',8) 
/

INSERT INTO HtmlLabelIndex values(16695,'排班设置') 
/
INSERT INTO HtmlLabelInfo VALUES(16695,'排班设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16695,'',8) 
/

INSERT INTO HtmlLabelIndex values(16696,'开始时间和结束时间没有成对出现！') 
/
INSERT INTO HtmlLabelInfo VALUES(16696,'开始时间和结束时间没有成对出现！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16696,'',8) 
/

INSERT INTO HtmlLabelIndex values(16697,'一般工作时间历史') 
/
INSERT INTO HtmlLabelInfo VALUES(16697,'一般工作时间历史',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16697,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16698,'打卡数据Excel表') 
/
INSERT INTO HtmlLabelInfo VALUES(16698,'打卡数据Excel表',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16698,'',8) 
/

INSERT INTO HtmlLabelIndex values(16699,'Excel文件') 
/
INSERT INTO HtmlLabelInfo VALUES(16699,'Excel文件',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16699,'',8) 
/

INSERT INTO HtmlLabelIndex values(16700,'打卡数据导入错误') 
/
INSERT INTO HtmlLabelInfo VALUES(16700,'打卡数据导入错误',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16700,'',8) 
/

INSERT INTO HtmlLabelIndex values(16701,'导入无对应用户数据') 
/
INSERT INTO HtmlLabelInfo VALUES(16701,'导入无对应用户数据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16701,'',8) 
/

INSERT INTO HtmlLabelIndex values(16702,'外部打卡用户编号') 
/
INSERT INTO HtmlLabelInfo VALUES(16702,'外部打卡用户编号',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16702,'',8) 
/

INSERT INTO HtmlLabelIndex values(16703,'打卡日期') 
/
INSERT INTO HtmlLabelInfo VALUES(16703,'打卡日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16703,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16704,'入公司时间') 
/
INSERT INTO HtmlLabelInfo VALUES(16704,'入公司时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16704,'',8) 
/

INSERT INTO HtmlLabelIndex values(16705,'出公司时间') 
/
INSERT INTO HtmlLabelInfo VALUES(16705,'出公司时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16705,'',8) 
/

INSERT INTO HtmlLabelIndex values(16706,'导出设置') 
/
INSERT INTO HtmlLabelInfo VALUES(16706,'导出设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16706,'',8) 
/

INSERT INTO HtmlLabelIndex values(16707,'导出开始日期') 
/
INSERT INTO HtmlLabelInfo VALUES(16707,'导出开始日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16707,'',8) 
/

INSERT INTO HtmlLabelIndex values(16708,'导出结束日期') 
/
INSERT INTO HtmlLabelInfo VALUES(16708,'导出结束日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16708,'',8) 
/

INSERT INTO HtmlLabelIndex values(16709,'是否计算薪资') 
/
INSERT INTO HtmlLabelInfo VALUES(16709,'是否计算薪资',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16709,'',8) 
/

INSERT INTO HtmlLabelIndex values(16710,'薪资计算方式') 
/
INSERT INTO HtmlLabelInfo VALUES(16710,'薪资计算方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16710,'',8) 
/

INSERT INTO HtmlLabelIndex values(16711,'计算值') 
/
INSERT INTO HtmlLabelInfo VALUES(16711,'计算值',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16711,'',8) 
/

INSERT INTO HtmlLabelIndex values(16712,'基准工资项') 
/
INSERT INTO HtmlLabelInfo VALUES(16712,'基准工资项',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16712,'',8) 
/

INSERT INTO HtmlLabelIndex values(16713,'最小计算时间') 
/
INSERT INTO HtmlLabelInfo VALUES(16713,'最小计算时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16713,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16714,'时间计算方式') 
/
INSERT INTO HtmlLabelInfo VALUES(16714,'时间计算方式',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16714,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16715,'以考勤时间计算') 
/
INSERT INTO HtmlLabelInfo VALUES(16715,'以考勤时间计算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16715,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16716,'以打卡时间计算') 
/
INSERT INTO HtmlLabelInfo VALUES(16716,'以打卡时间计算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16716,'',8) 
/

INSERT INTO HtmlLabelIndex values(16717,'以较大时间计算') 
/
INSERT INTO HtmlLabelInfo VALUES(16717,'以较大时间计算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16717,'',8) 
/

INSERT INTO HtmlLabelIndex values(16718,'以较小时间计算') 
/
INSERT INTO HtmlLabelInfo VALUES(16718,'以较小时间计算',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16718,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16719,'考勤计算时间') 
/
INSERT INTO HtmlLabelInfo VALUES(16719,'考勤计算时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16719,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16720,'打卡计算时间') 
/
INSERT INTO HtmlLabelInfo VALUES(16720,'打卡计算时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16720,'',8) 
/

INSERT INTO HtmlLabelIndex values(16721,'开始日期不能大于结束日期！') 
/
INSERT INTO HtmlLabelInfo VALUES(16721,'开始日期不能大于结束日期！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16721,'',8) 
/

INSERT INTO HtmlLabelIndex values(16722,'开始时间不能大于结束时间！') 
/
INSERT INTO HtmlLabelInfo VALUES(16722,'开始时间不能大于结束时间！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16722,'',8) 
/

INSERT INTO HtmlLabelIndex values(16723,'打卡数据文件下载：') 
/
INSERT INTO HtmlLabelInfo VALUES(16723,'打卡数据文件下载：',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16723,'',8) 
/

INSERT INTO HtmlLabelIndex values(16724,'打卡用户编码管理') 
/
INSERT INTO HtmlLabelInfo VALUES(16724,'打卡用户编码管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16724,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16725,'本系统ID') 
/
INSERT INTO HtmlLabelInfo VALUES(16725,'本系统ID',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16725,'',8) 
/

INSERT INTO HtmlLabelIndex values(16726,'打卡用户编码冲突！！！') 
/
INSERT INTO HtmlLabelInfo VALUES(16726,'打卡用户编码冲突！！！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16726,'',8) 
/

INSERT INTO HtmlLabelIndex values(16727,'用户编码信息') 
/
INSERT INTO HtmlLabelInfo VALUES(16727,'用户编码信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16727,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16728,'本系统用户ID') 
/
INSERT INTO HtmlLabelInfo VALUES(16728,'本系统用户ID',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16728,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16729,'生成出勤统计') 
/
INSERT INTO HtmlLabelInfo VALUES(16729,'生成出勤统计',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16729,'',8) 
/

INSERT INTO HtmlLabelIndex values(16730,'出勤生成日期') 
/
INSERT INTO HtmlLabelInfo VALUES(16730,'出勤生成日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16730,'',8) 
/

INSERT INTO HtmlLabelIndex values(16731,'员工出勤管理') 
/
INSERT INTO HtmlLabelInfo VALUES(16731,'员工出勤管理',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16731,'',8) 
/

INSERT INTO HtmlLabelIndex values(16732,'出勤统计') 
/
INSERT INTO HtmlLabelInfo VALUES(16732,'出勤统计',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16732,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16733,'编辑出勤统计') 
/
INSERT INTO HtmlLabelInfo VALUES(16733,'编辑出勤统计',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16733,'',8) 
/

INSERT INTO HtmlLabelIndex values(16734,'生成偏差') 
/
INSERT INTO HtmlLabelInfo VALUES(16734,'生成偏差',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16734,'',8) 
/

INSERT INTO HtmlLabelIndex values(16735,'偏差生成日期') 
/
INSERT INTO HtmlLabelInfo VALUES(16735,'偏差生成日期',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16735,'',8) 
/

INSERT INTO HtmlLabelIndex values(16736,'考勤关联') 
/
INSERT INTO HtmlLabelInfo VALUES(16736,'考勤关联',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16736,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16737,'获取打卡数据') 
/
INSERT INTO HtmlLabelInfo VALUES(16737,'获取打卡数据',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16737,'',8) 
/

INSERT INTO HtmlLabelIndex values(16738,'考勤系统设置') 
/
INSERT INTO HtmlLabelInfo VALUES(16738,'考勤系统设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16738,'',8) 
/

INSERT INTO HtmlLabelIndex values(16739,'实际计算金额') 
/
INSERT INTO HtmlLabelInfo VALUES(16739,'实际计算金额',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16739,'',8) 
/

 INSERT INTO HtmlLabelIndex values(16740,'出勤津贴') 
/
INSERT INTO HtmlLabelInfo VALUES(16740,'出勤津贴',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16740,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16741,'出勤种类') 
/
INSERT INTO HtmlLabelInfo VALUES(16741,'出勤种类',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16741,'',8) 
/

INSERT INTO HtmlLabelIndex values(16742,'考勤打卡数据正在采集，离开该页面会导致数据采集停止，真的要离开吗？') 
/
INSERT INTO HtmlLabelInfo VALUES(16742,'考勤打卡数据正在采集，离开该页面会导致数据采集停止，真的要离开吗？',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16742,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16743,'考勤系统管理员邮件设置') 
/
INSERT INTO HtmlLabelInfo VALUES(16743,'考勤系统管理员邮件设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16743,'',8) 
/

INSERT INTO HtmlLabelIndex values(16744,'数据采集时间间隔') 
/
INSERT INTO HtmlLabelInfo VALUES(16744,'数据采集时间间隔',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16744,'',8) 
/
 
INSERT INTO HtmlLabelIndex values(16745,'收件人地址') 
/
INSERT INTO HtmlLabelInfo VALUES(16745,'收件人地址',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16745,'',8) 
/

INSERT INTO HtmlLabelIndex values(16746,'设置成功!') 
/
INSERT INTO HtmlLabelInfo VALUES(16746,'设置成功!',7) 
/
INSERT INTO HtmlLabelInfo VALUES(16746,'',8) 
/
 

