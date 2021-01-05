/*开发者：刘煜 功能：人力资源的工资与考勤功能*/
create or replace PROCEDURE HrmArrangeShift_SelectAll
(ishistory_1 char,
 flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 select * from HrmArrangeShift where ishistory = ishistory_1 order by id;
 end;
/


/* 人力资源排班人员表 记录属于排班的人*/
create table HrmArrangeShiftSet (
id integer not null primary key ,
resourceid integer
)
/

create sequence HrmArrangeShiftSet_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmArrangeShiftSet_Trigger
before insert on HrmArrangeShiftSet
for each row
begin
select HrmArrangeShiftSet_id.nextval into :new.id from dual;
end;
/




create or replace PROCEDURE HrmArrangeShiftSet_Insert 
(
 resourceid_2 	 varchar2,
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO HrmArrangeShiftSet (resourceid) VALUES (resourceid_2) ;
 end;
/


create or replace PROCEDURE HrmArrangeShiftSet_Delete 
(
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 delete from HrmArrangeShiftSet ;
 end;
/



/* 公众假日，改为工作时间调整 */

alter table HrmPubHoliday add changetype integer   /* 调整类型 ： 1：设置为法定假日 2： 设置为工作日 3： 设置为休息日 */
/
alter table HrmPubHoliday add relateweekday integer  /* 设置为工作日的时候对应的星期 1: 星期日 2:星期一 .... 7:星期六 */
/

update HrmPubHoliday set changetype = 1
/

CREATE or replace PROCEDURE HrmPubHoliday_Insert 
(countryid_1 	integer, 
holidaydate_2 	char,
holidayname_3 	varchar2,
changetype_4  integer ,
relateweekday_5 integer ,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
xx integer;
begin

select count(id) into xx from hrmpubholiday where countryid=countryid_1 and holidaydate=holidaydate_2; 
if xx<>0 then
 INSERT INTO HrmPubHoliday ( countryid, holidaydate, holidayname,changetype,relateweekday) 
 VALUES (countryid_1, holidaydate_2, holidayname_3,changetype_4,relateweekday_5);
end if;
open thecursor for
select max(id) from hrmpubholiday;
end;
/


CREATE or replace PROCEDURE HrmPubHoliday_Update 
(id_1 integer,
holidayname_2 	varchar2, 
changetype_4  integer ,
relateweekday_5 integer ,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin 
  update HrmPubHoliday set 
  holidayname=holidayname_2 ,
  changetype=changetype_4 ,
  relateweekday=relateweekday_5 
  where id=id_1 ;
end;
/


alter table HrmkqSystemSet add getdatatype integer   /* 数据采集方式 */
/

alter table HrmkqSystemSet add getdatavalue varchar2(200)   /* 各个方式的值 */
/

alter table HrmkqSystemSet add avgworkhour integer  /* 平均每月工作时间(小时) */
/

delete from HrmkqSystemSet
/

insert into HrmkqSystemSet values('',60,1,'1',172)
/


CREATE or REPLACE PROCEDURE  HrmkqSystemSet_Update(
tosomeone_1  varchar2 ,
timeinterval_2  integer , 
getdatatype_3  integer , 
getdatavalue_4  varchar2 , 
avgworkhour_5  integer , 
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
update HrmkqSystemSet 
set 
tosomeone = tosomeone_1 , 
timeinterval = timeinterval_2 ,
getdatatype = getdatatype_3 , 
getdatavalue = getdatavalue_4 , 
avgworkhour = avgworkhour_5  ;
end ;
/




/* 对打卡记录增加一个有效的记录列表, 以便进行统计 */

CREATE TABLE HrmRightCardInfo (
	id integer not null primary key ,
    resourceid integer, /*人力资源id*/
    carddate char(10) null , /*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
    cardtime char(5) null ,  /*打卡时间，格式：hh:nn(08:12)*/
    inorout  integer ,           /*出公司还是入公司 0:出 1:入 现在暂时不用 */
    islegal integer default 1 /* 考勤的合法性, 合法 1, 不合法 2 */
)
/

create sequence HrmRightCardInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmRightCardInfo_Trigger
before insert on HrmRightCardInfo
for each row
begin
select HrmRightCardInfo_id.nextval into :new.id from dual;
end;
/



CREATE or REPLACE PROCEDURE HrmRightCardInfo_Insert (
resourceid_2 integer , /*卡钟的台号*/
carddate_3 char,/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
cardtime_4 char, /*打卡时间，格式：hh:nn(08:12)*/
inorout_5  integer ,           /*出公司还是入公司 0:出 1:入 现在暂时不用 */
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
AS 

 cardcount number;
 reccount integer;

begin
 INSERT INTO HrmRightCardInfo (
 resourceid , 
 carddate , 
 cardtime , 
 inorout            
 ) 
 VALUES (
 resourceid_2 , 
 carddate_3 , 
 cardtime_4 , 
 inorout_5 
 ) ;
 
 select count(id) into cardcount from HrmRightCardInfo where carddate = carddate_3 and resourceid = resourceid_2 ;

 if cardcount > 2  then /* 一天打卡超过3次 */
    select count(id) into reccount  from HrmArrangeShiftSet where resourceid = resourceid_2 ;
    if reccount = 0  then /* 是按照一般工作时间计算, 认为不正常 */
        update HrmRightCardInfo set islegal = 2 where carddate = carddate_3 and resourceid = resourceid_2 ;
    else /* 按照排班计算, 计算当天的排班数量 */
        select count(id) into reccount  from HrmArrangeShiftInfo where resourceid = resourceid_2 and shiftdate = carddate_3 ;
        if reccount * 2 < cardcount  then /* 打卡次数超过排班次数*2 , 认为不正常 */
            update HrmRightCardInfo set islegal = 2 where carddate = carddate_3 and resourceid = resourceid_2 ;
        end if ;
    end if ;
 end if ; 
end ;
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
 where  resourceid=resourceid_2 and shiftdate = shiftdate_3 and shiftid=shiftid_4 ;
 if count_1 is null or count_1 = 0 then
    INSERT INTO HrmArrangeShiftInfo(resourceid,shiftdate,shiftid) 
    VALUES(resourceid_2,shiftdate_3, shiftid_4);
 end if;
end;
/


drop PROCEDURE HrmArrangeShiftProcess_Save
/


CREATE PROCEDURE HrmRightCardInfo_Delete (
id_1 integer ,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS 
 resourceid_2 integer;
 carddate_3 char(10) ;
 cardcount integer;
 reccount integer;
 begin

 select resourceid , carddate into resourceid_2  , carddate_3  from HrmRightCardInfo where id = id_1 ;

 delete HrmRightCardInfo where id = id_1 ;

 select count(id) into cardcount from HrmRightCardInfo where carddate = carddate_3 and resourceid = resourceid_2 ;

 if cardcount <= 2  then /* 一天打卡不超过2次 认为正常*/
    update HrmRightCardInfo set islegal = 1 where carddate = carddate_3 and resourceid = resourceid_2 ;
 else 
    select count(id) into reccount  from HrmArrangeShiftSet where resourceid = resourceid_2 ;
    if reccount > 0  then /* 按照排班计算, 计算当天的排班数量 */
        select count(id) into reccount from HrmArrangeShiftInfo where resourceid = resourceid_2 and shiftdate = carddate_3 ;
        if reccount * 2 >= cardcount then  /* 打卡次数不超过排班次数*2 , 认为正常 */
            update HrmRightCardInfo set islegal = 1 where carddate = carddate_3 and resourceid = resourceid_2 ;
        end if ;
     end if ;
 end if ;
end ;
/


alter table HrmTimecardInfo add relateshiftid integer 
/


create or replace PROCEDURE HrmArrangeShift_Select
( flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
 AS
 begin
  open thecursor for
 select id , shiftbegintime, shiftendtime from HrmArrangeShift order by shiftbegintime;
 end;
/


alter table HrmRightCardInfo add workout integer default 0  /* 是否为加班 (在无效页面转入加班) 0 : 否 1 : 是 */
/

update HrmRightCardInfo set workout = 0 
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
where resourceid != resourceid_1 and usercode is not null and usercode = usercode_2 ;
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


/* 人力资源工资项目关联出勤杂费信息表 */
create table HrmSalaryResourcePay(
id	integer not null primary key ,
itemid  integer ,                           /*工资项目id*/
resourceid  integer ,                          /*人力资源id*/
resourcepay  number(10,2)                 /*金额*/
)
/

create sequence HrmSalaryResourcePay_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmSalaryResourcePay_Trigger
before insert on HrmSalaryResourcePay
for each row
begin
select HrmSalaryResourcePay_id.nextval into :new.id from dual;
end;
/




create or replace PROCEDURE HrmSalaryResourcePay_SByItemid
	(itemid_1 	integer,
     flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for
Select * from HrmSalaryResourcePay where itemid = itemid_1 ;
end ;
/

create or replace PROCEDURE HrmSalaryResourcePay_Insert
	(itemid_1 	integer,
	 resourceid_2 	integer,
	 resourcepay_3 	number,	
     flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin

INSERT INTO HrmSalaryResourcePay 
	 ( itemid,
	 resourceid,
	 resourcepay) 
 
VALUES 
	( itemid_1,
	 resourceid_2,
	 resourcepay_3);
end ;
/



create or replace PROCEDURE HrmSalaryResourcePay_Delete
	(itemid_1 	integer,	
     flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
DELETE from HrmSalaryResourcePay WHERE ( itemid	 = itemid_1) ;
end ;
/





create or replace PROCEDURE  HrmSalaryShiftPay_Insert
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


/* 未执行 */

update HrmScheduleDiff set countnum = null 
/
alter table HrmScheduleDiff modify (countnum  number(10, 2)) 
/

update HrmScheduleDiff set countnum = 0 
/


CREATE or REPLACE PROCEDURE HrmScheduleDiff_Insert 
 (diffname_1 	varchar2, 
  diffdesc_2 	varchar2, 
  difftype_3 	char, 
  difftime_4 	char, 
  mindifftime_5 	smallint, 
  workflowid_6 	integer, 
  salaryable_7 	char, 
  counttype_8 	char, 
  countnum_9 	integer,  
  salaryitem_11 	integer, 
  diffremark_12 	varchar2,
  color_13 varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS
countnum_10 number(10,2) ;
begin

if countnum_9 is not null or countnum_9 <>'' then 
    countnum_10 := to_number(countnum_9) ;
else 
    countnum_10 := 0  ;
end if ;

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
( diffname_1, 
  diffdesc_2, 
  difftype_3, 
  difftime_4, 
  mindifftime_5, 
  workflowid_6, 
  salaryable_7, 
  counttype_8, 
  countnum_10,   /* 注意， 这里由 countnum_9 变成了 countnum_10 */   
  salaryitem_11, 
  diffremark_12,
  color_13);
 open thecursor for 
select max(id) from HrmScheduleDiff ;
end;
/


CREATE or REPLACE PROCEDURE HrmScheduleDiff_Update 
 (id_1 	integer, 
  diffname_2 	varchar2, 
  diffdesc_3 	varchar2, 
  difftype_4 	char, 
  difftime_5 	char, 
  mindifftime_6 	smallint, 
  workflowid_7 	integer, 
  salaryable_8 	char, 
  counttype_9 	char, 
  countnum_11      varchar2, 
  salaryitem_12 	integer, 
  diffremark_13 	varchar2, 
  color_14 varchar2,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor) 
AS 
  countnum_10 number(10,3);
  begin 
  if countnum_11 is not null or countnum_11 <>'' then
   countnum_10 := to_number(countnum_11); 
  else
    countnum_10 := 0 ;
	end if;	

UPDATE HrmScheduleDiff  SET  
  diffname	 = diffname_2, 
  diffdesc	 = diffdesc_3, 
  difftype	 = difftype_4, 
  difftime	 = difftime_5, 
  mindifftime	 = mindifftime_6, 
  workflowid	 = workflowid_7, 
  salaryable	 = salaryable_8, 
  counttype	 = counttype_9, 
  countnum	 = countnum_10, 
  salaryitem	 = salaryitem_12, 
  diffremark	 = diffremark_13,
  color = color_14
WHERE 
( id	 = id_1)  ;
end;
/



insert into SystemRights (id,rightdesc,righttype) values (399,'排班维护','3') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3088,'排班维护','HrmArrangeShiftMaintance:Maintance',399) 
/

insert into SystemRightToGroup (groupid,rightid) values (3,399)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (399,4,'1')
/


insert into SystemRights (id,rightdesc,righttype) values (400,'排班种类维护','3') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3089,'排班种类维护','HrmArrangeShift:Maintance',400) 
/

insert into SystemRightToGroup (groupid,rightid) values (3,400)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (400,4,'1')
/


insert into SystemRights (id,rightdesc,righttype) values (401,'考勤系统设置','3') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3090,'考勤系统设置','HrmkqSystemSetEdit:Edit',401) 
/

insert into SystemRightToGroup (groupid,rightid) values (3,401)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (401,4,'1')
/

insert into SystemRights (id,rightdesc,righttype) values (402,'打卡用户接口维护','3') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3091,'打卡用户接口维护','HrmTimecardUser:Maintenance',402) 
/
insert into SystemRightToGroup (groupid,rightid) values (3,402)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (402,4,'1')
/

insert into SystemRights (id,rightdesc,righttype) values (403,'出勤与偏差维护','3') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3092,'出勤与偏差维护','HrmWorktimeWarp:Maintenance',403) 
/

insert into SystemRightToGroup (groupid,rightid) values (3,403)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (403,4,'1')
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

if olditemtype_1 = '1' then
    delete from HrmSalaryRank where itemid = id_1;
    delete from HrmSalaryResourcePay where itemid = id_1 ;
else 
    if olditemtype_1 = '2' then
        delete from HrmSalaryRank where itemid = id_1 ;
        delete from HrmSalaryWelfarerate where itemid = id_1 ;
        delete from HrmSalaryResourcePay where itemid = id_1 ;
    else 
        if olditemtype_1 = '5' or olditemtype_1 = '6' then
            delete from HrmSalarySchedule where itemid = id_1;
        else 
            if olditemtype_1 = '7' then
                delete from HrmSalaryShiftPay where itemid = id_1 ;
            else 
                if olditemtype_1 = '8' then
                    delete from HrmSalaryResourcePay where itemid = id_1 ;
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
            end if ;
        end if;
    end if ;
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

DELETE HrmSalaryItem  WHERE ( id	 = id_1);

if olditemtype_1 = '1' then
    delete from HrmSalaryRank where itemid = id_1 ;
    delete from HrmSalaryResourcePay where itemid = id_1 ;
else 
    if olditemtype_1 = '5' or olditemtype_1 = '6' then
        delete from HrmSalarySchedule where itemid = id_1;
    else 
        if olditemtype_1 = '7' then
            delete from HrmSalaryShiftPay where itemid = id_1 ;
        else 
            if olditemtype_1 = '8' then 
                delete from HrmSalaryResourcePay where itemid = id_1 ;
            else 
                if olditemtype_1 = '2' then
                    delete from HrmSalaryRank where itemid = id_1;
                    delete from HrmSalaryWelfarerate where itemid = id_1;
                    delete from HrmSalaryResourcePay where itemid = id_1；
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
            end if ;
        end if;
    end if ;
end if;
end;
/


alter table  HrmSalaryWelfarerate modify (personwelfarerate  number(10, 2))  
/

alter table  HrmSalaryWelfarerate modify (companywelfarerate  number(10, 2))  
/



CREATE or REPLACE PROCEDURE HrmSalaryWelfarerate_Insert
    (itemid_1 	integer,
     cityid_2 	integer,
     personwelfarerate_3 	integer,
     companywelfarerate_4 	integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
AS
begin
INSERT INTO HrmSalaryWelfarerate 
	 ( itemid,
	 cityid,
	 personwelfarerate,
	 companywelfarerate) 
 
VALUES 
	( itemid_1,
	 cityid_2,
	 personwelfarerate_3,
	 companywelfarerate_4);
end;
/


alter table HrmkqSystemSet add  salaryenddate integer   /* 薪资计算截至日期（包含当天） */
/

update HrmkqSystemSet set salaryenddate=31 
/


CREATE or REPLACE PROCEDURE  HrmkqSystemSet_Update(
tosomeone_1  varchar2 ,
timeinterval_2  integer , 
getdatatype_3  integer , 
getdatavalue_4  varchar2 , 
avgworkhour_5  integer , 
salaryenddate_6  int , 
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
update HrmkqSystemSet 
set 
tosomeone = tosomeone_1 , 
timeinterval = timeinterval_2 ,
getdatatype = getdatatype_3 , 
getdatavalue = getdatavalue_4 , 
avgworkhour = avgworkhour_5  ,
salaryenddate = salaryenddate_6  ;
end ;
/
alter table HrmSalaryRank add jobactivityid integer /*工资和福利项目选项加入职务选择*/
/ 


CREATE or REPLACE PROCEDURE HrmSalaryRank_Insert
	(itemid_1 	integer,
	 jobid_2 	integer,
	 joblevelfrom_3 	integer,
	 joblevelto_4 	integer,
	 amount_5 	number,
     jobactivityid_6 	integer,
	flag out integer ,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)

AS 
begin
INSERT INTO HrmSalaryRank 
	 ( itemid,
	 jobid,
	 joblevelfrom,
	 joblevelto,
	 amount,
     jobactivityid) 
 
VALUES 
	( itemid_1,
	 jobid_2,
	 joblevelfrom_3,
	 joblevelto_4,
	 amount_5,
     jobactivityid_6);
end;
/


CREATE or REPLACE PROCEDURE HrmRightCardInfo_Insert (
resourceid_2 integer , /*卡钟的台号*/
carddate_3 char,/*打卡日期，格式：yyyy-mm-dd(1900-00-00)*/
cardtime_4 char, /*打卡时间，格式：hh:nn(08:12)*/
inorout_5  integer ,           /*出公司还是入公司 0:出 1:入 现在暂时不用 */
flag	out integer, 
msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
AS 

 cardcount number;
 reccount integer;

begin

select count(id) into cardcount  from HrmRightCardInfo where carddate = carddate_3 and resourceid = resourceid_2 and cardtime = cardtime_4  ;
if cardcount = 0 then  /* 只有不相同的打卡才录入 开始*/
     INSERT INTO HrmRightCardInfo (
     resourceid , 
     carddate , 
     cardtime , 
     inorout  ,
     islegal ,
     workout 
     ) 
     VALUES (
     resourceid_2 , 
     carddate_3 , 
     cardtime_4 , 
     inorout_5 ,
     0 ,
     0
     ) ;
end if ;
end ;
/



/* 修改删除无效打卡记入, 增加转入加班的判断 */
create or replace PROCEDURE  HrmRightCardInfo_Delete (
id_1 integer ,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS 
 resourceid_2 integer;
 carddate_3 char(10) ;
 begin

 select resourceid , carddate into resourceid_2  , carddate_3  from HrmRightCardInfo where id = id_1 ;

 delete HrmRightCardInfo where id = id_1 ;
 update HrmRightCardInfo set islegal = 0 where carddate = carddate_3 and resourceid = resourceid_2 ;
 
 open thecursor for
 select resourceid_2, carddate_3 from dual ;
end ;
/



/* 转入加班的无效打卡记入, 增加转入加班的判断 */
create or replace PROCEDURE  HrmRightCardInfo_AddWork (
id_1 integer ,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS 
 resourceid_2 integer;
 carddate_3 char(10) ;
 cardcount integer;
 reccount integer;
 begin

 select resourceid , carddate into resourceid_2 , carddate_3  from HrmRightCardInfo where id = id_1 ;
 update HrmRightCardInfo set workout = 2 where id = id_1 ;
 update HrmRightCardInfo set islegal = 0 where carddate = carddate_3 and resourceid = resourceid_2 ;
 open thecursor for
 select resourceid_2, carddate_3 from dual ;
end ;
/


update HrmRightCardInfo set islegal = 0 
/

delete from HrmTimecardinfo 
/
INSERT INTO HtmlLabelIndex values(17091,'现在') 
/
INSERT INTO HtmlLabelInfo VALUES(17091,'现在',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17091,'Now',8) 
/


create table HrmSalaryCreateInfo (
id integer not null primary key ,
currentdate char(7),            /* 需要创建工资的月份 */
salarybegindate char(10) ,      /* 该月开始的日期 */
salaryenddate char(10) ,      /* 该月结束的日期 */
payid varchar2(6) ,              /* 工资单id ,如果第一次生成, payid 为 0 ,否则为原来的 payid */
plandate char(10) ,             /* 计划处理日期 */
hasdone  char(1) default '0'    /* 是否已经处理 */
)
/

create sequence HrmSalaryCreateInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmSalaryCreateInfo_Trigger
before insert on HrmSalaryCreateInfo
for each row
begin
select HrmSalaryCreateInfo_id.nextval into :new.id from dual;
end;
/




CREATE or REPLACE PROCEDURE  HrmSalaryCreateInfo_Insert
(currentdate_1 	char,
 salarybegindate_2 	char,
 salaryenddate_3 	char,
 payid_4 	varchar2,
 plandate_5 	char,
 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor ) 
 AS 
begin

INSERT INTO HrmSalaryCreateInfo 
	 ( currentdate,
	 salarybegindate,
	 salaryenddate,
	 payid,
	 plandate) 
 
VALUES 
	( currentdate_1,
	 salarybegindate_2,
	 salaryenddate_3,
	 payid_4,
	 plandate_5) ;
end ;
/




CREATE or REPLACE PROCEDURE  HrmSalaryCreateInfo_Delete
	(id_1 	integer,
	 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor ) 
 AS 
 begin

 DELETE from HrmSalaryCreateInfo WHERE  ( id = id_1) ;
end ;
/


CREATE or REPLACE PROCEDURE  HrmSalaryCreateInfo_Select
	(hasdone_1 	char,
	 flag	out integer, 
 msg   out	varchar2, 
 thecursor IN OUT cursor_define.weavercursor ) 
 AS 
 begin

open thecursor for 
select * from HrmSalaryCreateInfo where hasdone = hasdone_1 ;
end ;
/

create or replace PROCEDURE HrmTimecardInfo_Update
	(resourceid_1 	integer,
	 timecarddate_3 	char,
	 intime_4 	char,
	 outtime_5 	char,
     relateshiftid_6  integer ,
     cardtimetype integer ,  /* 1: 昨日连班 2: 今日连班 0: 正常 */
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)

AS 
reccount integer ;
begin

    select count(resourceid)  into reccount  from HrmTimecardinfo 
    where resourceid = resourceid_1 and timecarddate = timecarddate_3 and relateshiftid = relateshiftid_6 ;
    
    if cardtimetype = 0 then
        if reccount = 0 then
            insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
            values(resourceid_1,timecarddate_3,intime_4 , outtime_5 ,relateshiftid_6);
        else 
            if relateshiftid_6 = -1 then
                select count(resourceid) into reccount from HrmTimecardinfo 
                where resourceid = resourceid_1 and timecarddate = timecarddate_3 and intime = intime_4 and outtime = outtime_5 ;
                if reccount = 0 then
                    insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
                    values(resourceid_1,timecarddate_3,intime_4 , outtime_5 ,relateshiftid_6) ;
                end if ;
            end if ;
        end if ;
    else 
        if cardtimetype = 1  then
            if reccount = 0  then
                insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
                values(resourceid_1,timecarddate_3,intime_4 , outtime_5 ,relateshiftid_6) ;
            else 
                update HrmTimecardinfo set outtime = outtime_5 
                where resourceid = resourceid_1 and timecarddate = timecarddate_3 and relateshiftid = relateshiftid_6 ;
            end if ;
        else 
            if cardtimetype = 2  then
                if reccount = 0  then
                    insert into HrmTimecardinfo(resourceid,timecarddate,intime,outtime,relateshiftid) 
                    values(resourceid_1,timecarddate_3,intime_4 , outtime_5 ,relateshiftid_6) ;
                else 
                    update HrmTimecardinfo set intime = intime_4 
                    where resourceid = resourceid_1 and timecarddate = timecarddate_3 and relateshiftid = relateshiftid_6 ;
                end if ;
            end if ;
        end if ;
    end if ;
end;
/




INSERT INTO HtmlLabelIndex values(17092,'计划时间') 
/
INSERT INTO HtmlLabelInfo VALUES(17092,'计划时间',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17092,'Plan time',8) 
/