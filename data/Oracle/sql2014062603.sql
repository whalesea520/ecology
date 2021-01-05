CREATE TABLE DocPreview ( 
    id integer not null,
    imageFileId integer,
    filePath varchar2(500),
    pdfFileId integer,
    pdfPath varchar2(500),
    swfFileId integer,
    swfPath varchar2(500),
    swfPageCount integer,
    previewCount integer,
    systemtag varchar2(100),
    fileTableName varchar2(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8)
) 
/
create sequence DocPreview_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocPreview_id_trigger
before insert on DocPreview
for each row
begin
select DocPreview_id.nextval into :new.id from dual;
end;
/


CREATE TABLE DocPreviewHistory ( 
    id integer not null,
    imageFileId integer,
    filePath varchar2(500),
    pdfFileId integer,
    pdfPath varchar2(500),
    swfFileId integer,
    swfPath varchar2(500),
    swfPageCount integer,
    previewCount integer,
    systemtag varchar2(100),
    fileTableName varchar2(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8)
) 
/
create sequence DocPreviewHistory_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocPreviewHistory_id_trigger
before insert on DocPreviewHistory
for each row
begin
select DocPreviewHistory_id.nextval into :new.id from dual;
end;
/

CREATE index DocPreview_fileId_in ON DocPreview(imageFileId)
/
CREATE index DocPreviewHistory_fileId_in ON DocPreviewHistory(imageFileId)
/

CREATE OR REPLACE TRIGGER Tri_ImageFile_BackUp
AFTER UPDATE  ON ImageFile REFERENCING NEW AS NEW OLD AS OLD FOR EACH ROW
Declare
imageFileId_1 integer;
begin
    imageFileId_1 := :old.imageFileId;

    insert into ImageFileBackUp(imageFileId) values(imageFileId_1)  ;
    update DocPreview set mustReconverted='1' where imageFileId=imageFileId_1;
end ;
/