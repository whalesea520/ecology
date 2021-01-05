CREATE TABLE CRM_CustomerDefinFieldGroup(
	id INT IDENTITY(1,1),
	usetable VARCHAR(50),
	grouplabel INT,
	candel CHAR(1),
	dsporder int 
)
GO

INSERT INTO workflow_browserurl(id,labelid,fielddbtype,tablename,columname,keycolumname,browserurl,linkurl) values (258,377,'int','HrmCountry','countryname','id','/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp','/hrm/country/CountryBrowser.jsp')
GO

INSERT INTO workflow_browserurl(id,labelid,fielddbtype,tablename,columname,keycolumname,browserurl,linkurl) values (259,15078,'int','CRM_CustomerStatus','fullname','id','/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','/CRM/Maint/CustomerStatusBrowser.jsp')
GO
INSERT INTO workflow_browserurl(id,labelid,fielddbtype,tablename,columname,keycolumname,browserurl,linkurl) values (260,645,'int','CRM_ContactWay','fullname','id','/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp','/CRM/Maint/ContactWayBrowser.jsp')
GO





insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',154,1,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',16378,2,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',15125,3,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',572,4,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',17088,5,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerContacter',154,1,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerContacter',17088,2,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerAddress',154,1,'n')
GO
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerAddress',17088,2,'n')
GO

update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp' ,linkurl='/CRM/Maint/ContacterTitleBrowser.jsp' WHERE id = 59
GO
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp' ,linkurl='/CRM/Maint/CustomerTypeBrowser.jsp' WHERE id = 60
GO
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp' ,linkurl='/CRM/Maint/CustomerDescBrowser.jsp' WHERE id = 61
GO
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp' ,linkurl='/CRM/Maint/CustomerSizeBrowser.jsp' WHERE id = 62
GO
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp' ,linkurl='/CRM/Maint/SectorInfoBrowser.jsp' WHERE id = 63
GO


ALTER TABLE CRM_CustomerDefinField ADD groupid INT 
GO
ALTER TABLE  CRM_CustomerContacter ADD  isperson INT 
GO

update CRM_CustomerDefinField set groupid=5,candel='y' where usetable='CRM_CustomerInfo'
GO

update CRM_CustomerDefinField set groupid=7,candel='y' where usetable='CRM_CustomerContacter'
GO

update CRM_CustomerDefinField set groupid=9,candel='y' where usetable='CRM_CustomerAddress'
GO






insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('name',1268,'varchar(100)','1','1','0','1','CRM_CustomerInfo',1,'n',1,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('crmcode',17080,'varchar(100)','1','1','0','2','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('engname',23893,'varchar(50)','1','1','0','3','CRM_CustomerInfo',1,'n',1,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('address1',110,'varchar(250)','1','1','0','4','CRM_CustomerInfo',1,'n',1,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('zipcode',479,'varchar(10)','1','1','0','5','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('city',493,'INT','3','58','0','6','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('county',644,'varchar(50)','1','1','0','7','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('language',231,'INT','5','1','0','8','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('phone',421,'varchar(50)','1','1','0','9','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('fax',494,'varchar(50)','1','1','0','10','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('email',477,'varchar(150)','1','1','0','11','CRM_CustomerInfo',1,'n',1,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('website',76,'varchar(150)','1','1','0','12','CRM_CustomerInfo',1,'n',0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,textheight,ismust,groupid)
VALUES('introduction',634,'varchar(500)','2','','0','13','CRM_CustomerInfo',1,'n',2,0,1)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('status',602,'INT','3','259','0','14','CRM_CustomerInfo',1,'n',1,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('type',63,'INT','3','60','0','15','CRM_CustomerInfo',1,'n',1,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('description',433,'INT','3','61','0','16','CRM_CustomerInfo',1,'n',1,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('size_n',576,'INT','3','62','0','17','CRM_CustomerInfo',1,'n',1,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('source',645,'INT','3','260','0','18','CRM_CustomerInfo',1,'n',1,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('sector',575,'INT','3','63','0','19','CRM_CustomerInfo',1,'n',1,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('manager',1278,'INT','3','1','0','20','CRM_CustomerInfo',1,'n',0,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('agent',132,'INT','3','7','0','21','CRM_CustomerInfo',1,'n',0,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('parentid',591,'INT','3','7','0','22','CRM_CustomerInfo',1,'n',0,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('documentid',58,'INT','3','9','0','23','CRM_CustomerInfo',1,'n',0,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('introductionDocid',6069,'INT','3','9','0','24','CRM_CustomerInfo',1,'n',0,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('seclevel',683,'INT','1','2','0','25','CRM_CustomerInfo',1,'n',0,2)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('CreditAmount',6097,'DECIMAL (10,2)','1','3','0','26','CRM_CustomerInfo',1,'n',0,3)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('CreditTime',6098,'INT','1','2','0','27','CRM_CustomerInfo',1,'n',0,3)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('bankName',17084,'varchar(200)','1','1','0','28','CRM_CustomerInfo',1,'n',0,3)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('accountName',571,'varchar(40)','1','1','0','29','CRM_CustomerInfo',1,'n',0,3)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('accounts',17085,'varchar(200)','1','1','0','30','CRM_CustomerInfo',1,'n',0,3)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('title',462,'INT','3','59','0','31','CRM_CustomerInfo',1,'n',1,4)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('firstname',413,'varchar(50)','1','1','0','32','CRM_CustomerInfo',1,'n',1,4)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('jobtitle',640,'varchar(100)','1','1','0','33','CRM_CustomerInfo',1,'n',1,4)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('contacteremail',477,'varchar(150)','1','1','0','34','CRM_CustomerInfo',1,'n',0,4)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phoneoffice',661,'varchar(20)','1','1','0','35','CRM_CustomerInfo',1,'n',0,4)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phonehome',662,'varchar(20)','1','1','0','36','CRM_CustomerInfo',1,'n',0,4)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('mobilephone',620,'varchar(20)','1','1','0','37','CRM_CustomerInfo',1,'n',0,4)
GO

INSERT INTO crm_selectitem(fieldid ,selectvalue ,selectname ,fieldorder ,isdel)
SELECT (SELECT id FROM CRM_CustomerDefinField WHERE usetable = 'CRM_CustomerInfo'  AND fieldname = 'language') , id , language ,
id-7 , 0 
FROM syslanguage
GO


insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('firstname',413,'varchar(50)','1','1','0','1','CRM_CustomerContacter',1,'n',1,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('title',462,'INT','3','59','0','2','CRM_CustomerContacter',1,'n',1,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('lastName',475,'varchar(50)','1','1','0','3','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('jobtitle',640,'varchar(100)','1','1','0','4','CRM_CustomerContacter',1,'n',1,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('projectrole',34059,'varchar(100)','1','1','0','5','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('attitude',34060,'varchar(50)','1','1','0','6','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('attention',34061,'varchar(200)','1','1','0','7','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('email',477,'varchar(150)','1','1','0','8','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phoneoffice',661,'varchar(20)','1','1','0','9','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phonehome',662,'varchar(20)','1','1','0','10','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('mobilephone',620,'varchar(20)','1','1','0','11','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('fax',620,'varchar(20)','1','1','0','12','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('imcode',25101,'varchar(50)','1','1','0','13','CRM_CustomerContacter',1,'n',0,6)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('birthday',1884,'varchar(20)','3','2','0','14','CRM_CustomerContacter',1,'n',0,7)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('birthdaynotifydays',17534,'varchar(10)','1','1','0','15','CRM_CustomerContacter',1,'n',0,7)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('language',231,'int','5','1','0','16','CRM_CustomerContacter',1,'n',1,7)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('main',1262,'int','4','','0','17','CRM_CustomerContacter',1,'n',0,7)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('isperson',34080,'int','4','','0','18','CRM_CustomerContacter',1,'n',0,7)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,textheight,ismust,groupid)
VALUES('remark',454,'varchar(500)','2','1','0','19','CRM_CustomerContacter',1,'n',2,0,7)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('remarkDoc',34064,'int','3','9','0','20','CRM_CustomerContacter',1,'n',0,7)
GO

INSERT INTO crm_selectitem(fieldid ,selectvalue ,selectname ,fieldorder ,isdel)
SELECT (SELECT id FROM CRM_CustomerDefinField WHERE usetable = 'CRM_CustomerContacter'  AND fieldname = 'language') , id , language ,
id-7 , 0 
FROM syslanguage
GO

insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('address1',33882,'varchar(250)','1','1','0','1','CRM_CustomerAddress',1,'n',1,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('address2',33883,'varchar(250)','1','1','0','2','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('address3',33884,'varchar(250)','1','1','0','3','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('city',493,'INT','3','58','0','4','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('county',644,'varchar(50)','1','1','0','5','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('phone',421,'varchar(50)','1','1','0','6','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('fax',640,'varchar(50)','1','1','0','7','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('email',34059,'varchar(150)','1','1','0','8','CRM_CustomerAddress',1,'n',0,8)
GO
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('contacter',34060,'INT','3','1','0','9','CRM_CustomerAddress',1,'n',0,8)
GO


