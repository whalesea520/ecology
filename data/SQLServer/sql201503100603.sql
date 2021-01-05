ALTER TABLE CRM_SellChance ADD selltypesid INT NULL
GO
ALTER TABLE CRM_CustomerDefinField ADD seltablename VARCHAR (400) NULL
GO
ALTER TABLE CRM_CustomerDefinField ADD selcolumname VARCHAR (400) NULL
GO
ALTER TABLE CRM_CustomerDefinField ADD selkeycolumname VARCHAR (400) NULL
GO

insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_SellChance',1361,1,'n')
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'subject',82534,'varchar(100)','1','1','0','1','CRM_SellChance',1,'n',1,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,seltablename,selkeycolumname,selcolumname,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'selltypesid',82538,'INT','5','1','CRM_SellTypes','id','fullname','0','2','CRM_SellChance',1,'n',0, min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'predate',2247,'CHAR(10)','3','2','0','3','CRM_SellChance',1,'n',1,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'customerid',1268,'INT','3','7','0','4','CRM_SellChance',1,'n',0,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'preyield',2248,'DECIMAL(18,2)','1','3','0','5','CRM_SellChance',1,'n',0,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'creater',1278,'INT','3','1','0','6','CRM_SellChance',1,'n',1,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'probability',2249,'DECIMAL(8,2)','1','3','0','7','CRM_SellChance',1,'n',1,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'comefromid',82535,'INT','3','274','0','8','CRM_SellChance',1,'n',0,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,seltablename,selkeycolumname,selcolumname,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'sufactor',15103,'INT','5','1','CRM_Successfactor','id','fullname','0','9','CRM_SellChance',1,'n',0,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'content',15239,'INT','3','7','0','10','CRM_SellChance',1,'n',0,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,seltablename,selkeycolumname,selcolumname,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'defactor',15104,'INT','5','1','CRM_Failfactor','id','fullname','0','11','CRM_SellChance',1,'n',0,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,seltablename,selkeycolumname,selcolumname,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) 
select 'sellstatusid',2250,'INT','5','1','CRM_SellStatus','id','fullname','0','12','CRM_SellChance',1,'n',0,min(id) from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance'
GO

CREATE TABLE CRM_SellTypes(
	id          INT IDENTITY NOT NULL,
	fullname    VARCHAR (1000) NULL,
	description VARCHAR (1000) NULL
)
GO


INSERT INTO workflow_browserurl (id,labelid,fielddbtype,browserurl,tablename,columname,keycolumname,linkurl) VALUES ( 274,82535,'int','/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactLogBrowser.jsp','WorkPlan','name','id','')
GO

update CRM_CustomerDefinField set issearch = 1 WHERE usetable = 'CRM_SellChance' AND fieldname IN('subject','preyield','probability','endtatusid','sellstatusid','predate')
GO


