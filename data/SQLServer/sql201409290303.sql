create table cpt_cptcardgroup(
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

SET IDENTITY_INSERT cpt_cptcardgroup ON
go
insert into cpt_cptcardgroup(id,groupname,grouplabel,dsporder,isopen,isused,issystem) values(1,'������Ϣ',1361,1,'1','1','1')
go
insert into cpt_cptcardgroup(id,groupname,grouplabel,dsporder,isopen,isused,issystem) values(2,'������Ϣ',27858,1,'1','1','1')
go
insert into cpt_cptcardgroup(id,groupname,grouplabel,dsporder,isopen,isused,issystem) values(3,'�ɹ���Ϣ',34081,1,'1','1','1')
go
insert into cpt_cptcardgroup(id,groupname,grouplabel,dsporder,isopen,isused,issystem) values(4,'�۾���Ϣ',1374,1,'1','1','1')
go
insert into cpt_cptcardgroup(id,groupname,grouplabel,dsporder,isopen,isused,issystem) values(5,'������Ϣ',410,1,'1','1','1')
go
SET IDENTITY_INSERT cpt_cptcardgroup OFF
go

create table prj_prjcardgroup(
id int IDENTITY (1, 1) not null,
prjtype int not null,
groupname varchar(60) null,
grouplabel int null,
dsporder decimal(10,2) null,
isopen char(1) null,
ismand char(1) null,
isused char(1) null,
issystem char(1) null
)
go

SET IDENTITY_INSERT prj_prjcardgroup ON
go
insert into prj_prjcardgroup(id,prjtype,groupname,grouplabel,dsporder,isopen,isused,issystem) values(1,-1,'������Ϣ',1361,1,'1','1','1')
go
insert into prj_prjcardgroup(id,prjtype,groupname,grouplabel,dsporder,isopen,isused,issystem) values(2,-1,'������Ϣ',27858,1,'1','1','1')
go
insert into prj_prjcardgroup(id,prjtype,groupname,grouplabel,dsporder,isopen,isused,issystem) values(3,-1,'������Ϣ',410,1,'1','1','1')
go
SET IDENTITY_INSERT prj_prjcardgroup OFF
go



alter table cptDefineField add issystem char(1)
go
alter table cptDefineField add allowhide char(1)
go
alter table cptDefineField add groupid int
go
alter table prjDefineField add issystem char(1)
go
alter table prjDefineField add allowhide char(1)
go
alter table prjDefineField add groupid int
go
alter table prjDefineField add prjtype int
go


SET IDENTITY_INSERT cptDefineField ON
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-1,0,'name',195,'varchar(60)','1',1,0,'','',0,'-100',0,0,0,'1','1','1','1','0',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-2,0,'mark',714,'varchar(60)','1',1,0,'','',0,'-99',0,0,0,'1','1','1','1','0',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-3,0,'capitalgroupid',831,'int','3',25,0,'','',0,'-98',0,0,0,'1','1','1','1','0',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-4,0,'capitaltypeid',703,'int','3',242,0,'','',0,'-97',0,0,0,'1','1','1','1','0',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-5,0,'capitalspec',904,'varchar(60)','1',1,0,'','',0,'-96',0,0,0,'1','0','1','1','1',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-6,0,'manufacturer',1364,'varchar(100)','1',1,0,'','',0,'-95',0,0,0,'1','0','1','1','1',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-7,0,'capitallevel',603,'varchar(30)','1',1,0,'','',0,'-94',0,0,0,'1','0','1','1','1',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-8,0,'attribute',713,'int','5',1,0,'','',0,'-93',0,0,0,'1','0','1','1','1',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-9,0,'unitid',705,'int','3',69,0,'','',0,'-92',0,0,0,'1','1','1','1','0',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-10,0,'barcode',1362,'varchar(30)','1',1,0,'','',0,'-91',0,0,0,'1','0','1','1','1',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-11,0,'fnamark',15293,'varchar(60)','1',1,0,'','',0,'-90',0,0,0,'1','0','1','1','1',1)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-12,0,'stateid',602,'int','3',243,0,'','',0,'-89',0,0,0,'1','1','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-13,0,'blongdepartment',15393,'int','3',4,0,'','',0,'-88',0,0,0,'1','1','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-14,0,'resourceid',1508,'int','3',1,0,'','',0,'-87',0,0,0,'1','1','1','1','0',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-15,0,'blongsubcompany',19799,'int','3',164,0,'','',0,'-86',0,0,0,'1','1','1','1','0',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-16,0,'sptcount',1363,'char(1)','4',1,0,'','',0,'-85',0,0,0,'1','1','1','1','0',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-17,0,'capitalnum',1331,'decimal(15,2)','1',3,0,'','',0,'-84',0,0,0,'1','1','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-18,0,'customerid',138,'int','3',7,0,'','',0,'-83',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-19,0,'replacecapitalid',1371,'int','3',23,0,'','',0,'-82',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-20,0,'version',567,'varchar(60)','1',1,0,'','',0,'-81',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-21,0,'isinner',15297,'int','5',1,0,'','',0,'-80',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-22,0,'startdate',717,'char(10)','3',2,0,'','',0,'-79',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-23,0,'enddate',718,'char(10)','3',2,0,'','',0,'-78',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-24,0,'manudate',1365,'char(10)','3',2,0,'','',0,'-77',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-25,0,'stockindate', 753 ,'char(10)','3',2,0,'','',0,'-76',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-26,0,'location', 1387 ,'varchar(100)','1',1,0,'','',0,'-75',0,0,0,'1','0','1','1','1',2)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-27,0,'selectdate', 16914 ,'char(10)','3',2,0,'','',0,'-74',0,0,0,'1','0','1','1','1',3)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-28,0,'contractno', 21282 ,'varchar(100)','1',1,0,'','',0,'-73',0,0,0,'1','0','1','1','1',3)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-29,0,'currencyid', 406 ,'int','3',12,0,'','',0,'-72',0,0,0,'1','1','1','1','0',3)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-30,0,'startprice', 726 ,'decimal(15,2)','1',3,0,'','',0,'-71',0,0,0,'1','0','1','1','1',3)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-31,0,'invoice', 900 ,'varchar(80)','1',1,0,'','',0,'-70',0,0,0,'1','0','1','1','1',3)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-32,0,'depreyear', 19598 ,'int','1',2,0,'','',0,'-69',0,0,0,'1','0','1','1','1',4)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-33,0,'deprerate',1390,'decimal(15,2)','1',3,0,'','',0,'-68',0,0,0,'1','0','1','1','1',4)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-34,0,'deprestartdate',1412,'char(10)','3',2,0,'','',0,'-67',0,0,0,'1','0','1','1','1',4)
go
insert into cptDefineField(id,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-35,0,'remark',454,'text','2',1,0,'','',4,'-66',0,0,0,'1','0','1','1','1',5)
go
SET IDENTITY_INSERT cptDefineField OFF
go

update cptDefineField set groupid=5 where id>=1 and id<=40
go

SET IDENTITY_INSERT prjDefineField ON
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-1,-1,0,'name',195,'varchar(50)','1',1,0,'','',0,'-100',0,0,0,'1','1','1','1','0',1)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-2,-1,0,'prjtype',586,'int','3',244,0,'','',0,'-99',0,0,0,'1','1','1','1','0',1)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-3,-1,0,'protemplateid',18375,'int','3',129,0,'','',0,'-98',0,0,0,'1','0','1','1','1',1)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-4,-1,0,'worktype',432,'int','3',245,0,'','',0,'-97',0,0,0,'1','0','1','1','1',1)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-5,-1,0,'description',783,'int','3',7,0,'','',0,'-96',0,0,0,'1','0','1','1','1',1)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-6,-1,0,'managerview',15263,'char(1)','4',1,0,'','',0,'-95',0,0,0,'1','0','1','1','1',1)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-7,-1,0,'parentid',636,'int','3',8,0,'','',0,'-94',0,0,0,'1','0','1','1','1',2)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-8,-1,0,'manager',144,'int','3',1,0,'','',0,'-93',0,0,0,'1','1','1','1','0',2)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-9,-1,0,'department',124,'int','3',4,0,'','',0,'-92',0,0,0,'1','1','1','1','0',2)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-10,-1,0,'members',18628,'text','3',17,0,'','',0,'-91',0,0,0,'1','1','1','1','0',2)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-11,-1,0,'isblock',624,'char(1)','4',1,0,'','',0,'-90',0,0,0,'1','1','1','1','0',2)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-12,-1,0,'envaluedoc',637,'int','3',9,0,'','',0,'-89',0,0,0,'1','0','1','1','1',2)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-13,-1,0,'confirmdoc',638,'int','3',9,0,'','',0,'-88',0,0,0,'1','0','1','1','1',2)
go
insert into prjDefineField(id,prjtype,billid,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable,fromUser,textheight,dsporder,childfieldid,imgheight,imgwidth,isopen,ismand,isused,issystem,allowhide,groupid) 
values(-14,-1,0,'proposedoc',639,'int','3',9,0,'','',0,'-87',0,0,0,'1','0','1','1','1',2)
go
SET IDENTITY_INSERT prjDefineField OFF
go

update prjDefineField set groupid=3,prjtype=-1 where id>=1 and id<=20
go

delete workflow_browserurl where id=244
go
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 244,586,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp','Prj_ProjectType','fullname','id','')
go
delete workflow_browserurl where id=245
go
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 245,432,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp','Prj_WorkType','fullname','id','')
go

SET IDENTITY_INSERT cpt_SelectItem ON
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-8,'����','0',0,'n','0',-1)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-8,'�ɹ�','1',1,'n','0',-2)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-8,'����','2',2,'n','0',-3)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-8,'����','3',3,'n','0',-4)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-8,'ά��','4',4,'n','0',-5)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-8,'����','5',5,'n','0',-6)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-8,'����','6',6,'n','0',-7)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-21,'����','1',0,'n','0',-8)
go
insert into cpt_SelectItem(fieldid,selectname,selectvalue,listorder,isdefault,cancel,id) values(-21,'����','2',1,'n','0',-9)
go
SET IDENTITY_INSERT cpt_SelectItem OFF
go