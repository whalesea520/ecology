CREATE TABLE prjtskDefineField(id int  not null,billid int null,fieldname varchar2(60) null,fieldlabel int null,fielddbtype varchar2(40) null,fieldhtmltype char(1) null,type int null,viewtype int null,detailtable varchar2(50) null,fromUser char(1) null,textheight int null,dsporder decimal(10,2) null,childfieldid int null,imgheight int null,imgwidth int null,isopen char(1) null,ismand char(1) null,isused char(1) null)
/
create sequence prjtskDefineField_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prjtskDefineField_TRIGGER before insert on prjtskDefineField for each row 
begin select prjtskDefineField_ID.nextval into :new.id from dual; end;
/
alter table prjtskDefineField add issystem char(1)
/
alter table prjtskDefineField add allowhide char(1)
/
alter table prjtskDefineField add groupid int
/


CREATE TABLE prjtsk_SelectItem(fieldid int null,isbill int null,selectvalue int null,selectname varchar2(250) null,id int  not null,listorder NUMBER(10) null,isdefault char(1) null,docPath varchar2(660) null,docCategory varchar2(200) null,isAccordToSubCom char(1) null ,childitemid varchar2(2000) null,cancel varchar2(1) null )
/
create sequence prjtsk_SelectItem_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prjtsk_SelectItem_TRIGGER before insert on prjtsk_SelectItem for each row 
begin select prjtsk_SelectItem_ID.nextval into :new.id from dual; end;
/

CREATE TABLE prjtsk_specialfield(id int  not null,fieldid int null,displayname varchar2(1000) null,linkaddress varchar2(1000) null,descriptivetext varchar2(4000) null,isbill int null,isform int null)
/
create sequence prjtsk_specialfield_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prjtsk_specialfield_TRIGGER before insert on prjtsk_specialfield for each row 
begin select prjtsk_specialfield_ID.nextval into :new.id from dual; end;
/

CREATE or REPLACE PROCEDURE prjtsk_selectitem_insert_new 
( fieldid2 INT , isbill2 INT , selectvalue2 INT , selectname2 varchar2 , listorder2 NUMERIC , isdefault2 CHAR , cancel2 varchar2, flag  OUT INTEGER ,msg OUT varchar2 ,thecursor      IN OUT   cursor_define.weavercursor ) 
AS 
BEGIN
	INSERT  INTO prjtsk_selectitem ( fieldid , isbill , selectvalue , selectname , listorder , isdefault,cancel ) VALUES  ( fieldid2 , isbill2 , selectvalue2 , selectname2 , listorder2 , isdefault2,cancel2 );
END;
/

CREATE OR REPLACE PROCEDURE prjtsk_selectitembyid_new (
   id_1                 VARCHAR2,
   isbill_1             VARCHAR2,
   flag        OUT      INTEGER,
   msg         OUT      VARCHAR2,
   thecursor   IN OUT   cursor_define.weavercursor
)
AS
BEGIN
   OPEN thecursor FOR
      SELECT   *
          FROM prjtsk_SelectItem
         WHERE fieldid = id_1 AND isbill = isbill_1
         AND (cancel!='1' or cancel is null)
      ORDER BY listorder, ID;
END;
/



insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(1,0,'subject',1352,'varchar(80)','1',1,0,'','',0,'1',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(2,0,'hrmid',2097,'int','3',1,0,'','',0,'2',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(3,0,'parentid',23785,'varchar(80)','1',1,0,'','',0,'3',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(4,0,'prjid',17749,'int','3',8,0,'','',0,'4',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(5,0,'begindate',1322,'int','3',2,0,'','',0,'5',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(6,0,'enddate',741,'int','3',2,0,'','',0,'6',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(7,0,'workday',1298,'int','1',2,0,'','',0,'7',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(8,0,'actualbegindate',33351,'int','3',2,0,'','',0,'8',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(9,0,'actualenddate',24697,'int','3',2,0,'','',0,'9',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(10,0,'realmandays',17501,'int','1',2,0,'','',0,'10',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(11,0,'fixedcost',15274,'int','1',3,0,'','',0,'11',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(12,0,'finish', 847 ,'int','1',2,0,'','',0,'12',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(13,0,'islandmark', 2232 ,'char(1)','4',1,0,'','',0,'13',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(14,0,'prefinish', 2233 ,'varchar(80)','1',1,0,'','',0,'14',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(15,0,'accessory', 22194 ,'text','6',1,0,'','',0,'15',0,0,0,'1','1','1','1','0',1)
/
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(16,0,'content', 2240 ,'text','2',1,0,'','',4,'16',0,0,0,'1','0','1','1','1',1)
/

create table prj_tskcardgroup(
id int  not null,
groupname varchar2(60) null,
grouplabel int null,
dsporder decimal(10,2) null,
isopen char(1) null,
ismand char(1) null,
isused char(1) null,
issystem char(1) null
)
/
create sequence prj_tskcardgroup_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
/
create or replace trigger prj_tskcardgroup_TRIGGER before insert on prj_tskcardgroup for each row 
begin select prj_tskcardgroup_ID.nextval into :new.id from dual; end;
/

insert into prj_tskcardgroup(id,groupname,grouplabel,dsporder,isopen,isused,issystem) values(1,'基本信息',1361,1,'1','1','1')
/
