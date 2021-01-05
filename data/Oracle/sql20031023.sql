

alter table DocImageFile add versionId integer
/
alter table DocImageFile add versionDetail Varchar2 (100)
/
alter table docimagefile modify id integer
/
alter table DocMouldFile add mouldType integer
/
alter table DocMouldFile add mouldPath Varchar2(100)
/

CREATE TABLE DocDocumentSignature (
id integer  NOT NULL,
versionId integer default 0,
markName varchar2 (50)  ,
userName varchar2 (50)  ,
dateTime date NULL , 
hostName varchar2 (50)  ,
markGuid varchar2 (50) ) 
/                           

create sequence DocDocumentSignature_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           


create or replace trigger DocDocumentSignature_Trigger
before insert on DocDocumentSignature
for each row
begin
select DocDocumentSignature_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DocSignature (
markId integer  NOT NULL,
hrmresid integer NOT NULL,
password varchar2 (50)  ,
markName varchar2 (100) ,
markType varchar2 (10)  ,
markPath varchar2 (200) ,
markSize integer NULL ,
markDate date )       
/                          


create sequence DocSignature_markId
start with 1
increment by 1
nomaxvalue
nocycle
/                           

create or replace trigger DocSignature_Trigger
before insert on DocSignature
for each row
begin
select DocSignature_markId.nextval into :new.markId from dual;
end;
/



CREATE or REPLACE PROCEDURE SequenceIndex_SelectVersionId
(flag out integer,msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for 
select currentid from SequenceIndex where indexdesc='versionId';

update SequenceIndex set currentid = currentid+1 where indexdesc='versionId';
end;
/

CREATE or REPLACE PROCEDURE SequenceIndex_SelectDocImageId
(flag out integer,msg out varchar2,
     thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for 
select currentid from SequenceIndex where indexdesc='docimageid';
update SequenceIndex set currentid = currentid+1 where indexdesc='docimageid';
end;
/

CREATE or REPLACE PROCEDURE DocImageFile_SelectByVersionId
(versionId_1 integer,flag out integer,msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for
select * from DocImageFile where versionId= versionId_1;
end;
/

CREATE or REPLACE PROCEDURE DocImageFile_UpdateByDocid
(docid_1 integer,
imagefileid_2 integer,
imagefilename_3 Varchar2,
imagefiledesc_4 Varchar2,
imagefilewidth_5 smallint,
imagefileheight_6 smallint,
imagefielsize_7 smallint,
docfiletype_8 char,
versionId_9 integer,
versionDetail_10 varchar2,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
UPDATE DocImageFile
set imagefileid=imagefileid_2, imagefilename=imagefilename_3, 
imagefiledesc=imagefiledesc_4, imagefilewidth=imagefilewidth_5,
imagefileheight=imagefileheight_6, imagefielsize=imagefielsize_7,
docfiletype=docfiletype_8,versionId=versionId_9,
versionDetail=versionDetail_10 
where docid=docid_1 and versionId=(select max(versionId) from DocImageFile where docid=docid_1);
end;
/

CREATE or REPLACE PROCEDURE DocImageFile_UpdateByDocidVid
(docid_1 integer,imagefileid_2 integer,imagefilename_3 Varchar2,
imagefiledesc_4 Varchar2,imagefilewidth_5 smallint,imagefileheight_6 smallint,
imagefielsize_7 smallint,docfiletype_8 char,versionId_9 integer,
versionDetail_10 Varchar2,flag out integer,msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
UPDATE DocImageFile
set imagefileid=imagefileid_2, imagefilename=imagefilename_3, 
imagefiledesc=imagefiledesc_4, imagefilewidth=imagefilewidth_5, 
imagefileheight=imagefileheight_6, imagefielsize=imagefielsize_7,
docfiletype=docfiletype_8,versionId=versionId_9,
versionDetail=versionDetail_10 where docid=docid_1 and versionId=versionId_9;
end;
/

CREATE or REPLACE PROCEDURE DocImageFile_SelectByDocid
(docid_1 integer,flag out integer,msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
open thecursor for
select * from DocImageFile where docid= docid_1 order by id, versionId desc;
end;
/

CREATE or REPLACE PROCEDURE DocImageFile_Insert
(docid_1 integer,
imagefileid_2 integer,
imagefilename_3 Varchar2,
imagefiledesc_4 Varchar2,
imagefilewidth_5 smallint,imagefileheight_6 smallint,
imagefielsize_7 smallint,docfiletype_8 char,versionId_9 integer,
versionDetail_10 Varchar2,docImageId_11 integer,
flag out integer,msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
as
begin
INSERT INTO DocImageFile ( docid, imagefileid, imagefilename, 
imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, 
docfiletype,versionId,versionDetail,id)  VALUES 
( docid_1, imagefileid_2, imagefilename_3, imagefiledesc_4, 
imagefilewidth_5, imagefileheight_6, imagefielsize_7, 
docfiletype_8,versionId_9,versionDetail_10,docImageId_11);
end;
/


insert into SequenceIndex(indexdesc,currentid) values('versionid',1)
/
insert into SequenceIndex(indexdesc,currentid) values('docimageid',1)
/

insert into SystemRights (id,rightdesc,righttype) values (395,'Ç©ÕÂÎ¬»¤','1') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3081,'ä¯ÀÀÇ©ÕÂÁÐ±í','SignatureList:List',395) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3082,'ÐÂ½¨Ç©ÕÂ','SignatureAdd:Add',395)
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3083,'±à¼­Ç©ÕÂ','SignatureEdit:Edit',395) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3084,'É¾³ýÇ©ÕÂ','SignatureEdit:Delete',395) 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (395,7,'Ç©ÕÂÎ¬»¤','Ç©ÕÂµÄÐÂ½¨£¬±à¼­£¬É¾³ýºÍÁÐ±íä¯ÀÀ') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (395,8,'','') 
/
insert into SystemRightToGroup (groupid,rightid) values (2,395) 
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (395,3,'2') 
/



update docimagefile set docfiletype = 3 where imagefilename like '%.doc' or imagefilename like '%.dot' 
/

update  docimagefile set docfiletype = 4 where imagefilename like '%.xls'
/

update  DocDetail set doctype = 1
/

update docimagefile set versionId = imagefileid 
/


CREATE or REPLACE PROCEDURE sequenceversion_update 
AS 
count_1 integer ;
begin
select  max(versionId) into count_1 from docimagefile  ;
if count_1 is null then
    count_1 := 0 ;
end if ;

update sequenceindex set currentid = count_1+1 where indexdesc = 'versionid' ;

count_1 := 0 ;
select  max(id) into count_1 from docimagefile  ;

if count_1 is null then
    count_1 := 0 ;
end if ;

update sequenceindex set currentid = count_1+1 where indexdesc ='docimageid' ;

end ;
/

call sequenceversion_update() 
/

drop PROCEDURE sequenceversion_update 
/


CREATE TABLE Tmp_DocImageFile
	(
	id integer NOT NULL,
	docid integer NULL,
	imagefileid integer NULL,
	imagefilename varchar2(200) NULL,
	imagefiledesc varchar2(200) NULL,
	imagefilewidth smallint NULL,
	imagefileheight smallint NULL,
	imagefielsize smallint NULL,
	docfiletype char(1) NULL,
	versionId integer NULL,
	versionDetail varchar2(100) NULL
	)  
/

INSERT INTO Tmp_DocImageFile (id, docid, imagefileid, imagefilename, imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, docfiletype, versionId, versionDetail) 
SELECT id, docid, imagefileid, imagefilename, imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, docfiletype, versionId, versionDetail FROM DocImageFile 
/

DROP TABLE DocImageFile
/

alter table Tmp_DocImageFile rename to DocImageFile
/

CREATE index docimagefile_docid_in ON DocImageFile(docid)
/

