CREATE TABLE cptcode1(id int IDENTITY (1, 1) not null,isuse int null,subcompanyflow varchar(10) null,departmentflow varchar(10) null,capitalgroupflow varchar(10) null,capitaltypeflow varchar(10) null,buydateflow varchar(10) null,Warehousingflow varchar(10) null,startcodenum int null,assetdataflow varchar(10) null)
 GO

  SET IDENTITY_INSERT cptcode1 ON
 insert into cptcode1([id],[isuse],[subcompanyflow],[departmentflow],[capitalgroupflow],[capitaltypeflow],[buydateflow],[Warehousingflow],[startcodenum],[assetdataflow]) Values(1,1,'','','1','','0|1','0|1',1,'')
  SET IDENTITY_INSERT cptcode1 OFF
 GO 
  

 CREATE TABLE cptcodeset1(id int IDENTITY (1, 1) not null,codeid int null,showname varchar(10) null,showtype int null,value varchar(100) null,codeorder int null)
 GO

  SET IDENTITY_INSERT cptcodeset1 ON
 insert into cptcodeset1([id],[codeid],[showname],[showtype],[value],[codeorder]) Values(1,1,'18729',2,'',0)
 insert into cptcodeset1([id],[codeid],[showname],[showtype],[value],[codeorder]) Values(2,1,'20344',1,'1',1)
 insert into cptcodeset1([id],[codeid],[showname],[showtype],[value],[codeorder]) Values(3,1,'22291',1,'0',2)
 insert into cptcodeset1([id],[codeid],[showname],[showtype],[value],[codeorder]) Values(4,1,'18811',2,'2',3)
 insert into cptcodeset1([id],[codeid],[showname],[showtype],[value],[codeorder]) Values(5,1,'20571',2,'',4)
 insert into cptcodeset1([id],[codeid],[showname],[showtype],[value],[codeorder]) Values(6,1,'20572',2,'',5)
 insert into cptcodeset1([id],[codeid],[showname],[showtype],[value],[codeorder]) Values(7,1,'20573',2,'',6)
  SET IDENTITY_INSERT cptcodeset1 OFF
 GO

 CREATE TABLE cptcapitalcodeseq1(id int IDENTITY (1, 1) not null,sequenceid int null,subcompanyid int null,departmentid int null,capitalgroupid int null,capitaltypeid int null,buydateyear int null,buydatemonth int null,buydateday int null,warehouseyear int null,warehousemonth int null,warehouseday int null,assetid int null)
 GO


 CREATE TABLE cptDefineField(id int IDENTITY (1, 1) not null,billid int null,fieldname varchar(60) null,fieldlabel int null,fielddbtype varchar(40) null,fieldhtmltype char(1) null,type int null,viewtype int null,detailtable varchar(50) null,fromUser char(1) null,textheight int null,dsporder decimal(10,2) null,childfieldid int null,imgheight int null,imgwidth int null,isopen char(1) null,ismand char(1) null,isused char(1) null)
GO

 CREATE TABLE cpt_SelectItem(fieldid int null,isbill int null,selectvalue int null,selectname varchar(250) null,id int IDENTITY (1, 1) not null,listorder numeric(10) null,isdefault char(1) null,docPath varchar(660) null,docCategory varchar(200) null,isAccordToSubCom char(1) null DEFAULT ('0'),childitemid varchar(2000) null,cancel varchar(1) null DEFAULT ((0)))
GO

 CREATE TABLE cpt_specialfield(id int IDENTITY (1, 1) not null,fieldid int null,displayname varchar(1000) null,linkaddress varchar(1000) null,descriptivetext text null,isbill int null,isform int null)
GO

  CREATE PROCEDURE cpt_selectitem_insert_new ( @fieldid INT , @isbill INT , @selectvalue INT , @selectname VARCHAR(250) , @listorder NUMERIC(10, 2) , @isdefault CHAR(1) , @cancel2 VARCHAR(1), @flag INTEGER OUTPUT , @msg VARCHAR(80) OUTPUT ) AS INSERT  INTO cpt_selectitem ( fieldid , isbill , selectvalue , selectname , listorder , isdefault,cancel ) VALUES  ( @fieldid , @isbill , @selectvalue , @selectname , @listorder , @isdefault,@cancel2 )
GO



SET IDENTITY_INSERT cptDefineField ON
insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(1,0,'datefield1',31595,'char(10)','3',2,0,'','',0,'1',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(2,0,'datefield2',31596,'char(10)','3',2,0,'','',0,'2',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(3,0,'datefield3',31597,'char(10)','3',2,0,'','',0,'3',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(4,0,'datefield4',31598,'char(10)','3',2,0,'','',0,'4',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(5,0,'datefield5',31599,'char(10)','3',2,0,'','',0,'5',0,0,0,'0','0','1')

 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(6,0,'numberfield1',31600,'decimal(15,2)','1',3,0,'','',0,'6',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(7,0,'numberfield2',31601,'decimal(15,2)','1',3,0,'','',0,'7',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(8,0,'numberfield3',31602,'decimal(15,2)','1',3,0,'','',0,'8',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(9,0,'numberfield4',31603,'decimal(15,2)','1',3,0,'','',0,'9',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(10,0,'numberfield5',31604,'decimal(15,2)','1',3,0,'','',0,'10',0,0,0,'0','0','1')

 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(11,0,'textfield1',31605,'varchar(100)','1',1,0,'','',0,'11',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(12,0,'textfield2',31606,'varchar(100)','1',1,0,'','',0,'12',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(13,0,'textfield3',31607,'varchar(100)','1',1,0,'','',0,'13',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(14,0,'textfield4',31608,'varchar(100)','1',1,0,'','',0,'14',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(15,0,'textfield5',31609,'varchar(100)','1',1,0,'','',0,'15',0,0,0,'0','0','1')

 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(16,0,'tinyintfield1',31610,'char(1)','4',1,0,'','',0,'16',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(17,0,'tinyintfield2',31611,'char(1)','4',1,0,'','',0,'17',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(18,0,'tinyintfield3',31612,'char(1)','4',1,0,'','',0,'18',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(19,0,'tinyintfield4',31613,'char(1)','4',1,0,'','',0,'19',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(20,0,'tinyintfield5',31614,'char(1)','4',1,0,'','',0,'20',0,0,0,'0','0','1')

 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(21,0,'docff01name',32960,'text','3',37,0,'','',0,'21',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(22,0,'docff02name',32961,'text','3',37,0,'','',0,'22',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(23,0,'docff03name',32962,'text','3',37,0,'','',0,'23',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(24,0,'docff04name',32963,'text','3',37,0,'','',0,'24',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(25,0,'docff05name',32964,'text','3',37,0,'','',0,'25',0,0,0,'0','0','1')

 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(26,0,'depff01name',32965,'text','3',57,0,'','',0,'26',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(27,0,'depff02name',32966,'text','3',57,0,'','',0,'27',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(28,0,'depff03name',32967,'text','3',57,0,'','',0,'28',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(29,0,'depff04name',32968,'text','3',57,0,'','',0,'29',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(30,0,'depff05name',32969,'text','3',57,0,'','',0,'30',0,0,0,'0','0','1')
 
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(31,0,'crmff01name',32970,'text','3',18,0,'','',0,'31',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(32,0,'crmff02name',32971,'text','3',18,0,'','',0,'32',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(33,0,'crmff03name',32972,'text','3',18,0,'','',0,'33',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(34,0,'crmff04name',32973,'text','3',18,0,'','',0,'34',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(35,0,'crmff05name',32974,'text','3',18,0,'','',0,'35',0,0,0,'0','0','1')
 
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(36,0,'reqff01name',32975,'text','3',152,0,'','',0,'36',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(37,0,'reqff02name',32976,'text','3',152,0,'','',0,'37',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(38,0,'reqff03name',32977,'text','3',152,0,'','',0,'38',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(39,0,'reqff04name',32978,'text','3',152,0,'','',0,'39',0,0,0,'0','0','1')
 insert into cptDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(40,0,'reqff05name',32979,'text','3',152,0,'','',0,'40',0,0,0,'0','0','1')
 
  SET IDENTITY_INSERT cptDefineField OFF
  
GO


CREATE PROCEDURE cpt_selectitembyid_new @id VARCHAR(100)  ,@isbill varchar(100), @flag INTEGER OUTPUT , @msg VARCHAR(80) OUTPUT AS SELECT  * FROM    cpt_SelectItem WHERE   fieldid = @id  AND ( cancel!='1' or cancel is null) ORDER BY listorder , id SET @flag = 0 SET @msg = ''
GO


 CREATE TABLE cptDetailField(id int IDENTITY (1, 1) not null,billid int null,fieldname varchar(60) null,fieldlabel int null,fielddbtype varchar(40) null,fieldhtmltype char(1) null,type int null,viewtype int null,detailtable varchar(50) null,fromUser char(1) null,textheight int null,dsporder decimal(10,2) null,childfieldid int null,imgheight int null,imgwidth int null,isopen char(1) null,ismand char(1) null,isused char(1) null,otherpara varchar(4000) null)
GO

 CREATE TABLE cpt_detailSelectItem(fieldid int null,isbill int null,selectvalue int null,selectname varchar(250) null,id int IDENTITY (1, 1) not null,listorder numeric(10) null,isdefault char(1) null,docPath varchar(660) null,docCategory varchar(200) null,isAccordToSubCom char(1) null DEFAULT ('0'),childitemid varchar(2000) null,cancel varchar(1) null DEFAULT ((0)))
GO

 CREATE TABLE cpt_detailspecialfield(id int IDENTITY (1, 1) not null,fieldid int null,displayname varchar(1000) null,linkaddress varchar(1000) null,descriptivetext text null,isbill int null,isform int null)
GO

  CREATE PROCEDURE cpt_detailselectitem_insert_new ( @fieldid INT , @isbill INT , @selectvalue INT , @selectname VARCHAR(250) , @listorder NUMERIC(10, 2) , @isdefault CHAR(1) , @cancel2 VARCHAR(1), @flag INTEGER OUTPUT , @msg VARCHAR(80) OUTPUT ) AS INSERT  INTO cpt_detailselectitem ( fieldid , isbill , selectvalue , selectname , listorder , isdefault,cancel ) VALUES  ( @fieldid , @isbill , @selectvalue , @selectname , @listorder , @isdefault,@cancel2 )
GO


SET IDENTITY_INSERT cptDetailField ON
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(1,0,'cpttype',1509,'int','3',179,0,'CptStockInDetail','',0,'1',0,100,100,'1','1','','sqlwhere=where isdata=''1''&isdata=1')
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(2,0,'capitalspec',904,'varchar(200)','1',1,0,'CptStockInDetail','',0,'2',0,100,100,'1','1','','')
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(3,0,'plannumber',1331,'decimal(15,2)','1',3,0,'CptStockInDetail','',0,'4',0,100,100,'1','1','','')
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(4,0,'contractno',21282,'varchar(200)','1',1,0,'CptStockInDetail','',0,'7',0,100,100,'0','0','','')
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(5,0,'location',1387,'varchar(200)','1',1,0,'CptStockInDetail','',0,'6',0,100,100,'1','0','','')
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(6,0,'invoice',900,'varchar(200)','1',1,0,'CptStockInDetail','',0,'5',0,100,100,'1','0','','')
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(7,0,'selectdate',16914,'char(10)','3',2,0,'CptStockInDetail','',0,'8',0,100,100,'0','0','','')
 insert into cptDetailField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused],[otherpara]) Values(8,0,'price',1330,'decimal(15,2)','1',3,0,'CptStockInDetail','',0,'3',0,100,100,'1','1','','')
 SET IDENTITY_INSERT cptDetailField OFF
 GO
 
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 242,703,'int','/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypelBrowser.jsp','CptCapitalType','name','id','')
GO
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 243,830,'int','/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp','CptCapitalState','name','id','')
GO

alter table CptAssortmentShare add subcompanyid int
GO
alter table CptCapitalShareInfo add subcompanyid int
GO

drop procedure CptAssortmentShare_Insert
GO
CREATE PROCEDURE CptAssortmentShare_Insert (@assortmentid_1 [int], @sharetype_2 [tinyint], @seclevel_3 [tinyint], @rolelevel_4 [tinyint], @sharelevel_5 [tinyint], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], @foralluser_9 [tinyint],@subcompanyid_10 [int], @flag integer output, @msg varchar(80) output)  AS INSERT INTO [CptAssortmentShare] ( [assortmentid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid])  VALUES ( @assortmentid_1, @sharetype_2, @seclevel_3, @rolelevel_4, @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9,@subcompanyid_10)  select max(id)  id from CptAssortmentShare 
GO

drop procedure CptAssortmentShareInfo_Insert
GO
CREATE PROCEDURE [CptAssortmentShareInfo_Insert] (@relateditemid_1 [int], @sharetype_2 [tinyint], @seclevel_3 [tinyint], @rolelevel_4 [tinyint], @sharelevel_5 [tinyint], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], @foralluser_9 [tinyint], @sharefrom_10 int ,@subcompanyid_11 int , @flag integer output, @msg varchar(80) output)  AS INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser], sharefrom,[subcompanyid])  VALUES ( @relateditemid_1, @sharetype_2, @seclevel_3, @rolelevel_4, @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9, @sharefrom_10,@subcompanyid_11)
GO

drop procedure CptCapitalShareInfo_Insert
GO
CREATE PROCEDURE CptCapitalShareInfo_Insert (@relateditemid_1 [int], @sharetype_2 [tinyint], @seclevel_3 [tinyint], @rolelevel_4 [tinyint], @sharelevel_5 [tinyint], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], @foralluser_9 [tinyint],@subcompanyid_10 [int], @flag integer output, @msg varchar(80) output)  AS INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid])  VALUES ( @relateditemid_1, @sharetype_2, @seclevel_3, @rolelevel_4, @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9,@subcompanyid_10)  select max(id)  id from CptCapitalShareInfo 
GO

drop procedure [CptCapitalAssortment_Select]
GO
CREATE PROCEDURE CptCapitalAssortment_Select @flag integer output , @msg varchar(80) output AS select * from CptCapitalAssortment order by assortmentmark
go
 
alter table CptCapitalAssortment add subcompanyid1 int
go


alter table CptCapital alter COLUMN capitalnum decimal(18,2)
go



CREATE TABLE cpt_shareinner(id int IDENTITY (1, 1) not null,sourceid int not null,type int not null,content int not null,seclevel int not null,sharelevel int not null,srcfrom int not null,opuser int not null,sharesource int null,downloadlevel int null )
GO

CREATE TABLE cpt_shareouter(id int IDENTITY (1, 1) not null,sourceid int not null,type int not null,content int not null,seclevel int not null,sharelevel int not null,srcfrom int not null,opuser int not null,sharesource int null,downloadlevel int null )
GO


drop procedure [CptUseLogBack_Insert]
GO
 CREATE PROCEDURE CptUseLogBack_Insert ( @capitalid_1 	[int], @usedate_2 	[char](10), @usedeptid_3 	[int], @useresourceid_4 	[int], @usecount_5 	[int], @useaddress_6 	[varchar](200), @userequest_7 	[int], @maintaincompany_8 	[varchar](100), @fee_9 	[decimal](18,3), @usestatus_10 	[varchar](2), @remark_11 	[text], @costcenterid   [int], @sptcount	[char](1), @flag integer output, @msg varchar(80) output) AS declare @num int  if @sptcount<>'1' begin select @num=capitalnum  from CptCapital where id = @capitalid_1 end INSERT INTO [CptUseLog] ( [capitalid], [usedate], [usedeptid], [useresourceid], [usecount], [useaddress], [userequest], [maintaincompany], [fee], [usestatus], [remark]) VALUES ( @capitalid_1, @usedate_2, @usedeptid_3, @useresourceid_4, @usecount_5, @useaddress_6, @userequest_7, @maintaincompany_8, @fee_9, '0', @remark_11)  if @sptcount='1' begin Update CptCapital Set departmentid=null where id = @capitalid_1 Update CptCapital Set  costcenterid=null, resourceid=null, stateid = @usestatus_10, deprestartdate = null where id = @capitalid_1 end  else begin Update CptCapital Set capitalnum = @num+@usecount_5 where id = @capitalid_1 end select 1 
GO

insert into CptCapitalModifyField(field,name) values(77,'±àºÅ')
go
 









alter table Prj_ProjectType add dsporder decimal(10,2)
go

drop procedure [Prj_ProjectType_Insert]
GO
CREATE PROCEDURE Prj_ProjectType_Insert ( @fullname  varchar(50), @description    varchar(150), @wfid       int, @protypecode varchar(50), @insertWorkPlan char(1),@dsporder decimal(10,2),@guid1 char(36), @flag   int output, @msg    varchar(80) output) AS  INSERT INTO Prj_ProjectType ( fullname, description, wfid, protypecode, insertWorkPlan,dsporder,guid1) VALUES ( @fullname, @description, @wfid, @protypecode, @insertWorkPlan,@dsporder,@guid1)  set @flag = 1 set @msg = 'OK!'
go

drop procedure [Prj_ProjectType_Update]
GO
CREATE PROCEDURE Prj_ProjectType_Update ( @id	 	int, @fullname 	varchar(50), @description 	varchar(150), @protypecode varchar(50), @wfid	 	int, @insertWorkPlan char(1),@dsporder decimal(10,2), @flag	int	output, @msg	varchar(80)	output )  AS UPDATE Prj_ProjectType SET  fullname	 = @fullname, description	 = @description, wfid	 = @wfid ,protypecode=@protypecode, insertWorkPlan=@insertWorkPlan,dsporder=@dsporder WHERE ( id	 = @id) set @flag = 1 set @msg = 'OK!' 
go

alter table Prj_T_ShareInfo add subcompanyid int
GO
drop procedure [Prj_T_ShareInfo_Insert]
GO
CREATE PROCEDURE Prj_T_ShareInfo_Insert (@relateditemid int, @sharetype tinyint, @seclevel  tinyint, @rolelevel tinyint, @sharelevel tinyint, @userid int, @departmentid int, @roleid int, @foralluser tinyint,@subcompanyid int, @flag integer output, @msg varchar(80) output ) AS INSERT INTO Prj_T_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid ) VALUES ( @relateditemid , @sharetype , @seclevel , @rolelevel , @sharelevel, @userid, @departmentid, @roleid, @foralluser ,@subcompanyid )
go


alter table Prj_WorkType add dsporder decimal(10,2)
go

drop procedure [Prj_ProjectType_Insert]
GO
CREATE PROCEDURE Prj_ProjectType_Insert ( @fullname  varchar(50), @description    varchar(150), @wfid       int, @protypecode varchar(50), @insertWorkPlan char(1),@dsporder decimal(10,2),@guid1 char(36), @flag   int output, @msg    varchar(80) output) AS  INSERT INTO Prj_ProjectType ( fullname, description, wfid, protypecode, insertWorkPlan,dsporder,guid1) VALUES ( @fullname, @description, @wfid, @protypecode, @insertWorkPlan,@dsporder,@guid1)  set @flag = 1 set @msg = 'OK!'
go

drop procedure [Prj_ProjectType_Update]
GO
CREATE PROCEDURE Prj_ProjectType_Update ( @id	 	int, @fullname 	varchar(50), @description 	varchar(150), @protypecode varchar(50), @wfid	 	int, @insertWorkPlan char(1),@dsporder decimal(10,2), @flag	int	output, @msg	varchar(80)	output )  AS UPDATE Prj_ProjectType SET  fullname	 = @fullname, description	 = @description, wfid	 = @wfid ,protypecode=@protypecode, insertWorkPlan=@insertWorkPlan,dsporder=@dsporder WHERE ( id	 = @id) set @flag = 1 set @msg = 'OK!' 
go

drop procedure [Prj_WorkType_Insert]
GO
CREATE PROCEDURE Prj_WorkType_Insert ( @fullname_1 	varchar(50), @description_2 	varchar(150), @worktypecode varchar(50),@dsporder decimal(10,2), @flag	int	output, @msg	varchar(80)	output) AS INSERT INTO Prj_WorkType ( fullname, description,worktypecode,dsporder) VALUES ( @fullname_1, @description_2,@worktypecode,@dsporder) set @flag = 1 set @msg = 'OK!'
go

drop procedure [Prj_WorkType_Update]
GO
CREATE PROCEDURE Prj_WorkType_Update ( @id	 	int, @fullname 	varchar(50), @description 	varchar(150), @worktypecode varchar(50),@dsporder decimal(10,2), @flag	int	output, @msg	varchar(80)	output) AS UPDATE Prj_WorkType SET  fullname	 = @fullname, description = @description,worktypecode= @worktypecode,dsporder=@dsporder WHERE ( id	 = @id) set @flag = 1 set @msg = 'OK!' 
go



CREATE TABLE Prj_code(id int IDENTITY (1, 1) not null,isuse int null,subcompanyflow varchar(10) null,departmentflow varchar(10) null,capitalgroupflow varchar(10) null,capitaltypeflow varchar(10) null,buydateflow varchar(10) null,Warehousingflow varchar(10) null,startcodenum int null,assetdataflow varchar(10) null)
GO

SET IDENTITY_INSERT prj_code ON
insert into prj_code([id],[isuse],[subcompanyflow],[departmentflow],[capitalgroupflow],[capitaltypeflow],[buydateflow],[Warehousingflow],[startcodenum],[assetdataflow]) Values(1,1,'','','','','0|1','0|',1,'')
SET IDENTITY_INSERT prj_code OFF
GO


CREATE TABLE prj_codeseq(id int IDENTITY (1, 1) not null,sequenceid int null,subcompanyid int null,departmentid int null,capitalgroupid int null,capitaltypeid int null,buydateyear int null,buydatemonth int null,buydateday int null,warehouseyear int null,warehousemonth int null,warehouseday int null,assetid int null)
go

CREATE TABLE Prj_Settings(

id int IDENTITY (1, 1) not null,
subcompanyid int,
departmentid int,
userid int,

prj_dsc_doc char(1),
prj_dsc_wf char(1),
prj_dsc_crm char(1),
prj_dsc_prj char(1),
prj_dsc_tsk char(1),
prj_dsc_acc char(1),
prj_dsc_accsec int,

tsk_dsc_doc char(1),
tsk_dsc_wf char(1),
tsk_dsc_crm char(1),
tsk_dsc_prj char(1),
tsk_dsc_tsk char(1),
tsk_dsc_acc char(1),
tsk_dsc_accsec int,

prj_acc char(1),
prj_accsec int,

tsk_acc char(1),
tsk_accsec int,

prj_gnt_showplan_ char(1),
prj_gnt_warningday int

)
GO

SET IDENTITY_INSERT Prj_Settings ON
insert into Prj_Settings(id) values(-1);
SET IDENTITY_INSERT Prj_Settings OFF
GO

CREATE TABLE prjDefineField(id int IDENTITY (1, 1) not null,billid int null,fieldname varchar(60) null,fieldlabel int null,fielddbtype varchar(40) null,fieldhtmltype char(1) null,type int null,viewtype int null,detailtable varchar(50) null,fromUser char(1) null,textheight int null,dsporder decimal(10,2) null,childfieldid int null,imgheight int null,imgwidth int null,isopen char(1) null,ismand char(1) null,isused char(1) null)
GO

 CREATE TABLE prj_SelectItem(fieldid int null,isbill int null,selectvalue int null,selectname varchar(250) null,id int IDENTITY (1, 1) not null,listorder numeric(10) null,isdefault char(1) null,docPath varchar(660) null,docCategory varchar(200) null,isAccordToSubCom char(1) null DEFAULT ('0'),childitemid varchar(2000) null,cancel varchar(1) null DEFAULT ((0)))
GO

 CREATE TABLE prj_specialfield(id int IDENTITY (1, 1) not null,fieldid int null,displayname varchar(1000) null,linkaddress varchar(1000) null,descriptivetext text null,isbill int null,isform int null)
GO

  CREATE PROCEDURE prj_selectitem_insert_new ( @fieldid INT , @isbill INT , @selectvalue INT , @selectname VARCHAR(250) , @listorder NUMERIC(10, 2) , @isdefault CHAR(1) , @cancel2 VARCHAR(1), @flag INTEGER OUTPUT , @msg VARCHAR(80) OUTPUT ) AS INSERT  INTO prj_selectitem ( fieldid , isbill , selectvalue , selectname , listorder , isdefault,cancel ) VALUES  ( @fieldid , @isbill , @selectvalue , @selectname , @listorder , @isdefault,@cancel2 )
GO


  SET IDENTITY_INSERT prjDefineField ON

 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(1,0,'datefield1',31595,'char(10)','3',2,0,'','',0,'1',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(2,0,'datefield2',31596,'char(10)','3',2,0,'','',0,'2',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(3,0,'datefield3',31597,'char(10)','3',2,0,'','',0,'3',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(4,0,'datefield4',31598,'char(10)','3',2,0,'','',0,'4',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(5,0,'datefield5',31599,'char(10)','3',2,0,'','',0,'5',0,0,0,'0','0','1')

 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(6,0,'numberfield1',31600,'decimal(15,2)','1',3,0,'','',0,'6',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(7,0,'numberfield2',31601,'decimal(15,2)','1',3,0,'','',0,'7',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(8,0,'numberfield3',31602,'decimal(15,2)','1',3,0,'','',0,'8',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(9,0,'numberfield4',31603,'decimal(15,2)','1',3,0,'','',0,'9',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(10,0,'numberfield5',31604,'decimal(15,2)','1',3,0,'','',0,'10',0,0,0,'0','0','1')

 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(11,0,'textfield1',31605,'varchar(100)','1',1,0,'','',0,'11',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(12,0,'textfield2',31606,'varchar(100)','1',1,0,'','',0,'12',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(13,0,'textfield3',31607,'varchar(100)','1',1,0,'','',0,'13',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(14,0,'textfield4',31608,'varchar(100)','1',1,0,'','',0,'14',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(15,0,'textfield5',31609,'varchar(100)','1',1,0,'','',0,'15',0,0,0,'0','0','1')

 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(16,0,'tinyintfield1',31610,'char(1)','4',1,0,'','',0,'16',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(17,0,'tinyintfield2',31611,'char(1)','4',1,0,'','',0,'17',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(18,0,'tinyintfield3',31612,'char(1)','4',1,0,'','',0,'18',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(19,0,'tinyintfield4',31613,'char(1)','4',1,0,'','',0,'19',0,0,0,'0','0','1')
 insert into prjDefineField([id],[billid],[fieldname],[fieldlabel],[fielddbtype],[fieldhtmltype],[type],[viewtype],[detailtable],[fromUser],[textheight],[dsporder],[childfieldid],[imgheight],[imgwidth],[isopen],[ismand],[isused]) Values(20,0,'tinyintfield5',31614,'char(1)','4',1,0,'','',0,'20',0,0,0,'0','0','1')

SET IDENTITY_INSERT prjDefineField OFF
GO

alter table Prj_Template add updatedate char(10)
go

alter table cus_formfield add prj_isopen char(1)
go
alter table cus_formfield add prj_fieldlabel int
go

update cus_formfield set prj_isopen='1'
go

alter table cus_selectitem add prj_isdefault char(1)
go

INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 244,586,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp','Prj_ProjectType','fullname','id','')
go
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 245,432,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/WorkTypeBrowser.jsp','Prj_WorkType','fullname','id','')
go
INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 246,587,'int','/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectStatusBrowser.jsp','Prj_ProjectStatus','description','id','')
go

 CREATE TABLE Prj_TaskShareInfo(id int IDENTITY (1, 1) not null,relateditemid int null,sharetype int null,seclevel int null,rolelevel int null,sharelevel int null,userid int null,departmentid int null,roleid int null,foralluser int null,crmid int null,sharefrom int null,subcompanyid int null PRIMARY KEY (id))
 go
 
 CREATE TABLE Prj_TaskShareDtl(taskid int null,userid int null,usertype int null,sharelevel int null)
 go
 
 CREATE PROCEDURE Prj_TaskShareInfo_Delete (@id_1 [int], @flag integer output, @msg varchar(80) output)  AS DELETE [Prj_TaskShareInfo]  WHERE ( [id] = @id_1) 
 go
 
 CREATE PROCEDURE Prj_TaskShareInfo_Insert (@relateditemid_1 [int], @sharetype_2 [int], @seclevel_3 [int], @rolelevel_4 [int], @sharelevel_5 [int], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], @foralluser_9 [int],@subcompanyid_10 [int], @flag integer output, @msg varchar(80) output)  AS INSERT INTO [Prj_TaskShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid])  VALUES ( @relateditemid_1, @sharetype_2, @seclevel_3, @rolelevel_4, @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9,@subcompanyid_10)  select max(id)  id from Prj_TaskShareInfo 
 go
 
 CREATE PROCEDURE Prj_TaskShareDtl_Insert (@capitalid 	[int], @userid 	[int], @usertype 	[int], @sharelevel 	[int] , @flag	[int]	output, @msg	[varchar](80)	output)  AS INSERT INTO [Prj_TaskShareDtl] ( [taskid],	 [userid] , [usertype], [sharelevel] )  VALUES ( @capitalid,@userid, @usertype, @sharelevel ) 
 go
 
 CREATE PROCEDURE Prj_TaskShareDtl_DeleteByTaskId (@cptid 	[int] , @flag	[int]	output, @msg	[varchar](80)	output)  AS DELETE [Prj_TaskShareDtl]  WHERE ( [taskid]	 = @cptid) 
 go
 

CREATE FUNCTION getPrjBeginDate
(@prjid int)
RETURNS char(10) AS
BEGIN
Return (SELECT MIN(begindate)  FROM Prj_TaskProcess WHERE prjid=@prjid)
END
go

CREATE FUNCTION getPrjEndDate
(@prjid int)
RETURNS char(10) AS
BEGIN
Return (SELECT MAX(enddate)  FROM Prj_TaskProcess WHERE prjid=@prjid)
END
go


CREATE FUNCTION getPrjFinish
(@prjid int)
RETURNS int AS
BEGIN
DECLARE @sumWorkday decimal(9)
DECLARE @finish int
set @finish=0
SELECT @sumWorkday=SUM(workday) FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') ;
IF @sumWorkday<>0 
	SELECT @finish= (sum(finish*workday)/sum(workday))  FROM Prj_TaskProcess WHERE ( prjid = @prjid and parentid = '0' and isdelete<>'1') 
Return @finish
END
go

update Task_Modify set fieldname='1352' where fieldname='subject'
go
update Task_Modify set fieldname='17501' where fieldname='realManDays'
go
update Task_Modify set fieldname='2097' where fieldname='hrmid'
go
update Task_Modify set fieldname='1322' where fieldname='begindate'
go
update Task_Modify set fieldname='741' where fieldname='enddate'
go
update Task_Modify set fieldname='1298' where fieldname='workday'
go
update Task_Modify set fieldname='555' where fieldname='finish'
go
update Task_Modify set fieldname='15274' where fieldname='fixedcost'
go
update Task_Modify set fieldname='2232' where fieldname='islandmark'
go
update Task_Modify set fieldname='2240' where fieldname='content'
go
update Task_Modify set fieldname='2233' where fieldname='pretask'
go
update Task_Modify set fieldname='33351' where fieldname='actualbegindate'
go
update Task_Modify set fieldname='24697' where fieldname='actualenddate'
go

alter table Prj_SearchMould add finish int
go
alter table Prj_SearchMould add finish1 int
go
alter table Prj_SearchMould add subcompanyid1 int
go
alter table Prj_ShareInfo add subcompanyid int
go

drop procedure [Prj_ShareInfo_Insert]
GO
CREATE PROCEDURE Prj_ShareInfo_Insert (@relateditemid int, @sharetype tinyint, @seclevel  int, @rolelevel int, @sharelevel int, @userid int, @departmentid int, @roleid int, @foralluser int,@subcompanyid int, @flag integer output, @msg varchar(80) output ) AS INSERT INTO Prj_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser,subcompanyid ) VALUES ( @relateditemid , @sharetype , @seclevel , @rolelevel , @sharelevel, @userid, @departmentid, @roleid, @foralluser,@subcompanyid  ) set @flag=1 set @msg='ok' 
go

CREATE PROCEDURE prj_selectitembyid_new @id VARCHAR(100)  ,@isbill varchar(100), @flag INTEGER OUTPUT , @msg VARCHAR(80) OUTPUT AS SELECT  * FROM    prj_SelectItem WHERE   fieldid = @id  AND ( cancel!='1' or cancel is null) ORDER BY listorder , id SET @flag = 0 SET @msg = ''
GO

alter table prj_taskprocess add accessory varchar(2000)
go
alter table Exchange_Info add accessory varchar(2000)
go

alter table Exchange_Info add relatedtsk varchar(2000)
go
alter table Exchange_Info add tskids varchar(2000)
go

CREATE PROCEDURE ExchangeInfo_Insert_PRJ
( @sortid_1 int  , @name_1  varchar (200)   , 
@remark_1 text  , @creater_1  int  ,
@createDate_1  char (10)   , 
@createTime_1  char (10)  , @type_n_1 char(2), 
@relateddoc_1	varchar(500), 
@relatedwf_1	varchar(500), 
@relatedcus_1	varchar(500), 
@relatedprj_1	varchar(500), 
@relatedtsk_1	varchar(500), 
@relatedacc_1	varchar(500), 
@flag integer output, @msg varchar(80) output)  
AS INSERT INTO Exchange_Info( sortid , name , 
remark , creater , createDate , createTime, type_n, 
docids, requestIds, crmIds, projectIds, tskids,accessory)  
VALUES( @sortid_1 , @name_1, 
@remark_1, @creater_1 , @createDate_1 , @createTime_1, @type_n_1, 
@relateddoc_1, @relatedwf_1, @relatedcus_1, @relatedprj_1, @relatedtsk_1,@relatedacc_1) 
go

SET IDENTITY_INSERT Prj_ProjectStatus ON 

insert into Prj_ProjectStatus (
  id
  ,fullname
  ,[description]
) VALUES (
  0
  , 220
  ,'²Ý¸å'
)
SET IDENTITY_INSERT Prj_ProjectStatus OFF
go

alter TABLE Prj_Template add accessory varchar(2000)
go
alter TABLE Prj_TemplateTask add accessory varchar(2000)
go
alter table Prj_TaskInfo add realManDays decimal(6,1)
go
alter table Prj_TaskInfo add actualBeginDate varchar(10)
go
alter table Prj_TaskInfo add actualEndDate varchar(10)
go
alter table Prj_TaskInfo add finish int
go

alter table Prj_TempletTask_needdoc add isTempletTask char(1)
go
alter table Prj_TempletTask_needwf add isTempletTask char(1)
go
alter table Prj_TempletTask_referdoc add isTempletTask char(1)
go

alter table Prj_TaskInfo add status int
go
alter table Prj_TaskInfo add islandmark char(1)
go

CREATE TABLE Prj_XchgInfo_ViewLog
(
id int IDENTITY (1, 1) not null,
xchg_id int  null,
sortid int  null,
type_n char(2) null,
viewer_id int null,
view_date varchar(50) null,
view_time varchar(50) null
)
GO

alter table Prj_TaskInfo add creater int,createdate varchar(50),createtime varchar(50)
go

drop procedure [Prj_Plan_SaveFromProcess]
GO
CREATE PROCEDURE Prj_Plan_SaveFromProcess 
(@prjid 	[int], @version	[int],@creater	[int],@createdate	varchar(50),@createtime	varchar(50), @flag integer output, @msg varchar(80) output  ) 
AS declare @taskid 	[int], @wbscoding 	[varchar](20), @subject 	[varchar](50), @begindate 	[varchar](10), @enddate 	[varchar](10), @workday        [decimal] (10,1), @content 	[varchar](255), @fixedcost	[decimal](10,2), @parentid	[int], @parentids	[varchar](255), @parenthrmids	[varchar](255), @level_n		[tinyint], @hrmid		[int], @all_cursor	cursor SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from [Prj_TaskProcess] where prjid = @prjid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid WHILE @@FETCH_STATUS = 0 begin INSERT INTO [Prj_TaskInfo] ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version,creater,createdate,createtime)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'1',@version,@creater,@createdate,@createtime) FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid end CLOSE @all_cursor DEALLOCATE @all_cursor 
GO


drop procedure [Prj_Plan_Approve]
GO
   CREATE PROCEDURE Prj_Plan_Approve (@prjid 	[int],@creater	[int],@createdate	varchar(50),@createtime	varchar(50), @flag integer output, @msg varchar(80) output  ) AS declare @taskid 	[int], @wbscoding 	[varchar](200), @subject 	[varchar](500), @begindate 	[varchar](50), @enddate 	[varchar](50), @workday        [decimal] (10,1), @content 	[varchar](4000), @fixedcost	[decimal](18,2), @parentid	[int], @parentids	[varchar](4000), @parenthrmids	[varchar](4000), @level_n		[tinyint], @hrmid		[int], @all_cursor	cursor SET @all_cursor = CURSOR FORWARD_ONLY STATIC FOR select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from [Prj_TaskProcess] where prjid = @prjid OPEN @all_cursor FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid WHILE @@FETCH_STATUS = 0 begin INSERT INTO [Prj_TaskInfo] (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version,creater,createdate,createtime)  VALUES (  @prjid, @taskid , @wbscoding, @subject , @begindate, @enddate, @workday, @content, @fixedcost, @parentid, @parentids, @parenthrmids, @level_n, @hrmid,'2','1',@creater,@createdate,@createtime) FETCH NEXT FROM @all_cursor INTO @taskid,@wbscoding,@subject,@begindate,@enddate, @workday,@content,@fixedcost,@parentid,@parentids,@parenthrmids,@level_n,@hrmid end CLOSE @all_cursor DEALLOCATE @all_cursor 
GO

CREATE TABLE prj_shareinner(id int IDENTITY (1, 1) not null,sourceid int not null,type int not null,content int not null,seclevel int not null,sharelevel int not null,srcfrom int not null,opuser int not null,sharesource int null,downloadlevel int null )
GO

CREATE TABLE prj_shareouter(id int IDENTITY (1, 1) not null,sourceid int not null,type int not null,content int not null,seclevel int not null,sharelevel int not null,srcfrom int not null,opuser int not null,sharesource int null,downloadlevel int null )
GO

CREATE TABLE prjtsk_shareinner(id int IDENTITY (1, 1) not null,sourceid int not null,type int not null,content int not null,seclevel int not null,sharelevel int not null,srcfrom int not null,opuser int not null,sharesource int null,downloadlevel int null )
GO

CREATE TABLE prjtsk_shareouter(id int IDENTITY (1, 1) not null,sourceid int not null,type int not null,content int not null,seclevel int not null,sharelevel int not null,srcfrom int not null,opuser int not null,sharesource int null,downloadlevel int null )
GO































































