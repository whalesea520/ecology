CREATE  TABLE HrmSalaryItem (
id	integer NOT NULL ,
name	Varchar2(50) null,
operationmark	 Char(1) default 1,
isshow	Char(1) default 1,
showorder	integer default 1 ,
history  char(1) default 0
)
/
create sequence HrmSalaryItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryItem_Tri
before insert on HrmSalaryItem
for each row
begin
select HrmSalaryItem_id.nextval into :new.id from dual;
end;
/


CREATE TABLE HrmSalaryRank (
	id integer  NOT NULL ,
	itemid integer   null ,
	rankname VarChar2 (50)   null,
	salary number (12,2)  default 0 
)
/
create sequence HrmSalaryRank_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryRank_Trigger
before insert on HrmSalaryRank
for each row
begin
select HrmSalaryRank_id.nextval into :new.id from dual;
end;
/


CREATE TABLE HrmSalaryRate (
	id integer NOT NULL ,
	ranknum integer  default 1 ,
	ranklow number (12,2)  default 0 ,
	rankhigh number (12,2)  default 0 ,
	taxrate number (12,2)  default 0
)
/

create sequence HrmSalaryRate_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryRate_Trigger
before insert on HrmSalaryRate
for each row
begin
select HrmSalaryRate_id.nextval into :new.id from dual;
end;
/




CREATE TABLE HrmSalaryRateBase (
id	integer  NOT NULL ,
name    varchar2(50) null,
taxrate	number(12,2)
)
/
create sequence HrmSalaryRateBase_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryRateBase_Trigger
before insert on HrmSalaryRateBase
for each row
begin
select HrmSalaryRateBase_id.nextval into :new.id from dual;
end;
/




CREATE TABLE HrmSalaryPersonality (
id		integer  NOT NULL ,
itemid	integer,
hrmid		integer,
salary	number(12,2) default 0
)
/
create sequence HrmSalaryPersonality_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryPersonality_Trigger
before insert on HrmSalaryPersonality
for each row
begin
select HrmSalaryPersonality_id.nextval into :new.id from dual;
end;
/


ALTER TABLE HrmSalaryPersonality   ADD 
	 PRIMARY KEY    
	(
		id
	) 
/


CREATE TABLE HrmSalaryResult (
id		integer  NOT NULL ,
itemid	integer,
hrmid		integer,
salary	number(12,2) default 0,
yearmonth	varchar2(7),
isvalidate integer default 0
)
/
create sequence HrmSalaryResult_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryResult_Trigger
before insert on HrmSalaryResult
for each row
begin
select HrmSalaryResult_id.nextval into :new.id from dual;
end;
/

ALTER TABLE HrmSalaryResult   ADD 
	 PRIMARY KEY    
	(
		id
	)  
/


CREATE TABLE HrmSalaryHistory(
id   integer   not null,
hrmid integer ,
currentdate char(10),
itemid integer,
salary number(12,2) default 0
)
/
create sequence HrmSalaryHistory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmSalaryHistory_Trigger
before insert on HrmSalaryHistory
for each row
begin
select HrmSalaryHistory_id.nextval into :new.id from dual;
end;
/

 CREATE or REPLACE PROCEDURE HrmSalaryRate_SelectAll 
 ( flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryRate order by ranknum ;
 end;
/




 CREATE or REPLACE PROCEDURE HrmSalaryRate_SelectByID 
 (id_1 integer,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryRate WHERE id=id_1;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryRate_Insert 
 (	ranknum_1 integer ,
	ranklow_1 number   ,
	rankhigh_1 number   ,
	taxrate_1 number   ,
   flag out 	integer	,
   msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 begin
 INSERT INTO HrmSalaryRate ( ranknum, ranklow, rankhigh,taxrate)  
 VALUES ( ranknum_1, ranklow_1, rankhigh_1,taxrate_1) ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryRate_Delete 
 (id_1 	int,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 DELETE HrmSalaryRate  
 WHERE ( id	 = id_1) ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryRate_Update 
 (
	id_1	 	integer, 
	ranknum_1 integer ,
	ranklow_1 number  ,
	rankhigh_1 number   ,
	taxrate_1 number   ,
	 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )  
 AS
 begin
 UPDATE HrmSalaryRate  SET  ranknum	 = ranknum_1, ranklow	 = ranklow_1, 
 rankhigh = rankhigh_1, taxrate=taxrate_1  WHERE ( id	 = id_1)  ;
 end;
/





 CREATE or REPLACE PROCEDURE HrmSalaryRateBase_SelectAll 
 ( flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryRateBase  ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryRateBase_Insert 
 (	name_1 varchar2 ,
	taxrate_1 number   ,
   flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
 begin
 INSERT INTO HrmSalaryRateBase ( name,taxrate)  
 VALUES ( name_1,taxrate_1) ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryRateBase_Delete 
 (id_1 	integer,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
 DELETE HrmSalaryRateBase  
 WHERE ( id	 = id_1)  ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryRateBase_Update 
 (
	id_1	 	integer, 
	name_1 varchar2 ,
	taxrate_1 number   ,
	 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )  
 AS
 begin
 UPDATE HrmSalaryRateBase SET  name	 = name_1,  taxrate=taxrate_1  WHERE ( id	 = id_1)  ;
 end;
/



 CREATE or REPLACE PROCEDURE HrmSalaryRateBase_SelectByID 
 (id_1 integer,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryRateBase WHERE id=id_1 ;
 end;
/










 CREATE or REPLACE PROCEDURE HrmSalaryItem_SelectAll 
 ( flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryItem order by showorder  ;
 end;
/



 CREATE or REPLACE PROCEDURE HrmSalaryItem_Insert 
 (
 name_1	varchar2  , 
 operationmark_1	Char  ,
 isshow_1	Char   ,
 showorder_1	integer   ,
 history_1 char,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO HrmSalaryItem ( name,operationmark,isshow,showorder,history)  
 VALUES ( name_1,operationmark_1,isshow_1,showorder_1,history_1);
 end;
/




 CREATE or REPLACE PROCEDURE HrmSalaryItem_Delete 
 (id_1 	integer,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 DELETE HrmSalaryItem  
 WHERE ( id	 = id_1)  ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryItem_Update 
 (
   id_1	integer  ,
   name_1	varchar2  , 
   operationmark_1	Char  ,
   isshow_1	Char   ,
    showorder_1	integer   ,
	history_1  char,
	 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )  
 AS 
 begin
 UPDATE HrmSalaryItem SET  name	 = name_1,  operationmark=operationmark_1, 
 isshow=isshow_1,showorder=showorder_1, history=history_1
 WHERE ( id	 = id_1)  ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryItem_SelectByID 
 (id_1 integer,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryItem WHERE id=id_1 ;
 end;
/






/*工资基准等级表*/

 CREATE or REPLACE PROCEDURE HrmSalaryRank_SelectAll 
 ( flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
BEGIN
 open thecursor for 
SELECT * FROM HrmSalaryRank  ;
end;
/



 CREATE or REPLACE PROCEDURE HrmSalaryRank_Insert 
 (  itemid_1  integer,	
 rankname_1 varchar2 ,  
	salary_1 number   ,
   flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 INSERT INTO HrmSalaryRank ( itemid,rankname,salary)  
 VALUES (itemid_1, rankname_1,salary_1);
 end;
/



 CREATE or REPLACE PROCEDURE HrmSalaryRank_Delete 
 (id_1 	integer,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
 DELETE HrmSalaryRank  
 WHERE ( id	 = id_1)  ;
 end;
/

 CREATE or REPLACE PROCEDURE HrmSalaryRank_Update 
 (
	id_1	 	integer, 
	itemid_1 integer,
    rankname_1 varchar2 ,
	salary_1 number   ,
	 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )  
 AS
 begin
 UPDATE HrmSalaryRank SET  rankname	 = rankname_1, itemid=itemid_1, salary=salary_1  WHERE ( id	 = id_1) ;
end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryRank_SelectByID 
 (id_1 integer,  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryRank WHERE id=id_1 ;
end;
/




/*个人工资配置*/
 CREATE or REPLACE PROCEDURE HrmSalaryPersonality_SByHrmid
 (id_1 integer,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryPersonality WHERE hrmid=id_1;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryPersonality_Update 
 ( id_1           integer,
   salary_1  	  number ,
   currentdate_1  char ,
   flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS 
 
		itemid_1 integer;
		hrmid_1 integer;
		history_1 char;
begin

 UPDATE HrmSalaryPersonality SET  salary=salary_1  WHERE ( id = id_1) ; 
 select  itemid,  hrmid INTO itemid_1,hrmid_1  from HrmSalaryPersonality  where id = id_1 ;
 select history into  history_1  from HrmSalaryItem WHERE id = itemid_1 ;
 if ( history_1 = '1')  then
delete HrmSalaryHistory WHERE hrmid=hrmid_1 AND itemid = itemid_1 AND currentdate=currentdate_1;
insert INTO HrmSalaryHistory(hrmid,currentdate,itemid,salary) values(hrmid_1,currentdate_1,itemid_1,salary_1);
 end if;
end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryPersonality_SByid
 (id_1 integer,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryPersonality WHERE id=id_1;
 end;
/



 CREATE or REPLACE PROCEDURE HrmSalaryPersonality_CByHrmid
 (id_1 integer,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
  open thecursor for 
 SELECT count(*) FROM HrmSalaryPersonality WHERE hrmid=id_1;
end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryPersonality_Insert
 (joblevel_1 integer, 
  hrmid_1 integer,
  currentdate_1 char,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
    
		itemid_1 integer;
		salary_1 number(12,2);
		itemid_count integer;
		history_1 char(1);
begin

for salary_cursor in ( select  id from HrmSalaryItem WHERE  (id>11) AND (id<18) )
loop 
    itemid_1 := salary_cursor.id  ;
    select  count(itemid) INTO itemid_count from HrmSalaryRank WHERE itemid=itemid_1 AND rankname=joblevel_1;
	if (itemid_count = 0) then		
		select  min(salary) INTO salary_1 from HrmSalaryRank WHERE itemid=itemid_1;		
	else
		select salary INTO salary_1 from HrmSalaryRank WHERE itemid=itemid_1 AND rankname=joblevel_1;
	end if;	
		insert INTO HrmSalaryPersonality(itemid,hrmid,salary) values(itemid_1,hrmid_1,salary_1);
		select  history INTO history_1  from HrmSalaryItem WHERE id = itemid_1;
		if history_1 = '1' then
		insert INTO HrmSalaryHistory(hrmid,currentdate,itemid,salary) values(hrmid_1,currentdate_1,itemid_1,salary_1);
		end if;
end loop;
open thecursor for
select  *  from HrmSalaryPersonality WHERE hrmid=hrmid_1 order by itemid; 
end;
/







 CREATE or REPLACE PROCEDURE HrmSalaryResult_Insert
 (yearmonth_1 varchar2,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
		itemid_1 integer;
		hrmid_1 integer;
		salary_1 number(12,2);
 cursor all_cursor is 
select  itemid, hrmid, salary from HrmSalaryPersonality ;  
 begin
   OPEN  all_cursor ;
  FETCH all_cursor into  itemid_1,hrmid_1,salary_1 ;
  while all_cursor%found 
  loop
	INSERT INTO HrmSalaryResult (  itemid, hrmid , salary, yearmonth)  VALUES (  itemid_1, hrmid_1, salary_1, yearmonth_1);
    FETCH all_cursor into  itemid_1,hrmid_1,salary_1 ;
  end loop;
 end;
/





 CREATE or REPLACE PROCEDURE HrmSalaryResult_send 
 (yearmonth_1 varchar2,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor)
 AS 
 begin
 UPDATE HrmSalaryResult SET  	 isvalidate=1  WHERE ( yearmonth	 = yearmonth_1) ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryResult_SByHrmid
 (hrmid_1 integer,
 yearmonth_1 varchar2,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryResult WHERE hrmid=hrmid_1 AND yearmonth=yearmonth_1 order by itemid;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryResult_SByid
 (id_1 integer,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
  open thecursor for 
 SELECT * FROM HrmSalaryResult WHERE id=id_1 ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryResult_Update 
 ( id_1           integer,
   salary_1  	  number  ,
   	 flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor
 )
 AS 
 begin
 UPDATE HrmSalaryResult SET  	 salary=salary_1  WHERE ( id	 = id_1)  ;
 end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryResult_delete
 (yearmonth_1 varchar2,
  flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 delete HrmSalaryResult  WHERE ( yearmonth	 = yearmonth_1)  ;
end;
/


 CREATE or REPLACE PROCEDURE HrmSalaryPersonality_Delete
(hrmid_1 integer,
flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
delete HrmSalaryPersonality  WHERE ( hrmid	 = hrmid_1) ;
end;
/

 CREATE or REPLACE PROCEDURE HrmSalaryHistory_SByHrmid
(hrmid_1 integer,
flag out 	integer	, msg out	varchar2,
 thecursor IN OUT cursor_define.weavercursor) 
 AS
 begin
 open thecursor for
 SELECT * FROM HrmSalaryHistory WHERE hrmid=hrmid_1 ;
 end;
/


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2214,' ',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2214,'个人所得税税率表',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2214,'个人所得税税率表')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2215,' ',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2215,'参照费率',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2215,'参照费率')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2216,' ',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2216,'基准等级',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2216,'基准等级')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2217,' ',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2217,'工资项目表',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2217,'工资项目表')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2218,' ',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2218,'个人工资设置',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2218,'个人工资设置')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2219,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2219,'个人工资变动历史记录',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2219,'个人工资变动历史记录')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('姓名','','1',1,'3')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('部门','','1',2,'3')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('职务','','1',3,'3')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('缴费工资','','1',10,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('公积金','','1',11,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('养老金','','1',12,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('失业保险','','1',13,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('医疗保险','','1',14,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('应纳税所得额','','1',15,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('个人所得税','','1',16,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('实发工资','','1',17,'0')
/
insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('基础工资','1','1',4,'1')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('岗位技能工资','1','1',5,'1')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('考勤扣款','0','1',6,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('考勤加薪','1','1',7,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('行政处罚','0','1',8,'0')
/

insert into HrmSalaryItem (name,operationmark,isshow,showorder,history) values ('行政奖励','1','1',9,'0')
/

insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (1,.00,500.00,5.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (2,500.00,2000.00,10.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (3,2000.00,5000.00,15.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (4,5000.00,20000.00,20.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (5,20000.00,40000.00,25.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (6,40000.00,60000.00,30.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (7,60000.00,80000.00,35.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (8,80000.00,100000.00,40.00)
/
insert into HrmSalaryRate (ranknum,ranklow,rankhigh,taxrate) values (9,100000.00,99999999.00,45.00)
/
insert into HrmSalaryRateBase (name,taxrate) values ('个调税起征点',1000)
/
insert into HrmSalaryRateBase (name,taxrate) values ('公积金',0)
/
insert into HrmSalaryRateBase (name,taxrate) values ('养老金',0)
/
insert into HrmSalaryRateBase (name,taxrate) values ('失业保险',0)
/
insert into HrmSalaryRateBase (name,taxrate) values ('医疗保险',0)
/

insert into HrmSalaryRank (itemid,rankname,salary) values (12,'0',1000)
/
insert into HrmSalaryRank (itemid,rankname,salary) values (13,'0',1000)
/
insert into HrmSalaryRank (itemid,rankname,salary) values (14,'0',0)
/
insert into HrmSalaryRank (itemid,rankname,salary) values (15,'0',0)
/
insert into HrmSalaryRank (itemid,rankname,salary) values (16,'0',0)
/
insert into HrmSalaryRank (itemid,rankname,salary) values (17,'0',0)
/

create table SMS_Message
(
id integer not null, 
message varchar2(100) null,	
recievenumber varchar2(4000) null,   
sendmark char(1) default 0,			
sendnumber varchar2(12) default 0,  
requestid integer default 0,			
userid integer default 0,		
usertype char(1) default 0,		
mobilenumber integer default 1	,	
senddate varchar(12) null        
)
/
create sequence SMS_Message_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger SMS_Message_Trigger
before insert on SMS_Message
for each row
begin
select SMS_Message_id.nextval INTO :new.id from dual;
end;
/


/*用户自编写短信存到表的存储过程：sendmark参数不用传入，未发送则为系统默认值0*/
CREATE or replace Procedure SMS_Message_insert
(
	message_1 varchar2 ,
	recievenumber_1 varchar2 ,
	sendmark_1 char,
	sendnumber_1 varchar2,
	requestid_1 integer,
	userid_1 integer,
	usertype_1 char,
	mobilenumber_1 integer,
	senddate_1 varchar2,
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

as
begin
insert INTO SMS_Message
(message,recievenumber,sendmark,sendnumber,requestid,userid,usertype,mobilenumber,senddate)
values
(message_1,recievenumber_1,sendmark_1,sendnumber_1,requestid_1,userid_1,usertype_1,mobilenumber_1,senddate_1);
end;
/



CREATE or replace  Procedure SMS_Message_SelectAll
(
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

as
begin
open thecursor for
SELECT  userid,sendnumber,mobilenumber,senddate  from  SMS_Message WHERE userid<>0 ;
end;
/


insert into HtmlLabelInfo (indexid,labelname,languageid) values (2220,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2220,'短信服务',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2220,'短信服务')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2221,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2221,'短信服务管理',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2221,'短信服务管理')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2222,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2222,'短信服务管理-用户自编短信统计',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2222,'短信服务管理－用户自编短信统计')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2223,'',8)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (2223,'短信服务管理-系统发送短信统计',7)
/
insert into HtmlLabelIndex (id,indexdesc) values (2223,'短信服务管理－系统发送短信统计')
/

/* 会议 */
CREATE TABLE Meeting_ShareDetail (
	meetingid integer NULL ,
	userid integer NULL ,
	usertype integer NULL ,
	sharelevel integer NULL 
)
/


CREATE TABLE MeetingRoom (
	id integer  NOT NULL ,
	name varchar2(100)  NULL ,
	roomdesc varchar2(100)  NULL ,
	hrmid int NULL 
)
/
create sequence MeetingRoom_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger MeetingRoom_Trigger
before insert on MeetingRoom
for each row
begin
select MeetingRoom_id.nextval into :new.id from dual;
end;
/


/* 资产入库 */
CREATE TABLE CptStockInMain (
	id integer NOT NULL ,
	invoice varchar2(80)  NULL ,
	buyerid integer NULL ,
	supplierid integer NULL ,
	checkerid integer NULL ,
	stockindate char(10)   NULL ,
	ischecked integer NULL 
)
/
create sequence CptStockInMain_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptStockInMain_Trigger
before insert on CptStockInMain
for each row
begin
select CptStockInMain_id.nextval into :new.id from dual;
end;
/




CREATE TABLE CptStockInDetail (
	id integer  NOT NULL ,
	cptstockinid integer NULL ,
	cpttype integer NULL ,
	plannumber integer NULL ,
	innumber integer NULL ,
	price number(10, 2) NULL 
)
/
create sequence CptStockInDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger CptStockInDetail_Trigger
before insert on CptStockInDetail
for each row
begin
select CptStockInDetail_id.nextval into :new.id from dual;
end;
/

/*会议*/


CREATE or REPLACE PROCEDURE MeetingShareDetail_DById 
	(meetingid_1 	integer ,
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
DELETE Meeting_ShareDetail 
WHERE 
	( meetingid	 = meetingid_1);
	end;
/


CREATE or REPLACE PROCEDURE MeetingShareDetail_Insert 
	(meetingid_1 integer ,
	 userid_1 integer ,
	 usertype_1 integer ,
	 sharelevel_1 integer ,
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS 
count_1 integer;
begin

select  count(userid) INTO count_1 from Meeting_ShareDetail where meetingid=meetingid_1 and userid=userid_1 and usertype=usertype_1;
if count_1=0 then
		INSERT INTO Meeting_ShareDetail 
		 (meetingid,
		 userid,
		 usertype,
		 sharelevel) 
		VALUES 
		(meetingid_1,
		 userid_1,
		 usertype_1,
		 sharelevel_1);
	   
else 
		update Meeting_ShareDetail 
		set sharelevel=sharelevel_1 where meetingid=meetingid_1 and userid=userid_1 and usertype=usertype_1 and sharelevel>sharelevel_1 ; 
     end if ;
end;
/


CREATE or REPLACE PROCEDURE MeetingRoom_Insert 
	(name_1 varchar2 ,
	 roomdesc_1 varchar2 ,
	 hrmid_1 integer ,
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
INSERT INTO MeetingRoom 
		 (name,
		 roomdesc,
		 hrmid) 
		VALUES 
		(name_1,
		 roomdesc_1,
		 hrmid_1);
end;
/




 CREATE or REPLACE PROCEDURE MeetingRoom_DeleById 
	(id_1 	integer ,
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
AS
begin
DELETE MeetingRoom 
WHERE 
	( id	 = id_1);
end;
/

 CREATE or REPLACE PROCEDURE MeetingRoom_SelectAll 
 ( 
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 open thecursor for
 SELECT * FROM MeetingRoom order by id ;
end;
/


 CREATE or REPLACE PROCEDURE MeetingRoom_SelectById 
 (id_1 	integer ,
     flag	out integer, 
     msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
 AS
 begin
 open thecursor for
 SELECT * FROM MeetingRoom where id= id_1;
end;
/



 CREATE or REPLACE PROCEDURE MeetingRoom_Update 
 (id_1 	integer ,
 name_1 varchar2 ,
 roomdesc_1 varchar2 ,
 hrmid_1 integer ,
 flag	out integer, 
 msg   out	varchar2, 
thecursor IN OUT cursor_define.weavercursor )
 AS 
begin
 Update MeetingRoom set  name=name_1, roomdesc=roomdesc_1, hrmid=hrmid_1  where id= id_1;
end;
/


/* 资产入库 */
CREATE or REPLACE PROCEDURE CptStockInMain_Insert (
	invoice_1 varchar2 ,
	buyerid_1 integer ,
	supplierid_1 integer ,
	checkerid_1 integer ,
	stockindate_1 char  ,
	ischecked_1 integer , 
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )
AS 
begin
INSERT INTO CptStockInMain 
		 (invoice,
		 buyerid,
		 supplierid,
		 checkerid,
		 stockindate,
		 ischecked) 
	VALUES 
	(invoice_1,
	buyerid_1,
	supplierid_1,
	checkerid_1,
	stockindate_1,
	ischecked_1);
open thecursor for
select max(id) from CptStockInMain;
end;
/


CREATE or REPLACE PROCEDURE CptStockInMain_SelectByid (
	id_1 integer ,
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )
AS 
begin
open thecursor for
select * from CptStockInMain where id = id_1;
end;
/


CREATE or REPLACE PROCEDURE CptStockInMain_Update (
	id_1 integer ,
	invoice_1 varchar2 ,
	buyerid_1 integer ,
	supplierid_1 integer ,
	checkerid_1 integer ,
	stockindate_1 char  ,
	ischecked_1 integer , 
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

AS 
begin
update CptStockInMain set invoice=invoice_1, buyerid=buyerid_1 , supplierid=supplierid_1 , checkerid=checkerid_1, stockindate=stockindate_1 , ischecked=ischecked_1  where id = id_1;
end;
/


CREATE or REPLACE PROCEDURE CptStockInDetail_Insert (
	cptstockinid_1 integer  ,
	cpttype_1 integer  ,
	plannumber_1 integer  ,
	innumber_1 integer  ,
	price_1 number ,
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

AS 
begin
INSERT INTO CptStockInDetail 
		 (cptstockinid,
		 cpttype,
		 plannumber,
		 innumber,
		 price) 
	VALUES 
	(cptstockinid_1,
	cpttype_1,
	plannumber_1,
	innumber_1 ,
	price_1);
	open thecursor for
select max(id) from CptStockInDetail;
end;
/


CREATE or REPLACE PROCEDURE CptStockInDetail_SByStockid (
	cptstockinid_1 integer ,
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

AS 
begin
open thecursor for
select * from CptStockInDetail where cptstockinid = cptstockinid_1;
end;
/


CREATE or REPLACE PROCEDURE CptStockInDetail_Update (
	id_1 integer ,
	innumber_1 integer , 
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

AS 
begin
update CptStockInDetail set  innumber=innumber_1  where id = id_1;
end;
/


CREATE or REPLACE PROCEDURE CptStockInDetail_Delete (
	id_1 integer ,
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )

AS 
begin
delete CptStockInDetail where id = id_1;
end;
/



/*修改的*/
 CREATE or REPLACE PROCEDURE CptUseLogInStock_Insert 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3  in out	integer,
	 useresourceid_4  in out integer,
	 checkerid 	integer,
	 usecount_5 	number,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 varchar2,
	 fee_9 			number,
	 usestatus_10 		varchar2,
	 remark_11 		varchar2,
	 mark_1				varchar2,
	 datatype_1			integer,
	 startdate_1			char,
	 enddate_1			char,
	 deprestartdate_1	char,
	 depreenddate_1		char,
	 manudate_1			char,
	 lastmoderid_1		integer,
	 lastmoddate_1		char,
	 lastmodtime_1    	char,
	 inprice_1		number,
	 crmid_1		integer,
	 counttype_1		char,
	 isinner_1		char,
    flag	out integer, 
    msg   out	varchar2, 
    thecursor IN OUT cursor_define.weavercursor )


AS
num number(18,3);
begin
if usestatus_10='2' then

	 INSERT INTO CptUseLog 
		 ( capitalid,
		 usedate,
		 usedeptid,
		 useresourceid,
		 usecount,
		 useaddress,
		 userequest,
		 maintaincompany,
		 fee,
		 usestatus,
		 remark) 
	 
	VALUES 
		( capitalid_1,
		 usedate_2,
		 usedeptid_3,
		 checkerid,
		 usecount_5,
		 useaddress_6,
		 userequest_7,
		 maintaincompany_8,
		 fee_9,
		'1',
		 remark_11);
end if;

 INSERT INTO CptUseLog 
	 ( capitalid,
	 usedate,
	 usedeptid,
	 useresourceid,
	 usecount,
	 useaddress,
	 userequest,
	 maintaincompany,
	 fee,
	 usestatus,
	 remark) 
 
VALUES 
	( capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	usestatus_10,
	 remark_11);


select capitalnum INTO num from CptCapital where id = capitalid_1;

if usestatus_10 = '1' then

     useresourceid_4 := 0 ;
end if;

if usedeptid_3 = 0 then

 usedeptid_3 := null; 
end if;

Update CptCapital
Set 
mark = mark_1,
capitalnum = usecount_5+num,
location = useaddress_6,
departmentid = usedeptid_3,
resourceid   = useresourceid_4,
stateid = usestatus_10,
datatype = datatype_1,
isdata = '2',
startdate = startdate_1,
enddate = enddate_1,
deprestartdate = deprestartdate_1,
depreenddate = depreenddate_1,
manudate = manudate_1,
lastmoderid = lastmoderid_1,
lastmoddate = lastmoddate_1,
lastmodtime = lastmodtime_1,
startprice  = inprice_1,
customerid		  =	crmid_1,
counttype    = counttype_1,
isinner     = isinner_1
where id = capitalid_1;
end;
/

/* 会议室维护 */
insert into SystemRights(id,rightdesc,righttype) values(350,'会议室维护','0')
/

insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(350,7,'会议室维护','会议室维护')
/
insert into SystemRightsLanguage(id,languageid,rightname,rightdesc) values(350,8,'','')
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2050,'会议室添加','MeetingRoomAdd:Add',350)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2051,'会议室编辑','MeetingRoomEdit:Edit',350)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2052,'会议室删除','MeetingRoomDelete:Delete',350)
/
insert into SystemRightDetail(id,rightdetailname,rightdetail,rightid) values(2053,'会议室日志','MeetingRoom:Log',350)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (350,11,'1')
/

insert into SystemRightToGroup (groupid,rightid) values (10,350)
/

insert into HtmlLabelIndex (id,indexdesc) values (6050,'资产验证入库')
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6050,'资产验证入库',7)
/
insert into HtmlLabelInfo (indexid,labelname,languageid) values (6050,'',8)
/

CREATE or replace PROCEDURE	Capital_Adjust
	(
	capitalid_1 integer,
	usedate_1 varchar2,
	usedeptid_1 integer,
	useresourceid_1 integer,
	usecount_1 integer,
	useaddress_1 varchar2,
	usestatus_1 varchar2,
	remark_1 varchar2,  
	olddeptid_1 integer,
	flag out 	integer	, 
	msg out	varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
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
	capitalid_1  ,
	usedate_1  ,
	usedeptid_1  ,
	useresourceid_1  ,
	usecount_1  ,
	useaddress_1  ,
	usestatus_1  ,
	remark_1  ,
	olddeptid_1  );

update CptCapital
set
departmentid = usedeptid_1  ,
resourceid = useresourceid_1        
WHERE id=capitalid_1;
end;
/




commit
/










