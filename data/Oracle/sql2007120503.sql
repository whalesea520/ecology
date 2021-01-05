CREATE or REPLACE PROCEDURE DocImageFile_Insert
(docid_1 integer,
imagefileid_2 integer,
imagefilename_3 Varchar2,
imagefiledesc_4 Varchar2,
imagefilewidth_5 integer,imagefileheight_6 integer,
imagefielsize_7 integer,docfiletype_8 char,versionId_9 integer,
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

CREATE or REPLACE PROCEDURE DocImageFile_UpdateByDocid
(docid_1 integer,
imagefileid_2 integer,
imagefilename_3 Varchar2,
imagefiledesc_4 Varchar2,
imagefilewidth_5 integer,
imagefileheight_6 integer,
imagefielsize_7 integer,
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
imagefiledesc_4 Varchar2,imagefilewidth_5 integer,imagefileheight_6 integer,
imagefielsize_7 integer,docfiletype_8 char,versionId_9 integer,
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