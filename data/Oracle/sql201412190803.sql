alter  table  DocPreview  add  docId  integer  
/
alter  table  DocPreviewHistory  add  docId  integer  
/
update DocPreview set docId=(select max(docId) from DocImageFile where imageFileId=DocPreview.imageFileId)
/
update DocPreviewHistory set docId=(select max(docId) from DocImageFile where imageFileId=DocPreviewHistory.imageFileId)
/


CREATE TABLE DocPreviewHtml ( 
    id integer NOT NULL ,
    imageFileId integer,
    htmlFileId integer,
    previewCount integer,
    systemtag varchar2(100),
    fileTableName varchar2(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8),
    docId integer
) 
/
create sequence DocPreviewHtml_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocPreviewHtml_id_trigger
before insert on DocPreviewHtml
for each row
begin
select DocPreviewHtml_id.nextval into :new.id from dual;
end;
/

CREATE TABLE DocPreviewHtmlHistory ( 
    id integer NOT NULL ,
    imageFileId integer,
    htmlFileId integer,
    previewCount integer,
    systemtag varchar2(100),
    fileTableName varchar2(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8),
    docId integer
) 
/
create sequence DocHtmlHis_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocHtmlHis_id_trigger
before insert on DocPreviewHtmlHistory
for each row
begin
select DocHtmlHis_id.nextval into :new.id from dual;
end;
/
CREATE index DocHtml_fileId_in ON DocPreviewHtml(imageFileId)
/
CREATE index DocHtmlHis_fileId_in ON DocPreviewHtmlHistory(imageFileId)
/
CREATE index DocHtml_htmlFileId_in ON DocPreviewHtml(htmlFileId)
/
CREATE index DocHtmlHis_htmlFileId_in ON DocPreviewHtmlHistory(htmlFileId)
/

CREATE TABLE DocPreviewHtmlImage ( 
    id integer NOT NULL ,
    imageFileId integer,
    picFileId integer,
    docId integer
) 
/
create sequence DocHtmlImg_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger DocHtmlImg_id_trigger
before insert on DocPreviewHtmlImage
for each row
begin
select DocHtmlImg_id.nextval into :new.id from dual;
end;
/
CREATE index DocHtmlImg_fileId_in ON DocPreviewHtmlImage(imageFileId)
/
CREATE index DocHtmlImg_picFileId_in ON DocPreviewHtmlImage(picFileId)
/


drop TRIGGER Tri_ImageFile_BackUp
/