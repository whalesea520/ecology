CREATE TABLE prjtskDefineField(id int IDENTITY (1, 1) not null,billid int null,fieldname varchar(60) null,fieldlabel int null,fielddbtype varchar(40) null,fieldhtmltype char(1) null,type int null,viewtype int null,detailtable varchar(50) null,fromUser char(1) null,textheight int null,dsporder decimal(10,2) null,childfieldid int null,imgheight int null,imgwidth int null,isopen char(1) null,ismand char(1) null,isused char(1) null)
go
alter table prjtskDefineField add issystem char(1)
go
alter table prjtskDefineField add allowhide char(1)
go
alter table prjtskDefineField add groupid int
go

CREATE TABLE prjtsk_SelectItem(fieldid int null,isbill int null,selectvalue int null,selectname varchar(250) null,id int IDENTITY (1, 1) not null,listorder numeric(10) null,isdefault char(1) null,docPath varchar(660) null,docCategory varchar(200) null,isAccordToSubCom char(1) null DEFAULT ('0'),childitemid varchar(2000) null,cancel varchar(1) null DEFAULT ((0)))
go

CREATE TABLE prjtsk_specialfield(id int IDENTITY (1, 1) not null,fieldid int null,displayname varchar(1000) null,linkaddress varchar(1000) null,descriptivetext text null,isbill int null,isform int null)
go

CREATE PROCEDURE prjtsk_selectitem_insert_new ( @fieldid INT , @isbill INT , @selectvalue INT , @selectname VARCHAR(250) , @listorder NUMERIC(10, 2) , @isdefault CHAR(1) , @cancel2 VARCHAR(1), @flag INTEGER OUTPUT , @msg VARCHAR(80) OUTPUT ) AS INSERT  INTO prjtsk_selectitem ( fieldid , isbill , selectvalue , selectname , listorder , isdefault,cancel ) VALUES  ( @fieldid , @isbill , @selectvalue , @selectname , @listorder , @isdefault,@cancel2 )
go

CREATE PROCEDURE prjtsk_selectitembyid_new @id VARCHAR(100)  ,@isbill varchar(100), @flag INTEGER OUTPUT , @msg VARCHAR(80) OUTPUT AS SELECT  * FROM    prjtsk_SelectItem WHERE   fieldid = @id  AND ( cancel!='1' or cancel is null) ORDER BY listorder , id SET @flag = 0 SET @msg = ''
GO

SET IDENTITY_INSERT prjtskDefineField ON
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(1,0,'subject',1352,'varchar(80)','1',1,0,'','',0,'1',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(2,0,'hrmid',2097,'int','3',1,0,'','',0,'2',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(3,0,'parentid',23785,'varchar(80)','1',1,0,'','',0,'3',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(4,0,'prjid',17749,'int','3',8,0,'','',0,'4',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(5,0,'begindate',1322,'int','3',2,0,'','',0,'5',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(6,0,'enddate',741,'int','3',2,0,'','',0,'6',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(7,0,'workday',1298,'int','1',2,0,'','',0,'7',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(8,0,'actualbegindate',33351,'int','3',2,0,'','',0,'8',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(9,0,'actualenddate',24697,'int','3',2,0,'','',0,'9',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(10,0,'realmandays',17501,'int','1',2,0,'','',0,'10',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(11,0,'fixedcost',15274,'int','1',3,0,'','',0,'11',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(12,0,'finish', 847 ,'int','1',2,0,'','',0,'12',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(13,0,'islandmark', 2232 ,'char(1)','4',1,0,'','',0,'13',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(14,0,'prefinish', 2233 ,'varchar(80)','1',1,0,'','',0,'14',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(15,0,'accessory', 22194 ,'text','6',1,0,'','',0,'15',0,0,0,'1','1','1','1','0',1)
insert into prjtskDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(16,0,'content', 2240 ,'text','2',1,0,'','',4,'16',0,0,0,'1','0','1','1','1',1)
SET IDENTITY_INSERT prjtskDefineField OFF
go

create table prj_tskcardgroup(
id int IDENTITY (1, 1) not null,
groupname varchar(60) null,
grouplabel int null,
dsporder decimal(10,2) null,
isopen char(1) null,
ismand char(1) null,
isused char(1) null,
issystem char(1) null
)
go

SET IDENTITY_INSERT prj_tskcardgroup ON
go
insert into prj_tskcardgroup(id,groupname,grouplabel,dsporder,isopen,isused,issystem) values(1,'基本信息',1361,1,'1','1','1')
go
SET IDENTITY_INSERT prj_tskcardgroup OFF
go
