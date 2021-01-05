CREATE TABLE CRM_CustomerDefinFieldGroup(
	id INT,
	usetable VARCHAR(50),
	grouplabel INT,
	candel CHAR(1),
	dsporder int 
)
/
create sequence CRM_CustomerDefinFieldGroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_Group_id_trigger
before insert on CRM_CustomerDefinFieldGroup
for each row 
begin
select CRM_CustomerDefinFieldGroup_id.nextval into :new.id from dual;
end;
/

INSERT INTO workflow_browserurl(id,labelid,fielddbtype,tablename,columname,keycolumname,browserurl,linkurl) values (258,377,'int','HrmCountry','countryname','id','/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp','/hrm/country/CountryBrowser.jsp')
/

INSERT INTO workflow_browserurl(id,labelid,fielddbtype,tablename,columname,keycolumname,browserurl,linkurl) values (259,15078,'int','CRM_CustomerStatus','fullname','id','/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','/CRM/Maint/CustomerStatusBrowser.jsp')
/
INSERT INTO workflow_browserurl(id,labelid,fielddbtype,tablename,columname,keycolumname,browserurl,linkurl) values (260,645,'int','CRM_ContactWay','fullname','id','/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp','/CRM/Maint/ContactWayBrowser.jsp')
/

insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',154,1,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',16378,2,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',15125,3,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',572,4,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerInfo',17088,5,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerContacter',154,1,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerContacter',17088,2,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerAddress',154,1,'n')
/
insert into CRM_CustomerDefinFieldGroup(usetable , grouplabel , dsporder,candel) values('CRM_CustomerAddress',17088,2,'n')
/

update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp' ,linkurl='/CRM/Maint/ContacterTitleBrowser.jsp' WHERE id = 59
/
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp' ,linkurl='/CRM/Maint/CustomerTypeBrowser.jsp' WHERE id = 60
/
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp' ,linkurl='/CRM/Maint/CustomerDescBrowser.jsp' WHERE id = 61
/
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp' ,linkurl='/CRM/Maint/CustomerSizeBrowser.jsp' WHERE id = 62
/
update workflow_browserurl SET browserurl  = '/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp' ,linkurl='/CRM/Maint/SectorInfoBrowser.jsp' WHERE id = 63
/


ALTER TABLE CRM_CustomerDefinField ADD groupid INT 
/
ALTER TABLE  CRM_CustomerContacter ADD  isperson INT 
/
AlTER TABLE CRM_CustomerDefinField ADD issearch char(1) 
/
update CRM_CustomerDefinField set groupid=5,candel='y' where usetable='CRM_CustomerInfo'
/

update CRM_CustomerDefinField set groupid=7,candel='y' where usetable='CRM_CustomerContacter'
/

update CRM_CustomerDefinField set groupid=9,candel='y' where usetable='CRM_CustomerAddress'
/






insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('name',1268,'varchar(100)','1','1','0','1','CRM_CustomerInfo',1,'n',1,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('crmcode',17080,'varchar(100)','1','1','0','2','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('engname',23893,'varchar(50)','1','1','0','3','CRM_CustomerInfo',1,'n',1,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('address1',110,'varchar(250)','1','1','0','4','CRM_CustomerInfo',1,'n',1,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('zipcode',479,'varchar(10)','1','1','0','5','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('city',493,'INT','3','58','0','6','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('county',644,'varchar(50)','1','1','0','7','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('language',231,'INT','5','1','0','8','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('phone',421,'varchar(50)','1','1','0','9','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('fax',494,'varchar(50)','1','1','0','10','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('email',477,'varchar(150)','1','1','0','11','CRM_CustomerInfo',1,'n',1,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('website',76,'varchar(150)','1','1','0','12','CRM_CustomerInfo',1,'n',0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,textheight,ismust,groupid)
VALUES('introduction',634,'varchar(500)','2','','0','13','CRM_CustomerInfo',1,'n',2,0,1)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('status',602,'INT','3','259','0','14','CRM_CustomerInfo',1,'n',1,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('type',63,'INT','3','60','0','15','CRM_CustomerInfo',1,'n',1,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('description',433,'INT','3','61','0','16','CRM_CustomerInfo',1,'n',1,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('size_n',576,'INT','3','62','0','17','CRM_CustomerInfo',1,'n',1,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('source',645,'INT','3','260','0','18','CRM_CustomerInfo',1,'n',1,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('sector',575,'INT','3','63','0','19','CRM_CustomerInfo',1,'n',1,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('manager',1278,'INT','3','1','0','20','CRM_CustomerInfo',1,'n',0,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('agent',132,'INT','3','7','0','21','CRM_CustomerInfo',1,'n',0,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('parentid',591,'INT','3','7','0','22','CRM_CustomerInfo',1,'n',0,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('documentid',58,'INT','3','9','0','23','CRM_CustomerInfo',1,'n',0,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('introductionDocid',6069,'INT','3','9','0','24','CRM_CustomerInfo',1,'n',0,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('seclevel',683,'INT','1','2','0','25','CRM_CustomerInfo',1,'n',0,2)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('CreditAmount',6097,'DECIMAL (10,2)','1','3','0','26','CRM_CustomerInfo',1,'n',0,3)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('CreditTime',6098,'INT','1','2','0','27','CRM_CustomerInfo',1,'n',0,3)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('bankName',17084,'varchar(200)','1','1','0','28','CRM_CustomerInfo',1,'n',0,3)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('accountName',571,'varchar(40)','1','1','0','29','CRM_CustomerInfo',1,'n',0,3)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('accounts',17085,'varchar(200)','1','1','0','30','CRM_CustomerInfo',1,'n',0,3)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('title',462,'INT','3','59','0','31','CRM_CustomerInfo',1,'n',1,4)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('firstname',413,'varchar(50)','1','1','0','32','CRM_CustomerInfo',1,'n',1,4)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('jobtitle',640,'varchar(100)','1','1','0','33','CRM_CustomerInfo',1,'n',1,4)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('contacteremail',477,'varchar(150)','1','1','0','34','CRM_CustomerInfo',1,'n',0,4)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phoneoffice',661,'varchar(20)','1','1','0','35','CRM_CustomerInfo',1,'n',0,4)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phonehome',662,'varchar(20)','1','1','0','36','CRM_CustomerInfo',1,'n',0,4)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('mobilephone',620,'varchar(20)','1','1','0','37','CRM_CustomerInfo',1,'n',0,4)
/

INSERT INTO crm_selectitem(fieldid ,selectvalue ,selectname ,fieldorder ,isdel)
SELECT (SELECT id FROM CRM_CustomerDefinField WHERE usetable = 'CRM_CustomerInfo'  AND fieldname = 'language') , id , language ,
id-7 , 0 
FROM syslanguage
/


insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('firstname',413,'varchar(50)','1','1','0','1','CRM_CustomerContacter',1,'n',1,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('title',462,'INT','3','59','0','2','CRM_CustomerContacter',1,'n',1,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('lastName',475,'varchar(50)','1','1','0','3','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('jobtitle',640,'varchar(100)','1','1','0','4','CRM_CustomerContacter',1,'n',1,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('projectrole',34059,'varchar(100)','1','1','0','5','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('attitude',34060,'varchar(50)','1','1','0','6','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('attention',34061,'varchar(200)','1','1','0','7','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('email',477,'varchar(150)','1','1','0','8','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phoneoffice',661,'varchar(20)','1','1','0','9','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('phonehome',662,'varchar(20)','1','1','0','10','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('mobilephone',620,'varchar(20)','1','1','0','11','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('fax',494,'varchar(20)','1','1','0','12','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('imcode',25101,'varchar(50)','1','1','0','13','CRM_CustomerContacter',1,'n',0,6)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('birthday',1884,'varchar(20)','3','2','0','14','CRM_CustomerContacter',1,'n',0,7)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('birthdaynotifydays',17534,'varchar(10)','1','2','0','15','CRM_CustomerContacter',1,'n',0,7)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('language',231,'int','5','1','0','16','CRM_CustomerContacter',1,'n',1,7)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('main',1262,'int','4','','0','17','CRM_CustomerContacter',1,'n',0,7)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('isperson',34080,'int','4','','0','18','CRM_CustomerContacter',1,'n',0,7)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,textheight,ismust,groupid)
VALUES('remark',454,'varchar(500)','2','1','0','19','CRM_CustomerContacter',1,'n',2,0,7)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid)
VALUES('remarkDoc',34064,'int','3','9','0','20','CRM_CustomerContacter',1,'n',0,7)
/

INSERT INTO crm_selectitem(fieldid ,selectvalue ,selectname ,fieldorder ,isdel)
SELECT (SELECT id FROM CRM_CustomerDefinField WHERE usetable = 'CRM_CustomerContacter'  AND fieldname = 'language') , id , language ,
id-7 , 0 
FROM syslanguage
/


ALTER TABLE CRM_CustomerAddress ADD  id INT
/
create sequence CRM_CustomerAddress_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_CustomerAddress_id_trigger
before insert on CRM_CustomerAddress
for each row 
begin
select CRM_CustomerAddress_id.nextval into :new.id from dual;
end;
/

delete from CRM_CustomerDefinField where usetable = 'CRM_CustomerAddress' and groupid = 8
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('address1',110,'varchar(250)','1','1','0','1','CRM_CustomerAddress',1,'n',1,8)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('city',493,'INT','3','58','0','2','CRM_CustomerAddress',1,'n',0,8)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('zipcode',479,'varchar(10)','1','1','0','3','CRM_CustomerAddress',1,'n',0,8)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('county',644,'varchar(50)','1','1','0','4','CRM_CustomerAddress',1,'n',0,8)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('phone',421,'varchar(50)','1','1','0','5','CRM_CustomerAddress',1,'n',0,8)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('fax',494,'varchar(50)','1','1','0','6','CRM_CustomerAddress',1,'n',0,8)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('email',477,'varchar(150)','1','1','0','7','CRM_CustomerAddress',1,'n',0,8)
/
insert into CRM_CustomerDefinField(fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,dsporder,usetable,isopen,candel,ismust,groupid) VALUES('contacter',572,'INT','3','1','0','8','CRM_CustomerAddress',1,'n',0,8)
/


ALTER TABLE CRM_T_ShareInfo ADD subcompanyid INT 
/

CREATE OR REPLACE PROCEDURE "CRM_T_SHAREINFO_INSERT" (
	relateditemid_1 INTEGER,
	sharetype_1 SMALLINT,
	seclevel_1 SMALLINT,
	rolelevel_1 SMALLINT,
	sharelevel_1 SMALLINT,
	userid_1 INTEGER,
	departmentid_1 INTEGER,
	roleid_1 INTEGER,
	foralluser_1 SMALLINT,
	subcompanyid_1 INTEGER,
	flag out INTEGER,
	msg out VARCHAR2,
	thecursor IN OUT cursor_define.weavercursor
) AS
BEGIN
	INSERT INTO CRM_T_ShareInfo (
		relateditemid,
		sharetype,
		seclevel,
		rolelevel,
		sharelevel,
		userid,
		departmentid,
		roleid,
		foralluser,
		subcompanyid
	)
VALUES
	(
		relateditemid_1,
		sharetype_1,
		seclevel_1,
		rolelevel_1,
		sharelevel_1,
		userid_1,
		departmentid_1,
		roleid_1,
		foralluser_1,
		subcompanyid_1
	) ;
END ;
/

DECLARE id_n INT; sharetype_n int ;
CURSOR managercursor  is SELECT id ,sharetype FROM cotype_sharemanager WHERE sharevalue LIKE '%,%';
BEGIN
OPEN managercursor;
	loop
	FETCH managercursor INTO id_n ,sharetype_n;
	exit when managercursor%notfound;

		IF(sharetype_n =1) THEN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype , t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmResource t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
		
		IF(sharetype_n =2) THEN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmDepartment t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
		
		IF(sharetype_n =3) THEN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmSubCompany t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
		
		IF(sharetype_n =4) THEN 
			INSERT into cotype_sharemanager(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemanager t1,HrmRoles t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
	   	
	  DELETE FROM cotype_sharemanager WHERE id = id_n;
	END loop;
CLOSE managercursor;
END;
/

DECLARE id_n INT; sharetype_n int ;
CURSOR membercursor  is SELECT id ,sharetype FROM cotype_sharemembers WHERE sharevalue LIKE '%,%';
BEGIN
OPEN membercursor;
	loop
	FETCH membercursor INTO id_n ,sharetype_n;
	exit when membercursor%notfound;

		IF(sharetype_n =1) THEN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype , t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmResource t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
		
		IF(sharetype_n =2) THEN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmDepartment t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
		
		IF(sharetype_n =3) THEN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmSubCompany t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
		
		IF(sharetype_n =4) THEN 
			INSERT into cotype_sharemembers(cotypeid ,sharetype ,sharevalue ,seclevel ,rolelevel)
			SELECT t1.cotypeid ,t1.sharetype ,t2.id , t1.seclevel ,t1.rolelevel
			FROM cotype_sharemembers t1,HrmRoles t2
			WHERE  t1.id = id_n AND ','||t1.sharevalue||',' LIKE '%,'||to_char(t2.id)||',%';
		END IF;
	   	
	  DELETE FROM cotype_sharemembers WHERE id = id_n;
	END loop;
CLOSE membercursor;
END;
/



UPDATE MailConfigureInfo SET innerMail = 1 ,outtermail = 1
/

ALTER TABLE WorkPlan ADD fileid VARCHAR(2000)
/

