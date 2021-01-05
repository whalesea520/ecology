alter table DocImageFile add versionId int,versionDetail varchar(100)
go

alter table docimagefile alter column id int


alter table DocMouldFile add mouldType int,mouldPath varchar(100)
go

CREATE TABLE DocDocumentSignature (
	id int IDENTITY (1, 1) NOT NULL ,
	versionId int NULL ,
	markName varchar (50)  ,
	userName varchar (50)  ,
	dateTime datetime NULL ,
	hostName varchar (50)  ,
	markGuid varchar (50)  
) 
GO

CREATE TABLE DocSignature (
	markId int IDENTITY (1, 1) NOT NULL ,
	hrmresid int NOT NULL ,
	password varchar (50)  ,
	markName varchar (100)  ,
	markType varchar (10)  ,
	markPath varchar (200)  ,
	markSize int NULL ,
	markDate datetime NULL 
) 
GO


CREATE PROCEDURE SequenceIndex_SelectVersionId (@flag int output, @msg varchar(80) output)  AS select currentid from SequenceIndex where indexdesc='versionId' update SequenceIndex set currentid = currentid+1 where indexdesc='versionId'
GO

CREATE PROCEDURE SequenceIndex_SelectDocImageId (@flag int output, @msg varchar(80) output)  AS select currentid from SequenceIndex where indexdesc='docimageid' update SequenceIndex set currentid = currentid+1 where indexdesc='docimageid'
GO



CREATE PROCEDURE DocImageFile_SelectByVersionId (@versionId_1 	int, @flag int output, @msg varchar(80) output)  AS select * from DocImageFile where versionId= @versionId_1
GO

CREATE PROCEDURE DocImageFile_UpdateByDocid (@docid_1 	int, @imagefileid_2 	int, @imagefilename_3 	varchar(200), @imagefiledesc_4 	varchar(200), @imagefilewidth_5 	smallint, @imagefileheight_6 	smallint, @imagefielsize_7 	smallint, @docfiletype_8 	char(1),@versionId_9	int,@versionDetail_10	varchar(100) , @flag int output, @msg varchar(80) output)  AS UPDATE DocImageFile set imagefileid=@imagefileid_2, imagefilename=@imagefilename_3, imagefiledesc=@imagefiledesc_4, imagefilewidth=@imagefilewidth_5, imagefileheight=@imagefileheight_6, imagefielsize=@imagefielsize_7, docfiletype=@docfiletype_8,versionId=@versionId_9,versionDetail=@versionDetail_10 where docid=@docid_1 and versionId=(select max(versionId) from DocImageFile where docid=@docid_1)
GO

CREATE PROCEDURE DocImageFile_UpdateByDocidVid (@docid_1 	int, @imagefileid_2 	int, @imagefilename_3 	varchar(200), @imagefiledesc_4 	varchar(200), @imagefilewidth_5 	smallint, @imagefileheight_6 	smallint, @imagefielsize_7 	smallint, @docfiletype_8 	char(1),@versionId_9	int,@versionDetail_10	varchar(100) , @flag int output, @msg varchar(80) output)  AS UPDATE DocImageFile set imagefileid=@imagefileid_2, imagefilename=@imagefilename_3, imagefiledesc=@imagefiledesc_4, imagefilewidth=@imagefilewidth_5, imagefileheight=@imagefileheight_6, imagefielsize=@imagefielsize_7, docfiletype=@docfiletype_8,versionId=@versionId_9,versionDetail=@versionDetail_10 where docid=@docid_1 and versionId=@versionId_9
GO

alter PROCEDURE DocImageFile_SelectByDocid (@docid_1 	int, @flag int output, @msg varchar(80) output)  AS select * from DocImageFile where docid= @docid_1 order by id, versionId desc
GO

alter PROCEDURE DocImageFile_Insert (@docid_1 	int, @imagefileid_2 	int, @imagefilename_3 	varchar(200), @imagefiledesc_4 	varchar(200), @imagefilewidth_5 	smallint, @imagefileheight_6 	smallint, @imagefielsize_7 	smallint, @docfiletype_8 	char(1),@versionId_9	int,@versionDetail_10	varchar(100) ,@docImageId_11	int, @flag int output, @msg varchar(80) output)  AS INSERT INTO DocImageFile ( docid, imagefileid, imagefilename, imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, docfiletype,versionId,versionDetail,id)  VALUES ( @docid_1, @imagefileid_2, @imagefilename_3, @imagefiledesc_4, @imagefilewidth_5, @imagefileheight_6, @imagefielsize_7, @docfiletype_8,@versionId_9,@versionDetail_10,@docImageId_11)
GO



insert into SequenceIndex(indexdesc,currentid) values('versionid',1)
go

insert into SequenceIndex(indexdesc,currentid) values('docimageid',1)
go



insert into SystemRights (id,rightdesc,righttype) values (395,'Ç©ÕÂÎ¬»¤','1') 
GO 
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3081,'ä¯ÀÀÇ©ÕÂÁÐ±í','SignatureList:List',395) 
GO 
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3082,'ÐÂ½¨Ç©ÕÂ','SignatureAdd:Add',395) 
GO 
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3083,'±à¼­Ç©ÕÂ','SignatureEdit:Edit',395) 
GO 
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3084,'É¾³ýÇ©ÕÂ','SignatureEdit:Delete',395) 
GO 
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (395,7,'Ç©ÕÂÎ¬»¤','Ç©ÕÂµÄÐÂ½¨£¬±à¼­£¬É¾³ýºÍÁÐ±íä¯ÀÀ') 
GO 
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (395,8,'','') 
GO 
insert into SystemRightToGroup (groupid,rightid) values (2,395) 
GO 
insert into SystemRightRoles (rightid,roleid,rolelevel) values (395,3,'2') 
GO 



update docimagefile set docfiletype = 3 where imagefilename like '%.doc' or imagefilename like '%.dot' 
GO

update  docimagefile set docfiletype = 4 where imagefilename like '%.xls'
GO

update  DocDetail set doctype = 1
GO

update docimagefile set versionId = imagefileid 
go 


CREATE PROCEDURE sequenceversion_update 
AS 
declare @count_1 int 
select @count_1 = max(versionId) from docimagefile 
if @count_1 is null 
set @count_1 = 0 

update sequenceindex set currentid = @count_1+1 where indexdesc = 'versionid' 

set @count_1 = 0 
select @count_1 = max(id) from docimagefile 
if @count_1 is null 
set @count_1 = 0 

update sequenceindex set currentid = @count_1+1 where indexdesc = 'docimageid' 

GO 

exec sequenceversion_update 
go 

drop PROCEDURE sequenceversion_update 
go



CREATE TABLE Tmp_DocImageFile
	(
	id int NOT NULL,
	docid int NULL,
	imagefileid int NULL,
	imagefilename varchar(200) NULL,
	imagefiledesc varchar(200) NULL,
	imagefilewidth smallint NULL,
	imagefileheight smallint NULL,
	imagefielsize smallint NULL,
	docfiletype char(1) NULL,
	versionId int NULL,
	versionDetail varchar(100) NULL
	)  
GO

INSERT INTO Tmp_DocImageFile (id, docid, imagefileid, imagefilename, imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, docfiletype, versionId, versionDetail) 
SELECT id, docid, imagefileid, imagefilename, imagefiledesc, imagefilewidth, imagefileheight, imagefielsize, docfiletype, versionId, versionDetail FROM DocImageFile 
GO

DROP TABLE DocImageFile
GO

EXEC sp_rename N'Tmp_DocImageFile', N'DocImageFile', 'OBJECT'
GO

CREATE NONCLUSTERED INDEX docimagefile_docid_in ON DocImageFile(docid)
GO


