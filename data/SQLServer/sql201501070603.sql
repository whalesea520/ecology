delete from hrm_formfield
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 0,'jobactivity',1915,'int',3,24,7,1,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 1,'workcode',714,'varchar(60)',1,1,1,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 2,'lastname',413,'varchar(60)',1,1,2,1,1,1,-1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 3,'sex',416,'char(1)',5,0,3,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 4,'accounttype',17745,'int',5,0,4,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 5,'belongto',17746,'int',3,1,5,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 6,'departmentid',124,'int',3,167,6,1,1,1,-1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 7,'jobtitle',6086,'int',3,24,7,1,1,1,-1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 8,'jobcall',806,'int',3,262,8,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 9,'joblevel',1909,'tinyint',1,2,9,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 10,'jobactivitydesc',15708,'varchar(200)',1,1,10,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 11,'status',602,'int',5,0,11,1,1,1,-1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 12,'systemlanguage',16066,'int',3,261,12,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 13,'resourceimageid',15707,'int',6,0,13,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 14,'mobile',620,'varchar(60)',1,1,14,0,1,2,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 15,'telephone',661,'varchar(60)',1,1,15,0,1,2,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 16,'mobilecall',15714,'varchar(60)',1,1,16,0,1,2,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 17,'fax',494,'varchar(60)',1,1,17,0,1,2,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 18,'email',477,'varchar(60)',1,1,18,0,1,2,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 19,'locationid',15712,'int',3,265,19,1,1,2,-1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 20,'workroom',420,'varchar(60)',1,1,20,0,1,2,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 21,'managerid',15709,'int',3,1,21,1,1,3,-1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 22,'assistantid',441,'int',3,1,22,0,1,3,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 24,'departmentvirtualids',34101,'varchar(60)',3,264,23,0,1,1,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 25,'birthday',464,'char(10)',3,2,1,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 26,'folk',1886,'varchar(30)',1,1,2,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 27,'nativeplace',1840,'varchar(100)',1,1,3,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 28,'regresidentplace',15683,'varchar(200)',1,1,4,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 29,'certificatenum',1887,'varchar(60)',1,1,5,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 30,'maritalstatus',469,'char(1)',5,0,6,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 31,'policy',1837,'varchar(30)',1,1,7,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 32,'bememberdate',1834,'char(10)',3,2,8,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 33,'bepartydate',1835,'char(10)',3,2,9,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 34,'islabouunion',15684,'char(1)',5,0,10,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 35,'educationlevel',818,'int',3,30,11,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 36,'degree',1833,'varchar(30)',1,1,12,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 37,'healthinfo',1827,'char(1)',5,0,13,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 38,'height',1826,'varchar(10)',1,1,14,0,1,4,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 39,'weight',15674,'varchar(10)',1,1,15,0,1,4,1)
GO 
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 40,'residentplace',1829,'varchar(200)',1,1,16,0,1,4,1)
GO 
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 41,'homeaddress',16018,'varchar(100)',1,1,17,0,1,4,1)
GO 
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 42,'tempresidentnumber',15685,'varchar(60)',1,1,18,0,1,4,1)
GO 
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 43,'usekind',804,'int',3,31,1,0,1,5,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 44,'startdate',1970,'char(10)',3,2,2,0,1,5,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 45,'probationenddate',15778,'char(10)',3,2,3,0,1,5,1)
GO
INSERT INTO hrm_formfield(fieldid,fieldname ,fieldlabel ,fielddbtype ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid, allowhide)
VALUES  ( 46,'enddate',15236,'char(10)',3,2,4,0,1,5,1)
GO
INSERT INTO hrm_formfield( fieldid ,fielddbtype ,fieldname ,fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide)
SELECT * FROM (
SELECT 47 AS 'fieldid','varchar(10)' AS 'fielddbtype','datefield1' AS 'fieldname',dff01name AS 'fieldlabel',3 AS 'fieldhtmltype',2 AS 'type',24 AS 'fieldorder',0 AS 'ismand',dff01use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 48 AS 'fieldid','varchar(10)' AS 'fielddbtype','datefield2' AS 'fieldname',dff02name AS 'fieldlabel',3 AS 'fieldhtmltype',2 AS 'type',25 AS 'fieldorder',0 AS 'ismand',dff02use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 49 AS 'fieldid','varchar(10)' AS 'fielddbtype','datefield3' AS 'fieldname',dff03name AS 'fieldlabel',3 AS 'fieldhtmltype',2 AS 'type',26 AS 'fieldorder',0 AS 'ismand',dff03use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 50 AS 'fieldid','varchar(10)' AS 'fielddbtype','datefield4' AS 'fieldname',dff04name AS 'fieldlabel',3 AS 'fieldhtmltype',2 AS 'type',27 AS 'fieldorder',0 AS 'ismand',dff04use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 51 AS 'fieldid','varchar(10)' AS 'fielddbtype','datefield5' AS 'fieldname',dff05name AS 'fieldlabel',3 AS 'fieldhtmltype',2 AS 'type',28 AS 'fieldorder',0 AS 'ismand',dff05use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 52 AS 'fieldid','float' AS 'fielddbtype','numberfield1' AS 'fieldname',nff01name AS 'fieldlabel',1 AS 'fieldhtmltype',3 AS 'type',29 AS 'fieldorder',0 AS 'ismand',nff01use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 53 AS 'fieldid','float' AS 'fielddbtype','numberfield2' AS 'fieldname',nff02name AS 'fieldlabel',1 AS 'fieldhtmltype',3 AS 'type',30 AS 'fieldorder',0 AS 'ismand',nff02use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 54 AS 'fieldid','float' AS 'fielddbtype','numberfield3' AS 'fieldname',nff03name AS 'fieldlabel',1 AS 'fieldhtmltype',3 AS 'type',31 AS 'fieldorder',0 AS 'ismand',nff03use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 55 AS 'fieldid','float' AS 'fielddbtype','numberfield4' AS 'fieldname',nff04name AS 'fieldlabel',1 AS 'fieldhtmltype',3 AS 'type',32 AS 'fieldorder',0 AS 'ismand',nff04use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 56 AS 'fieldid','float' AS 'fielddbtype','numberfield5' AS 'fieldname',nff05name AS 'fieldlabel',1 AS 'fieldhtmltype',3 AS 'type',33 AS 'fieldorder',0 AS 'ismand',nff05use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 57 AS 'fieldid','varchar(100)' AS 'fielddbtype','textfield1' AS 'fieldname',tff01name AS 'fieldlabel',1 AS 'fieldhtmltype',1 AS 'type',34 AS 'fieldorder',0 AS 'ismand',tff01use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 58 AS 'fieldid','varchar(100)' AS 'fielddbtype','textfield2' AS 'fieldname',tff02name AS 'fieldlabel',1 AS 'fieldhtmltype',1 AS 'type',35 AS 'fieldorder',0 AS 'ismand',tff02use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 59 AS 'fieldid','varchar(100)' AS 'fielddbtype','textfield3' AS 'fieldname',tff03name AS 'fieldlabel',1 AS 'fieldhtmltype',1 AS 'type',36 AS 'fieldorder',0 AS 'ismand',tff03use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 60 AS 'fieldid','varchar(100)' AS 'fielddbtype','textfield4' AS 'fieldname',tff04name AS 'fieldlabel',1 AS 'fieldhtmltype',1 AS 'type',37 AS 'fieldorder',0 AS 'ismand',tff04use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 61 AS 'fieldid','varchar(100)' AS 'fielddbtype','textfield5' AS 'fieldname',tff05name AS 'fieldlabel',1 AS 'fieldhtmltype',1 AS 'type',38 AS 'fieldorder',0 AS 'ismand',tff05use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 62 AS 'fieldid','tinyint' AS 'fielddbtype','tinyintfield1' AS 'fieldname',bff01name AS 'fieldlabel',5 AS 'fieldhtmltype',1 AS 'type',38 AS 'fieldorder',0 AS 'ismand',bff01use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 63 AS 'fieldid','tinyint' AS 'fielddbtype','tinyintfield2' AS 'fieldname',bff02name AS 'fieldlabel',5 AS 'fieldhtmltype',1 AS 'type',40 AS 'fieldorder',0 AS 'ismand',bff02use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 64 AS 'fieldid','tinyint' AS 'fielddbtype','tinyintfield3' AS 'fieldname',bff03name AS 'fieldlabel',5 AS 'fieldhtmltype',1 AS 'type',41 AS 'fieldorder',0 AS 'ismand',bff03use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 65 AS 'fieldid','tinyint' AS 'fielddbtype','tinyintfield4' AS 'fieldname',bff04name AS 'fieldlabel',5 AS 'fieldhtmltype',1 AS 'type',42 AS 'fieldorder',0 AS 'ismand',bff04use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
UNION
SELECT 66 AS 'fieldid','tinyint' AS 'fielddbtype','tinyintfield5' AS 'fieldname',bff05name AS 'fieldlabel',5 AS 'fieldhtmltype',1 AS 'type',43 AS 'fieldorder',0 AS 'ismand',bff05use AS 'isuse',1 AS 'groupid',1 AS 'allowhide' FROM Base_FreeField WHERE tablename = 'hr'
) AS t WHERE isuse = 1 
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 67 ,'varchar(200)' ,'subcompanyname' ,'399' ,'1' , 1 , 1 ,'1' , '1' ,6 , 0 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 68 ,'varchar(200)' ,'subcompanydesc' ,'15767' ,'1' , 1 , 2 ,'1' , '1' ,6 , 0 , 0 , 0 , 0 , 1 )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 69 ,'int' ,'supsubcomid' ,'22753' ,'3' , 164 , 3 ,'0' , '1' ,6 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 70 ,'varchar(50)' ,'url' ,'76' ,'1' , 1 , 4 ,'0' , '1' ,6 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 71 ,'int' ,'showorder' ,'15513' ,'1' , 2 , 5 ,'0' , '1' ,6 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 72 ,'varchar(100)' ,'subcompanycode' ,'22289' ,'1' , 1 , 6 ,'0' , '1' ,6 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 73 ,'varchar(60)' ,'departmentmark' ,'399' ,'1' , 1 , 1 ,'1' , '1' ,7 , 0 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 74 ,'varchar(200)' ,'departmentname' ,'15767' ,'1' , 1 , 2 ,'1' , '1' ,7 , 0 , 0 , 0 , 0 , 1 )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 75 ,'int' ,'subcompanyid1' ,'19799' ,'3' , 164 , 3 ,'1' , '1' ,7 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 76 ,'int' ,'supdepid' ,'15772' ,'3' , 4 , 4 ,'0' , '1' ,7 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 77 ,'int' ,'coadjutant' ,'22671' ,'3' , 1 , 5 ,'0' , '1' ,7 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 78 ,'int' ,'showorder' ,'15513' ,'1' , 2 , 6 ,'0' , '1' ,7 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 79 ,'int' ,'showid' ,'22279' ,'1' , 2 , 7 ,'1' , '1' ,7 , 1 , 0 , 0 , 0 , 1  )
GO
INSERT INTO hrm_formfield ( fieldid ,fielddbtype ,fieldname , fieldlabel ,fieldhtmltype ,type ,fieldorder ,ismand ,isuse ,groupid ,allowhide ,imgwidth ,imgheight ,textheight ,issystem)
VALUES  ( 80 ,'varchar(100)' ,'departmentcode' ,'15391' ,'1' , 1 , 8 ,'0' , '1' ,7 , 1 , 0 , 0 , 0 , 1  )
GO
DELETE from hrm_SelectItem
GO
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 3 , 0 , 0 , '男' , NULL , 'y' ,'' ,'' ,'' ,'' ,''  )
GO    
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 3 ,0 ,1 ,'女' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO    
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 4 ,0 ,0 ,'主账号' ,NULL ,'y' ,'' ,'' ,'' ,'' ,''  )
GO    
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 4 ,0 ,1 ,'次账号' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO     
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,0 ,'试用' , NULL ,'y' ,'' ,'' ,'' ,'' ,''  )
GO      
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,1 ,'正式' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO       
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,2 ,'临时' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO       
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,3 ,'试用延期' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,4 ,'解聘' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 , 0 ,5 ,'离职' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,6 ,'退休' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO       
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,7 ,'无效' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )
GO       
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 11 ,0 ,10 ,'在职' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  ) 
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 30 ,0 , 0 ,'未婚' ,NULL ,'y' ,'' ,'' ,'' ,'' ,''  ) 
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 30 ,0 , 1 ,'已婚' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )             
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 30 ,0 ,2 ,'离异' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )     
GO     
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 34 ,0 ,0 ,'否' ,2 ,'' ,'' ,'' ,'' ,'' ,''  )  
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 34 ,0 ,1 ,'是' ,1 , 'y' ,'' ,'' ,'' ,'' ,''  )        
GO       
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 37 ,0 ,0 ,'优秀' ,NULL ,'y' ,'' ,'' ,'' ,'' ,''  )  
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 37 ,0 ,1 ,'良好' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )    
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 37 ,0 ,2 ,'一般' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )    
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 37 ,0 ,3 ,'较差' ,NULL ,'' ,'' ,'' ,'' ,'' ,''  )    
GO
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 62 ,0 , 1 ,'是' ,1 ,'' ,'' ,'' ,'' ,'' ,'')  
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 62 ,0 , 0 ,'否' ,2 ,'' ,'' ,'' ,'' ,'' ,'')  
GO 
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 63 ,0 , 1 ,'是' ,1 ,'' ,'' ,'' ,'' ,'' ,'')  
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 63 ,0 , 0 ,'否' ,2 ,'' ,'' ,'' ,'' ,'' ,'')  
GO 
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 64 ,0 , 1 ,'是' ,1 ,'' ,'' ,'' ,'' ,'' ,'')  
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 64 ,0 , 0 ,'否' ,2 ,'' ,'' ,'' ,'' ,'' ,'')  
GO 
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 65 ,0 , 1 ,'是' ,1 ,'' ,'' ,'' ,'' ,'' ,'')  
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 65 ,0 , 0 ,'否' ,2 ,'' ,'' ,'' ,'' ,'' ,'')  
GO 
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 66 ,0 , 1 ,'是' ,1 ,'' ,'' ,'' ,'' ,'' ,'')  
GO        
INSERT  INTO hrm_SelectItem( fieldid , isbill , selectvalue ,selectname ,listorder ,isdefault ,docPath ,docCategory ,isAccordToSubCom ,childitemid ,cancel)
VALUES  ( 66 ,0 , 0 ,'否' ,2 ,'' ,'' ,'' ,'' ,'' ,'')  
GO