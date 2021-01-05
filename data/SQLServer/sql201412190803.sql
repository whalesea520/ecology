alter  table  DocPreview  add  docId  int  
GO
alter  table  DocPreviewHistory  add  docId  int  
GO
update DocPreview set docId=(select max(docId) from DocImageFile where imageFileId=DocPreview.imageFileId)
GO
update DocPreviewHistory set docId=(select max(docId) from DocImageFile where imageFileId=DocPreviewHistory.imageFileId)
GO


CREATE TABLE DocPreviewHtml ( 
    id int NOT NULL IDENTITY(1,1) PRIMARY key,
    imageFileId int,
    htmlFileId int,
    previewCount int,
    systemtag varchar(100),
    fileTableName varchar(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8),
    docId int
) 
GO
CREATE TABLE DocPreviewHtmlHistory ( 
    id int NOT NULL IDENTITY(1,1) PRIMARY key,
    imageFileId int,
    htmlFileId int,
    previewCount int,
    systemtag varchar(100),
    fileTableName varchar(60),
    mustReconverted char(1)  default '0',
    createDate char(10),
    createTime char(8),
    lastAccessDate char(10),
    lastAccessTime char(8),
    docId int
) 
GO
CREATE index DocHtml_fileId_in ON DocPreviewHtml(imageFileId)
GO
CREATE index DocHtmlHis_fileId_in ON DocPreviewHtmlHistory(imageFileId)
GO
CREATE index DocHtml_htmlFileId_in ON DocPreviewHtml(htmlFileId)
GO
CREATE index DocHtmlHis_htmlFileId_in ON DocPreviewHtmlHistory(htmlFileId)
GO

CREATE TABLE DocPreviewHtmlImage ( 
    id int NOT NULL IDENTITY(1,1) PRIMARY key,
    imageFileId int,
    picFileId int,
    docId int
) 
GO
CREATE index DocHtmlImg_fileId_in ON DocPreviewHtmlImage(imageFileId)
GO
CREATE index DocHtmlImg_picFileId_in ON DocPreviewHtmlImage(picFileId)
GO


drop TRIGGER Tri_ImageFile_BackUp
GO